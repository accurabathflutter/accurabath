class FollowupImageListResponse {
  List<FollowupImageListResponseDetails> details;
  int totalCount;

  FollowupImageListResponse({this.details, this.totalCount});

  FollowupImageListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new FollowupImageListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class FollowupImageListResponseDetails {
  int pkID;
  int followupID;
  String name;

  FollowupImageListResponseDetails({
    this.pkID,
    this.followupID,
    this.name,
  });

  FollowupImageListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    followupID = json['FollowupID'] == null ? 0 : json['FollowupID'];
    name = json['Name'] == null ? "" : json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['FollowupID'] = this.followupID;
    data['Name'] = this.name;
    return data;
  }
}
