import 'dart:math';

import 'package:for_practice_the_app/models/common/sales_bill_table.dart';
import 'package:for_practice_the_app/utils/calculation/model/product_calculation_model.dart';
import 'package:for_practice_the_app/utils/calculation/product_calulation.dart';

class SalesBillOrderHeaderDiscountCalculation {
  static List<String> testmethod(double i, double j) {
    double sum = i + j;
    double multiplication = i * j;
    List<String> table = [sum.toString(), multiplication.toString()];

    return table;
  }

  static List<SaleBillTable> txtHeadDiscount_TextChanged(
      List<SaleBillTable> qtTable,
      double txtHeadDiscount,
      String CompanyStateID,
      String CustomerStateID) {
    List<SaleBillTable> outqtTable = [];

    double TotalAmt = 0;
    double HeaderDiscAmt = txtHeadDiscount != null ? txtHeadDiscount : 0;
    double HeaderDiscItemWise = 0;
    if (qtTable != null) {
      qtTable.forEach((SaleBillTable car) {
        //print("${car.name} is electric? ${car.isElectric}");
        TotalAmt += car.NetAmount != null ? car.NetAmount : 0;
      });

      qtTable.forEach((SaleBillTable car) {
        //Convert.ToDecimal(row["CGSTPer"])
        HeaderDiscItemWise = 0;
        double a = car
            .NetAmount; //(!String.IsNullOrEmpty(row["NetAmt"].ToString())) ? Convert.ToDecimal(row["NetAmt"]) : 0;
        int uq =
            1; //(!String.IsNullOrEmpty(row["UnitQuantity"].ToString())) ? Convert.ToInt64(row["UnitQuantity"]) : 0;
        double q = car
            .Quantity; //(!String.IsNullOrEmpty(row["Qty"].ToString())) ? Convert.ToDecimal(row["Qty"]) : 0;
        double unitqty =
            1; //(!String.IsNullOrEmpty(row["UnitQty"].ToString())) ? Convert.ToDecimal(row["UnitQty"]) : 0;
        double ur = car
            .UnitRate; //(!String.IsNullOrEmpty(row["Rate"].ToString())) ? Convert.ToDecimal(row["Rate"]) : 0;
        double dp = car
            .DiscountPercent; //(!String.IsNullOrEmpty(row["DiscountPer"].ToString())) ? Convert.ToDecimal(row["DiscountPer"]) : 0;
        double dpa = car
            .DiscountAmt; //(!String.IsNullOrEmpty(row["DiscountAmt"].ToString())) ? Convert.ToDecimal(row["DiscountAmt"]) : 0;
        double tr = car
            .TaxRate; //(!String.IsNullOrEmpty(row["TaxRate"].ToString())) ? Convert.ToDecimal(row["TaxRate"]) : 0;
        double at =
            0; //(!String.IsNullOrEmpty(row["AddTaxPer"].ToString())) ? Convert.ToDecimal(row["AddTaxPer"]) : 0;
        int taxtype = car
            .TaxType; //Convert.ToInt16((!String.IsNullOrEmpty(row["TaxType"].ToString())) ? Convert.ToInt16(row["TaxType"]) : 0);
        HeaderDiscItemWise = (TotalAmt > 0)
            ? roundDouble(((HeaderDiscAmt * a) / TotalAmt), 2)
            : 0; //Math.Round((HeaderDiscAmt * a) / TotalAmt, 2) : 0;
        double TaxAmt = 0;
        double CGSTPer = 0, CGSTAmt = 0;
        double SGSTPer = 0,
            SGSTAmt = 0,
            IGSTPer = 0,
            IGSTAmt = 0,
            NetRate = 0,
            BasicAmt = 0,
            NetAmt = 0,
            ItmDiscPer1 = 0,
            ItmDiscAmt1 = 0,
            AddTaxAmt = 0,
            HeadDiscAmt1 = 0;

        ProductCalculationModel productoutparam =
            productCalculation.funCalculateProduct(
          UnitQuantity: 1,
          TaxType: taxtype,
          Qty: q,
          Rate: ur,
          ItmDiscPer: dp,
          ItmDiscAmt: dpa,
          TaxPer: tr,
          AddTaxPer: at,
          HdDiscAmt: HeaderDiscItemWise,
          CustomerStateId: CustomerStateID,
          CompanyStateId: CompanyStateID,
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
        );

        print("Amount1TEST" +
            " AmountU " +
            productoutparam.BasicAmt.toString() +
            "  NetAmountU : " +
            productoutparam.NetAmt.toString());
        outqtTable.add(SaleBillTable(
            car.QuotationNo,
            car.ProductSpecification,
            car.ProductID,
            car.ProductName,
            car.Unit,
            car.Quantity,
            car.UnitRate,
            car.DiscountPercent,
            car.DiscountAmt,
            car.NetRate,
            productoutparam.BasicAmt,
            car.TaxRate,
            productoutparam.TaxAmt,
            productoutparam.NetAmt,
            car.TaxType,
            productoutparam.CGSTPer,
            productoutparam.SGSTPer,
            productoutparam.IGSTPer,
            productoutparam.CGSTAmt,
            productoutparam.SGSTAmt,
            productoutparam.IGSTAmt,
            car.StateCode,
            car.pkID,
            car.LoginUserID,
            car.CompanyId,
            car.BundleId,
            productoutparam.ItemHdDiscAmt,
            id: car.id));
      });

      return outqtTable;
    } else {
      return null;
    }
  }

