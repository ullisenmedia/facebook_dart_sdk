part of facebook;

class FacebookRequest {

  static Client client;

  /**
   * The maximum number of requests that can be submitted in a single batch. This limit is enforced on the service
   * side by the Facebook platform, not by the Request class.
   */
  static final int MAXIMUM_BATCH_SIZE = 50;

//  static final String TAG = Request.sim

  static final String VERSION = '4.0.11';
  static String GRAPH_API_VERSION = 'v2.0';
  static final String BASE_GRAPH_URL = 'https://graph.facebook.com';

  static final String ME = "me";
  static final String MY_FRIENDS = "me/friends";
  static final String MY_PHOTOS = "me/photos";
  static final String MY_VIDEOS = "me/videos";
  static final String VIDEOS_SUFFIX = "/videos";
  static final String SEARCH = "search";
  static final String MY_FEED = "me/feed";
  static final String MY_STAGING_RESOURCES = "me/staging_resources";
  static final String MY_OBJECTS_FORMAT = "me/objects/%s";
  static final String MY_ACTION_FORMAT = "me/%s";

  static final String USER_AGENT_BASE = "FBDartSDK";
  static final String USER_AGENT_HEADER = "User-Agent";
  static final String CONTENT_TYPE_HEADER = "Content-Type";
  static final String ACCEPT_ENCODING_HEADER = "Accept-Encoding";
  static final String ACCEPT_LANGUAGE_HEADER = "Accept-Language";

  // Parameter names/values
  static final String PICTURE_PARAM = "picture";
  static final String FORMAT_PARAM = "format";
  static final String FORMAT_JSON = "json";
  static final String ACCESS_TOKEN_PARAM = "access_token";
  static final String BATCH_ENTRY_NAME_PARAM = "name";
  static final String BATCH_ENTRY_OMIT_RESPONSE_ON_SUCCESS_PARAM = "omit_response_on_success";
  static final String BATCH_ENTRY_DEPENDS_ON_PARAM = "depends_on";
  static final String BATCH_APP_ID_PARAM = "batch_app_id";
  static final String BATCH_RELATIVE_URL_PARAM = "relative_url";
  static final String BATCH_BODY_PARAM = "body";
  static final String BATCH_METHOD_PARAM = "method";
  static final String BATCH_PARAM = "batch";
  static final String ATTACHMENT_FILENAME_PREFIX = "file";
  static final String ATTACHED_FILES_PARAM = "attached_files";
  static final String ISO_8601_FORMAT_STRING = "yyyy-MM-dd'T'HH:mm:ssZ";
  static final String STAGING_PARAM = "file";
  static final String OBJECT_PARAM = "object";

  static final String MIME_BOUNDARY = "3i2ndDfv2rTHiSisAbouNdArYfORhtTPEefj3q2f";

  static String defaultBatchApplicationId;

  FacebookSession _session;
  String _graphPath;
  String _httpMethod;
  String _version;

  Map<String, dynamic> _parameters;
  Map<String, dynamic> _headers;

  GraphObject graphObject;

  FacebookRequest({
           FacebookSession session: null,
           String graphPath: null,
           Map<String, dynamic> parameters: null,
           String httpMethod: HttpMethod.GET,
           String version: 'v2.0'
          }) {

    this._session = session;
    this._graphPath = graphPath;
    this._httpMethod = httpMethod;
    this._version = version;

    this._parameters = parameters;

    if(_parameters) {
      _parameters = new Map<String, dynamic>.from(_parameters);
    } else {
      _parameters = new Map<String, dynamic>();
    }

    if(session != null && !_parameters.containsKey(ACCESS_TOKEN_PARAM)) {
      _parameters[ACCESS_TOKEN_PARAM] = session.accessToken;
    }

    if(session != null && !_parameters.containsKey(FORMAT_JSON)) {
      _parameters[FORMAT_PARAM] = FORMAT_JSON;
    }

    _headers = new Map<String, dynamic>.from({
//        USER_AGENT_HEADER: '${USER_AGENT_BASE}-${version}',
//        ACCEPT_ENCODING_HEADER: '*',
        CONTENT_TYPE_HEADER: 'application/json'
    });

  }

