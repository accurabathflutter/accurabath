import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/price_model.dart';

class ProductWithSizedList {
  int id;
  String InquiryNo;
  String LoginUserID;
  String CompanyId;
  String ProductName;
  String ProductID;
  String UnitPrice;
  List<PriceModel> SizedList = [];

  ProductWithSizedList(
      {this.id,
      this.InquiryNo,
      this.LoginUserID,
      this.CompanyId,
      this.ProductName,
      this.ProductID,
      this.UnitPrice,
      this.SizedList});
}
