class SizeListResponse {
  List<SizeListResponseDetails> details;
  int totalCount;

  SizeListResponse({this.details, this.totalCount});

  SizeListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SizeListResponseDetails.fromJson(v));
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

class SizeListResponseDetails {
  int productID;
  String productName;
  int sizeID;
  String sizeName;

  SizeListResponseDetails({this.productID, this.productName, this.sizeID, this.sizeName});

  SizeListResponseDetails.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID'];
    productName = json['ProductName'];
    sizeID = json['SizeID'];
    sizeName = json['SizeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['SizeID'] = this.sizeID;
    data['SizeName'] = this.sizeName;
    return data;
  }
}