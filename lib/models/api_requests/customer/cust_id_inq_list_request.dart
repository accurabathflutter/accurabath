class CustIdToInqListRequest {
  String CustomerID;
  String ModuleType;
  String CompanyID;

  CustIdToInqListRequest({this.CustomerID, this.ModuleType, this.CompanyID});

  CustIdToInqListRequest.fromJson(Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];
    ModuleType = json['ModuleType'];
    CompanyID = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.CustomerID;
    data['ModuleType'] = this.ModuleType;
    data['CompanyId'] = this.CompanyID;

    return data;
  }
}
