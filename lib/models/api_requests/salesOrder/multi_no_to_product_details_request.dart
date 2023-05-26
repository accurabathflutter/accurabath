/*FetchType:Quotation
No:,QT-AUG22-006,QT-AUG22-007,
CustomerID:91694
CompanyId:4132*/

class MultiNoToProductDetailsRequest {
  String FetchType;
  String No;
  String CustomerID;
  String CompanyId;

  MultiNoToProductDetailsRequest(
      {this.FetchType, this.No, this.CustomerID, this.CompanyId});

  MultiNoToProductDetailsRequest.fromJson(Map<String, dynamic> json) {
    FetchType = json['FetchType'];
    No = json['No'];
    CustomerID = json['CustomerID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FetchType'] = this.FetchType;
    data['No'] = this.No;
    data['CustomerID'] = this.CustomerID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
