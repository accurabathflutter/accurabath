/*ConstantHead:AttendenceWithImage
CompanyId:4132*/

class ConstantRequest {
  String ConstantHead;
  String CompanyId;

  ConstantRequest({this.ConstantHead, this.CompanyId});

  ConstantRequest.fromJson(Map<String, dynamic> json) {
    ConstantHead = json['ConstantHead'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ConstantHead'] = this.ConstantHead;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
