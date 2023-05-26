class QucikComplaintListResponse {
  List<QucikComplaintListResponseDetails> details;
  int totalCount;

  QucikComplaintListResponse({this.details, this.totalCount});

  QucikComplaintListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new QucikComplaintListResponseDetails.fromJson(v));
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

class QucikComplaintListResponseDetails {
  int pkID;
  String visitDate;
  String nextVisitDate;
  String visitNotes;
  int complaintNo;
  String visitType;
  int employeeID;
  String employeeName;
  String complaintStatus;
  String timeIn;
  String timeOut;
  String latitudeIN;
  String latitudeOUT;
  String longitudeIN;
  String longitudeOUT;
  String locationAddressIN;
  String locationAddressOUT;
  String createdBy;
  String createdEmployeeName;
  String createdDate;

  QucikComplaintListResponseDetails(
      {this.pkID,
      this.visitDate,
      this.nextVisitDate,
      this.visitNotes,
      this.complaintNo,
      this.visitType,
      this.employeeID,
      this.employeeName,
      this.complaintStatus,
      this.timeIn,
      this.timeOut,
      this.latitudeIN,
      this.latitudeOUT,
      this.longitudeIN,
      this.longitudeOUT,
      this.locationAddressIN,
      this.locationAddressOUT,
      this.createdBy,
      this.createdEmployeeName,
      this.createdDate});

  QucikComplaintListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    visitDate = json['VisitDate'];
    nextVisitDate = json['NextVisitDate'];
    visitNotes = json['VisitNotes'];
    complaintNo = json['ComplaintNo'];
    visitType = json['VisitType'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    complaintStatus = json['ComplaintStatus'];
    timeIn = json['TimeIn'];
    timeOut = json['TimeOut'];
    latitudeIN = json['Latitude_IN'];
    latitudeOUT = json['Latitude_OUT'];
    longitudeIN = json['Longitude_IN'];
    longitudeOUT = json['Longitude_OUT'];
    locationAddressIN = json['LocationAddress_IN'];
    locationAddressOUT = json['LocationAddress_OUT'];
    createdBy = json['CreatedBy'];
    createdEmployeeName = json['CreatedEmployeeName'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['VisitDate'] = this.visitDate;
    data['NextVisitDate'] = this.nextVisitDate;
    data['VisitNotes'] = this.visitNotes;
    data['ComplaintNo'] = this.complaintNo;
    data['VisitType'] = this.visitType;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['ComplaintStatus'] = this.complaintStatus;
    data['TimeIn'] = this.timeIn;
    data['TimeOut'] = this.timeOut;
    data['Latitude_IN'] = this.latitudeIN;
    data['Latitude_OUT'] = this.latitudeOUT;
    data['Longitude_IN'] = this.longitudeIN;
    data['Longitude_OUT'] = this.longitudeOUT;
    data['LocationAddress_IN'] = this.locationAddressIN;
    data['LocationAddress_OUT'] = this.locationAddressOUT;
    data['CreatedBy'] = this.createdBy;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
