class QuotationOrganizationListResponse {
  List<QuotationOrganizationListResponseDetails> details;
  int totalCount;

  QuotationOrganizationListResponse({this.details, this.totalCount});

  QuotationOrganizationListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new QuotationOrganizationListResponseDetails.fromJson(v));
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

class QuotationOrganizationListResponseDetails {
  int rowNum;
  int pkID;
  String orgCode;
  String orgName;
  int orgTypeCode;
  String orgType;
  String address;
  String pincode;
  String cityCode;
  String cityName;
  String stateCode;
  String stateName;
  String landline1;
  String landline2;
  String fax1;
  String fax2;
  String emailAddress;
  String reportToOrgCode;
  int gSTStateCode;
  String reportToOrgName;
  String gSTIN;
  String pANNO;
  String cINNO;
  bool activeFlag;
  String orgHead;
  String orgHeadName;
  String activeFlagDesc;

  QuotationOrganizationListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.orgCode,
      this.orgName,
      this.orgTypeCode,
      this.orgType,
      this.address,
      this.pincode,
      this.cityCode,
      this.cityName,
      this.stateCode,
      this.stateName,
      this.landline1,
      this.landline2,
      this.fax1,
      this.fax2,
      this.emailAddress,
      this.reportToOrgCode,
      this.gSTStateCode,
      this.reportToOrgName,
      this.gSTIN,
      this.pANNO,
      this.cINNO,
      this.activeFlag,
      this.orgHead,
      this.orgHeadName,
      this.activeFlagDesc});

  QuotationOrganizationListResponseDetails.fromJson(Map<String, dynamic> json) {
    /* rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];*/
    orgCode = json['OrgCode'] == null ? "" : json['OrgCode'];
    orgName = json['OrgName'] == null ? "" : json['OrgName'];
    /*   orgTypeCode = json['OrgTypeCode'] == null ? 0 : json['OrgTypeCode'];
    orgType = json['OrgType'] == null ? "" : json['OrgTypeCode'];
    address = json['Address'] == null ? "" : json['Address'];
    pincode = json['Pincode'] == null ? "" : json['Pincode'];
    cityCode = json['CityCode'] == null ? "" : json['CityCode'];
    cityName = json['CityName'] == null ? "" : json['CityName'];
    stateCode = json['StateCode'] == null ? "" : json['StateCode'];
    stateName = json['StateName'] == null ? "" : json['StateName'];
    landline1 = json['Landline1'] == null ? "" : json['Landline1'];
    landline2 = json['Landline2'] == null ? "" : json['Landline2'];
    fax1 = json['Fax1'] == null ? "" : json['Fax1'];
    fax2 = json['Fax2'] == null ? "" : json['Fax2'];
    emailAddress = json['EmailAddress'] == null ? "" : json['EmailAddress'];
    reportToOrgCode =
        json['ReportTo_OrgCode'] == null ? "" : json['ReportTo_OrgCode'];
    gSTStateCode = json['GSTStateCode'] == null ? 0 : json['GSTStateCode'];
    reportToOrgName =
        json['ReportTo_OrgName'] == null ? "" : json['ReportTo_OrgName'];
    gSTIN = json['GSTIN'] == null ? "" : json['GSTIN'];
    pANNO = json['PANNO'] == null ? "" : json['PANNO'];
    cINNO = json['CINNO'] == null ? "" : json['CINNO'];*/
    activeFlag = json['ActiveFlag'] == null ? false : json['ActiveFlag'];
    /*orgHead = json['OrgHead'] == null ? "" : json['OrgHead'];
    orgHeadName = json['OrgHeadName'] == null ? "" : json['OrgHeadName'];
    activeFlagDesc =
        json['ActiveFlagDesc'] == null ? "" : json['ActiveFlagDesc'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['OrgCode'] = this.orgCode;
    data['OrgName'] = this.orgName;
    data['OrgTypeCode'] = this.orgTypeCode;
    data['OrgType'] = this.orgType;
    data['Address'] = this.address;
    data['Pincode'] = this.pincode;
    data['CityCode'] = this.cityCode;
    data['CityName'] = this.cityName;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['Landline1'] = this.landline1;
    data['Landline2'] = this.landline2;
    data['Fax1'] = this.fax1;
    data['Fax2'] = this.fax2;
    data['EmailAddress'] = this.emailAddress;
    data['ReportTo_OrgCode'] = this.reportToOrgCode;
    data['GSTStateCode'] = this.gSTStateCode;
    data['ReportTo_OrgName'] = this.reportToOrgName;
    data['GSTIN'] = this.gSTIN;
    data['PANNO'] = this.pANNO;
    data['CINNO'] = this.cINNO;
    data['ActiveFlag'] = this.activeFlag;
    data['OrgHead'] = this.orgHead;
    data['OrgHeadName'] = this.orgHeadName;
    data['ActiveFlagDesc'] = this.activeFlagDesc;
    return data;
  }
}
