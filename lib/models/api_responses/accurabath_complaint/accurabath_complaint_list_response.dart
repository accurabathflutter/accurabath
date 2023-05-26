class AccuraBathComplaintListResponse {
  List<AccuraBathComplaintListResponseDetails> details;
  int totalCount;

  AccuraBathComplaintListResponse({this.details, this.totalCount});

  AccuraBathComplaintListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new AccuraBathComplaintListResponseDetails.fromJson(v));
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

class AccuraBathComplaintListResponseDetails {
  int rowNum;
  int pkID;
  String complaintDate;
  String complaintNo;
  String customerEmpName;
  String custmoreMobileNo;
  String referenceNo;
  String srNo;
  int productID;
  String productName;
  String siteAddress;
  int cityCode;
  String cityName;
  int stateCode;
  String stateName;
  String countryCode;
  String countryName;
  String pincode;
  String complaintNotes;
  String preferredDate;
  String timeFrom;
  String timeTo;
  String customerID2;
  String assignedTo;
  String complaintStatus;
  String complaintType;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;

  AccuraBathComplaintListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.complaintDate,
      this.complaintNo,
      this.customerEmpName,
      this.custmoreMobileNo,
      this.referenceNo,
      this.srNo,
      this.productID,
      this.productName,
      this.siteAddress,
      this.cityCode,
      this.cityName,
      this.stateCode,
      this.stateName,
      this.countryCode,
      this.countryName,
      this.pincode,
      this.complaintNotes,
      this.preferredDate,
      this.timeFrom,
      this.timeTo,
      this.customerID2,
      this.assignedTo,
      this.complaintStatus,
      this.complaintType,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  AccuraBathComplaintListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintDate = json['ComplaintDate'] == null ? "" : json['ComplaintDate'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    customerEmpName =
        json['CustomerEmpName'] == null ? "" : json['CustomerEmpName'];
    custmoreMobileNo =
        json['CustmoreMobileNo'] == null ? "" : json['CustmoreMobileNo'];
    referenceNo = json['ReferenceNo'] == null ? "" : json['ReferenceNo'];
    srNo = json['SrNo'] == null ? "" : json['SrNo'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    siteAddress = json['SiteAddress'] == null ? "" : json['SiteAddress'];
    cityCode = json['CityCode'] == null ? 0 : json['CityCode'];
    cityName = json['CityName'] == null ? "" : json['CityName'];
    stateCode = json['StateCode'] == null ? 0 : json['StateCode'];
    stateName = json['StateName'] == null ? "" : json['StateName'];
    countryCode = json['CountryCode'] == null ? "" : json['CountryCode'];
    countryName = json['CountryName'] == null ? "" : json['CountryName'];
    pincode = json['Pincode'] == null ? "" : json['Pincode'];
    complaintNotes =
        json['ComplaintNotes'] == null ? "" : json['ComplaintNotes'];
    preferredDate = json['PreferredDate'] == null ? "" : json['PreferredDate'];
    timeFrom = json['TimeFrom'] == null ? "" : json['TimeFrom'];
    timeTo = json['TimeTo'] == null ? "" : json['TimeTo'];
    customerID2 = json['CustomerID2'] == null ? "" : json['CustomerID2'];
    assignedTo = json['AssignedTo'] == null ? "" : json['AssignedTo'];
    complaintStatus =
        json['ComplaintStatus'] == null ? "" : json['ComplaintStatus'];
    complaintType = json['ComplaintType'] == null ? "" : json['ComplaintType'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComplaintDate'] = this.complaintDate;
    data['ComplaintNo'] = this.complaintNo;
    data['CustomerEmpName'] = this.customerEmpName;
    data['CustmoreMobileNo'] = this.custmoreMobileNo;
    data['ReferenceNo'] = this.referenceNo;
    data['SrNo'] = this.srNo;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['SiteAddress'] = this.siteAddress;
    data['CityCode'] = this.cityCode;
    data['CityName'] = this.cityName;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['Pincode'] = this.pincode;
    data['ComplaintNotes'] = this.complaintNotes;
    data['PreferredDate'] = this.preferredDate;
    data['TimeFrom'] = this.timeFrom;
    data['TimeTo'] = this.timeTo;
    data['CustomerID2'] = this.customerID2;
    data['AssignedTo'] = this.assignedTo;
    data['ComplaintStatus'] = this.complaintStatus;
    data['ComplaintType'] = this.complaintType;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    return data;
  }
}
