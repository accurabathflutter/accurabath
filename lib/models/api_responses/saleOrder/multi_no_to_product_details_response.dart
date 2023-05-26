class MultiNoToProductDetailsResponse {
  List<MultiNoToProductDetailsResponseDetails> details;
  int totalCount;

  MultiNoToProductDetailsResponse({this.details, this.totalCount});

  MultiNoToProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MultiNoToProductDetailsResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class MultiNoToProductDetailsResponseDetails {
  int pkID;
  String quotationNo;
  int productID;
  String productName;
  String productNameLong;
  String productSpecification;
  String unit;
  double unitPrice;
  double taxRate;
  int taxType;
  double quantity;
  String unit1;

  MultiNoToProductDetailsResponseDetails(
      {this.pkID,
      this.quotationNo,
      this.productID,
      this.productName,
      this.productNameLong,
      this.productSpecification,
      this.unit,
      this.unitPrice,
      this.taxRate,
      this.taxType,
      this.quantity,
      this.unit1});

  MultiNoToProductDetailsResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    quotationNo = json['QuotationNo'] == null ? "" : json['QuotationNo'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    productNameLong =
        json['ProductNameLong'] == null ? "" : json['ProductNameLong'];
    productSpecification = json['ProductSpecification'] == null
        ? ""
        : json['ProductSpecification'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    unitPrice = json['UnitPrice'] == null ? 0.00 : json['UnitPrice'];
    taxRate = json['TaxRate'] == null ? 0.00 : json['TaxRate'];
    taxType = json['TaxType'] == null ? 0 : json['TaxType'];
    quantity = json['Quantity'] == null ? 0.00 : json['Quantity'];
    unit1 = json['Unit1'] == null ? "" : json['Unit1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['QuotationNo'] = this.quotationNo;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['ProductNameLong'] = this.productNameLong;
    data['ProductSpecification'] = this.productSpecification;
    data['Unit'] = this.unit;
    data['UnitPrice'] = this.unitPrice;
    data['TaxRate'] = this.taxRate;
    data['TaxType'] = this.taxType;
    data['Quantity'] = this.quantity;
    data['Unit1'] = this.unit1;
    return data;
  }
}
