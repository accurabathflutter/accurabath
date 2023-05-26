/*
* OrderNo:SO-AUG22-007
LoginUserID:admin
CompanyId:4132*/
class SOShipmentListRequest {
  String OrderNo;
  String LoginUserID;
  String CompanyId;

  SOShipmentListRequest({this.OrderNo, this.LoginUserID, this.CompanyId});

  SOShipmentListRequest.fromJson(Map<String, dynamic> json) {
    OrderNo = json['OrderNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.OrderNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
