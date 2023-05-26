class AssignToNotificationResponse {
  List<AssignToNotificationResponseDetails> details;
  int totalCount;

  AssignToNotificationResponse({this.details, this.totalCount});

  AssignToNotificationResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new AssignToNotificationResponseDetails.fromJson(v));
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

class AssignToNotificationResponseDetails {
  int employeeID;
  String employeeName;
  String tokenNo;

  AssignToNotificationResponseDetails({this.employeeID, this.employeeName, this.tokenNo});

  AssignToNotificationResponseDetails.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    tokenNo = json['TokenNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['TokenNo'] = this.tokenNo;
    return data;
  }
}