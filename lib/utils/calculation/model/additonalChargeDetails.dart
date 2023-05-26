class AddditionalCharges {
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
  String ChargeName1;
  String ChargeName2;
  String ChargeName3;
  String ChargeName4;
  String ChargeName5;
  String ChargeTaxType1;
  String ChargeTaxType2;
  String ChargeTaxType3;
  String ChargeTaxType4;
  String ChargeTaxType5;
  String ChargeGstPer1;
  String ChargeGstPer2;
  String ChargeGstPer3;
  String ChargeGstPer4;
  String ChargeGstPer5;
  String ChargeIsBeforGst1;
  String ChargeIsBeforGst2;
  String ChargeIsBeforGst3;
  String ChargeIsBeforGst4;
  String ChargeIsBeforGst5;
  String OtherChargeWithTax;
  String OtherChargeWithExcludTax;
  String TotalGSTAmnt;

  AddditionalCharges(
      {this.DiscountAmt,
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
      this.ChargeName1,
      this.ChargeName2,
      this.ChargeName3,
      this.ChargeName4,
      this.ChargeName5,
      this.ChargeTaxType1,
      this.ChargeTaxType2,
      this.ChargeTaxType3,
      this.ChargeTaxType4,
      this.ChargeTaxType5,
      this.ChargeGstPer1,
      this.ChargeGstPer2,
      this.ChargeGstPer3,
      this.ChargeGstPer4,
      this.ChargeGstPer5,
      this.ChargeIsBeforGst1,
      this.ChargeIsBeforGst2,
      this.ChargeIsBeforGst3,
      this.ChargeIsBeforGst4,
      this.ChargeIsBeforGst5,
      this.OtherChargeWithTax,
      this.OtherChargeWithExcludTax,
      this.TotalGSTAmnt});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['ChargeName1'] = this.ChargeName1;
    data['ChargeName2'] = this.ChargeName2;
    data['ChargeName3'] = this.ChargeName3;
    data['ChargeName4'] = this.ChargeName4;
    data['ChargeName5'] = this.ChargeName5;
    data['ChargeTaxType1'] = this.ChargeTaxType1;
    data['ChargeTaxType2'] = this.ChargeTaxType2;
    data['ChargeTaxType3'] = this.ChargeTaxType3;
    data['ChargeTaxType4'] = this.ChargeTaxType4;
    data['ChargeTaxType5'] = this.ChargeTaxType5;
    data['ChargeGstPer1'] = this.ChargeGstPer1;
    data['ChargeGstPer2'] = this.ChargeGstPer2;
    data['ChargeGstPer3'] = this.ChargeGstPer3;
    data['ChargeGstPer4'] = this.ChargeGstPer4;
    data['ChargeGstPer5'] = this.ChargeGstPer5;
    data['ChargeIsBeforGst1'] = this.ChargeIsBeforGst1;
    data['ChargeIsBeforGst2'] = this.ChargeIsBeforGst2;
    data['ChargeIsBeforGst3'] = this.ChargeIsBeforGst3;
    data['ChargeIsBeforGst4'] = this.ChargeIsBeforGst4;
    data['ChargeIsBeforGst5'] = this.ChargeIsBeforGst5;

    data['OtherChargeWithTax'] = this.OtherChargeWithTax;
    data['OtherChargeWithExcludTax'] = this.OtherChargeWithExcludTax;
    data['TotalGSTAmnt'] = this.TotalGSTAmnt;
  }
}
