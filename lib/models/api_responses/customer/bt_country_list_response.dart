class BTCountryListResponse {
  List<BTCountryListResponseDetails> details;
  int totalCount;

  BTCountryListResponse({this.details, this.totalCount});

  BTCountryListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new BTCountryListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class BTCountryListResponseDetails {
  String countryCode;
  String countryName;
  String currencyName;
  String currencySymbol;
  String countryISO;
  bool activeFlag;
  String telephonicCode;

  BTCountryListResponseDetails(
      {this.countryCode,
      this.countryName,
      this.currencyName,
      this.currencySymbol,
      this.countryISO,
      this.activeFlag,
      this.telephonicCode});

  BTCountryListResponseDetails.fromJson(Map<String, dynamic> json) {
    countryCode = json['CountryCode'] == null ? "" : json['CountryCode'];
    countryName = json['CountryName'] == null ? "" : json['CountryName'];
    currencyName = json['CurrencyName'] == null ? "" : json['CurrencyName'];
    currencySymbol =
        json['CurrencySymbol'] == null ? "" : json['CurrencySymbol'];
    countryISO = json['CountryISO'] == null ? "" : json['CountryISO'];
    activeFlag = json['ActiveFlag'] == null ? false : json['ActiveFlag'];
    telephonicCode =
        json['TelephonicCode'] == null ? "" : json['TelephonicCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['CurrencyName'] = this.currencyName;
    data['CurrencySymbol'] = this.currencySymbol;
    data['CountryISO'] = this.countryISO;
    data['ActiveFlag'] = this.activeFlag;
    data['TelephonicCode'] = this.telephonicCode;
    return data;
  }
}
