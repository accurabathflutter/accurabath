class ProductBrandListRequest {
  String LoginUserID;
  String CompanyId;

  ProductBrandListRequest({this.LoginUserID, this.CompanyId});

  ProductBrandListRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
