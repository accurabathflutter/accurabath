/*TaskStatus:Future
Month:0
Year:0
SearchKey:
LoginUserID:admin
PageNo:1
PageSize:11
CompanyId:4132*/

class OfficeToListRequest {
  String TaskStatus;
  String LoginUserID;
  String CompanyId;
  int PageNo;
  int PageSize;

  /*

TaskTitle:
TaskStatus:Completed
LoginUserID:admin
CompanyId:10032
Month:
Year:
EmployeeID:49
PageNo:1
PageSize:11
  */

  OfficeToListRequest({
    this.TaskStatus,
    this.LoginUserID,
    this.CompanyId,
    this.PageNo,
    this.PageSize
  });

  OfficeToListRequest.fromJson(Map<String, dynamic> json) {
    TaskStatus = json['TaskStatus'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['TaskStatus'] = this.TaskStatus;
    data['Month'] = "";
    data['Year'] = "";
    data['SearchKey'] = "";
    data['LoginUserID'] = this.LoginUserID;
    data['PageNo'] = 1;
    data['PageSize'] = 100000;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
