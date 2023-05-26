import 'dart:math';

import 'package:for_practice_the_app/utils/calculation/model/product_calculation_model.dart';

class productCalculation {
  static List<String> producwisecalculation(double i, double j) {
    double sum = i + j;
    double multiplication = i * j;
    List<String> table = [sum.toString(), multiplication.toString()];

    return table;
  }

  static ProductCalculationModel funCalculateProduct(
      {double UnitQuantity,
      int TaxType,
      double Qty = 0,
      double Rate = 0,
      double ItmDiscPer = 0,
      double ItmDiscAmt = 0,
      double TaxPer = 0,
      double AddTaxPer = 0,
      double HdDiscAmt = 0,
      String CustomerStateId = "0",
      String CompanyStateId = "",
      /*out*/ double TaxAmt = 0.00,
      /*out*/ double CGSTPer = 0.00,
      /*out*/ double CGSTAmt = 0.00,
      /*out*/ double SGSTPer = 0.00,
      /*out*/ double SGSTAmt = 0.00,
      /*out*/ double IGSTPer = 0.00,
      /*out*/ double IGSTAmt = 0.00,
      /*out*/ double NetRate = 0.00,
      /*out*/ double BasicAmt = 0.00,
      /*out*/ double NetAmt = 0.00,
      /*out*/ double ItmDiscPer1 = 0.00,
      /*out*/ double ItmDiscAmt1 = 0.00,
      /*out*/ double AddTaxAmt = 0.00}) {
    //Out
    TaxAmt = 0;
    CGSTPer = 0;
    CGSTAmt = 0;
    SGSTPer = 0;
    SGSTAmt = 0;
    IGSTPer = 0;
    IGSTAmt = 0;
    NetRate = 0;
    BasicAmt = 0;
    NetAmt = 0;
    ItmDiscPer1 = 0;
    ItmDiscAmt1 = 0;
    AddTaxAmt = 0;
    bool isIGSTItem = false; //isIGST(CustomerStateId, CompanyStateId);
    double BasicVal = 0, GSTAmt = 0;
    //In
    //TaxType = 0; Qty = 2; Rate = 100; ItmDiscPer = 5; ItmDiscAmt = 0; TaxPer = 5; AddTaxPer = 5; isIGST = false;HeadDiscAmt=0;
    if (Rate > 0) {
      if (ItmDiscPer > 0) {
        ItmDiscAmt = ((ItmDiscPer * Rate) / 100);
      } else {
        ItmDiscAmt = 0;
      }
      //else if (ItmDiscPer == 0 && ItmDiscAmt > 0)
      //{
      //    ItmDiscPer = Math.Round((ItmDiscAmt * 100) / Rate, 2);
      //}
      NetRate = roundDouble(
          (Rate - ItmDiscAmt), 2); //Math.Round(Rate - ItmDiscAmt, 2);
      ItmDiscPer1 = ItmDiscPer;
      ItmDiscAmt1 = ItmDiscAmt;
      BasicVal = roundDouble(((Qty * UnitQuantity) * NetRate),
          2); //Math.Round((Qty * UnitQuantity) * NetRate, 2);
      if (TaxType == 0) {
        NetAmt = BasicVal;
        BasicVal = BasicVal - HdDiscAmt;
        double taxamt1 = roundDouble(
            ((((TaxPer + AddTaxPer) * BasicVal) / (100 + TaxPer + AddTaxPer))),
            2);

        /*Math.Round(
            (((TaxPer + AddTaxPer) * BasicVal) / (100 + TaxPer + AddTaxPer)),
            2);*/
        BasicAmt = roundDouble(
            (BasicVal - taxamt1), 2); //Math.Round(BasicVal - taxamt1, 2);
        GSTAmt =
            roundDouble(roundDouble(((((BasicAmt) * TaxPer) / 100)), 2), 2);
        /*Math.Round(Math.Round((((BasicAmt) * TaxPer) / 100), 2) / 2, 2) *
                2; */ //To set round of difference while sgst+CGST
        AddTaxAmt = roundDouble(((((BasicAmt) * AddTaxPer) / 100)),
            2); //Math.Round((((BasicAmt) * AddTaxPer) / 100), 2);
        BasicAmt = roundDouble((BasicVal - (AddTaxAmt + GSTAmt)),
            2); //Math.Round(BasicVal - (AddTaxAmt + GSTAmt), 2);
        if (isIGSTItem) {
          IGSTPer = TaxPer;
          IGSTAmt = GSTAmt;
        } else {
          CGSTPer = roundDouble((TaxPer / 2), 2); //Math.Round(TaxPer / 2, 2);
          SGSTPer = roundDouble((TaxPer / 2), 2); //Math.Round(TaxPer / 2, 2);
          CGSTAmt = roundDouble((GSTAmt / 2), 2); //Math.Round(GSTAmt / 2, 2);
          SGSTAmt = roundDouble((GSTAmt / 2), 2);
        }
        // -------------------------------------------------------------
        TaxAmt = GSTAmt;
        AddTaxAmt = roundDouble(((((BasicAmt) * AddTaxPer) / 100)),
            2); //Math.Round((((BasicAmt) * AddTaxPer) / 100), 2);
        NetAmt = roundDouble((BasicAmt + GSTAmt + AddTaxAmt),
            2); //Math.Round(BasicAmt + GSTAmt + AddTaxAmt, 2);
      } else if (TaxType == 1) {
        BasicAmt = BasicVal - HdDiscAmt;
        GSTAmt = roundDouble((((BasicAmt * TaxPer) / 100)),
            2); //Math.Round(((BasicAmt * TaxPer) / 100), 2);
        if (isIGSTItem) {
          IGSTPer = TaxPer;
          IGSTAmt = roundDouble((((BasicAmt * TaxPer) / 100)),
              2); //Math.Round(((BasicAmt * TaxPer) / 100), 2);
        } else {
          CGSTPer = roundDouble((TaxPer / 2), 2); //Math.Round(TaxPer / 2, 2);
          SGSTPer = roundDouble((TaxPer / 2), 2); //Math.Round(TaxPer / 2, 2);

          // For All Others
          CGSTAmt = roundDouble((GSTAmt / 2), 2); //Math.Round(GSTAmt / 2, 2);
          SGSTAmt = roundDouble((GSTAmt / 2), 2); //Math.Round(GSTAmt / 2, 2);
        }
        GSTAmt = (SGSTAmt + CGSTAmt + IGSTAmt);
        //TaxAmt = GSTAmt;
        // -------------------------------------------------------------
        TaxAmt = GSTAmt;
        AddTaxAmt = roundDouble(((((BasicAmt) * AddTaxPer) / 100)),
            2); //Math.Round((((BasicAmt) * AddTaxPer) / 100), 2);
        NetAmt = roundDouble((BasicVal + GSTAmt + AddTaxAmt),
            2); //Math.Round(BasicVal + GSTAmt + AddTaxAmt, 2);
      } else {
        BasicAmt = BasicVal;
        NetAmt = BasicVal;
        // -------------------------------------------------------------
        TaxAmt = GSTAmt;
        AddTaxAmt = roundDouble(((((BasicAmt) * AddTaxPer) / 100)),
            2); //Math.Round((((BasicAmt) * AddTaxPer) / 100), 2);
        NetAmt = roundDouble((BasicVal + GSTAmt + AddTaxAmt),
            2); //Math.Round(BasicVal + GSTAmt + AddTaxAmt, 2);
      }
    }

    List<double> outparamlist = [
      TaxAmt,
      CGSTPer,
      CGSTAmt,
      SGSTPer,
      SGSTAmt,
      IGSTPer,
      IGSTAmt,
      NetRate,
      BasicAmt,
      NetAmt,
      ItmDiscPer1,
      ItmDiscAmt1,
      AddTaxAmt
    ];

    return /*outparamlist;*/ new ProductCalculationModel(
        TaxAmt: TaxAmt,
        CGSTPer: CGSTPer,
        CGSTAmt: CGSTAmt,
        SGSTPer: SGSTPer,
        SGSTAmt: SGSTAmt,
        IGSTPer: IGSTPer,
        IGSTAmt: IGSTAmt,
        NetRate: NetRate,
        BasicAmt: BasicAmt,
        NetAmt: NetAmt,
        ItmDiscPer1: ItmDiscPer1,
        ItmDiscAmt1: ItmDiscAmt1,
        AddTaxAmt: AddTaxAmt,
        ItemHdDiscAmt: HdDiscAmt);
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
