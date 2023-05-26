class ProductMasterResponse {
  List<ProductMasterResponseDetails> details;
  int totalCount;

  ProductMasterResponse({this.details, this.totalCount});

  ProductMasterResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ProductMasterResponseDetails.fromJson(v));
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

class ProductMasterResponseDetails {
  int rowNum;
  int pkID;
  String productName;
  String productNameLong;
  String productSpecification;
  String productAlias;
  String productType;
  String unit;
  double unitPrice;
  double purcPrice;
  double taxRate;
  double addTaxPer;
  String productAdvantage;
  String productApplication;
  int productGroupID;
  String productGroupName;
  String productImage;
  int brandID;
  String brandName;
  int taxType;
  bool activeFlag;
  String activeFlagDesc;
  String hSNCode;
  double manPower;
  double horsePower;
  double minUnitPrice;
  double maxUnitPrice;
  double profitRatio;
  double minQuantity;
  int unitQuantity;
  String unitSize;
  String unitSurface;
  String unitGrade;
  double boxWeight;
  double boxSQFT;
  double boxSQMT;
  double openingSTK;
  double inwardSTK;
  double outwardSTK;
  double closingSTK;

  ProductMasterResponseDetails(
      {this.rowNum,
      this.pkID,
      this.productName,
      this.productNameLong,
      this.productSpecification,
      this.productAlias,
      this.productType,
      this.unit,
      this.unitPrice,
      this.purcPrice,
      this.taxRate,
      this.addTaxPer,
      this.productAdvantage,
      this.productApplication,
      this.productGroupID,
      this.productGroupName,
      this.productImage,
      this.brandID,
      this.brandName,
      this.taxType,
      this.activeFlag,
      this.activeFlagDesc,
      this.hSNCode,
      this.manPower,
      this.horsePower,
      this.minUnitPrice,
      this.maxUnitPrice,
      this.profitRatio,
      this.minQuantity,
      this.unitQuantity,
      this.unitSize,
      this.unitSurface,
      this.unitGrade,
      this.boxWeight,
      this.boxSQFT,
      this.boxSQMT,
      this.openingSTK,
      this.inwardSTK,
      this.outwardSTK,
      this.closingSTK});

  ProductMasterResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    productNameLong =
        json['ProductNameLong'] == null ? "" : json['ProductNameLong'];
    productSpecification = json['ProductSpecification'] == null
        ? ""
        : json['ProductSpecification'];
    productAlias = json['ProductAlias'] == null ? "" : json['ProductAlias'];
    productType = json['ProductType'] == null ? "" : json['ProductType'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    unitPrice = json['UnitPrice'] == null ? 0.00 : json['UnitPrice'];
    purcPrice = json['PurcPrice'] == null ? 0.00 : json['PurcPrice'];
    taxRate = json['TaxRate'] == null ? 0.00 : json['TaxRate'];
    addTaxPer = json['AddTaxPer'] == null ? 0.00 : json['AddTaxPer'];
    productAdvantage =
        json['ProductAdvantage'] == null ? "" : json['ProductAdvantage'];
    productApplication =
        json['ProductApplication'] == null ? "" : json['ProductApplication'];
    productGroupID =
        json['ProductGroupID'] == null ? 0 : json['ProductGroupID'];
    productGroupName =
        json['ProductGroupName'] == null ? "" : json['ProductGroupName'];
    productImage = json['ProductImage'] == null ? "" : json['ProductImage'];
    brandID = json['BrandID'] == null ? 0 : json['BrandID'];
    brandName = json['BrandName'] == null ? "" : json['BrandName'];
    taxType = json['TaxType'] == null ? 0 : json['TaxType'];
    activeFlag = json['ActiveFlag'] == null ? false : json['ActiveFlag'];
    activeFlagDesc =
        json['ActiveFlagDesc'] == null ? "" : json['ActiveFlagDesc'];
    hSNCode = json['HSNCode'] == null ? "" : json['HSNCode'];
    manPower = json['ManPower'] == null ? 0.00 : json['ManPower'];
    horsePower = json['HorsePower'] == null ? 0.00 : json['HorsePower'];
    minUnitPrice = json['Min_UnitPrice'] == null ? 0.00 : json['Min_UnitPrice'];
    maxUnitPrice = json['Max_UnitPrice'] == null ? 0.00 : json['Max_UnitPrice'];
    profitRatio = json['ProfitRatio'] == null ? 0.00 : json['ProfitRatio'];
    minQuantity = json['MinQuantity'] == null ? 0 : json['MinQuantity'];
    unitQuantity = json['UnitQuantity'] == null ? 0 : json['UnitQuantity'];
    unitSize = json['UnitSize'] == null ? "" : json['UnitSize'];
    unitSurface = json['UnitSurface'] == null ? "" : json['UnitSurface'];
    unitGrade = json['UnitGrade'] == null ? "" : json['UnitGrade'];
    boxWeight = json['Box_Weight'] == null ? 0.00 : json['Box_Weight'];
    boxSQFT = json['Box_SQFT'] == null ? 0.00 : json['Box_SQFT'];
    boxSQMT = json['Box_SQMT'] == null ? 0.00 : json['Box_SQMT'];
    openingSTK = json['OpeningSTK'] == null ? 0.00 : json['OpeningSTK'];
    inwardSTK = json['InwardSTK'] == null ? 0.00 : json['InwardSTK'];
    outwardSTK = json['OutwardSTK'] == null ? 0.00 : json['OutwardSTK'];
    closingSTK = json['ClosingSTK'] == null ? 0.00 : json['ClosingSTK'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ProductName'] = this.productName;
    data['ProductNameLong'] = this.productNameLong;
    data['ProductSpecification'] = this.productSpecification;
    data['ProductAlias'] = this.productAlias;
    data['ProductType'] = this.productType;
    data['Unit'] = this.unit;
    data['UnitPrice'] = this.unitPrice;
    data['PurcPrice'] = this.purcPrice;
    data['TaxRate'] = this.taxRate;
    data['AddTaxPer'] = this.addTaxPer;
    data['ProductAdvantage'] = this.productAdvantage;
    data['ProductApplication'] = this.productApplication;
    data['ProductGroupID'] = this.productGroupID;
    data['ProductGroupName'] = this.productGroupName;
    data['ProductImage'] = this.productImage;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['TaxType'] = this.taxType;
    data['ActiveFlag'] = this.activeFlag;
    data['ActiveFlagDesc'] = this.activeFlagDesc;
    data['HSNCode'] = this.hSNCode;
    data['ManPower'] = this.manPower;
    data['HorsePower'] = this.horsePower;
    data['Min_UnitPrice'] = this.minUnitPrice;
    data['Max_UnitPrice'] = this.maxUnitPrice;
    data['ProfitRatio'] = this.profitRatio;
    data['MinQuantity'] = this.minQuantity;
    data['UnitQuantity'] = this.unitQuantity;
    data['UnitSize'] = this.unitSize;
    data['UnitSurface'] = this.unitSurface;
    data['UnitGrade'] = this.unitGrade;
    data['Box_Weight'] = this.boxWeight;
    data['Box_SQFT'] = this.boxSQFT;
    data['Box_SQMT'] = this.boxSQMT;
    data['OpeningSTK'] = this.openingSTK;
    data['InwardSTK'] = this.inwardSTK;
    data['OutwardSTK'] = this.outwardSTK;
    data['ClosingSTK'] = this.closingSTK;
    return data;
  }
}
