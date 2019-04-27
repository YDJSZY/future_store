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

class PricingType {
  String type;
  PricingType(this.type);
}

class AppState {
  MyInfo myInfo;
  StoreUserInfo storeUserInfo;
  Language language;
  PricingType pricingType;

  AppState({
    this.myInfo,
    this.storeUserInfo,
    this.language,
    this.pricingType
  });
}