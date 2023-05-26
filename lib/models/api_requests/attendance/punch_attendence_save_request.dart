/*

Mode
pkID
EmployeeID
PresenceDate
TimeIn
TimeOut
LunchIn
LunchOut
LoginUserID
Notes
Latitude
Longitude
LocationAddress
CompanyId

*/

class PunchAttendanceSaveRequest {
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

  String pkID;
  String CompanyId;
  String Mode;
  String EmployeeID;
  String FileName;
  String PresenceDate;
  String Time;
  String Notes;
  String Latitude;
  String Longitude;
  String LocationAddress;
  String LoginUserId;

  PunchAttendanceSaveRequest(
      {this.pkID,
      this.CompanyId,
      this.Mode,
      this.EmployeeID,
      this.FileName,
      this.PresenceDate,
      this.Time,
      this.Notes,
      this.Latitude,
      this.Longitude,
      this.LocationAddress,
      this.LoginUserId});

  PunchAttendanceSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    CompanyId = json['CompanyId'];
    Mode = json['Mode'];
    EmployeeID = json['EmployeeID'];
    FileName = json['FileName'];
    PresenceDate = json['PresenceDate'];
    Time = json['Time'];
    Notes = json['Notes'];
    Latitude = json['Latitude'];
    Longitude = json['Longitude'];
    LocationAddress = json['LocationAddress'];
    LoginUserId = json['LoginUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, String>();

    data['Mode'] = this.Mode;

    data['pkID'] = this.pkID;
    data['CompanyId'] = this.CompanyId;
    data['Mode'] = this.Mode;
    data['EmployeeID'] = this.EmployeeID;
    data['FileName'] = this.FileName;
    data['PresenceDate'] = this.PresenceDate;
    data['Time'] = this.Time;
    data['Notes'] = this.Notes;
    data['Latitude'] = this.Latitude;
    data['Longitude'] = this.Longitude;
    data['LocationAddress'] = this.LocationAddress;
    data['LoginUserId'] = this.LoginUserId;

    return data;
  }
}
