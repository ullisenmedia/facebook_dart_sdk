part of facebook;

class FacebookSession {

  static final GraphSession _activeSession = new GraphSession();

  final String _accessToken;

  FacebookSession(this._accessToken);

  static setDefaultApplication(String appId, String appSecret) {

    _activeSession.appId = appId;
    _activeSession.appSecret = appSecret;
  }

  get accessToken => _accessToken;
  static get activeSession => _activeSession;
}
