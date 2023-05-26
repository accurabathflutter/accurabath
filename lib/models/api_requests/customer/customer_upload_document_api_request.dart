/*pkID:0
Name:delete_user_black.png
CustomerID:81569
LoginUserId:admin
CompanyId:4132*/

import 'dart:io';

class CustomerUploadDocumentApiRequest {
  String pkID;
  String Name;
  String CustomerID;
  String CompanyID;
  String LoginUserId;
  File file;

  CustomerUploadDocumentApiRequest(
      {this.pkID,
      this.Name,
      this.CustomerID,
      this.CompanyID,
      this.LoginUserId,
      this.file});

  CustomerUploadDocumentApiRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    Name = json['Name'];
    CustomerID = json['CustomerID'];
    CompanyID = json['CompanyId'];
    LoginUserId = json['LoginUserId'];
    file = json[''];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['pkID'] = this.pkID;
    data['Name'] = this.Name;
    data['CustomerID'] = this.CustomerID;
    data['CompanyId'] = this.CompanyID;
    data['LoginUserId'] = this.LoginUserId;

    return data;
  }
}
