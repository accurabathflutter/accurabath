/*CustomerID:41447
CompanyId:4132*/

class CustomerDeleteDocumentApiRequest {
  String CompanyID;

  CustomerDeleteDocumentApiRequest({
    this.CompanyID,
  });

  CustomerDeleteDocumentApiRequest.fromJson(Map<String, dynamic> json) {
    CompanyID = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['CompanyId'] = this.CompanyID;

    return data;
  }
}
