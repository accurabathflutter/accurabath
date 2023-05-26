/*

ModuleName:complaint
DocName:lady.png
KeyValue:TK-MAR22-002
LoginUserId:admin
CompanyId:4132
pkID:3

*/

import 'dart:io';

class AccuraBathComplaintUploadImageAPIRequest {
  String ModuleName;
  String DocName;
  String KeyValue;
  String LoginUserId;
  String CompanyId;
  String pkID;
  File file;

  AccuraBathComplaintUploadImageAPIRequest(
      {this.ModuleName,
      this.DocName,
      this.KeyValue,
      this.LoginUserId,
      this.CompanyId,
      this.pkID,
      this.file});

  AccuraBathComplaintUploadImageAPIRequest.fromJson(Map<String, dynamic> json) {
    ModuleName = json['ModuleName'];
    DocName = json['DocName'];
    KeyValue = json['KeyValue'];
    LoginUserId = json['LoginUserId'];
    CompanyId = json['CompanyId'];
    pkID = json['pkID'];
    file = json[''];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['ModuleName'] = this.ModuleName;
    data['DocName'] = this.DocName;
    data['KeyValue'] = this.KeyValue;
    data['LoginUserId'] = this.LoginUserId;
    data['CompanyId'] = this.CompanyId;
    data['pkID'] = this.pkID;

    // data['']=this.file;
    return data;
  }
}
