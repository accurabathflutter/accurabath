/*CustomerID:41447
CompanyId:4132*/

class CustomerFetchDocumentApiRequest {
  String CustomerID;
  String CompanyID;

  CustomerFetchDocumentApiRequest({
    this.CustomerID,
    this.CompanyID,
  });

  CustomerFetchDocumentApiRequest.fromJson(Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];
    CompanyID = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['CustomerID'] = this.CustomerID;
    data['CompanyId'] = this.CompanyID;

    return data;
  }
}
