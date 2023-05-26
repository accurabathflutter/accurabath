class SBProductSaveRequest {
  int pkID;

  String InvoiceNo;

  String ProductID;

  String TaxType;

  String UnitQty;

  String Qty;

  String Unit;

  String Rate;

  String DiscountPer;

  String DiscountAmt;

  String NetRate;

  String Amount;

  String SGSTPer;

  String SGSTAmt;

  String CGSTPer;

  String CGSTAmt;

  String IGSTPer;

  String IGSTAmt;

  String AddTaxPer;

  String AddTaxAmt;

  String NetAmt;

  String HeaderDiscAmt;

  String ForOrderNo;

  String LocationID;

  String ProductSpecification;

  String LoginUserID;

  int CompanyId;

  SBProductSaveRequest(
      {this.pkID,
      this.InvoiceNo,
      this.ProductID,
      this.TaxType,
      this.UnitQty,
      this.Qty,
      this.Unit,
      this.Rate,
      this.DiscountPer,
      this.DiscountAmt,
      this.NetRate,
      this.Amount,
      this.SGSTPer,
      this.SGSTAmt,
      this.CGSTPer,
      this.CGSTAmt,
      this.IGSTPer,
      this.IGSTAmt,
      this.AddTaxPer,
      this.AddTaxAmt,
      this.NetAmt,
      this.HeaderDiscAmt,
      this.ForOrderNo,
      this.LocationID,
      this.ProductSpecification,
      this.LoginUserID,
      this.CompanyId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.InvoiceNo;
    data['ProductID'] = this.ProductID;
    data['TaxType'] = this.TaxType;
    data['UnitQty'] = this.UnitQty;
    data['Qty'] = this.Qty;
    data['Unit'] = this.Unit;
    data['Rate'] = this.Rate;
    data['DiscountPer'] = this.DiscountPer;
    data['DiscountAmt'] = this.DiscountAmt;
    data['NetRate'] = this.NetRate;
    data['Amount'] = this.Amount;
    data['SGSTPer'] = this.SGSTPer;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTPer'] = this.CGSTPer;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTPer'] = this.IGSTPer;
    data['IGSTAmt'] = this.IGSTAmt;
    data['AddTaxPer'] = this.AddTaxPer;
    data['AddTaxAmt'] = this.AddTaxAmt;
    data['NetAmt'] = this.NetAmt;
    data['HeaderDiscAmt'] = this.HeaderDiscAmt;
    data['ForOrderNo'] = this.ForOrderNo;
    data['LocationID'] = this.LocationID;
    data['ProductSpecification'] = this.ProductSpecification;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
