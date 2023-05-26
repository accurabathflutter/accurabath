class SOShipmentlistResponse {
  List<SOShipmentlistResponseDetails> details;
  int totalCount;

  SOShipmentlistResponse({this.details, this.totalCount});

  SOShipmentlistResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SOShipmentlistResponseDetails.fromJson(v));
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

class SOShipmentlistResponseDetails {
  int rowNum;
  int pkID;
  String orderNo;
  String sCompanyName;
  String sGSTNo;
  String sContactNo;
  String sContactPersonName;
  String sAddress;
  String sArea;
  String sCountryCode;
  String countryName;
  int sCityCode;
  String cityName;
  int sStateCode;
  String stateName;
  String sPincode;
  String updatedBy;
  String updatedDate;
  int customerID;
  String customerName;
  int employeeID;
  String employeeName;
  String createdBy;
  String createdDate;
  String createdEmployeeName;
  int companyID;

  SOShipmentlistResponseDetails(
      {this.rowNum,
      this.pkID,
      this.orderNo,
      this.sCompanyName,
      this.sGSTNo,
      this.sContactNo,
      this.sContactPersonName,
      this.sAddress,
      this.sArea,
      this.sCountryCode,
      this.countryName,
      this.sCityCode,
      this.cityName,
      this.sStateCode,
      this.stateName,
      this.sPincode,
      this.updatedBy,
      this.updatedDate,
      this.customerID,
      this.customerName,
      this.employeeID,
      this.employeeName,
      this.createdBy,
      this.createdDate,
      this.createdEmployeeName,
      this.companyID});

  SOShipmentlistResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    orderNo = json['OrderNo'] == null ? "" : json['OrderNo'];
    sCompanyName = json['SCompanyName'] == null ? "" : json['SCompanyName'];
    sGSTNo = json['SGSTNo'] == null ? "" : json['SGSTNo'];
    sContactNo = json['SContactNo'] == null ? "" : json['SContactNo'];
    sContactPersonName =
        json['SContactPersonName'] == null ? "" : json['SContactPersonName'];
    sAddress = json['SAddress'] == null ? "" : json['SAddress'];
    sArea = json['SArea'] == null ? "" : json['SArea'];
    sCountryCode = json['SCountryCode'] == null ? "" : json['SCountryCode'];
    countryName = json['CountryName'] == null ? "" : json['CountryName'];
    sCityCode = json['SCityCode'] == null ? 0 : json['SCityCode'];
    cityName = json['CityName'] == null ? "" : json['CityName'];
    sStateCode = json['SStateCode'] == null ? 0 : json['SStateCode'];
    stateName = json['StateName'] == null ? "" : json['StateName'];
    sPincode = json['SPincode'] == null ? "" : json['SPincode'];
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    createdEmployeeName =
        json['CreatedEmployeeName'] == null ? "" : json['CreatedEmployeeName'];
    companyID = json['CompanyID'] == null ? 0 : json['CompanyID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.orderNo;
    data['SCompanyName'] = this.sCompanyName;
    data['SGSTNo'] = this.sGSTNo;
    data['SContactNo'] = this.sContactNo;
    data['SContactPersonName'] = this.sContactPersonName;
    data['SAddress'] = this.sAddress;
    data['SArea'] = this.sArea;
    data['SCountryCode'] = this.sCountryCode;
    data['CountryName'] = this.countryName;
    data['SCityCode'] = this.sCityCode;
    data['CityName'] = this.cityName;
    data['SStateCode'] = this.sStateCode;
    data['StateName'] = this.stateName;
    data['SPincode'] = this.sPincode;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['CompanyID'] = this.companyID;
    return data;
  }
}
