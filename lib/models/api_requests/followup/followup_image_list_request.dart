class FollowupImageListRequest {
  String CompanyId;
  String FollowUpID;

  FollowupImageListRequest({this.CompanyId, this.FollowUpID});

  FollowupImageListRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    FollowUpID = json['FollowUpID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['FollowUpID'] = this.FollowUpID;

    return data;
  }
}
