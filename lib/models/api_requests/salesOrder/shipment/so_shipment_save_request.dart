class SOShipmentSaveRequest {
  String OrderNo;
  String SCompanyName;
  String SGSTNo;
  String SContactNo;
  String SContactPersonName;
  String SAddress;
  String SArea;
  String SCountryCode;
  String SCityCode;
  String SStateCode;
  String SPincode;
  String LoginUserID;
  String CompanyId;

  SOShipmentSaveRequest(
      {this.OrderNo,
      this.SCompanyName,
      this.SGSTNo,
      this.SContactNo,
      this.SContactPersonName,
      this.SAddress,
      this.SArea,
      this.SCountryCode,
      this.SCityCode,
      this.SStateCode,
      this.SPincode,
      this.LoginUserID,
      this.CompanyId});

  SOShipmentSaveRequest.fromJson(Map<String, dynamic> json) {
    OrderNo = json['OrderNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    OrderNo = json['OrderNo'];
    SCompanyName = json['SCompanyName'];
    SGSTNo = json['SGSTNo'];
    SContactNo = json['SContactNo'];
    SContactPersonName = json['SContactPersonName'];
    SAddress = json['SAddress'];
    SArea = json['SArea'];
    SCountryCode = json['SCountryCode'];
    SCityCode = json['SCityCode'];
    SStateCode = json['SStateCode'];
    SPincode = json['SPincode'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['OrderNo'] = this.OrderNo;
    data['SCompanyName'] = this.SCompanyName;
    data['SGSTNo'] = this.SGSTNo;
    data['SContactNo'] = this.SContactNo;
    data['SContactPersonName'] = this.SContactPersonName;
    data['SAddress'] = this.SAddress;
    data['SArea'] = this.SArea;
    data['SCountryCode'] = this.SCountryCode;
    data['SCityCode'] = this.SCityCode;
    data['SStateCode'] = this.SStateCode;
    data['SPincode'] = this.SPincode;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
