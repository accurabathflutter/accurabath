class VkComplaintListRequest {
  String pkID;
  String SearchKey;
  String LoginUserID;
  String CompanyId;

  VkComplaintListRequest(
      {this.pkID, this.SearchKey, this.LoginUserID, this.CompanyId});

  VkComplaintListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
