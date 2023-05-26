/*FetchType:Quotation
No:,QT-AUG22-006,QT-AUG22-007,
CustomerID:91694
CompanyId:4132*/

class SalesOrderAllProductDeleteRequest {
  String CompanyId;

  SalesOrderAllProductDeleteRequest({this.CompanyId});

  SalesOrderAllProductDeleteRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
