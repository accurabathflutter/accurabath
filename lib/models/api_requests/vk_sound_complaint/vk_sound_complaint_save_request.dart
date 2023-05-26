/*pkID:0
ComplaintNo:
ComplaintDate:2023-04-12
ComplaintStatus:Open
CustomerID:0
CustomerName:Kumar Patil 1
CustmoreMobileNo:8488861994
SiteAddress:Amraiwadi
CityCode:350
StateCode:12
CountryCode:IND
Pincode:380026
ScheduleDate:2023-04-12
ComplaintType:Online
ComplaintNotes:Place ComplaintNotes Here1
RequirementSpecs:Place RequirementSpecs Here1
ProjectTypeSpecs:Place ProjectTypeSpecs Here1
TechnicalDetail:Place TechnicalDetail Here1
MarkedAreaLength:10.10
MarkedAreaWidth:10.10
CeilingHeight:10.10
TentativeBudget:10.10
VisitedDate:2023-04-12
ContactPerson:CP
Designation:Technician
TimeIn:2023-04-12
SiteInCharge:SIC
VisitedPerson:VP
RequirementDetail:Home Theatre
ProjectType:Individual Bungalow
NoOfVisit:1st
EmployeeID:47
MetWith:MW
ContactNo:9974935623
LoginUserID:admin
CompanyId:4132
TimeOut:2023-04-12*/

class VkComplaintSaveRequest {
  String pkID;

  String ComplaintNo;

  String ComplaintDate;

  String ComplaintStatus;

  String CustomerID;

  String CustomerName;

  String CustmoreMobileNo;

  String SiteAddress;

  String CityCode;

  String StateCode;

  String CountryCode;

  String Pincode;

  String ScheduleDate;

  String ComplaintType;

  String ComplaintNotes;

  String RequirementSpecs;

  String ProjectTypeSpecs;

  String TechnicalDetail;

  String MarkedAreaLength;

  String MarkedAreaWidth;

  String CeilingHeight;

  String TentativeBudget;

  String VisitedDate;

  String ContactPerson;

  String Designation;

  String TimeIn;

  String SiteInCharge;

  String VisitedPerson;

  String RequirementDetail;

  String ProjectType;

  String NoOfVisit;

  String EmployeeID;

  String MetWith;

  String ContactNo;

  String LoginUserID;

  String CompanyId;
  String TimeOut;

  VkComplaintSaveRequest(
      {this.pkID,
      this.ComplaintNo,
      this.ComplaintDate,
      this.ComplaintStatus,
      this.CustomerID,
      this.CustomerName,
      this.CustmoreMobileNo,
      this.SiteAddress,
      this.CityCode,
      this.StateCode,
      this.CountryCode,
      this.Pincode,
      this.ScheduleDate,
      this.ComplaintType,
      this.ComplaintNotes,
      this.RequirementSpecs,
      this.ProjectTypeSpecs,
      this.TechnicalDetail,
      this.MarkedAreaLength,
      this.MarkedAreaWidth,
      this.CeilingHeight,
      this.TentativeBudget,
      this.VisitedDate,
      this.ContactPerson,
      this.Designation,
      this.TimeIn,
      this.SiteInCharge,
      this.VisitedPerson,
      this.RequirementDetail,
      this.ProjectType,
      this.NoOfVisit,
      this.EmployeeID,
      this.MetWith,
      this.ContactNo,
      this.LoginUserID,
      this.CompanyId,
      this.TimeOut});

  VkComplaintSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json[pkID];
    ComplaintNo = json[ComplaintNo];
    ComplaintDate = json[ComplaintDate];
    ComplaintStatus = json[ComplaintStatus];
    CustomerID = json[CustomerID];
    CustomerName = json[CustomerName];
    CustmoreMobileNo = json[CustmoreMobileNo];
    SiteAddress = json[SiteAddress];
    CityCode = json[CityCode];
    StateCode = json[StateCode];
    CountryCode = json[CountryCode];
    Pincode = json[Pincode];
    ScheduleDate = json[ScheduleDate];
    ComplaintType = json[ComplaintType];
    ComplaintNotes = json[ComplaintNotes];
    RequirementSpecs = json[RequirementSpecs];
    ProjectTypeSpecs = json[ProjectTypeSpecs];
    TechnicalDetail = json[TechnicalDetail];
    MarkedAreaLength = json[MarkedAreaLength];
    MarkedAreaWidth = json[MarkedAreaWidth];
    CeilingHeight = json[CeilingHeight];
    TentativeBudget = json[TentativeBudget];
    VisitedDate = json[VisitedDate];
    ContactPerson = json[ContactPerson];
    Designation = json[Designation];
    TimeIn = json[TimeIn];
    SiteInCharge = json[SiteInCharge];
    VisitedPerson = json[VisitedPerson];
    RequirementDetail = json[RequirementDetail];
    ProjectType = json[ProjectType];
    NoOfVisit = json[NoOfVisit];
    EmployeeID = json[EmployeeID];
    MetWith = json[MetWith];
    ContactNo = json[ContactNo];
    LoginUserID = json[LoginUserID];
    CompanyId = json[CompanyId];
    TimeOut = json[TimeOut];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.ComplaintNo;
    data['ComplaintDate'] = this.ComplaintDate;
    data['ComplaintStatus'] = this.ComplaintStatus;
    data['CustomerID'] = this.CustomerID;
    data['CustomerName'] = this.CustomerName;
    data['CustmoreMobileNo'] = this.CustmoreMobileNo;
    data['SiteAddress'] = this.SiteAddress;
    data['CityCode'] = this.CityCode;
    data['StateCode'] = this.StateCode;
    data['CountryCode'] = this.CountryCode;
    data['Pincode'] = this.Pincode;
    data['ScheduleDate'] = this.ScheduleDate;
    data['ComplaintType'] = this.ComplaintType;
    data['ComplaintNotes'] = this.ComplaintNotes;
    data['RequirementSpecs'] = this.RequirementSpecs;
    data['ProjectTypeSpecs'] = this.ProjectTypeSpecs;
    data['TechnicalDetail'] = this.TechnicalDetail;
    data['MarkedAreaLength'] = this.MarkedAreaLength;
    data['MarkedAreaWidth'] = this.MarkedAreaWidth;
    data['CeilingHeight'] = this.CeilingHeight;
    data['TentativeBudget'] = this.TentativeBudget;
    data['Date'] = this.VisitedDate;
    data['ContactPerson'] = this.ContactPerson;
    data['Designation'] = this.Designation;
    data['TimeIn'] = this.TimeIn;
    data['SiteInCharge'] = this.SiteInCharge;
    data['VisitedPerson'] = this.VisitedPerson;
    data['RequirementDetail'] = this.RequirementDetail;
    data['ProjectType'] = this.ProjectType;
    data['NoOfVisit'] = this.NoOfVisit;
    data['EmployeeID'] = this.EmployeeID;
    data['MetWith'] = this.MetWith;
    data['ContactNo'] = this.ContactNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['TimeOut'] = this.TimeOut;

    return data;
  }
}
