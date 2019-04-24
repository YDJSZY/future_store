class MyInfo {
  Map infos;
  MyInfo(this.infos);
}

class StoreUserInfo {
  Map infos;
  StoreUserInfo(this.infos);
}

class Language {
  Map data;
  Language(this.data);
}

class AppState {
  MyInfo myInfo;
  StoreUserInfo storeUserInfo;
  Language language;

  AppState({
    this.myInfo,
    this.storeUserInfo,
    this.language
  });
}