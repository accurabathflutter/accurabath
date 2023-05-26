class ProductMasterListRequest {
/*ProductID:
CompanyId:4132
ListMode:
Searchkey:AAA
PageNo:1
PageSize:10
LoginUserID:admin*/
  String ProductID;
  String ListMode;
  String SearchKey;
  String PageNo;
  String PageSize;
  String LoginUserID;
  String CompanyId;

  ProductMasterListRequest(
      {this.ProductID,
      this.ListMode,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.LoginUserID,
      this.CompanyId});

  ProductMasterListRequest.fromJson(Map<String, dynamic> json) {
    ProductID = json['ProductID'];
    ListMode = json['ListMode'];
    SearchKey = json['Searchkey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.ProductID;
    data['ListMode'] = this.ListMode;
    data['Searchkey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