  static List<double> funCalculateTotal(
      double hdnOthChrgGST1,
      double hdnOthChrgGST2,
      double hdnOthChrgGST3,
      double hdnOthChrgGST4,
      double hdnOthChrgGST5,
      double hdnOthChrgBasic1,
      double hdnOthChrgBasic2,
      double hdnOthChrgBasic3,
      double hdnOthChrgBasic4,
      double hdnOthChrgBasic5,
      double hdnTotCGSTAmt,
      double hdnTotSGSTAmt,
      double hdnTotIGSTAmt,
      double txtTotBasicAmt,
      double NetAmount,
      double txtHeadDiscount,
      double Tot_otherChargeWithTax,
      Tot_otherChargeExcludeTax) {
    /*double txtTotOthChrgBeforeGST1 = hdnOthChrgBasic1 +
        hdnOthChrgBasic2 +
        hdnOthChrgBasic3 +
        hdnOthChrgBasic4 +
        hdnOthChrgBasic5;*/
    double hdnTotItemGST = hdnTotCGSTAmt + hdnTotSGSTAmt + hdnTotIGSTAmt;
    double txtTotGST = hdnTotItemGST +
        hdnOthChrgGST1 +
        hdnOthChrgGST2 +
        hdnOthChrgGST3 +
        hdnOthChrgGST4 +
        hdnOthChrgGST5;

    /* double txtTotOthChrgAfterGST = hdnOthChrgBasic1 +
        hdnOthChrgBasic2 +
        hdnOthChrgBasic3 +
        hdnOthChrgBasic4 +
        hdnOthChrgBasic5;*/

    double NetAmt = 0;
    NetAmt = NetAmount +
        Tot_otherChargeWithTax +
        Tot_otherChargeExcludeTax +
        hdnOthChrgGST1 +
        hdnOthChrgGST2 +
        hdnOthChrgGST3 +
        hdnOthChrgGST4 +
        hdnOthChrgGST5 -
        txtHeadDiscount;

    double txtTotNetAmt = roundDouble(NetAmt, 0);
    double txtRoff = roundDouble(NetAmt, 0) - roundDouble(NetAmt, 2);

    List<double> addtional = [
      0,
      hdnTotItemGST,
      txtTotGST,
      0,
      txtTotNetAmt,
      txtRoff
    ];
    return addtional;
  }

