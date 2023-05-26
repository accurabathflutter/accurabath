/*pkID
ExtpkID
FollowupDate
FollowupSource
InquiryStatusID
MeetingNotes
NextFollowupDate
PreferredTime
LeadStatus
NoFollClosureID
AssignToEmployee
LoginUserID
CompanyId*/

class TeleCallerFollowupSaveRequest {
  String pkID;
  String ExtpkID;
  String FollowupDate;
  String FollowupSource;
  String InquiryStatusID;
  String MeetingNotes;
  String NextFollowupDate;
  String PreferredTime;
  String LeadStatus;
  String NoFollClosureID;
  String AssignToEmployee;
  String LoginUserID;
  String CompanyId;

  TeleCallerFollowupSaveRequest(
      {this.pkID,
      this.ExtpkID,
      this.FollowupDate,
      this.FollowupSource,
      this.InquiryStatusID,
      this.MeetingNotes,
      this.NextFollowupDate,
      this.PreferredTime,
      this.LeadStatus,
      this.NoFollClosureID,
      this.AssignToEmployee,
      this.LoginUserID,
      this.CompanyId});

  TeleCallerFollowupSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ExtpkID = json['ExtpkID'];
    FollowupDate = json['FollowupDate'];
    FollowupSource = json['FollowupSource'];
    InquiryStatusID = json['InquiryStatusID'];
    MeetingNotes = json['MeetingNotes'];
    NextFollowupDate = json['NextFollowupDate'];
    PreferredTime = json['PreferredTime'];
    LeadStatus = json['LeadStatus'];
    NoFollClosureID = json['NoFollClosureID'];
    AssignToEmployee = json['AssignToEmployee'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = this.pkID;
    data['ExtpkID'] = this.ExtpkID;
    data['FollowupDate'] = this.FollowupDate;
    data['FollowupSource'] = this.FollowupSource;
    data['InquiryStatusID'] = this.InquiryStatusID;
    data['MeetingNotes'] = this.MeetingNotes;
    data['NextFollowupDate'] = this.NextFollowupDate;
    data['PreferredTime'] = this.PreferredTime;
    data['LeadStatus'] = this.LeadStatus;
    data['NoFollClosureID'] = this.NoFollClosureID;
    data['AssignToEmployee'] = this.AssignToEmployee;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
