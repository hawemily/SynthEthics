class CurrentUser {
  String _uid;
  static CurrentUser _instance;

  static CurrentUser getInstance() {
    if (_instance == null) {
      _instance = CurrentUser._internal();
    }
    return _instance;
  }

  setUID(String uid) {
    _uid = uid;
  }

  getUID() {
    return _uid;
  }

  CurrentUser._internal();
}
