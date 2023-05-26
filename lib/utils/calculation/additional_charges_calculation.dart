import 'dart:math';

class AddtionalCharges {
  static List<double> txtOthChrgAmt1_TextChanged(
      int chrgid,
      double txtOthChrgAmt1,
      double OthChrgGST,
      int Taxtype,
      bool OthChrgBeforeGST) {
    //double txtOthChrgAmt = 0,
    // double OthChrgGSTAmt = 0, OthChrgBasicAmt = 0;
    print("value1111" +
        chrgid.toString() +
        "  = " +
        txtOthChrgAmt1.toString() +
        " = " +
        OthChrgGST.toString() +
        " = " +
        Taxtype.toString() +
        " = " +
        OthChrgBeforeGST.toString());
    //2 method below after this method

    double OthChrgGSTAmt1 = 0;
    double OthChrgBasicAmt1 = 0;
    if (chrgid > 0 && txtOthChrgAmt1 > 0) {
      List<double> getresult = funCalOthChrgGST(
          txtOthChrgAmt1,
          OthChrgBeforeGST,
          OthChrgGST,
          Taxtype,
          /*out*/
          0,
          /*out*/ 0);
      OthChrgGSTAmt1 = getresult[0];
      OthChrgBasicAmt1 = getresult[1];
    } else {
      OthChrgGSTAmt1 = 0;
      OthChrgBasicAmt1 = 0;
    }

    /* hdnOthChrgGST1.Value = OthChrgGSTAmt.ToString();
    hdnOthChrgBasic1.Value = OthChrgBasicAmt.ToString();
    funCalculateTotal();*/
    //drpOthChrg2.Focus();

    List<double> output = [OthChrgGSTAmt1, OthChrgBasicAmt1];

    return output;
  }

  static List<double> funCalOthChrgGST(
      double txtOthChrgAmt,
      bool OthChrgBeforeGST,
      double OthChrgGST,
      int taxtype,
      /*out*/ double OthChargGSTAmt,
      /*out*/ double othchargBasicAmt) {
    OthChargGSTAmt = 0;
    othchargBasicAmt = 0;
    if (OthChrgBeforeGST == true) {
      if (taxtype == 0) {
        OthChargGSTAmt = roundDouble(
            ((txtOthChrgAmt * OthChrgGST) / (100 + OthChrgGST)),
            2); //Math.Round((txtOthChrgAmt * OthChrgGST) / (100 + OthChrgGST), 2);
        othchargBasicAmt = txtOthChrgAmt - OthChargGSTAmt;
      } else if (taxtype == 1) {
        OthChargGSTAmt = roundDouble(((txtOthChrgAmt * OthChrgGST) / 100),
            2); //Math.Round((txtOthChrgAmt * OthChrgGST) / 100, 2);
        othchargBasicAmt = txtOthChrgAmt;
      } else {
        othchargBasicAmt = txtOthChrgAmt;
        OthChargGSTAmt = 0;
      }
    } else {
      othchargBasicAmt = txtOthChrgAmt;
      OthChargGSTAmt = 0;
    }

    List<double> othercharges = [OthChargGSTAmt, othchargBasicAmt];

    return othercharges;
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
