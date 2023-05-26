class VkComplainPkIDtoDetailsResponse {
  List<VkComplainPkIDtoDetailsResponseDetails> details;
  int totalCount;

  VkComplainPkIDtoDetailsResponse({this.details, this.totalCount});

  VkComplainPkIDtoDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new VkComplainPkIDtoDetailsResponseDetails.fromJson(v));
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

class VkComplainPkIDtoDetailsResponseDetails {
  int rowNum;
  int pkID;
  String complaintNo;
  String complaintDate;
  String complaintStatus;
  int customerID;
  String customerName;
  String address;
  String contactNo1;
  int cityCode;
  String cityname;
  int stateCode;
  String stateName;
  String countryCode;
  String countryName;
  String pinCode;
  String scheduleDate;
  String complaintType;
  String complaintNotes;
  String requirementSpecs;
  String projectTypeSpecs;
  String technicalDetail;
  double markedAreaLength;
  double markedAreaWidth;
  double ceilingHeight;
  double tentativeBudget;
  String visitedDate;
  String contactPerson;
  String designation;
  String timeIn;
  String timeOut;
  String siteInCharge;

  String visitedPerson;
  String requirementDetail;
  String projectType;
  String noOfVisit;
  int employeeID;
  String metWith;
  String contactNo;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String AssignedTo;
  String SiteInChargeName;
  String VisitedPersonName;

  VkComplainPkIDtoDetailsResponseDetails(
      {this.rowNum,
      this.pkID,
      this.complaintNo,
      this.complaintDate,
      this.complaintStatus,
      this.customerID,
      this.customerName,
      this.address,
      this.contactNo1,
      this.cityCode,
      this.cityname,
      this.stateCode,
      this.stateName,
      this.countryCode,
      this.countryName,
      this.pinCode,
      this.scheduleDate,
      this.complaintType,
      this.complaintNotes,
      this.requirementSpecs,
      this.projectTypeSpecs,
      this.technicalDetail,
      this.markedAreaLength,
      this.markedAreaWidth,
      this.ceilingHeight,
      this.tentativeBudget,
      this.visitedDate,
      this.contactPerson,
      this.designation,
      this.timeIn,
      this.timeOut,
      this.siteInCharge,
      this.visitedPerson,
      this.requirementDetail,
      this.projectType,
      this.noOfVisit,
      this.employeeID,
      this.metWith,
      this.contactNo,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.AssignedTo,
      this.SiteInChargeName,
      this.VisitedPersonName});

  VkComplainPkIDtoDetailsResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    complaintDate = json['ComplaintDate'] == null ? "" : json['ComplaintDate'];
    complaintStatus =
        json['ComplaintStatus'] == null ? "" : json['ComplaintStatus'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    address = json['Address'] == null ? "" : json['Address'];
    contactNo1 = json['ContactNo1'] == null ? "" : json['ContactNo1'];
    cityCode = json['CityCode'] == null ? 0 : json['CityCode'];
    cityname = json['Cityname'] == null ? "" : json['Cityname'];
    stateCode = json['StateCode'] == null ? 0 : json['StateCode'];
    stateName = json['StateName'] == null ? "" : json['StateName'];
    countryCode = json['CountryCode'] == null ? "" : json['CountryCode'];
    countryName = json['CountryName'] == null ? "" : json['CountryName'];
    pinCode = json['PinCode'] == null ? "" : json['PinCode'];
    scheduleDate = json['ScheduleDate'] == null ? "" : json['ScheduleDate'];
    complaintType = json['ComplaintType'] == null ? "" : json['ComplaintType'];
    complaintNotes =
        json['ComplaintNotes'] == null ? "" : json['ComplaintNotes'];
    requirementSpecs =
        json['RequirementSpecs'] == null ? "" : json['RequirementSpecs'];
    projectTypeSpecs =
        json['ProjectTypeSpecs'] == null ? "" : json['ProjectTypeSpecs'];
    technicalDetail =
        json['TechnicalDetail'] == null ? "" : json['TechnicalDetail'];
    markedAreaLength =
        json['MarkedAreaLength'] == null ? 0.00 : json['MarkedAreaLength'];
    markedAreaWidth =
        json['MarkedAreaWidth'] == null ? 0.00 : json['MarkedAreaWidth'];
    ceilingHeight =
        json['CeilingHeight'] == null ? 0.00 : json['CeilingHeight'];
    tentativeBudget =
        json['TentativeBudget'] == null ? 0.00 : json['TentativeBudget'];
    visitedDate = json['Date'] == null ? "" : json['Date'];
    contactPerson = json['ContactPerson'] == null ? "" : json['ContactPerson'];
    designation = json['Designation'] == null ? "" : json['Designation'];
    timeIn = json['TimeIn'] == null ? "" : json['TimeIn'];
    timeOut = json['TimeOut'] == null ? "" : json['TimeOut'];
    siteInCharge = json['SiteInCharge'] == null ? "" : json['SiteInCharge'];
    visitedPerson = json['VisitedPerson'] == null ? "" : json['VisitedPerson'];
    requirementDetail =
        json['RequirementDetail'] == null ? "" : json['RequirementDetail'];
    projectType = json['ProjectType'] == null ? "" : json['ProjectType'];
    noOfVisit = json['NoOfVisit'] == null ? "" : json['NoOfVisit'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    metWith = json['MetWith'] == null ? "" : json['MetWith'];
    contactNo = json['ContactNo'] == null ? "" : json['ContactNo'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
    AssignedTo = json['AssignedTo'] == null ? "" : json['AssignedTo'];
    SiteInChargeName =
        json['SiteInChargeName'] == null ? "" : json['SiteInChargeName'];
    VisitedPersonName =
        json['VisitedPersonName'] == null ? "" : json['VisitedPersonName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.complaintNo;
    data['ComplaintDate'] = this.complaintDate;
    data['ComplaintStatus'] = this.complaintStatus;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['Address'] = this.address;
    data['ContactNo1'] = this.contactNo1;
    data['CityCode'] = this.cityCode;
    data['Cityname'] = this.cityname;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['PinCode'] = this.pinCode;
    data['ScheduleDate'] = this.scheduleDate;
    data['ComplaintType'] = this.complaintType;
    data['ComplaintNotes'] = this.complaintNotes;
    data['RequirementSpecs'] = this.requirementSpecs;
    data['ProjectTypeSpecs'] = this.projectTypeSpecs;
    data['TechnicalDetail'] = this.technicalDetail;
    data['MarkedAreaLength'] = this.markedAreaLength;
    data['MarkedAreaWidth'] = this.markedAreaWidth;
    data['CeilingHeight'] = this.ceilingHeight;
    data['TentativeBudget'] = this.tentativeBudget;
    data['Date'] = this.visitedDate;
    data['ContactPerson'] = this.contactPerson;
    data['Designation'] = this.designation;
    data['TimeIn'] = this.timeIn;
    data['TimeOut'] = this.timeOut;
    data['SiteInCharge'] = this.siteInCharge;
    data['VisitedPerson'] = this.visitedPerson;
    data['RequirementDetail'] = this.requirementDetail;
    data['ProjectType'] = this.projectType;
    data['NoOfVisit'] = this.noOfVisit;
    data['EmployeeID'] = this.employeeID;
    data['MetWith'] = this.metWith;
    data['ContactNo'] = this.contactNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['AssignedTo'] = AssignedTo;
    data['SiteInChargeName'] = AssignedTo;
    data['VisitedPersonName'] = AssignedTo;

    return data;
  }
}
