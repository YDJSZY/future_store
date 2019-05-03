class MyInfo {
  Map infos;
  Map wallet;
  MyInfo(this.infos, this.wallet);
}

class StoreUserInfo {
  Map infos;
  StoreUserInfo(this.infos);
}

class Language {
  Map data;
  Language(this.data);
}

class Locale {
  String locale;
  Locale(this.locale);
}

class PricingType {
  String type;
  PricingType(this.type);
}

class SelectToken {
  Map token;
  SelectToken(this.token);
}

class AppState {
  MyInfo myInfo;
  StoreUserInfo storeUserInfo;
  Language language;
  PricingType pricingType;
  Locale locale;
  SelectToken selectToken;

  AppState({
    this.myInfo,
    this.storeUserInfo,
    this.language,
    this.pricingType,
    this.locale,
    this.selectToken
  });
}