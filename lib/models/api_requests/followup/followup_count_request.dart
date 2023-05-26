class FollowupCountRequest {
  String CompanyId;
  String LoginUserID;
  String FollowupStatus;

  FollowupCountRequest({this.CompanyId, this.LoginUserID, this.FollowupStatus});

  FollowupCountRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    FollowupStatus = json['FollowupStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['FollowupStatus'] = this.FollowupStatus;

    return data;
  }
}
