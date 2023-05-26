class BTCountryListRequest {
  /*
  CompanyId:4132
CountryCode:IND
ListMode:L
*/

  String CompanyId;
  String CountryCode;
  String ListMode;

  BTCountryListRequest({this.CompanyId, this.CountryCode, this.ListMode});

  BTCountryListRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    CountryCode = json['CountryCode'];
    ListMode = json['ListMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['CountryCode'] = this.CountryCode;
    data['ListMode'] = this.ListMode;
    return data;
  }
}
