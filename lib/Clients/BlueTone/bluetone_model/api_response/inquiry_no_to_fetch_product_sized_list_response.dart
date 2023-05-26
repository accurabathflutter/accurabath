class InquiryNoToFetchProductSizedListResponse {
  List<InquiryNoToFetchProductSizedListResponseDetails> details;
  int totalCount;

  InquiryNoToFetchProductSizedListResponse({this.details, this.totalCount});

  InquiryNoToFetchProductSizedListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new InquiryNoToFetchProductSizedListResponseDetails.fromJson(v));
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

class InquiryNoToFetchProductSizedListResponseDetails {
  String inquiryNo;
  int productID;
  String productName;
  int sizeID;
  String sizeName;

  InquiryNoToFetchProductSizedListResponseDetails(
      {this.inquiryNo,
        this.productID,
        this.productName,
        this.sizeID,
        this.sizeName});

  InquiryNoToFetchProductSizedListResponseDetails.fromJson(Map<String, dynamic> json) {
    inquiryNo = json['InquiryNo']==null?"":json['InquiryNo'];
    productID = json['ProductID']==null?0:json['ProductID'];
    productName = json['ProductName']==null?"":json['ProductName'];
    sizeID = json['SizeID']==null?0:json['SizeID'];
    sizeName = json['SizeName']==null?"":json['SizeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InquiryNo'] = this.inquiryNo;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['SizeID'] = this.sizeID;
    data['SizeName'] = this.sizeName;
    return data;
  }
}