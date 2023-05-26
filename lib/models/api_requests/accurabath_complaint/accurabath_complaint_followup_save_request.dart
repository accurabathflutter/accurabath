class AccuraBathComplaintFollowupSaveRequest {
  String ComppkID;
  String FollowupDate;
  String FollowupSource;
  String MeetingNotes;
  String NextFollowupDate;
  String PreferredTime;
  String CustomerID;
  String InquiryStatusID;
  String LoginUserID;
  String CompanyID;

  /*ComppkID:2
FollowupDate:2023-04-21
FollowupSource:Mail
MeetingNotes:Need to visit
NextFollowupDate:2023-04-22
PreferredTime:06:15 PM
LoginUserID:admin
CompanyId:4156*/

  AccuraBathComplaintFollowupSaveRequest(
      {this.ComppkID,
      this.FollowupDate,
      this.FollowupSource,
      this.MeetingNotes,
      this.NextFollowupDate,
      this.PreferredTime,
      this.CustomerID,
      this.InquiryStatusID,
      this.LoginUserID,
      this.CompanyID});

  AccuraBathComplaintFollowupSaveRequest.fromJson(Map<String, dynamic> json) {
    ComppkID = json['ComppkID'];
    FollowupDate = json['FollowupDate'];
    FollowupSource = json['FollowupSource'];
    MeetingNotes = json['MeetingNotes'];
    NextFollowupDate = json['NextFollowupDate'];
    PreferredTime = json['PreferredTime'];
    CustomerID = json['CustomerID'];
    InquiryStatusID = json['InquiryStatusID'];
    CompanyID = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComppkID'] = this.ComppkID;
    data['FollowupDate'] = this.FollowupDate;
    data['FollowupSource'] = this.FollowupSource;
    data['MeetingNotes'] = this.MeetingNotes;
    data['NextFollowupDate'] = this.NextFollowupDate;
    data['PreferredTime'] = this.PreferredTime;
    // data['CustomerID'] = this.CustomerID;
    // data['InquiryStatusID'] = this.InquiryStatusID;
    data['CompanyId'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
