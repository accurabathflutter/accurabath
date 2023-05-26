class QTSpecSaveRequest {
  String pkID;
  String QuotationNo;
  String FinishProductID;
  String GroupHead;
  String MaterialHead;
  String MaterialSpec;
  String MaterialRemarks;
  String ItemOrder;
  String LoginUserID;
  String CompanyId;

  QTSpecSaveRequest(
      {this.pkID,
      this.QuotationNo,
      this.FinishProductID,
      this.GroupHead,
      this.MaterialHead,
      this.MaterialSpec,
      this.MaterialRemarks,
      this.ItemOrder,
      this.LoginUserID,
      this.CompanyId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['QuotationNo'] = this.QuotationNo;
    data['FinishProductID'] = this.FinishProductID;
    data['GroupHead'] = this.GroupHead;
    data['MaterialHead'] = this.MaterialHead;
    data['MaterialSpec'] = this.MaterialSpec;
    data['MaterialRemarks'] = this.MaterialRemarks;
    data['ItemOrder'] = this.ItemOrder;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
