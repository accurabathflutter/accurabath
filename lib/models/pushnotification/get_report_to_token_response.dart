class GetReportToTokenResponse {
  List<GetReportToTokenResponseDetails> details;
  int totalCount;

  GetReportToTokenResponse({this.details, this.totalCount});

  GetReportToTokenResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new GetReportToTokenResponseDetails.fromJson(v));
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

class GetReportToTokenResponseDetails {
  int employeeID;
  String employeeName;
  int reportTo;
  String reportPersonName;
  String reportPersonTokenNo;

  GetReportToTokenResponseDetails(
      {this.employeeID,
      this.employeeName,
      this.reportTo,
      this.reportPersonName,
      this.reportPersonTokenNo});

  GetReportToTokenResponseDetails.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    reportTo = json['ReportTo'] == null ? 0 : json['ReportTo'];
    reportPersonName =
        json['ReportPersonName'] == null ? "" : json['ReportPersonName'];
    reportPersonTokenNo =
        json['ReportPersonTokenNo'] == null ? "" : json['ReportPersonTokenNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['ReportTo'] = this.reportTo;
    data['ReportPersonName'] = this.reportPersonName;
    data['ReportPersonTokenNo'] = this.reportPersonTokenNo;
    return data;
  }
}
