class QuotationOrganazationListRequest {
  String LoginUserID;
  String CompanyID;

  QuotationOrganazationListRequest({this.LoginUserID, this.CompanyID});

  QuotationOrganazationListRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    CompanyID = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;
    return data;
  }
}
