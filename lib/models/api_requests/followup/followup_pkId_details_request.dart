class FollowupPkIdDetailsRequest {
  String pkID;
  String CompanyId;
  String LoginUserID;

  /*pkID:1
LoginUserID:admin
CompanyId:4132*/

  FollowupPkIdDetailsRequest({this.pkID, this.CompanyId, this.LoginUserID});

  FollowupPkIdDetailsRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
