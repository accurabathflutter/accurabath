class VkComplaintHistoryRequest {
  String CustomerID;

  String CompanyId;

  VkComplaintHistoryRequest({this.CustomerID, this.CompanyId});

  VkComplaintHistoryRequest.fromJson(Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.CustomerID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
