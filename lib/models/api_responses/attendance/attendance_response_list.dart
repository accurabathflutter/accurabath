class Attendance_List_Response {
  List<AttendanceList> details;
  int totalCount;

  Attendance_List_Response({this.details, this.totalCount});

  Attendance_List_Response.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new AttendanceList.fromJson(v));
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

class AttendanceList {
  int pkID;
  int employeeID;
  String employeeName;
  String presenceDate;
  String timeIn;
  String timeOut;
  String LunchIn;
  String LunchOut;
  String notes;
  int workingHrs;

  String LunchIMageURL_Out;
  String LunchIMageURL_in;
  String ImageURL_In;
  String ImageURL_OUT;
  String LocationAddress_IN;
  String LocationAddress_OUT;

  /* "LunchIMageURL_Out": null,
                "LunchIMageURL_in": null,
                "ImageURL_In": "47_18_11_2022_1668745318864.jpg",
                "ImageURL_OUT": null,*/

  AttendanceList({
    this.pkID,
    this.employeeID,
    this.employeeName,
    this.presenceDate,
    this.timeIn,
    this.timeOut,
    this.LunchIn,
    this.LunchOut,
    this.workingHrs,
    this.notes,
    this.LunchIMageURL_Out,
    this.LunchIMageURL_in,
    this.ImageURL_In,
    this.ImageURL_OUT,
    this.LocationAddress_IN,
    this.LocationAddress_OUT,
  });

  AttendanceList.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    presenceDate = json['PresenceDate'];
    timeIn = json['TimeIn'];
    timeOut = json['TimeOut'];
    workingHrs = json['WorkingHrs'];
    notes = json['Notes'] == null ? "" : json['Notes'];
    LunchIn = json['LunchIn'] == null ? "" : json['LunchIn'];
    LunchOut = json['LunchOut'] == null ? "" : json['LunchOut'];
    LunchIMageURL_Out =
        json['LunchIMageURL_Out'] == null ? "" : json['LunchIMageURL_Out'];
    LunchIMageURL_in =
        json['LunchIMageURL_in'] == null ? "" : json['LunchIMageURL_in'];
    ImageURL_In = json['ImageURL_In'] == null ? "" : json['ImageURL_In'];
    ImageURL_OUT = json['ImageURL_OUT'] == null ? "" : json['ImageURL_OUT'];
    LocationAddress_IN =
        json['LocationAddress_IN'] == null ? "" : json['LocationAddress_IN'];
    LocationAddress_OUT =
        json['LocationAddress_OUT'] == null ? "" : json['LocationAddress_OUT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['PresenceDate'] = this.presenceDate;
    data['TimeIn'] = this.timeIn;
    data['TimeOut'] = this.timeOut;
    data['WorkingHrs'] = this.workingHrs;
    data['Notes'] = this.notes;
    data['LunchIn'] = this.LunchIn;
    data['LunchOut'] = this.LunchOut;
    data['LunchIMageURL_Out'] = this.LunchIMageURL_Out;
    data['LunchIMageURL_in'] = this.LunchIMageURL_in;
    data['ImageURL_In'] = this.ImageURL_In;
    data['ImageURL_OUT'] = this.ImageURL_OUT;
    data['LocationAddress_IN'] = this.LocationAddress_IN;
    data['LocationAddress_OUT'] = this.LocationAddress_OUT;

    return data;
  }
}
