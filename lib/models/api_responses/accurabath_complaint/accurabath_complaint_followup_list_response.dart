class AccuraBathComplaintFollowupHistoryListResponse {
  List<AccuraBathComplaintFollowupHistoryListResponseDetails> details;
  int totalCount;

  AccuraBathComplaintFollowupHistoryListResponse(
      {this.details, this.totalCount});

  AccuraBathComplaintFollowupHistoryListResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new AccuraBathComplaintFollowupHistoryListResponseDetails.fromJson(
                v));
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

class AccuraBathComplaintFollowupHistoryListResponseDetails {
  int rowNum;
  int pkID;
  int comppkID;
  String followupSource;
  int inquiryStatusID;
  String inquiryStatus;
  String meetingNotes;
  String followupDate;
  String nextFollowupDate;
  String preferredTime;
  int customerID;
  String customerName;

  AccuraBathComplaintFollowupHistoryListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.comppkID,
      this.followupSource,
      this.inquiryStatusID,
      this.inquiryStatus,
      this.meetingNotes,
      this.followupDate,
      this.nextFollowupDate,
      this.preferredTime,
      this.customerID,
      this.customerName});

  AccuraBathComplaintFollowupHistoryListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    comppkID = json['ComppkID'] == null ? 0 : json['ComppkID'];
    followupSource =
        json['FollowupSource'] == null ? "" : json['FollowupSource'];
    inquiryStatusID =
        json['InquiryStatusID'] == null ? 0 : json['InquiryStatusID'];
    inquiryStatus = json['InquiryStatus'] == null ? "" : json['InquiryStatus'];
    meetingNotes = json['MeetingNotes'] == null ? "" : json['MeetingNotes'];
    followupDate = json['FollowupDate'] == null ? "" : json['FollowupDate'];
    nextFollowupDate =
        json['NextFollowupDate'] == null ? "" : json['NextFollowupDate'];
    preferredTime = json['PreferredTime'] == null ? "" : json['PreferredTime'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComppkID'] = this.comppkID;
    data['FollowupSource'] = this.followupSource;
    data['InquiryStatusID'] = this.inquiryStatusID;
    data['InquiryStatus'] = this.inquiryStatus;
    data['MeetingNotes'] = this.meetingNotes;
    data['FollowupDate'] = this.followupDate;
    data['NextFollowupDate'] = this.nextFollowupDate;
    data['PreferredTime'] = this.preferredTime;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    return data;
  }
}
