/*

ModuleName:complaint
DocName:lady.png
KeyValue:TK-MAR22-002
LoginUserId:admin
CompanyId:4132
pkID:3

*/

import 'dart:io';

class AccuraBathComplaintUploadVideoAPIRequest {
  String CompanyId;
  String pkID;
  String ComplaintNo;
  String Name;
  String Type;
  String LoginUserId;
  File file;

  /*CompanyId:4156
pkID:0
ComplaintNo:TK-APR23-001
Name:sitevideo-videoplayback1.mp4
Type:sitevideo
LoginUserID:admin*/

  AccuraBathComplaintUploadVideoAPIRequest(
      {this.CompanyId,
      this.pkID,
      this.ComplaintNo,
      this.Name,
      this.Type,
      this.LoginUserId,
      this.file});

  AccuraBathComplaintUploadVideoAPIRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    pkID = json['pkID'];
    ComplaintNo = json['ComplaintNo'];
    Name = json['Name'];
    Type = json['Type'];
    LoginUserId = json['LoginUserID'];
    file = json[''];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['CompanyId'] = this.CompanyId;
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.ComplaintNo;
    data['Name'] = this.Name;
    data['Type'] = this.Type;
    data['LoginUserID'] = this.LoginUserId;

    // data['']=this.file;
    return data;
  }
}
