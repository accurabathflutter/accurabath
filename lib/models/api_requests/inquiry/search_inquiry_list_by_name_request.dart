class SearchInquiryListByNameRequest {
  String CompanyId;
  String LoginUserID;
  String needALL;
  String word;
  String EmployeeID;

  /*CompanyId:10032
CustomerName:Sharv
ProductName:Test M
InquiryNo:
StateCode:
CityCode:
CountryCode:
Priority:
NameOnly:1
Word:*/

  SearchInquiryListByNameRequest(
      {this.CompanyId,
      this.LoginUserID,
      this.word,
      this.needALL,
      this.EmployeeID});

  SearchInquiryListByNameRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    word = json['word'];
    needALL = json['needALL'];
    EmployeeID = json['EmployeeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['word'] = this.word;
    data['needALL'] = this.needALL;
    data['EmployeeID'] = this.EmployeeID;

    return data;
  }
}
