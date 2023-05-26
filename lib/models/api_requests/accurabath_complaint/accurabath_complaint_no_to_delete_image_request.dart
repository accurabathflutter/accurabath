class AccurabathComplaintImageDeleteRequest {
  String CompanyId;
  String LoginUserID;
  String KeyValue;

  AccurabathComplaintImageDeleteRequest(
      {this.CompanyId, this.LoginUserID, this.KeyValue});

  AccurabathComplaintImageDeleteRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    KeyValue = json['KeyValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['KeyValue'] = this.KeyValue;
    data['DocName'] = "";
    return data;
  }
}
