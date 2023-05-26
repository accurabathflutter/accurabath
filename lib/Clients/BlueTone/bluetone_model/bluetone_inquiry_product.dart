class BlueToneProductModel {
  int id;
  String InquiryNo;
  String LoginUserID;
  String CompanyId;
  String ProductName;
  String ProductID;
  String UnitPrice;

  BlueToneProductModel(this.InquiryNo, this.LoginUserID, this.CompanyId,
      this.ProductName, this.ProductID, this.UnitPrice,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InquiryNo'] = this.InquiryNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['ProductName'] = this.ProductName;
    data['ProductID'] = this.ProductID;
    data['UnitPrice'] = this.UnitPrice;

    return data;
  }

  @override
  String toString() {
    return 'BlueToneProductModel{id: $id, InquiryNo: $InquiryNo, LoginUserID: $LoginUserID, CompanyId: $CompanyId, ProductName: $ProductName, ProductID: $ProductID, UnitPrice: $UnitPrice}';
  }
}
