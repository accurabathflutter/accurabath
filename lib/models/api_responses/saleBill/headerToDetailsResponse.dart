class HeaderToDetailsResponse {
  List<HeaderToDetailsResponseDetails> details;
  int totalCount;

  HeaderToDetailsResponse({this.details, this.totalCount});

  HeaderToDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new HeaderToDetailsResponseDetails.fromJson(v));
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

class HeaderToDetailsResponseDetails {
  int rowNum; //InvoiceNo   nvarchar(20)
  int pkID; //InvoiceDate datetime
  String invoiceNo; //FixedLedgerID   bigint
  String invoiceDate; //CustomerID  bigint
  int fixedLedgerID; //LocationID  bigint
  String fixedLedgerAccount; //BankID  bigint
  int customerID; //TerminationOfDeliery    bigint
  String customerName; //TerminationOfDelieryCity    bigint
  int locationID; //TermsCondition  nvarchar(max)
  String locationName; //InquiryNo   nvarchar(50)
  int bankID; //OrderNo nvarchar(50)
  String bankName; //QuotationNo nvarchar(50)
  int terminationOfDeliery; //ComplaintNo nvarchar(20)
  String terminationOfDelieryStatename; //RefType nvarchar(50)
  int terminationOfDelieryCity; //SupplierRef nvarchar(20)
  String terminationOfDelieryCityName; //SupplierRefDate datetime
  String termsCondition; //EmailSubject    nvarchar(1000)
  String inquiryNo; //EmailContent    nvarchar(max)
  String orderNo; //OtherRef    nvarchar(20)
  String quotationNo; //PatientName nvarchar(50)
  String complaintNo; //PatientType nvarchar(25)
  String refType; //Amount  decimal(12,2)
  String supplierRef; //Percentage  decimal(12,2)
  String supplierRefDate; //EstimatedAmt    decimal(12,2)
  String emailSubject; //BasicAmt    decimal(12,2)
  String emailContent; //DiscountAmt decimal(12,2)
  String otherRef; //SGSTAmt decimal(12,2)
  String patientName; //CGSTAmt decimal(12,2)
  String patientType; //IGSTAmt decimal(12,2)
  double amount; //ROffAmt decimal(12,2)
  double percentage; //ChargeID1   bigint
  double estimatedAmt; //ChargeAmt1  decimal(12,2)
  double basicAmt; //ChargeBasicAmt1 decimal(12,2)
  double discountAmt; //ChargeGSTAmt1   decimal(12,2)
  double sGSTAmt; //ChargeID2   bigint
  double cGSTAmt; //ChargeAmt2  decimal(12,2)
  double iGSTAmt; //ChargeBasicAmt2 decimal(12,2)
  double rOffAmt; //ChargeGSTAmt2   decimal(12,2)
  int chargeID1; //ChargeID3   bigint
  String chargeName1; //ChargeAmt3  decimal(12,2)
  double chargeAmt1; //ChargeBasicAmt3 decimal(12,2)
  double chargeBasicAmt1; //ChargeGSTAmt3   decimal(12,2)
  double chargeGSTAmt1; //ChargeID4   bigint
  int chargeID2; //ChargeAmt4  decimal(12,2)
  String chargeName2; //ChargeBasicAmt4 decimal(12,2)
  double chargeAmt2; //ChargeGSTAmt4   decimal(12,2)
  double chargeBasicAmt2; //ChargeID5   bigint
  double chargeGSTAmt2; //ChargeAmt5  decimal(12,2)
  int chargeID3; //ChargeBasicAmt5 decimal(12,2)
  String chargeName3; //ChargeGSTAmt5   decimal(12,2)
  double chargeAmt3; //NetAmt  decimal(12,2)
  double chargeBasicAmt3; //ModeOfTransport nvarchar(50)
  double chargeGSTAmt3; //TransporterName nvarchar(100)
  int chargeID4; //DeliverTo   nvarchar(50)
  String chargeName4; //VehicleNo   nvarchar(50)
  double chargeAmt4; //LRNo    nvarchar(50)
  double chargeBasicAmt4; //DeliveryNote    nvarchar(100)
  double chargeGSTAmt4; //DeliveryDate    datetime
  int chargeID5; //DispatchDocNo   nvarchar(20)
  String chargeName5; //LRDate  datetime
  double chargeAmt5; //EwayBillNo  nvarchar(50)
  double chargeBasicAmt5; //ModeOfPayment   nvarchar(50)
  double chargeGSTAmt5; //TransportRemark nvarchar(150)
  int cRDays; //ProjectName nvarchar(50)
  String dueDate; //CRDays  bigint
  String projectName; //DueDate datetime
  String currencyName; //CurrencyName    nvarchar(20)
  String currencySymbol; //CurrencySymbol  nvarchar(5)
  double exchangeRate; //ExchangeRate    decimal(12,2)
  double netAmt; //
  String modeOfTransport;
  String transporterName;
  String deliverTo;
  String vehicleNo;
  String lRNo;
  String deliveryNote;
  String deliveryDate;
  String dispatchDocNo;
  String lRDate;
  String ewayBillNo;
  String modeOfPayment;
  String transportRemark;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;

