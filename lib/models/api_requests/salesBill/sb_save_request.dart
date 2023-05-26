class SBHeaderSaveRequest {
  String InvoiceNo;
  String InvoiceDate;
  String FixedLedgerID;
  String CustomerID;
  String LocationID;
  String BankID;
  String TerminationOfDeliery;
  String TerminationOfDelieryCity;
  String TermsCondition;
  String InquiryNo;
  String OrderNo;
  String QuotationNo;
  String ComplaintNo;
  String RefType;
  String SupplierRef;
  String SupplierRefDate;
  String EmailSubject;
  String EmailContent;
  String OtherRef;
  String PatientName;
  String PatientType;
  String Amount;
  String Percentage;
  String EstimatedAmt;
  String BasicAmt;
  String DiscountAmt;
  String SGSTAmt;
  String CGSTAmt;
  String IGSTAmt;
  String ROffAmt;
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
  String ModeOfTransport;
  String TransporterName;
  String DeliverTo;
  String VehicleNo;
  String LRNo;
  String DeliveryNote;
  String DeliveryDate;
  String DispatchDocNo;
  String LRDate;
  String EwayBillNo;
  String ModeOfPayment;
  String TransportRemark;
  String LoginUserID;
  String ReturnInvoiceNo;
  String CompanyId;
  String CRDays;
  String DueDate;
  String CurrencyName;
  String CurrencySymbol;
  String ExchangeRate;
  String ProjectName;

  SBHeaderSaveRequest({
    this.InvoiceNo,
    this.InvoiceDate,
    this.FixedLedgerID,
    this.CustomerID,
    this.LocationID,
    this.BankID,
    this.TerminationOfDeliery,
    this.TerminationOfDelieryCity,
    this.TermsCondition,
    this.InquiryNo,
    this.OrderNo,
    this.QuotationNo,
    this.ComplaintNo,
    this.RefType,
    this.SupplierRef,
    this.SupplierRefDate,
    this.EmailSubject,
    this.EmailContent,
    this.OtherRef,
    this.PatientName,
    this.PatientType,
    this.Amount,
    this.Percentage,
    this.EstimatedAmt,
    this.BasicAmt,
    this.DiscountAmt,
    this.SGSTAmt,
    this.CGSTAmt,
    this.IGSTAmt,
    this.ROffAmt,
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
    this.ModeOfTransport,
    this.TransporterName,
    this.DeliverTo,
    this.VehicleNo,
    this.LRNo,
    this.DeliveryNote,
    this.DeliveryDate,
    this.DispatchDocNo,
    this.LRDate,
    this.EwayBillNo,
    this.ModeOfPayment,
    this.TransportRemark,
    this.LoginUserID,
    this.ReturnInvoiceNo,
    this.CompanyId,
    this.CRDays,
    this.DueDate,
    this.CurrencyName,
    this.CurrencySymbol,
    this.ExchangeRate,
    this.ProjectName,
  });

  SBHeaderSaveRequest.fromJson(Map<String, dynamic> json) {
    InvoiceNo = json['InvoiceNo'];
    InvoiceDate = json['InvoiceDate'];
    FixedLedgerID = json['FixedLedgerID'];
    CustomerID = json['CustomerID'];
    LocationID = json['LocationID'];
    BankID = json['BankID'];
    TerminationOfDeliery = json['TerminationOfDeliery'];
    TerminationOfDelieryCity = json['TerminationOfDelieryCity'];
    TermsCondition = json['TermsCondition'];
    InquiryNo = json['InquiryNo'];
    OrderNo = json['OrderNo'];
    QuotationNo = json['QuotationNo'];
    ComplaintNo = json['ComplaintNo'];
    RefType = json['RefType'];
    SupplierRef = json['SupplierRef'];
    SupplierRefDate = json['SupplierRefDate'];
    EmailSubject = json['EmailSubject'];
    EmailContent = json['EmailContent'];
    OtherRef = json['OtherRef'];
    PatientName = json['PatientName'];
    PatientType = json['PatientType'];
    Amount = json['Amount'];
    Percentage = json['Percentage'];
    EstimatedAmt = json['EstimatedAmt'];
    BasicAmt = json['BasicAmt'];
    DiscountAmt = json['DiscountAmt'];
    SGSTAmt = json['SGSTAmt'];
    CGSTAmt = json['CGSTAmt'];
    IGSTAmt = json['IGSTAmt'];
    ROffAmt = json['ROffAmt'];
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
    ModeOfTransport = json['ModeOfTransport'];
    TransporterName = json['TransporterName'];
    DeliverTo = json['DeliverTo'];
    VehicleNo = json['VehicleNo'];
    LRNo = json['LRNo'];
    DeliveryNote = json['DeliveryNote'];
    DeliveryDate = json['DeliveryDate'];
    DispatchDocNo = json['DispatchDocNo'];
    LRDate = json['LRDate'];
    EwayBillNo = json['EwayBillNo'];
    ModeOfPayment = json['ModeOfPayment'];
    TransportRemark = json['TransportRemark'];
    LoginUserID = json['LoginUserID'];
    ReturnInvoiceNo = json['ReturnInvoiceNo'];
    CompanyId = json['CompanyId'];
    CRDays = json['CRDays'];
    DueDate = json['DueDate'];
    CurrencyName = json['CurrencyName'];
    CurrencySymbol = json['CurrencySymbol'];
    ExchangeRate = json['ExchangeRate'];
    ProjectName = json['ProjectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['InvoiceNo'] = this.InvoiceNo;
    data['InvoiceDate'] = this.InvoiceDate;
    data['FixedLedgerID'] = this.FixedLedgerID;
    data['CustomerID'] = this.CustomerID;
    data['LocationID'] = this.LocationID;
    data['BankID'] = this.BankID;
    data['TerminationOfDeliery'] = this.TerminationOfDeliery;
    data['TerminationOfDelieryCity'] = this.TerminationOfDelieryCity;
    data['TermsCondition'] = this.TermsCondition;
    data['InquiryNo'] = this.InquiryNo;
    data['OrderNo'] = this.OrderNo;
    data['QuotationNo'] = this.QuotationNo;
    data['ComplaintNo'] = this.ComplaintNo;
    data['RefType'] = this.RefType;
    data['SupplierRef'] = this.SupplierRef;
    data['SupplierRefDate'] = this.SupplierRefDate;
    data['EmailSubject'] = this.EmailSubject;
    data['EmailContent'] = this.EmailContent;
    data['OtherRef'] = this.OtherRef;
    data['PatientName'] = this.PatientName;
    data['PatientType'] = this.PatientType;
    data['Amount'] = this.Amount;
    data['Percentage'] = this.Percentage;
    data['EstimatedAmt'] = this.EstimatedAmt;
    data['BasicAmt'] = this.BasicAmt;
    data['DiscountAmt'] = this.DiscountAmt;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTAmt'] = this.IGSTAmt;
    data['ROffAmt'] = this.ROffAmt;
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
    data['ModeOfTransport'] = this.ModeOfTransport;
    data['TransporterName'] = this.TransporterName;
    data['DeliverTo'] = this.DeliverTo;
    data['VehicleNo'] = this.VehicleNo;
    data['LRNo'] = this.LRNo;
    data['DeliveryNote'] = this.DeliveryNote;
    data['DeliveryDate'] = this.DeliveryDate;
    data['DispatchDocNo'] = this.DispatchDocNo;
    data['LRDate'] = this.LRDate;
    data['EwayBillNo'] = this.EwayBillNo;
    data['ModeOfPayment'] = this.ModeOfPayment;
    data['TransportRemark'] = this.TransportRemark;
    data['LoginUserID'] = this.LoginUserID;
    data['ReturnInvoiceNo'] = this.ReturnInvoiceNo;
    data['CompanyId'] = this.CompanyId;
    data['CRDays'] = this.CRDays;
    data['DueDate'] = this.DueDate;
    data['CurrencyName'] = this.CurrencyName;
    data['CurrencySymbol'] = this.CurrencySymbol;
    data['ExchangeRate'] = this.ExchangeRate;
    data['ProjectName'] = this.ProjectName;
    // ProjectName = json['ProjectName'];

    return data;
  }
}
