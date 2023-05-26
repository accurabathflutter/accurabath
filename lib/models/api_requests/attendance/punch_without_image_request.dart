/*String Mode;
  String pkID;
  String EmployeeID;
  String PresenceDate;
  String TimeIn;
  String TimeOut;
  String LunchIn;
  String LunchOut;
  String LoginUserID;
  String Notes;
  String Latitude;
  String Longitude;
  String LocationAddress;
  String CompanyId;*/

class PunchWithoutImageAttendanceSaveRequest {
  String Mode;
  String pkID;
  String EmployeeID;
  String PresenceDate;
  String TimeIn;
  String TimeOut;
  String LunchIn;
  String LunchOut;
  String LoginUserID;
  String Notes;
  String Latitude;
  String Longitude;
  String LocationAddress;
  String CompanyId;

  PunchWithoutImageAttendanceSaveRequest(
      {this.Mode,
      this.pkID,
      this.EmployeeID,
      this.PresenceDate,
      this.TimeIn,
      this.TimeOut,
      this.LunchIn,
      this.LunchOut,
      this.LoginUserID,
      this.Notes,
      this.Latitude,
      this.Longitude,
      this.LocationAddress,
      this.CompanyId});

  PunchWithoutImageAttendanceSaveRequest.fromJson(Map<String, dynamic> json) {
    Mode = json['Mode'];
    pkID = json['pkID'];
    EmployeeID = json['EmployeeID'];
    PresenceDate = json['PresenceDate'];
    TimeIn = json['TimeIn'];
    TimeOut = json['TimeOut'];
    LunchIn = json['LunchIn'];
    LunchOut = json['LunchOut'];
    LoginUserID = json['LoginUserID'];
    Notes = json['Notes'];
    Latitude = json['Latitude'];
    Longitude = json['Longitude'];
    LocationAddress = json['LocationAddress'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, String>();

    data['Mode'] = this.Mode;
    data['pkID'] = this.pkID;
    data['EmployeeID'] = this.EmployeeID;
    data['PresenceDate'] = this.PresenceDate;
    data['TimeIn'] = this.TimeIn;
    data['TimeOut'] = this.TimeOut;
    data['LunchIn'] = this.LunchIn;
    data['LunchOut'] = this.LunchOut;
    data['LoginUserID'] = this.LoginUserID;
    data['Notes'] = this.Notes;
    data['Latitude'] = this.Latitude;
    data['Longitude'] = this.Longitude;
    data['LocationAddress'] = this.LocationAddress;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