  HeaderToDetailsResponseDetails(
      {this.rowNum,
      this.pkID,
      this.invoiceNo,
      this.invoiceDate,
      this.fixedLedgerID,
      this.fixedLedgerAccount,
      this.customerID,
      this.customerName,
      this.locationID,
      this.locationName,
      this.bankID,
      this.bankName,
      this.terminationOfDeliery,
      this.terminationOfDelieryStatename,
      this.terminationOfDelieryCity,
      this.terminationOfDelieryCityName,
      this.termsCondition,
      this.inquiryNo,
      this.orderNo,
      this.quotationNo,
      this.complaintNo,
      this.refType,
      this.supplierRef,
      this.supplierRefDate,
      this.emailSubject,
      this.emailContent,
      this.otherRef,
      this.patientName,
      this.patientType,
      this.amount,
      this.percentage,
      this.estimatedAmt,
      this.basicAmt,
      this.discountAmt,
      this.sGSTAmt,
      this.cGSTAmt,
      this.iGSTAmt,
      this.rOffAmt,
      this.chargeID1,
      this.chargeName1,
      this.chargeAmt1,
      this.chargeBasicAmt1,
      this.chargeGSTAmt1,
      this.chargeID2,
      this.chargeName2,
      this.chargeAmt2,
      this.chargeBasicAmt2,
      this.chargeGSTAmt2,
      this.chargeID3,
      this.chargeAmt3,
      this.chargeBasicAmt3,
      this.chargeGSTAmt3,
      this.chargeID4,
      this.chargeAmt4,
      this.chargeBasicAmt4,
      this.chargeGSTAmt4,
      this.chargeID5,
      this.chargeAmt5,
      this.chargeBasicAmt5,
      this.chargeGSTAmt5,
      this.cRDays,
      this.dueDate,
      this.projectName,
      this.currencyName,
      this.currencySymbol,
      this.exchangeRate,
      this.netAmt,
      this.modeOfTransport,
      this.transporterName,
      this.deliverTo,
      this.vehicleNo,
      this.lRNo,
      this.deliveryNote,
      this.deliveryDate,
      this.dispatchDocNo,
      this.lRDate,
      this.ewayBillNo,
      this.modeOfPayment,
      this.transportRemark,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  HeaderToDetailsResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    invoiceNo = json['InvoiceNo'] == null ? "" : json['InvoiceNo'];
    invoiceDate = json['InvoiceDate'] == null ? "" : json['InvoiceDate'];
    fixedLedgerID = json['FixedLedgerID'] == null ? 0 : json['fixedLedgerID'];
    fixedLedgerAccount =
        json['FixedLedgerAccount'] == null ? "" : json['FixedLedgerAccount'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    locationID = json['LocationID'] == null ? 0 : json['LocationID'];
    locationName = json['LocationName'] == null ? "" : json['LocationName'];
    bankID = json['BankID'] == null ? 0 : json['BankID'];
    bankName = json['BankName'] == null ? "" : json['BankName'];
    terminationOfDeliery =
        json['TerminationOfDeliery'] == null ? 0 : json['TerminationOfDeliery'];
    terminationOfDelieryStatename =
        json['TerminationOfDelieryStatename'] == null
            ? ""
            : json['TerminationOfDelieryStatename'];
    terminationOfDelieryCity = json['TerminationOfDelieryCity'] == null
        ? 0
        : json['TerminationOfDelieryCity'];
    terminationOfDelieryCityName = json['TerminationOfDelieryCityName'] == null
        ? ""
        : json['TerminationOfDelieryCityName'];
    termsCondition =
        json['TermsCondition'] == null ? "" : json['TermsCondition'];
    inquiryNo = json['InquiryNo'] == null ? "" : json['InquiryNo'];
    orderNo = json['OrderNo'] == null ? "" : json['OrderNo'];
    quotationNo = json['QuotationNo'] == null ? "" : json['QuotationNo'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    refType = json['RefType'] == null ? "" : json['RefType'];
    supplierRef = json['SupplierRef'] == null ? "" : json['SupplierRef'];
    supplierRefDate =
        json['SupplierRefDate'] == null ? "" : json['SupplierRefDate'];
    emailSubject = json['EmailSubject'] == null ? "" : json['EmailSubject'];
    emailContent = json['EmailContent'] == null ? "" : json['EmailContent'];
    otherRef = json['OtherRef'] == null ? "" : json['OtherRef'];
    patientName = json['PatientName'] == null ? "" : json['PatientName'];
    patientType = json['PatientType'] == null ? "" : json['PatientType'];
    amount = json['Amount'] == null ? 0.00 : json['Amount'];
    percentage = json['Percentage'] == null ? 0.00 : json['Percentage'];
    estimatedAmt = json['EstimatedAmt'] == null ? 0.00 : json['EstimatedAmt'];
    basicAmt = json['BasicAmt'] == null ? 0.00 : json['BasicAmt'];
    discountAmt = json['DiscountAmt'] == null ? 0.00 : json['DiscountAmt'];
    sGSTAmt = json['SGSTAmt'] == null ? 0.00 : json['SGSTAmt'];
    cGSTAmt = json['CGSTAmt'] == null ? 0.00 : json['CGSTAmt'];
    iGSTAmt = json['IGSTAmt'] == null ? 0.00 : json['IGSTAmt'];

    rOffAmt = json['ROffAmt'] == null ? 0.00 : json['ROffAmt'];
    chargeID1 = json['ChargeID1'] == null ? 0 : json['ChargeID1'];
    chargeName1 = json['ChargeName1'] == null ? "" : json['ChargeName1'];
    chargeAmt1 = json['ChargeAmt1'] == null ? 0.00 : json['ChargeAmt1'];
    chargeBasicAmt1 =
        json['ChargeBasicAmt1'] == null ? 0.00 : json['ChargeBasicAmt1'];
    chargeGSTAmt1 =
        json['ChargeGSTAmt1'] == null ? 0.00 : json['ChargeGSTAmt1'];
    chargeID2 = json['ChargeID2'] == null ? 0 : json['ChargeID2'];
    chargeName2 = json['ChargeName2'] == null ? "" : json['ChargeName2'];
    chargeAmt2 = json['ChargeAmt2'] == null ? 0.00 : json['ChargeAmt2'];
    chargeBasicAmt2 =
        json['ChargeBasicAmt2'] == null ? 0.00 : json['ChargeBasicAmt2'];
    chargeGSTAmt2 =
        json['ChargeGSTAmt2'] == null ? 0.00 : json['ChargeGSTAmt2'];
    chargeID3 = json['ChargeID3'] == null ? 0 : json['ChargeID3'];
    chargeName3 = json['ChargeName3'] == null ? "" : json['ChargeName3'];
    chargeAmt3 = json['ChargeAmt3'] == null ? 0.00 : json['ChargeAmt3'];
    chargeBasicAmt3 =
        json['ChargeBasicAmt3'] == null ? 0.00 : json['ChargeBasicAmt3'];
    chargeGSTAmt3 =
        json['ChargeGSTAmt3'] == null ? 0.00 : json['ChargeGSTAmt3'];
    chargeID4 = json['ChargeID4'] == null ? 0 : json['ChargeID4'];
    chargeName4 = json['ChargeName4'] == null ? "" : json['ChargeName4'];
    chargeAmt4 = json['ChargeAmt4'] == null ? 0.00 : json['ChargeAmt4'];
    chargeBasicAmt4 =
        json['ChargeBasicAmt4'] == null ? 0.00 : json['ChargeBasicAmt4'];
    chargeGSTAmt4 =
        json['ChargeGSTAmt4'] == null ? 0.00 : json['ChargeGSTAmt4'];
    chargeID5 = json['ChargeID5'] == null ? 0 : json['ChargeID5'];
    chargeName5 = json['ChargeName5'] == null ? "" : json['ChargeName5'];
    chargeAmt5 = json['ChargeAmt5'] == null ? 0.00 : json['ChargeAmt5'];
    chargeBasicAmt5 =
        json['ChargeBasicAmt5'] == null ? 0.00 : json['ChargeBasicAmt5'];
    chargeGSTAmt5 =
        json['ChargeGSTAmt5'] == null ? 0.00 : json['ChargeGSTAmt5'];
    cRDays = json['CRDays'] == null ? 0 : json['CRDays'];
    dueDate = json['DueDate'] == null ? "" : json['DueDate'];
    projectName = json['ProjectName'] == null ? "" : json['ProjectName'];
    currencyName = json['CurrencyName'] == null ? "" : json['CurrencyName'];
    currencySymbol =
        json['CurrencySymbol'] == null ? "" : json['CurrencySymbol'];
    exchangeRate = json['ExchangeRate'] == null ? 0.00 : json['ExchangeRate'];
    netAmt = json['NetAmt'] == null ? 0.00 : json['NetAmt'];
    modeOfTransport =
        json['ModeOfTransport'] == null ? "" : json['ModeOfTransport'];
    transporterName =
        json['TransporterName'] == null ? "" : json['TransporterName'];
    deliverTo = json['DeliverTo'] == null ? "" : json['DeliverTo'];
    vehicleNo = json['VehicleNo'] == null ? "" : json['VehicleNo'];
    lRNo = json['LRNo'] == null ? "" : json['LRNo'];
    deliveryNote = json['DeliveryNote'] == null ? "" : json['DeliveryNote'];
    deliveryDate = json['DeliveryDate'] == null ? "" : json['DeliveryDate'];
    dispatchDocNo = json['DispatchDocNo'] == null ? "" : json['DispatchDocNo'];
    lRDate = json['LRDate'] == null ? "" : json['LRDate'];
    ewayBillNo = json['EwayBillNo'] == null ? "" : json['EwayBillNo'];
    modeOfPayment = json['ModeOfPayment'] == null ? "" : json['ModeOfPayment'];
    transportRemark =
        json['TransportRemark'] == null ? "" : json['TransportRemark'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.invoiceNo;
    data['InvoiceDate'] = this.invoiceDate;
    data['FixedLedgerID'] = this.fixedLedgerID;
    data['FixedLedgerAccount'] = this.fixedLedgerAccount;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['LocationID'] = this.locationID;
    data['LocationName'] = this.locationName;
    data['BankID'] = this.bankID;
    data['BankName'] = this.bankName;
    data['TerminationOfDeliery'] = this.terminationOfDeliery;
    data['TerminationOfDelieryStatename'] = this.terminationOfDelieryStatename;
    data['TerminationOfDelieryCity'] = this.terminationOfDelieryCity;
    data['TerminationOfDelieryCityName'] = this.terminationOfDelieryCityName;
    data['TermsCondition'] = this.termsCondition;
    data['InquiryNo'] = this.inquiryNo;
    data['OrderNo'] = this.orderNo;
    data['QuotationNo'] = this.quotationNo;
    data['ComplaintNo'] = this.complaintNo;
    data['RefType'] = this.refType;
    data['SupplierRef'] = this.supplierRef;
    data['SupplierRefDate'] = this.supplierRefDate;
    data['EmailSubject'] = this.emailSubject;
    data['EmailContent'] = this.emailContent;
    data['OtherRef'] = this.otherRef;
    data['PatientName'] = this.patientName;
    data['PatientType'] = this.patientType;
    data['Amount'] = this.amount;
    data['Percentage'] = this.percentage;
    data['EstimatedAmt'] = this.estimatedAmt;
    data['BasicAmt'] = this.basicAmt;
    data['DiscountAmt'] = this.discountAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['ROffAmt'] = this.rOffAmt;
    data['ChargeID1'] = this.chargeID1;
    data['ChargeName1'] = this.chargeName1;
    data['ChargeAmt1'] = this.chargeAmt1;
    data['ChargeBasicAmt1'] = this.chargeBasicAmt1;
    data['ChargeGSTAmt1'] = this.chargeGSTAmt1;
    data['ChargeID2'] = this.chargeID2;
    data['ChargeName2'] = this.chargeName2;
    data['ChargeAmt2'] = this.chargeAmt2;
    data['ChargeBasicAmt2'] = this.chargeBasicAmt2;
    data['ChargeGSTAmt2'] = this.chargeGSTAmt2;
    data['ChargeID3'] = this.chargeID3;
    data['ChargeName3'] = this.chargeName3;
    data['ChargeAmt3'] = this.chargeAmt3;
    data['ChargeBasicAmt3'] = this.chargeBasicAmt3;
    data['ChargeGSTAmt3'] = this.chargeGSTAmt3;
    data['ChargeID4'] = this.chargeID4;
    data['ChargeAmt4'] = this.chargeAmt4;
    data['ChargeBasicAmt4'] = this.chargeBasicAmt4;
    data['ChargeGSTAmt4'] = this.chargeGSTAmt4;
    data['ChargeID5'] = this.chargeID5;
    data['ChargeName5'] = this.chargeName5;
    data['ChargeAmt5'] = this.chargeAmt5;
    data['ChargeBasicAmt5'] = this.chargeBasicAmt5;
    data['ChargeGSTAmt5'] = this.chargeGSTAmt5;
    data['CRDays'] = this.cRDays;
    data['DueDate'] = this.dueDate;
    data['ProjectName'] = this.projectName;
    data['CurrencyName'] = this.currencyName;
    data['CurrencySymbol'] = this.currencySymbol;
    data['ExchangeRate'] = this.exchangeRate;
    data['NetAmt'] = this.netAmt;
    data['ModeOfTransport'] = this.modeOfTransport;
    data['TransporterName'] = this.transporterName;
    data['DeliverTo'] = this.deliverTo;
    data['VehicleNo'] = this.vehicleNo;
    data['LRNo'] = this.lRNo;
    data['DeliveryNote'] = this.deliveryNote;
    data['DeliveryDate'] = this.deliveryDate;
    data['DispatchDocNo'] = this.dispatchDocNo;
    data['LRDate'] = this.lRDate;
    data['EwayBillNo'] = this.ewayBillNo;
    data['ModeOfPayment'] = this.modeOfPayment;
    data['TransportRemark'] = this.transportRemark;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    return data;
  }
}
