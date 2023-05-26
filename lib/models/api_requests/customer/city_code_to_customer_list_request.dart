class CityCodeToCustomerListRequest {
  /*
  CompanyId:4132
CountryCode:IND
ListMode:L
*/

  String CityCode;
  String LoginUserID;
  String CompanyID;

  CityCodeToCustomerListRequest(
      {this.CityCode, this.LoginUserID, this.CompanyID});

  CityCodeToCustomerListRequest.fromJson(Map<String, dynamic> json) {
    CityCode = json['CityCode'];
    LoginUserID = json['LoginUserID'];
    CompanyID = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CityCode'] = this.CityCode;
    //  data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyID;
    return data;
  }
}
