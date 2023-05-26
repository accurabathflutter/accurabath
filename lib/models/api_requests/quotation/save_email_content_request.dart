/*pkID:0
Subject:Regarding PO
ContentData:Developed Direct send Email to Client
LoginUserID:admin
CompanyId:4132*/

class SaveEmailContentRequest {
  String pkID;
  String Subject;
  String ContentData;
  String LoginUserID;
  String CompanyId;

  SaveEmailContentRequest(
      {this.pkID,
      this.Subject,
      this.ContentData,
      this.LoginUserID,
      this.CompanyId});

  SaveEmailContentRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    Subject = json['Subject'];
    ContentData = json['ContentData'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['Subject'] = this.Subject;
    data['ContentData'] = this.ContentData;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
