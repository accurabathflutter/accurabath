class QuickComplaintListRequest {
  String Status;
  String CompanyId;

  QuickComplaintListRequest({this.Status, this.CompanyId});

  QuickComplaintListRequest.fromJson(Map<String, dynamic> json) {
    Status = json['Status'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.Status;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
