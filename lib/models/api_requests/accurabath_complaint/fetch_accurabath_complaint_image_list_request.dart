class FetchAccuraBathComplaintImageListRequest {
  String pkID;
  String SearchKey;
  String ModuleName;
  String DocName;
  String KeyValue;
  String CompanyID;
  String LoginUserID;

  /*pkID:0
SearchKey:
ModuleName:complaint
DocName:
KeyValue:TK-APR23-001
LoginUserID:
CompanyId:4156*/

  FetchAccuraBathComplaintImageListRequest(
      {this.pkID,
      this.SearchKey,
      this.ModuleName,
      this.DocName,
      this.KeyValue,
      this.CompanyID,
      this.LoginUserID});

  FetchAccuraBathComplaintImageListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    ModuleName = json['ModuleName'];
    DocName = json['DocName'];
    KeyValue = json['KeyValue'];
    CompanyID = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['ModuleName'] = this.ModuleName;
    data['DocName'] = this.DocName;
    data['KeyValue'] = this.KeyValue;
    data['CompanyId'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
