class InquiryListApiRequest {
  String CompanyId;
  String LoginUserID;
  String PkId;
  String EmployeeID;

  InquiryListApiRequest(
      {this.CompanyId, this.LoginUserID, this.PkId, this.EmployeeID});

  InquiryListApiRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    PkId = json['PkID'];
    EmployeeID = json['EmployeeID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['PkID'] = this.PkId;
    data['EmployeeID'] = this.EmployeeID;
    return data;
  }
}