  static List<SaleBillTable> txtHeadDiscount_WithZero(
      List<SaleBillTable> qtTable,
      double txtHeadDiscount,
      String CompanyStateID,
      String CustomerStateID) {
    List<SaleBillTable> outqtTable = [];

    double TotalAmt = 0;
    double HeaderDiscAmt =
        0.00; //txtHeadDiscount != null ? txtHeadDiscount : 0;
    double HeaderDiscItemWise = 0;
    if (qtTable != null) {
      qtTable.forEach((SaleBillTable car) {
        //print("${car.name} is electric? ${car.isElectric}");
        TotalAmt += car.NetAmount != null ? car.NetAmount : 0;
      });

      qtTable.forEach((SaleBillTable car) {
        //Convert.ToDecimal(row["CGSTPer"])
        HeaderDiscItemWise = 0;
        double a = car
            .NetAmount; //(!String.IsNullOrEmpty(row["NetAmt"].ToString())) ? Convert.ToDecimal(row["NetAmt"]) : 0;
        int uq =
            1; //(!String.IsNullOrEmpty(row["UnitQuantity"].ToString())) ? Convert.ToInt64(row["UnitQuantity"]) : 0;
        double q = car
            .Quantity; //(!String.IsNullOrEmpty(row["Qty"].ToString())) ? Convert.ToDecimal(row["Qty"]) : 0;
        double unitqty =
            1; //(!String.IsNullOrEmpty(row["UnitQty"].ToString())) ? Convert.ToDecimal(row["UnitQty"]) : 0;
        double ur = car
            .UnitRate; //(!String.IsNullOrEmpty(row["Rate"].ToString())) ? Convert.ToDecimal(row["Rate"]) : 0;
        double dp = car
            .DiscountPercent; //(!String.IsNullOrEmpty(row["DiscountPer"].ToString())) ? Convert.ToDecimal(row["DiscountPer"]) : 0;
        double dpa = car
            .DiscountAmt; //(!String.IsNullOrEmpty(row["DiscountAmt"].ToString())) ? Convert.ToDecimal(row["DiscountAmt"]) : 0;

        print("sddsif" +
            " DiscountPercent :  " +
            dp.toString() +
            " DiscountAmt : " +
            dpa.toString());
        double tr = car
            .TaxRate; //(!String.IsNullOrEmpty(row["TaxRate"].ToString())) ? Convert.ToDecimal(row["TaxRate"]) : 0;
        double at =
            0; //(!String.IsNullOrEmpty(row["AddTaxPer"].ToString())) ? Convert.ToDecimal(row["AddTaxPer"]) : 0;
        int taxtype = car
            .TaxType; //Convert.ToInt16((!String.IsNullOrEmpty(row["TaxType"].ToString())) ? Convert.ToInt16(row["TaxType"]) : 0);
        HeaderDiscItemWise = (TotalAmt > 0)
            ? roundDouble(((HeaderDiscAmt * a) / TotalAmt), 2)
            : 0; //Math.Round((HeaderDiscAmt * a) / TotalAmt, 2) : 0;
        double TaxAmt = 0;
        double CGSTPer = 0, CGSTAmt = 0;
        double SGSTPer = 0,
            SGSTAmt = 0,
            IGSTPer = 0,
            IGSTAmt = 0,
            NetRate = 0,
            BasicAmt = 0,
            NetAmt = 0,
            ItmDiscPer1 = 0,
            ItmDiscAmt1 = 0,
            AddTaxAmt = 0,
            HeadDiscAmt1 = 0;

        ProductCalculationModel productoutparam =
            productCalculation.funCalculateProduct(
          UnitQuantity: 1,
          TaxType: taxtype,
          Qty: q,
          Rate: ur,
          ItmDiscPer: dp,
          ItmDiscAmt: dpa,
          TaxPer: tr,
          AddTaxPer: at,
          HdDiscAmt: HeaderDiscItemWise,
          CustomerStateId: CustomerStateID,
          CompanyStateId: CompanyStateID,
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
        );

        print("Amount1TEST" +
            " AmountP : " +
            productoutparam.BasicAmt.toString() +
            "  NetAmountP  : " +
            productoutparam.NetAmt.toString());
        outqtTable.add(SaleBillTable(
            car.QuotationNo,
            car.ProductSpecification,
            car.ProductID,
            car.ProductName,
            car.Unit,
            car.Quantity,
            car.UnitRate,
            car.DiscountPercent,
            car.DiscountAmt,
            car.NetRate,
            productoutparam.BasicAmt,
            car.TaxRate,
            productoutparam.TaxAmt,
            productoutparam.NetAmt,
            car.TaxType,
            productoutparam.CGSTPer,
            productoutparam.SGSTPer,
            productoutparam.IGSTPer,
            productoutparam.CGSTAmt,
            productoutparam.SGSTAmt,
            productoutparam.IGSTAmt,
            car.StateCode,
            car.pkID,
            car.LoginUserID,
            car.CompanyId,
            car.BundleId,
            productoutparam.ItemHdDiscAmt,
            id: car.id));
      });

      return outqtTable;
    } else {
      return null;
    }
  }

  static List<double> funCalculateTotal_WithZero(
      double hdnOthChrgGST1,
      double hdnOthChrgGST2,
      double hdnOthChrgGST3,
      double hdnOthChrgGST4,
      double hdnOthChrgGST5,
      double hdnOthChrgBasic1,
      double hdnOthChrgBasic2,
      double hdnOthChrgBasic3,
      double hdnOthChrgBasic4,
      double hdnOthChrgBasic5,
      double hdnTotCGSTAmt,
      double hdnTotSGSTAmt,
      double hdnTotIGSTAmt,
      double txtTotBasicAmt,
      double NetAmount,
      double txtHeadDiscount,
      double Tot_otherChargeWithTax,
      Tot_otherChargeExcludeTax) {
    /*double txtTotOthChrgBeforeGST1 = hdnOthChrgBasic1 +
        hdnOthChrgBasic2 +
        hdnOthChrgBasic3 +
        hdnOthChrgBasic4 +
        hdnOthChrgBasic5;*/
    double hdnTotItemGST = hdnTotCGSTAmt + hdnTotSGSTAmt + hdnTotIGSTAmt;
    double txtTotGST = hdnTotItemGST +
        hdnOthChrgGST1 +
        hdnOthChrgGST2 +
        hdnOthChrgGST3 +
        hdnOthChrgGST4 +
        hdnOthChrgGST5;

    /* double txtTotOthChrgAfterGST = hdnOthChrgBasic1 +
        hdnOthChrgBasic2 +
        hdnOthChrgBasic3 +
        hdnOthChrgBasic4 +
        hdnOthChrgBasic5;*/

    double NetAmt = 0;
    NetAmt = NetAmount +
        Tot_otherChargeWithTax +
        Tot_otherChargeExcludeTax +
        hdnOthChrgGST1 +
        hdnOthChrgGST2 +
        hdnOthChrgGST3 +
        hdnOthChrgGST4 +
        hdnOthChrgGST5 -
        txtHeadDiscount;

    double txtTotNetAmt = roundDouble(NetAmt, 0);
    double txtRoff = roundDouble(NetAmt, 0) - roundDouble(NetAmt, 2);

    List<double> addtional = [
      0,
      hdnTotItemGST,
      txtTotGST,
      0,
      txtTotNetAmt,
      txtRoff
    ];
    return addtional;
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
