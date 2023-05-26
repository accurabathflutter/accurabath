class SaleOrderHeaderSaveRequest {
  String CompanyId;

  String OrderNo;

  String OrderDate;

  String LoginUserID;

  String CustomerId;

  String QuotationNo;

  String DeliveryDate;

  String TermsCondition;

  String Latitude;

  String Longitude;

  String DiscountAmt;

  String SGSTAmt;

  String CGSTAmt;

  String IGSTAmt;

  String ChargeID1;

  String ChargeAmt1;

  String ChargeBasicAmt1;

  String ChargeGSTAmt1;

  String ChargeID2;

  String ChargeAmt2;

  String ChargeBasicAmt2;

  String ChargeGSTAmt2;

  String ChargeID3;

  String ChargeAmt3;

  String ChargeBasicAmt3;

  String ChargeGSTAmt3;

  String ChargeID4;

  String ChargeAmt4;

  String ChargeBasicAmt4;

  String ChargeGSTAmt4;

  String ChargeID5;

  String ChargeAmt5;

  String ChargeBasicAmt5;

  String ChargeGSTAmt5;

  String NetAmt;

  String BasicAmt;

  String ROffAmt;

  String ApprovalStatus;

  String ChargePer1;

  String ChargePer2;

  String ChargePer3;

  String ChargePer4;

  String ChargePer5;

  String AdvancePer;

  String AdvanceAmt;

  String CurrencyName;

  String CurrencySymbol;

  String ExchangeRate;

  String RefType;

  String EmailHeader;
  String EmailContent;

  SaleOrderHeaderSaveRequest(
      {this.CompanyId,
      this.OrderNo,
      this.OrderDate,
      this.LoginUserID,
      this.CustomerId,
      this.QuotationNo,
      this.DeliveryDate,
      this.TermsCondition,
      this.Latitude,
      this.Longitude,
      this.DiscountAmt,
      this.SGSTAmt,
      this.CGSTAmt,
      this.IGSTAmt,
      this.ChargeID1,
      this.ChargeAmt1,
      this.ChargeBasicAmt1,
      this.ChargeGSTAmt1,
      this.ChargeID2,
      this.ChargeAmt2,
      this.ChargeBasicAmt2,
      this.ChargeGSTAmt2,
      this.ChargeID3,
      this.ChargeAmt3,
      this.ChargeBasicAmt3,
      this.ChargeGSTAmt3,
      this.ChargeID4,
      this.ChargeAmt4,
      this.ChargeBasicAmt4,
      this.ChargeGSTAmt4,
      this.ChargeID5,
      this.ChargeAmt5,
      this.ChargeBasicAmt5,
      this.ChargeGSTAmt5,
      this.NetAmt,
      this.BasicAmt,
      this.ROffAmt,
      this.ApprovalStatus,
      this.ChargePer1,
      this.ChargePer2,
      this.ChargePer3,
      this.ChargePer4,
      this.ChargePer5,
      this.AdvancePer,
      this.AdvanceAmt,
      this.CurrencyName,
      this.CurrencySymbol,
      this.ExchangeRate,
      this.RefType,
      this.EmailHeader,
      this.EmailContent});

  //  String EmailHeader;
  //   String EmailContent;

  SaleOrderHeaderSaveRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    OrderNo = json['OrderNo'];
    OrderDate = json['OrderDate'];
    LoginUserID = json['LoginUserID'];
    CustomerId = json['CustomerId'];
    QuotationNo = json['QuotationNo'];
    DeliveryDate = json['DeliveryDate'];
    TermsCondition = json['TermsCondition'];
    Latitude = json['Latitude'];
    Longitude = json['Longitude'];
    DiscountAmt = json['DiscountAmt'];
    SGSTAmt = json['SGSTAmt'];
    CGSTAmt = json['CGSTAmt'];
    IGSTAmt = json['IGSTAmt'];
    ChargeID1 = json['ChargeID1'];
    ChargeAmt1 = json['ChargeAmt1'];
    ChargeBasicAmt1 = json['ChargeBasicAmt1'];
    ChargeGSTAmt1 = json['ChargeGSTAmt1'];
    ChargeID2 = json['ChargeID2'];
    ChargeAmt2 = json['ChargeAmt2'];
    ChargeBasicAmt2 = json['ChargeBasicAmt2'];
    ChargeGSTAmt2 = json['ChargeGSTAmt2'];
    ChargeID3 = json['ChargeID3'];
    ChargeAmt3 = json['ChargeAmt3'];
    ChargeBasicAmt3 = json['ChargeBasicAmt3'];
    ChargeGSTAmt3 = json['ChargeGSTAmt3'];
    ChargeID4 = json['ChargeID4'];
    ChargeAmt4 = json['ChargeAmt4'];
    ChargeBasicAmt4 = json['ChargeBasicAmt4'];
    ChargeGSTAmt4 = json['ChargeGSTAmt4'];
    ChargeID5 = json['ChargeID5'];
    ChargeAmt5 = json['ChargeAmt5'];
    ChargeBasicAmt5 = json['ChargeBasicAmt5'];
    ChargeGSTAmt5 = json['ChargeGSTAmt5'];
    NetAmt = json['NetAmt'];
    BasicAmt = json['BasicAmt'];
    ROffAmt = json['ROffAmt'];
    ApprovalStatus = json['ApprovalStatus'];
    ChargePer1 = json['ChargePer1'];
    ChargePer2 = json['ChargePer2'];
    ChargePer3 = json['ChargePer3'];
    ChargePer4 = json['ChargePer4'];
    ChargePer5 = json['ChargePer5'];
    AdvancePer = json['AdvancePer'];
    AdvanceAmt = json['AdvanceAmt'];
    CurrencyName = json['CurrencyName'];
    CurrencySymbol = json['CurrencySymbol'];
    ExchangeRate = json['ExchangeRate'];
    RefType = json['RefType'];

    EmailHeader = json['EmailHeader'];
    EmailContent = json['EmailContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['CompanyId'] = this.CompanyId;
    data['OrderNo'] = this.OrderNo;
    data['OrderDate'] = this.OrderDate;
    data['LoginUserID'] = this.LoginUserID;
    data['CustomerId'] = this.CustomerId;
    data['QuotationNo'] = this.QuotationNo;
    data['DeliveryDate'] = this.DeliveryDate;
    data['TermsCondition'] = this.TermsCondition;
    data['Latitude'] = this.Latitude;
    data['Longitude'] = this.Longitude;
    data['DiscountAmt'] = this.DiscountAmt;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTAmt'] = this.IGSTAmt;
    data['ChargeID1'] = this.ChargeID1;
    data['ChargeAmt1'] = this.ChargeAmt1;
    data['ChargeBasicAmt1'] = this.ChargeBasicAmt1;
    data['ChargeGSTAmt1'] = this.ChargeGSTAmt1;
    data['ChargeID2'] = this.ChargeID2;
    data['ChargeAmt2'] = this.ChargeAmt2;
    data['ChargeBasicAmt2'] = this.ChargeBasicAmt2;
    data['ChargeGSTAmt2'] = this.ChargeGSTAmt2;
    data['ChargeID3'] = this.ChargeID3;
    data['ChargeAmt3'] = this.ChargeAmt3;
    data['ChargeBasicAmt3'] = this.ChargeBasicAmt3;
    data['ChargeGSTAmt3'] = this.ChargeGSTAmt3;
    data['ChargeID4'] = this.ChargeID4;
    data['ChargeAmt4'] = this.ChargeAmt4;
    data['ChargeBasicAmt4'] = this.ChargeBasicAmt4;
    data['ChargeGSTAmt4'] = this.ChargeGSTAmt4;
    data['ChargeID5'] = this.ChargeID5;
    data['ChargeAmt5'] = this.ChargeAmt5;
    data['ChargeBasicAmt5'] = this.ChargeBasicAmt5;
    data['ChargeGSTAmt5'] = this.ChargeGSTAmt5;
    data['NetAmt'] = this.NetAmt;
    data['BasicAmt'] = this.BasicAmt;
    data['ROffAmt'] = this.ROffAmt;
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['ChargePer1'] = this.ChargePer1;
    data['ChargePer2'] = this.ChargePer2;
    data['ChargePer3'] = this.ChargePer3;
    data['ChargePer4'] = this.ChargePer4;
    data['ChargePer5'] = this.ChargePer5;
    data['AdvancePer'] = this.AdvancePer;
    data['AdvanceAmt'] = this.AdvanceAmt;
    data['CurrencyName'] = this.CurrencyName;
    data['CurrencySymbol'] = this.CurrencySymbol;
    data['ExchangeRate'] = this.ExchangeRate;
    data['RefType'] = this.RefType;

    data['EmailHeader'] = this.EmailHeader;
    data['EmailContent'] = this.EmailContent;
    return data;
  }
}
