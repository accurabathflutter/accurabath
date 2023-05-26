/*ExtpkID:1284043
LoginUserID:admin
CompanyId:4132*/

class TeleCallerFollowupHistoryRequest {
  // String FollowupDate;

  String ExtpkID;
  String LoginUserID;

  String CompanyId;

  TeleCallerFollowupHistoryRequest(
      {this.ExtpkID, this.LoginUserID, this.CompanyId});

  TeleCallerFollowupHistoryRequest.fromJson(Map<String, dynamic> json) {
    // FollowupDate = json['FollowupDate'];
    ExtpkID = json['ExtpkID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['FollowupDate'] = this.FollowupDate;
    data['ExtpkID'] = this.ExtpkID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
