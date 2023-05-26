class SOCurrencyListResponse {
  List<SOCurrencyListResponseDetails> details;
  int totalCount;

  SOCurrencyListResponse({this.details, this.totalCount});

  SOCurrencyListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SOCurrencyListResponseDetails.fromJson(v));
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

class SOCurrencyListResponseDetails {
  int rowNum;
  String currencyName;
  String currencyShortName;
  String currencySymbol;
  bool activeFlag;

  SOCurrencyListResponseDetails(
      {this.rowNum,
      this.currencyName,
      this.currencyShortName,
      this.currencySymbol,
      this.activeFlag});

  SOCurrencyListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    currencyName = json['CurrencyName'];
    currencyShortName = json['CurrencyShortName'];
    currencySymbol = json['CurrencySymbol'];
    activeFlag = json['ActiveFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['CurrencyName'] = this.currencyName;
    data['CurrencyShortName'] = this.currencyShortName;
    data['CurrencySymbol'] = this.currencySymbol;
    data['ActiveFlag'] = this.activeFlag;
    return data;
  }
}
