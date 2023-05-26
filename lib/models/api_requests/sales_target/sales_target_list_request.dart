class SalaryTargetListRequest {
  /*LoginUserID:
Day:0
Month:0
Year:0
TargetType:A
PageNo:1
PageSize:111
CompanyId:4132*/
  String LoginUserID;
  String Day;
  String Month;
  String Year;
  String TargetType;
  String PageNo;
  String PageSize;
  String CompanyId;
  String EmployeeID;

  SalaryTargetListRequest({
    this.LoginUserID,
    this.Day,
    this.Month,
    this.Year,
    this.TargetType,
    this.PageNo,
    this.PageSize,
    this.CompanyId,
    this.EmployeeID,
  });

  SalaryTargetListRequest.fromJson(Map<String, dynamic> json) {
    LoginUserID = json['LoginUserID'];
    Day = json['Day'];
    Month = json['Month'];
    Year = json['Year'];
    TargetType = json['TargetType'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
    EmployeeID = json['EmployeeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LoginUserID'] = this.LoginUserID;
    data['Day'] = this.Day;
    data['Month'] = this.Month;
    data['Year'] = this.Year;
    data['TargetType'] = this.TargetType;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;
    data['EmployeeID'] = this.EmployeeID;

    return data;
  }
}
