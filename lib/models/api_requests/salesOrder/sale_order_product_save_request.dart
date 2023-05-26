class SalesOrderProductRequest {
  String pkID;

  String OrderNo;

  int ProductID;

  double Quantity;

  String Unit;

  double UnitRate;

  double DiscountPercent;

  double NetRate;

  double Amount;

  double TaxAmount;

  double NetAmount;

  String LoginUserID;

  double TaxRate;

  double SGSTPer;

  double SGSTAmt;

  double CGSTPer;

  double CGSTAmt;

  double IGSTPer;

  double IGSTAmt;

  int TaxType;

  double DiscountAmt;

  double HeaderDiscAmt;

  String DeliveryDate;

  int CompanyId;

  SalesOrderProductRequest(
      {this.pkID,
      this.OrderNo,
      this.ProductID,
      this.Quantity,
      this.Unit,
      this.UnitRate,
      this.DiscountPercent,
      this.NetRate,
      this.Amount,
      this.TaxAmount,
      this.NetAmount,
      this.LoginUserID,
      this.TaxRate,
      this.SGSTPer,
      this.SGSTAmt,
      this.CGSTPer,
      this.CGSTAmt,
      this.IGSTPer,
      this.IGSTAmt,
      this.TaxType,
      this.DiscountAmt,
      this.HeaderDiscAmt,
      this.DeliveryDate,
      this.CompanyId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.OrderNo;
    data['ProductID'] = this.ProductID;
    data['Quantity'] = this.Quantity;
    data['Unit'] = this.Unit;
    data['UnitRate'] = this.UnitRate;
    data['DiscountPercent'] = this.DiscountPercent;
    data['NetRate'] = this.NetRate;
    data['Amount'] = this.Amount;
    data['TaxAmount'] = this.TaxAmount;
    data['NetAmount'] = this.NetAmount;
    data['LoginUserID'] = this.LoginUserID;
    data['TaxRate'] = this.TaxRate;
    data['SGSTPer'] = this.SGSTPer;
    data['SGSTAmt'] = this.SGSTAmt;
    data['CGSTPer'] = this.CGSTPer;
    data['CGSTAmt'] = this.CGSTAmt;
    data['IGSTPer'] = this.IGSTPer;
    data['IGSTAmt'] = this.IGSTAmt;
    data['TaxType'] = this.TaxType;
    data['DiscountAmt'] = this.DiscountAmt;
    data['HeaderDiscAmt'] = this.HeaderDiscAmt;
    data['DeliveryDate'] = this.DeliveryDate;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
