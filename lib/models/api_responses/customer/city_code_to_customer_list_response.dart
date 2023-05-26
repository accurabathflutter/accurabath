class CityCodeToCustomerListResponse {
  List<CityCodeToCustomerListResponseDetails> details;
  int totalCount;

  CityCodeToCustomerListResponse({this.details, this.totalCount});

  CityCodeToCustomerListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CityCodeToCustomerListResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class CityCodeToCustomerListResponseDetails {
  int rowNum;
  int customerID;
  String customerName;
  String address;
  String contactNo1;
  String contactNo2;
  String emailAddress;
  String gSTNO;
  String pANNO;
  int cityCode;
  String cityname;
  int stateCode;
  String stateName;
  String countryCode;
  String countryName;
  String pinCode;

  CityCodeToCustomerListResponseDetails(
      {this.rowNum,
      this.customerID,
      this.customerName,
      this.address,
      this.contactNo1,
      this.contactNo2,
      this.emailAddress,
      this.gSTNO,
      this.pANNO,
      this.cityCode,
      this.cityname,
      this.stateCode,
      this.stateName,
      this.countryCode,
      this.countryName,
      this.pinCode});

  CityCodeToCustomerListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    address = json['Address'] == null ? "" : json['Address'];
    contactNo1 = json['ContactNo1'] == null ? "" : json['ContactNo1'];
    contactNo2 = json['ContactNo2'] == null ? "" : json['ContactNo2'];
    emailAddress = json['EmailAddress'] == null ? "" : json['EmailAddress'];
    gSTNO = json['GSTNO'] == null ? "" : json['GSTNO'];
    pANNO = json['PANNO'] == null ? "" : json['PANNO'];
    cityCode = json['CityCode'] == null ? 0 : json['CityCode'];
    cityname = json['Cityname'] == null ? "" : json['Cityname'];
    stateCode = json['StateCode'] == null ? 0 : json['StateCode'];
    stateName = json['StateName'] == null ? "" : json['StateName'];
    countryCode = json['CountryCode'] == null ? "" : json['CountryCode'];
    countryName = json['CountryName'] == null ? "" : json['CountryName'];
    pinCode = json['PinCode'] == null ? "" : json['PinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['Address'] = this.address;
    data['ContactNo1'] = this.contactNo1;
    data['ContactNo2'] = this.contactNo2;
    data['EmailAddress'] = this.emailAddress;
    data['GSTNO'] = this.gSTNO;
    data['PANNO'] = this.pANNO;
    data['CityCode'] = this.cityCode;
    data['Cityname'] = this.cityname;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['PinCode'] = this.pinCode;
    return data;
  }
}
