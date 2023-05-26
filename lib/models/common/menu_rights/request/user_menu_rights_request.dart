/*MenuID:15
LoginUserID:admin
CompanyId:4132*/

class UserMenuRightsRequest {
  String MenuID;
  String CompanyId;
  String LoginUserID;

  UserMenuRightsRequest({this.MenuID, this.CompanyId, this.LoginUserID});

  UserMenuRightsRequest.fromJson(Map<String, dynamic> json) {
    MenuID = json['MenuID'];
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MenuID'] = this.MenuID;
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    return data;
  }
}
