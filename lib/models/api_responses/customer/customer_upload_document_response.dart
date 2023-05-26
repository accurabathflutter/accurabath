class CustomerUploadDocumentResponse {
  List<CustomerUploadDocumentResponseDetails> details;
  int totalCount;

  CustomerUploadDocumentResponse({this.details, this.totalCount});

  CustomerUploadDocumentResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CustomerUploadDocumentResponseDetails.fromJson(v));
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

class CustomerUploadDocumentResponseDetails {
  String column1;

  CustomerUploadDocumentResponseDetails({this.column1});

  CustomerUploadDocumentResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}
