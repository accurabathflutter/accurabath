/*LoginUserID:admin
CompanyId:4132*/

class LogoutCountRequest {
  String LoginUserID;
  String CompanyId;

  LogoutCountRequest({this.LoginUserID, this.CompanyId});

  LogoutCountRequest.fromJson(Map<String, dynamic> json) {
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
