class AccuraBathComplaintSaveRequest {
  String ComplaintDate;
  String ComplaintNo;
  String CustomerEmpName;
  String CustmoreMobileNo;
  String ComplaintNotes;
  String ComplaintType;
  String ComplaintStatus;
  String CustomerID2;
  String PreferredDate;
  String TimeFrom;
  String TimeTo;
  String LoginUserID;
  String CompanyId;
  String ReferenceNo;
  String DateOfPurchase;
  String SiteAddress;
  String CityCode;
  String CountryCode;
  String StateCode;
  String Pincode;
  String ConvinientDate;
  String ProductID;
  String SrNo;
  String pkID;

  AccuraBathComplaintSaveRequest({
    this.pkID,
    this.ComplaintDate,
    this.ComplaintNo,
    this.CustomerEmpName,
    this.CustmoreMobileNo,
    this.ComplaintNotes,
    this.ComplaintType,
    this.ComplaintStatus,
    this.CustomerID2,
    this.PreferredDate,
    this.TimeFrom,
    this.TimeTo,
    this.LoginUserID,
    this.CompanyId,
    this.ReferenceNo,
    this.DateOfPurchase,
    this.SiteAddress,
    this.CityCode,
    this.CountryCode,
    this.StateCode,
    this.Pincode,
    this.ConvinientDate,
    this.ProductID,
    this.SrNo,
  });

  AccuraBathComplaintSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ComplaintDate = json['ComplaintDate'];
    ComplaintNo = json['ComplaintNo'];
    CustomerEmpName = json['CustomerEmpName'];
    CustmoreMobileNo = json['CustmoreMobileNo'];
    ComplaintNotes = json['ComplaintNotes'];
    ComplaintType = json['ComplaintType'];
    ComplaintStatus = json['ComplaintStatus'];
    CustomerID2 = json['CustomerID2'];
    PreferredDate = json['PreferredDate'];
    TimeFrom = json['TimeFrom'];
    TimeTo = json['TimeTo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    ReferenceNo = json['ReferenceNo'];
    DateOfPurchase = json['DateOfPurchase'];
    SiteAddress = json['SiteAddress'];
    CityCode = json['CityCode'];
    CountryCode = json['CountryCode'];
    StateCode = json['StateCode'];
    Pincode = json['Pincode'];
    ConvinientDate = json['ConvinientDate'];
    ProductID = json['ProductID'];
    SrNo = json['SrNo'];
  }

  /*pkID:0
ComplaintDate:2023-04-04
ComplaintNo:
CustomerEmpName:Kumar Patil
CustmoreMobileNo:8488861994
ReferenceNo:ReferenceNo____________________
SrNo:SrNo
ProductID:100141
SiteAddress:Satellite
CityCode:350
StateCode:12
CountryCode:IND
Pincode:380015
ComplaintNotes:Fault Need to Fix.
PreferredDate:2023-04-10
TimeFrom:10:10 AM
TimeTo:10:10 PM
CustomerID2:32771_____________
ComplaintStatus:Open
ComplaintType:Online
LoginUserID:admin
CompanyId:4156*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ComplaintDate'] = this.ComplaintDate;
    data['ComplaintDate'] = this.ComplaintDate;
    data['ComplaintNo'] = this.ComplaintNo;
    data['CustomerEmpName'] = this.CustomerEmpName;
    data['CustmoreMobileNo'] = this.CustmoreMobileNo;
    data['ComplaintNotes'] = this.ComplaintNotes;
    data['ComplaintType'] = this.ComplaintType;
    data['ComplaintStatus'] = this.ComplaintStatus;
    data['CustomerID2'] = this.CustomerID2;
    data['PreferredDate'] = this.PreferredDate;
    data['TimeFrom'] = this.TimeFrom;
    data['TimeTo'] = this.TimeTo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['ReferenceNo'] = this.ReferenceNo;
    data['DateOfPurchase'] = this.DateOfPurchase;
    data['SiteAddress'] = this.SiteAddress;
    data['CityCode'] = this.CityCode;
    data['CountryCode'] = this.CountryCode;
    data['StateCode'] = this.StateCode;
    data['Pincode'] = this.Pincode;
    data['ConvinientDate'] = this.ConvinientDate;
    data['ProductID'] = this.ProductID;
    data['SrNo'] = this.SrNo;

    return data;
  }
}
