/*InquiryNo:MAR23-001
ProductID:40122
LoginUserID:admin
CompanyId:4132*/

class InquiryNoToFetchProductSizedListRequest {
  String InquiryNo;
  String ProductID;
  String LoginUserID;
  String CompanyId;

  InquiryNoToFetchProductSizedListRequest(
      {this.InquiryNo, this.ProductID, this.LoginUserID, this.CompanyId});

  InquiryNoToFetchProductSizedListRequest.fromJson(Map<String, dynamic> json) {
    InquiryNo = json['InquiryNo'];
    ProductID = json['ProductID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InquiryNo'] = this.InquiryNo;
    data['ProductID'] = this.ProductID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
