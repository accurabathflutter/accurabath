class AccurabathComplaintVideoDeleteRequest {
  String CompanyId;
  String LoginUserID;
  String ComplaintNo;

  AccurabathComplaintVideoDeleteRequest(
      {this.CompanyId, this.LoginUserID, this.ComplaintNo});

  AccurabathComplaintVideoDeleteRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    ComplaintNo = json['ComplaintNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['ComplaintNo'] = this.ComplaintNo;
    return data;
  }
}
