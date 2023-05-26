class GetReportToTokenRequest {
  String CompanyId;
  String EmployeeID;
  GetReportToTokenRequest({this.CompanyId, this.EmployeeID});

  GetReportToTokenRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    EmployeeID = json['EmployeeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['EmployeeID'] = this.EmployeeID;

    return data;
  }
}
