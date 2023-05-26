/*pkID:
InvoiceNo:Inv-DEC22-002
LoginUserID:admin
CompanyId:4132*/

class SBExportListRequest {
  String pkID;
  String InvoiceNo;
  String LoginUserID;
  String CompanyId;

  SBExportListRequest(
      {this.pkID, this.InvoiceNo, this.LoginUserID, this.CompanyId});

  SBExportListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    InvoiceNo = json['InvoiceNo'];
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.InvoiceNo;
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
