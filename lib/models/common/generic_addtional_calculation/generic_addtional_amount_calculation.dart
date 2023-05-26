class GenericAddditionalCharges {
  int id;
  String DiscountAmt;
  String ChargeID1;
  String ChargeAmt1;
  String ChargeID2;
  String ChargeAmt2;
  String ChargeID3;
  String ChargeAmt3;
  String ChargeID4;
  String ChargeAmt4;
  String ChargeID5;
  String ChargeAmt5;
  String ChargeName1;
  String ChargeName2;
  String ChargeName3;
  String ChargeName4;
  String ChargeName5;

  GenericAddditionalCharges(
      this.DiscountAmt,
      this.ChargeID1,
      this.ChargeAmt1,
      this.ChargeID2,
      this.ChargeAmt2,
      this.ChargeID3,
      this.ChargeAmt3,
      this.ChargeID4,
      this.ChargeAmt4,
      this.ChargeID5,
      this.ChargeAmt5,
      this.ChargeName1,
      this.ChargeName2,
      this.ChargeName3,
      this.ChargeName4,
      this.ChargeName5,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DiscountAmt'] = this.DiscountAmt;
    data['ChargeID1'] = this.ChargeID1;
    data['ChargeAmt1'] = this.ChargeAmt1;
    data['ChargeID2'] = this.ChargeID2;
    data['ChargeAmt2'] = this.ChargeAmt2;
    data['ChargeID3'] = this.ChargeID3;
    data['ChargeAmt3'] = this.ChargeAmt3;
    data['ChargeID4'] = this.ChargeID4;
    data['ChargeAmt4'] = this.ChargeAmt4;
    data['ChargeID5'] = this.ChargeID5;
    data['ChargeAmt5'] = this.ChargeAmt5;
    data['ChargeName1'] = this.ChargeName1;
    data['ChargeName2'] = this.ChargeName2;
    data['ChargeName3'] = this.ChargeName3;
    data['ChargeName4'] = this.ChargeName4;
    data['ChargeName5'] = this.ChargeName5;

    return data;
  }

  @override
  String toString() {
    return 'GenericAddditionalCharges{id: $id, DiscountAmt: $DiscountAmt, ChargeID1: $ChargeID1, ChargeAmt1: $ChargeAmt1, ChargeID2: $ChargeID2, ChargeAmt2: $ChargeAmt2, ChargeID3: $ChargeID3, ChargeAmt3: $ChargeAmt3, ChargeID4: $ChargeID4, ChargeAmt4: $ChargeAmt4, ChargeID5: $ChargeID5, ChargeAmt5: $ChargeAmt5, ChargeName1: $ChargeName1, ChargeName2: $ChargeName2, ChargeName3: $ChargeName3, ChargeName4: $ChargeName4, ChargeName5: $ChargeName5}';
  }
}
