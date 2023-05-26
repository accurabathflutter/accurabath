/*

Module:pro
QuotationNo:
FinishProductID:40119
LoginUserID:admin
CompanyId:4132
* */

class SpecificationListRequest {
  String Module;
  String QuotationNo;
  String FinishProductID;
  String LoginUserID;
  String CompanyId;

  SpecificationListRequest(
      {this.Module,
      this.QuotationNo,
      this.FinishProductID,
      this.LoginUserID,
      this.CompanyId});

  SpecificationListRequest.fromJson(Map<String, dynamic> json) {
    Module = json['Module'];
    QuotationNo = json['QuotationNo'];
    FinishProductID = json['FinishProductID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Module'] = this.Module;
    data['QuotationNo'] = this.QuotationNo;
    data['FinishProductID'] = this.FinishProductID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