  Future<Response> execute() {

    var completer = new Completer();

    Future<Response> requestFuture;

    var queryParams = null;
    var body = null;

    if(_httpMethod == HttpMethod.GET) {
      queryParams = _parameters;
    }

    if(graphObject != null) {
      body = JSON.encode(graphObject.map);
    }

    var url = this.getRequestURL(params: _parameters);

    switch (this._httpMethod) {

      case HttpMethod.POST:
        requestFuture = FacebookRequest.client.post(url, headers:_headers, body:body);
        break;

      case HttpMethod.DELETE:
        requestFuture = FacebookRequest.client.delete(url, headers:body);
        break;

      case HttpMethod.PUT:
        requestFuture = FacebookRequest.client.put(url, headers:_headers, body:body);
        break;

      default:
        requestFuture = FacebookRequest.client.get(url);
        break;
      }

    requestFuture
      .then((Response response) {

        var result = this.processResponse(response);

        if(result is FacebookError) {

          completer.completeError(result);

        } else {

          completer.complete(result);
        }

      })

      .catchError((error) {

        completer.completeError(error);

      });

      return completer.future;

    }

  static Future<GraphObject> newPostRequest(FacebookSession session, String graphPath, GraphObject graphObject) {

      var completer = new Completer();

      FacebookRequest request = new FacebookRequest(session: session,
                                                    graphPath: graphPath,
                                                    httpMethod: HttpMethod.POST);
      request.graphObject = graphObject;

      request.execute()
        .then((dynamic res) {

          completer.complete(res);
        })

        .catchError((Error error) {

            completer.completeError(error);
        });

    return completer.future;
  }

  static Future<GraphUser> newMeRequest(FacebookSession session) {

    var completer = new Completer();
    var request = new FacebookRequest(session: session, graphPath: ME);

    request.execute()
      .then((Response response) {
        print(response);

        var data = JSON.decode(response.body);

        var graphUser = new GraphObject(data).cast(GraphUser);

        completer.complete(graphUser);
      })

      .catchError((error) {
        completer.completeError(error);
      });

    return completer.future;
  }

  static Future<GraphObject> newMyFriendRequest(FacebookSession session) {

    var completer = new Completer();
    var request = new FacebookRequest(session: session, graphPath: MY_FRIENDS);

    request.execute()
      .then((Response response) {

        var data = JSON.decode(response.body);
        var graphObjectList = null;

        if(data['data'] != null) {
          graphObjectList = new GraphObjectList.castToListFrom(data['data'], GraphUser);
        }

        completer.complete(graphObjectList);
      })

      .catchError((error) {
        completer.completeError(error);
      });

    return completer.future;
  }

  static Future<GraphObject> newGraphPathRequest(FacebookSession session, String graphPath) {

    var completer = new Completer();

    var request = new FacebookRequest(session: session, graphPath: graphPath);

    request.execute()
      .then((Response response) {

        completer.complete(response);

      })

      .catchError((error) {

        completer.completeError(error);

      });

    return completer.future;
  }

  dynamic processResponse(Response response) {

    var result = null;

    if(response.body) {

      Map<String, dynamic> data = JSON.decode(response.body);

      if(data.containsKey('error')) {

        var error = data['error'];

        result = new FacebookError(error);

      } else {

        result = new GraphObject(data);
      }
    }

    return result;
  }

  Uri getRequestURL({Map<String, String> params: null}) {

    var url = Uri.parse('${BASE_GRAPH_URL}/${_version}/');
    var requestPath = '${url.path}${_graphPath}';

    var requestUrl = new Uri(scheme: url.scheme, host: url.host, path: requestPath, queryParameters: params);

    return requestUrl;
  }
}
