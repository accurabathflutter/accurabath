class ProductCalculationModel {
  double TaxAmt;
  double CGSTPer;
  double CGSTAmt;
  double SGSTPer;
  double SGSTAmt;
  double IGSTPer;
  double IGSTAmt;
  double NetRate;
  double BasicAmt;
  double NetAmt;
  double ItmDiscPer1;
  double ItmDiscAmt1;
  double AddTaxAmt;
  double ItemHdDiscAmt;

  ProductCalculationModel({
    this.TaxAmt,
    this.CGSTPer,
    this.CGSTAmt,
    this.SGSTPer,
    this.SGSTAmt,
    this.IGSTPer,
    this.IGSTAmt,
    this.NetRate,
    this.BasicAmt,
    this.NetAmt,
    this.ItmDiscPer1,
    this.ItmDiscAmt1,
    this.AddTaxAmt,
    this.ItemHdDiscAmt,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TaxAmt'] = this.TaxAmt;
    data['CGSTPer'] = this.CGSTPer;
    data['CGSTAmt'] = this.CGSTAmt;
    data['SGSTPer'] = this.SGSTPer;
    data['SGSTAmt'] = this.SGSTAmt;
    data['IGSTPer'] = this.IGSTPer;
    data['IGSTAmt'] = this.IGSTAmt;
    data['NetRate'] = this.NetRate;
    data['BasicAmt'] = this.BasicAmt;
    data['NetAmt'] = this.NetAmt;
    data['ItmDiscPer1'] = this.ItmDiscPer1;
    data['ItmDiscAmt1'] = this.ItmDiscAmt1;
    data['AddTaxAmt'] = this.AddTaxAmt;
    data['ItemHdDiscAmt'] = this.ItemHdDiscAmt;

    return data;
  }
}
