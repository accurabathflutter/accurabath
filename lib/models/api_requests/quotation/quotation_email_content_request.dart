class QuotationEmailContentRequest {
  String CompanyId;

  String LoginUserID;

  QuotationEmailContentRequest({this.CompanyId, this.LoginUserID});

  QuotationEmailContentRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];

    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;

    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
