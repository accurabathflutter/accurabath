class FollowupPkIdDetailsResponse {
  List<FollowupPkIdDetailsResponseDetails> details;
  int totalCount;

  FollowupPkIdDetailsResponse({this.details, this.totalCount});

  FollowupPkIdDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new FollowupPkIdDetailsResponseDetails.fromJson(v));
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

class FollowupPkIdDetailsResponseDetails {
  int rowNum;
  int pkID;
  String inquiryNo;
  String inquiryDate;
  int customerID;
  String customerName;
  String meetingNotes;
  String followupDate;
  String nextFollowupDate;
  int rating;
  bool noFollowup;
  int inquiryStatusID;
  String inquiryStatus;
  String inquirySource;
  String priority;
  String inquiryStatusDesc;
  String employeeName;
  String quotationNo;
  String latitude;
  String longitude;
  String preferredTime;
  String contactNo1;
  String contactNo2;
  int noFollClosureID;
  String noFollClosureName;
  String contactPerson1;
  String contactNumber1;
  String FollowupStatus;
  int FollowupStatusID;
  int InquiryStatus_Desc_ID;
  int FollowupPriority;
  String TimeIn;
  String TimeOut;
  String FollowUpImage;

  FollowupPkIdDetailsResponseDetails(
      {this.rowNum,
      this.pkID,
      this.inquiryNo,
      this.inquiryDate,
      this.customerID,
      this.customerName,
      this.meetingNotes,
      this.followupDate,
      this.nextFollowupDate,
      this.rating,
      this.noFollowup,
      this.inquiryStatusID,
      this.inquiryStatus,
      this.inquirySource,
      this.priority,
      this.inquiryStatusDesc,
      this.employeeName,
      this.quotationNo,
      this.latitude,
      this.longitude,
      this.preferredTime,
      this.contactNo1,
      this.contactNo2,
      this.noFollClosureID,
      this.noFollClosureName,
      this.contactPerson1,
      this.contactNumber1,
      this.FollowupStatus,
      this.FollowupStatusID,
      this.InquiryStatus_Desc_ID,
      this.FollowupPriority,
      this.TimeIn,
      this.TimeOut,
      this.FollowUpImage});

  FollowupPkIdDetailsResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    inquiryNo = json['InquiryNo'] == null ? "" : json['InquiryNo'];
    inquiryDate = json['InquiryDate'] == null ? "" : json['InquiryDate'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    meetingNotes = json['MeetingNotes'] == null ? "" : json['MeetingNotes'];
    followupDate = json['FollowupDate'] == null ? "" : json['FollowupDate'];
    nextFollowupDate = nextFollowupDate =
        json['NextFollowupDate'] == null ? "" : json['NextFollowupDate'];
    rating = json['Rating'] == null ? 0 : json['Rating'];
    noFollowup = json['NoFollowup'] == null ? false : json['NoFollowup'];
    inquiryStatusID =
        json['InquiryStatusID'] == null ? 0 : json['InquiryStatusID'];
    inquiryStatus = json['InquiryStatus'] == null ? "" : json['InquiryStatus'];
    inquirySource = json['InquirySource'] == null ? "" : json['InquirySource'];
    priority = json['Priority'] == null ? "" : json['Priority'];
    inquiryStatusDesc =
        json['InquiryStatus_Desc'] == null ? "" : json['InquiryStatus_Desc'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    quotationNo = json['QuotationNo'] == null ? "" : json['QuotationNo'];
    latitude = json['Latitude'] == null ? "" : json['Latitude'];
    longitude = json['Longitude'] == null ? "" : json['Longitude'];
    preferredTime = json['PreferredTime'] == null ? "" : json['PreferredTime'];
    contactNo1 = json['ContactNo1'] == null ? "" : json['ContactNo1'];
    contactNo2 = json['ContactNo2'] == null ? "" : json['ContactNo2'];
    noFollClosureID =
        json['NoFollClosureID'] == null ? 0 : json['NoFollClosureID'];
    noFollClosureName =
        json['NoFollClosureName'] == null ? "" : json['NoFollClosureName'];
    contactPerson1 =
        json['ContactPerson1'] == null ? "" : json['ContactPerson1'];
    contactNumber1 =
        json['ContactNumber1'] == null ? "" : json['ContactNumber1'];
    FollowupStatus =
        json['FollowupStatus'] == null ? "" : json['FollowupStatus'];
    FollowupStatusID =
        json['FollowupStatusID'] == null ? 0 : json['FollowupStatusID'];

    InquiryStatus_Desc_ID = json['InquiryStatus_Desc_ID'] == null
        ? 0
        : json['InquiryStatus_Desc_ID'];

    FollowupPriority =
        json['FollowupPriority'] == null ? 0 : json['FollowupPriority'];

    TimeIn = json['TimeIn'] == null ? "" : json['TimeIn'];

    TimeOut = json['TimeOut'] == null || json['TimeOut'] == "00:00:00"
        ? ""
        : json['TimeOut'];

    FollowUpImage = json['FollowUpImage'] == null ? "" : json['FollowUpImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InquiryNo'] = this.inquiryNo;
    data['InquiryDate'] = this.inquiryDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['MeetingNotes'] = this.meetingNotes;
    data['FollowupDate'] = this.followupDate;
    data['NextFollowupDate'] = this.nextFollowupDate;
    data['Rating'] = this.rating;
    data['NoFollowup'] = this.noFollowup;
    data['InquiryStatusID'] = this.inquiryStatusID;
    data['InquiryStatus'] = this.inquiryStatus;
    data['InquirySource'] = this.inquirySource;
    data['Priority'] = this.priority;
    data['InquiryStatus_Desc'] = this.inquiryStatusDesc;
    data['EmployeeName'] = this.employeeName;
    data['QuotationNo'] = this.quotationNo;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['PreferredTime'] = this.preferredTime;
    data['ContactNo1'] = this.contactNo1;
    data['ContactNo2'] = this.contactNo2;
    data['NoFollClosureID'] = this.noFollClosureID;
    data['NoFollClosureName'] = this.noFollClosureName;
    data['ContactPerson1'] = this.contactPerson1;
    data['ContactNumber1'] = this.contactNumber1;
    data['FollowupStatus'] = this.FollowupStatus;
    data['FollowupStatusID'] = this.FollowupStatusID;
    data['InquiryStatus_Desc_ID'] = this.InquiryStatus_Desc_ID;
    data['FollowupPriority'] = this.FollowupPriority;
    data['TimeIn'] = this.TimeIn;
    data['TimeOut'] = this.TimeOut;
    data['FollowUpImage'] = this.FollowUpImage;

    /*"FollowupStatus": "Visit",
                "FollowupStatusID": 5,
                "InquiryStatus_Desc_ID": null,
                "FollowupPriority": 3,
                "TimeIn": "14:33:00",
                "TimeOut": "16:01:00",
                "FollowUpImage": ""*/
    return data;
  }
}
