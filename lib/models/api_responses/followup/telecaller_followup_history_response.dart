class TeleCallerFollowupHestoryResponse {
  List<TeleCallerFollowupHestoryResponseDetails> details;
  int totalCount;

  TeleCallerFollowupHestoryResponse({this.details, this.totalCount});

  TeleCallerFollowupHestoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new TeleCallerFollowupHestoryResponseDetails.fromJson(v));
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

class TeleCallerFollowupHestoryResponseDetails {
  int rowNum;
  int pkID;
  int extpkID;
  String inquiryNo;
  String inquiryDate;
  String leadSource;
  int inquiryStatusID;
  String inquiryStatus;
  String followUpSource;
  String customerName;
  String primaryMobileNo;
  String meetingNotes;
  String followupDate;
  String nextFollowupDate;
  String preferredTime;
  String leadStatus;
  String employeeName;
  String designation;

  TeleCallerFollowupHestoryResponseDetails(
      {this.rowNum,
      this.pkID,
      this.extpkID,
      this.inquiryNo,
      this.inquiryDate,
      this.leadSource,
      this.inquiryStatusID,
      this.inquiryStatus,
      this.followUpSource,
      this.customerName,
      this.primaryMobileNo,
      this.meetingNotes,
      this.followupDate,
      this.nextFollowupDate,
      this.preferredTime,
      this.leadStatus,
      this.employeeName,
      this.designation});

  TeleCallerFollowupHestoryResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] != null ? json['RowNum'] : 0;
    pkID = json['pkID'] != null ? json['pkID'] : 0;
    extpkID = json['ExtpkID'] != null ? json['ExtpkID'] : 0;
    inquiryNo = json['InquiryNo'] != null ? json['InquiryNo'] : "";
    inquiryDate = json['InquiryDate'] != null ? json['InquiryDate'] : "";
    leadSource = json['LeadSource'] != null ? json['LeadSource'] : "";
    inquiryStatusID =
        json['InquiryStatusID'] != null ? json['InquiryStatusID'] : 0;
    inquiryStatus = json['InquiryStatus'] != null ? json['InquiryStatus'] : "";
    followUpSource =
        json['FollowUpSource'] != null ? json['FollowUpSource'] : "";
    customerName = json['CustomerName'] != null ? json['CustomerName'] : "";
    primaryMobileNo =
        json['PrimaryMobileNo'] != null ? json['PrimaryMobileNo'] : "";
    meetingNotes = json['MeetingNotes'] != null ? json['MeetingNotes'] : "";
    followupDate = json['FollowupDate'] != null ? json['FollowupDate'] : "";
    nextFollowupDate =
        json['NextFollowupDate'] != null ? json['NextFollowupDate'] : "";
    preferredTime = json['PreferredTime'] != null ? json['PreferredTime'] : "";
    leadStatus = json['LeadStatus'] != null ? json['LeadStatus'] : "";
    employeeName = json['EmployeeName'] != null ? json['EmployeeName'] : "";
    designation = json['Designation'] != null ? json['Designation'] : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ExtpkID'] = this.extpkID;
    data['InquiryNo'] = this.inquiryNo;
    data['InquiryDate'] = this.inquiryDate;
    data['LeadSource'] = this.leadSource;
    data['InquiryStatusID'] = this.inquiryStatusID;
    data['InquiryStatus'] = this.inquiryStatus;
    data['FollowUpSource'] = this.followUpSource;
    data['CustomerName'] = this.customerName;
    data['PrimaryMobileNo'] = this.primaryMobileNo;
    data['MeetingNotes'] = this.meetingNotes;
    data['FollowupDate'] = this.followupDate;
    data['NextFollowupDate'] = this.nextFollowupDate;
    data['PreferredTime'] = this.preferredTime;
    data['LeadStatus'] = this.leadStatus;
    data['EmployeeName'] = this.employeeName;
    data['Designation'] = this.designation;
    return data;
  }
}
