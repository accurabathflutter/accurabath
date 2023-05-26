/*ProductID:40122
LoginUserID:admin
CompanyId:4132*/

class SizeListRequest {
  String ProductID;
  String LoginUserID;
  String CompanyId;

  SizeListRequest({this.ProductID, this.LoginUserID, this.CompanyId});

  SizeListRequest.fromJson(Map<String, dynamic> json) {
    ProductID = json['ProductID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.ProductID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
