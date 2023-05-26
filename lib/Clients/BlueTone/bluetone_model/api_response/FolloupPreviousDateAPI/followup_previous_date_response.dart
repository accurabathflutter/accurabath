class FollowupPreviousDateResponse {
  List<FollowupPreviousDateResponseDetails> details;
  int totalCount;

  FollowupPreviousDateResponse({this.details, this.totalCount});

  FollowupPreviousDateResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new FollowupPreviousDateResponseDetails.fromJson(v));
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

class FollowupPreviousDateResponseDetails {
  String CustomerName;
  String NextFollowupDate;
  String MeetingNotes;
  int pkID;

  FollowupPreviousDateResponseDetails(
      {this.CustomerName, this.NextFollowupDate, this.MeetingNotes, this.pkID});

  FollowupPreviousDateResponseDetails.fromJson(Map<String, dynamic> json) {
    CustomerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    NextFollowupDate =
        json['NextFollowupDate'] == null ? "" : json['NextFollowupDate'];
    MeetingNotes = json['MeetingNotes'] == null ? "" : json['MeetingNotes'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerName'] = this.CustomerName;
    data['NextFollowupDate'] = this.NextFollowupDate;
    data['MeetingNotes'] = this.MeetingNotes;
    data['pkID'] = this.pkID;

    return data;
  }
}
