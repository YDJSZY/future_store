//import 'dart:convert';

class MyInfo {
  Map infos;
  MyInfo(this.infos);
}

class Language {
  Map data;
  Language(this.data);
}

class AppState {
  MyInfo myInfo;
  Language language;

  AppState({
    this.myInfo,
    this.language
  });
}