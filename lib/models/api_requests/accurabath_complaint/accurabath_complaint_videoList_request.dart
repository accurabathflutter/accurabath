class AccuraBathComplaintVideoListRequest {
  String pkID;
  String ComplaintNo;
  String Type;
  String LoginUserID;
  String CompanyId;

  /*pkID:0
ComplaintNo:TK-APR23-001
Type:sitevideo
LoginUserID:admin
CompanyId:4156*/

  AccuraBathComplaintVideoListRequest({
    this.pkID,
    this.ComplaintNo,
    this.Type,
    this.LoginUserID,
    this.CompanyId,
  });

  AccuraBathComplaintVideoListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ComplaintNo = json['ComplaintNo'];
    Type = json['Type'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = pkID;
    data['ComplaintNo'] = this.ComplaintNo;
    data['Type'] = this.Type;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
