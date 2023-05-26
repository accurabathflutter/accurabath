class QuickComplaintSaveRequest {
  String pkID;
  String ComplaintNo;
  String CustomerID;
  String VisitDate;
  String TimeFrom;
  String TimeTo;
  String VisitNotes;
  String VisitType;
  String VisitChargeType;
  String VisitCharge;
  String ComplaintStatus;
  String TimeIn;
  String TimeOut;
  String Latitude_IN;
  String Longitude_IN;
  String Latitude_OUT;
  String Longitude_OUT;
  String LocationAddress_IN;
  String LocationAddress_OUT;
  String NextVisitDate;
  String LoginUserID;
  String CompanyId;

  QuickComplaintSaveRequest(
      {this.pkID,
      this.ComplaintNo,
      this.CustomerID,
      this.VisitDate,
      this.TimeFrom,
      this.TimeTo,
      this.VisitNotes,
      this.VisitType,
      this.VisitChargeType,
      this.VisitCharge,
      this.ComplaintStatus,
      this.TimeIn,
      this.TimeOut,
      this.Latitude_IN,
      this.Longitude_IN,
      this.Latitude_OUT,
      this.Longitude_OUT,
      this.LocationAddress_IN,
      this.LocationAddress_OUT,
      this.NextVisitDate,
      this.LoginUserID,
      this.CompanyId});

  QuickComplaintSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ComplaintNo = json['ComplaintNo'];
    CustomerID = json['CustomerID'];
    VisitDate = json['VisitDate'];
    TimeFrom = json['TimeFrom'];
    TimeTo = json['TimeTo'];
    VisitNotes = json['VisitNotes'];
    VisitType = json['VisitType'];
    VisitChargeType = json['VisitChargeType'];
    VisitCharge = json['VisitCharge'];
    ComplaintStatus = json['ComplaintStatus'];
    TimeIn = json['TimeIn'];
    TimeOut = json['TimeOut'];
    Latitude_IN = json['Latitude_IN'];
    Longitude_IN = json['Longitude_IN'];
    Latitude_OUT = json['Latitude_OUT'];
    Longitude_OUT = json['Longitude_OUT'];
    LocationAddress_IN = json['LocationAddress_IN'];
    LocationAddress_OUT = json['LocationAddress_OUT'];
    NextVisitDate = json['NextVisitDate'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.ComplaintNo;
    data['CustomerID'] = this.CustomerID;
    data['VisitDate'] = this.VisitDate;
    data['TimeFrom'] = this.TimeFrom;
    data['TimeTo'] = this.TimeTo;
    data['VisitNotes'] = this.VisitNotes;
    data['VisitType'] = this.VisitType;
    data['VisitChargeType'] = this.VisitChargeType;
    data['VisitCharge'] = this.VisitCharge;
    data['ComplaintStatus'] = this.ComplaintStatus;
    data['TimeIn'] = this.TimeIn;
    data['TimeOut'] = this.TimeOut;
    data['Latitude_IN'] = this.Latitude_IN;
    data['Longitude_IN'] = this.Longitude_IN;
    data['Latitude_OUT'] = this.Latitude_OUT;
    data['Longitude_OUT'] = this.Longitude_OUT;
    data['LocationAddress_IN'] = this.LocationAddress_IN;
    data['LocationAddress_OUT'] = this.LocationAddress_OUT;
    data['NextVisitDate'] = this.NextVisitDate;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
