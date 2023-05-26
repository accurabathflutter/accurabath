/*OrderNo:SO-JAN21-001
LoginUserID:admin
CompanyId:4132
*/

class SOExportListRequest {
  String OrderNo;
  String LoginUserID;
  String CompanyId;

  SOExportListRequest({this.OrderNo, this.LoginUserID, this.CompanyId});

  SOExportListRequest.fromJson(Map<String, dynamic> json) {
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
