class AssignToNotificationRequest {
  String EmployeeID;
  String CompanyId;

  AssignToNotificationRequest({this.EmployeeID, this.CompanyId});

  AssignToNotificationRequest.fromJson(Map<String, dynamic> json) {
    EmployeeID = json['EmployeeID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();

    data['EmployeeID'] = this.EmployeeID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
