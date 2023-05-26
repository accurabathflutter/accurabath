/*CompanyId:4132
CurrencyName:
LoginUserID:admin*/

class SOCurrencyListRequest {
  String LoginUserID;
  String CurrencyName;
  String CompanyID;

  SOCurrencyListRequest({this.LoginUserID, this.CurrencyName, this.CompanyID});

  SOCurrencyListRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    CurrencyName = json['CurrencyName'];
    CompanyID = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['LoginUserID'] = this.LoginUserID;
    data['CurrencyName'] = this.CurrencyName;
    data['CompanyId'] = this.CompanyID;
    return data;
  }
}
