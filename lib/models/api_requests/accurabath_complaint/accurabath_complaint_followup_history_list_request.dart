/*

pkID:16
//CustomerID:
SearchKey:
LoginUserID:admin
CompanyId:4156

*/

class AccuraBathComplaintFollowupHistoryListRequest {
  String pkID;
  String SearchKey;
  String CompanyID;
  String LoginUserID;
  String PageNo;
  String PageSize;

  /*pkID:2
LoginUserID:admin
SearchKey:
PageNo:
PageSize:
CompanyId:4156
*/

  AccuraBathComplaintFollowupHistoryListRequest(
      {this.pkID,
      this.SearchKey,
      this.CompanyID,
      this.LoginUserID,
      this.PageNo,
      this.PageSize});

  AccuraBathComplaintFollowupHistoryListRequest.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    CompanyID = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    PageNo = json['PageNo'];

    PageSize = json['PageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['CompanyId'] = this.CompanyID;
    data['LoginUserID'] = this.LoginUserID;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;

    return data;
  }
}
