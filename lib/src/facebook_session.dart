part of facebook;

class FacebookSession {

  static final GraphSession _activeSession;

  final String _accessToken;

  FacebookSession(this._accessToken);

  static setDefaultApplication(String appId, String appSecret) {

    _activeSession = new GraphSession();
    _activeSession.appId = appId;
    _activeSession.appSecret = _appSecret;
  }

  get accessToken => _accessToken;
  static get activeSession => _activeSession;
}
