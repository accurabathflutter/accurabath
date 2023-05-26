/*InquiryNo:MAR23-001
ProductID:40122
LoginUserID:admin
CompanyId:4132*/

class SizedListInsUpdateApiRequest {
  String InquiryNo;
  String ProductID;
  String SizeID;
  String LoginUserID;
  String CompanyId;

  SizedListInsUpdateApiRequest(
      {this.InquiryNo,
      this.ProductID,
      this.SizeID,
      this.LoginUserID,
      this.CompanyId});

  SizedListInsUpdateApiRequest.fromJson(Map<String, dynamic> json) {
    InquiryNo = json['InquiryNo'];
    ProductID = json['ProductID'];
    SizeID = json['SizeID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InquiryNo'] = this.InquiryNo;
    data['ProductID'] = this.ProductID;
    data['SizeID'] = this.SizeID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
