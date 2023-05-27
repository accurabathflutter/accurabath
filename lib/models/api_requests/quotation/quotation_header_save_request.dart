class QuotationHeaderSaveRequest {
  String pkID;
  String InquiryNo;
  String QuotationNo;
  String QuotationDate;
  String CustomerID;
  String ProjectName;
  String QuotationSubject;
  String QuotationKindAttn;
  String QuotationHeader;
  String QuotationFooter;
  String LoginUserID;
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
  String ChargePer1;
  String ChargePer2;
  String ChargePer3;
  String ChargePer4;
  String ChargePer5;
  String CompanyId;
  String BankID;
  String AdditionalRemarks;
  String AssumptionRemarks;
  String OrgCode;
  String ReferenceNo;
  String ReferenceDate;
  String CreditDays;
  String CurrencyName;
  String CurrencySymbol;
  String ExchangeRate;
  String DiscountPer;
  String DeliveryDays;
  String Validity;

  /*CreditDays:7Days
DiscountPer:0
DeliveryDays:7Days
Validity:30Days
CurrencyName:US Dollor
CurrencySymbol:$
ExchangeRate:85.00*/

  QuotationHeaderSaveRequest(
      {this.pkID,
      this.InquiryNo,
      this.QuotationNo,
      this.QuotationDate,
      this.CustomerID,
      this.ProjectName,
      this.QuotationSubject,
      this.QuotationKindAttn,
      this.QuotationHeader,
      this.QuotationFooter,
      this.LoginUserID,
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
      this.ChargePer1,
      this.ChargePer2,
      this.ChargePer3,
      this.ChargePer4,
      this.ChargePer5,
      this.CompanyId,
      this.BankID,
      this.AdditionalRemarks,
      this.AssumptionRemarks,
      this.OrgCode,
      this.ReferenceNo,
      this.ReferenceDate,
      this.CreditDays,
      this.CurrencyName,
      this.CurrencySymbol,
      this.ExchangeRate,
      this.DiscountPer,
        this.DeliveryDays,
        this.Validity
      });

  QuotationHeaderSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    InquiryNo = json['InquiryNo'];
    QuotationNo = json['QuotationNo'];
    QuotationDate = json['QuotationDate'];
    CustomerID = json['CustomerID'];
    ProjectName = json['ProjectName'];
    QuotationSubject = json['QuotationSubject'];
    QuotationKindAttn = json['QuotationKindAttn'];
    QuotationHeader = json['QuotationHeader'];
    QuotationFooter = json['QuotationFooter'];
    LoginUserID = json['LoginUserID'];
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
    ChargePer1 = json['ChargePer1'];
    ChargePer2 = json['ChargePer2'];
    ChargePer3 = json['ChargePer3'];
    ChargePer4 = json['ChargePer4'];
    ChargePer5 = json['ChargePer5'];
    CompanyId = json['CompanyId'];
    BankID = json['BankID'];
    AdditionalRemarks = json['AdditionalRemarks'];
    AssumptionRemarks = json['AssumptionRemarks'];
    OrgCode = json['OrgCode'];
    ReferenceNo = json['ReferenceNo'];
    ReferenceDate = json['ReferenceDate'];
    CreditDays = json['CreditDays'];
    CurrencyName = json['CurrencyName'];
    CurrencySymbol = json['CurrencySymbol'];
    ExchangeRate = json['ExchangeRate'];
    DiscountPer =  json['DiscountPer'];
    DeliveryDays = json['DeliveryDays'];
    Validity =     json['Validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['InquiryNo'] = this.InquiryNo;
    data['QuotationNo'] = this.QuotationNo;
    data['QuotationDate'] = this.QuotationDate;
    data['CustomerID'] = this.CustomerID;
    data['ProjectName'] = this.ProjectName;
    data['QuotationSubject'] = this.QuotationSubject;
    data['QuotationKindAttn'] = this.QuotationKindAttn;
    data['QuotationHeader'] = this.QuotationHeader;
    data['QuotationFooter'] = this.QuotationFooter;
    data['LoginUserID'] = this.LoginUserID;
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
    data['ChargePer1'] = this.ChargePer1;
    data['ChargePer2'] = this.ChargePer2;
    data['ChargePer3'] = this.ChargePer3;
    data['ChargePer4'] = this.ChargePer4;
    data['ChargePer5'] = this.ChargePer5;
    data['CompanyId'] = this.CompanyId;
    data['BankID'] = this.BankID;
    data['AdditionalRemarks'] = this.AdditionalRemarks;
    data['AssumptionRemarks'] = this.AssumptionRemarks;
    data['OrgCode'] = this.OrgCode;
    data['ReferenceNo'] = this.ReferenceNo;
    data['ReferenceDate'] = this.ReferenceDate;
    data['CreditDays'] = this.CreditDays;
    data['QType'] = "";
    data['Hosting'] = "";
    data['MaxUsers'] = "";
    data['DeliveryTime'] = "";
    data['ProfitPer'] = "";
    data['ProfitAmt'] = "";
    data['AfterProfitAmt'] = "";
    data['ManualQuoteNo'] = "";
    data['BidDate'] = "";
    data['CurrencyName'] = CurrencyName;
    data['CurrencySymbol'] = CurrencySymbol;
    data['ExchangeRate'] = ExchangeRate;
    data['DiscountPer']  =  DiscountPer;
    data['DeliveryDays'] =  DeliveryDays;
    data['Validity']     =  Validity;


    return data;
  }
}
