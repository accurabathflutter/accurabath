import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_response/inquiry_no_to_fetch_product_sized_list_response.dart';

class InquiryProductWithSizedListDetails {
  int rowNum;
  int pkID;
  String inquiryNo;
  double unitPrice;
  double taxRate;
  String unit;
  int productID;
  String productName;
  double quantity;
  String productNameLong;
  String productAlias;
  int taxType;
  double minRate;
  double maxRate;
  List<InquiryNoToFetchProductSizedListResponseDetails>
      all_sized_with_productID = [];
  List<InquiryNoToFetchProductSizedListResponseDetails>
      custom_sized_with_InquiryNo = [];

  InquiryProductWithSizedListDetails(
      {this.rowNum,
      this.pkID,
      this.inquiryNo,
      this.unitPrice,
      this.taxRate,
      this.unit,
      this.productID,
      this.productName,
      this.quantity,
      this.productNameLong,
      this.productAlias,
      this.taxType,
      this.minRate,
      this.maxRate,
      this.all_sized_with_productID});
}
