class SOShipmentDeleteRequest {
  String OrderNo;
  String CompanyId;

  SOShipmentDeleteRequest({this.OrderNo, this.CompanyId});

  SOShipmentDeleteRequest.fromJson(Map<String, dynamic> json) {
    OrderNo = json['OrderNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.OrderNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
