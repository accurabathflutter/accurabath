class CustomerFetchDocumentResponse {
  List<CustomerFetchDocumentResponseDetails> details;
  int totalCount;

  CustomerFetchDocumentResponse({this.details, this.totalCount});

  CustomerFetchDocumentResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CustomerFetchDocumentResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class CustomerFetchDocumentResponseDetails {
  int pkID;
  int customerID;
  String name;
  String customerName;
  String createdBy;
  String createdDate;

  CustomerFetchDocumentResponseDetails(
      {this.pkID,
      this.customerID,
      this.name,
      this.customerName,
      this.createdBy,
      this.createdDate});

  CustomerFetchDocumentResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    name = json['Name'] == null ? "" : json['Name'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CustomerID'] = this.customerID;
    data['Name'] = this.name;
    data['CustomerName'] = this.customerName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
