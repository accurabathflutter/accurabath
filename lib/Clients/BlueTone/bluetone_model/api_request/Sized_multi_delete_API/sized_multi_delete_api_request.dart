/*InquiryNo:MAR23-001
ProductID:40122
LoginUserID:admin
CompanyId:4132*/

class SizedMultiDeleteApiRequest {
  String CompanyId;

  SizedMultiDeleteApiRequest({this.CompanyId});

  SizedMultiDeleteApiRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
