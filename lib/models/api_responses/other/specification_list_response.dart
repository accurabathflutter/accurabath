class SpecificationListResponse {
  List<SpecificationDetails> details;
  int totalCount;

  SpecificationListResponse({this.details, this.totalCount});

  SpecificationListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SpecificationDetails.fromJson(v));
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

class SpecificationDetails {
  int rowNum;
  int pkID;
  String OrderNo;
  int finishProductID;
  String finishProductName;
  String finishProductNameLong;
  String groupHead;
  String materialHead;
  String materialSpec;
  String MaterialRemarks;
  int itemOrder;

  SpecificationDetails(
      {this.rowNum,
      this.pkID,
      this.OrderNo,
      this.finishProductID,
      this.finishProductName,
      this.finishProductNameLong,
      this.groupHead,
      this.materialHead,
      this.materialSpec,
      this.MaterialRemarks,
      this.itemOrder});

  /* {
                "RowNum": 5,
                "pkID": 10715,
                "OrderNo": "",
                "FinishProductID": 40119,
                "FinishProductName": "test Exclusive",
                "FinishProductNameLong": "[Exclusive] - test Exclusive",
                "GroupHead": "Material of Construction",
                "MaterialHead": "Cylinder",
                "MaterialSpec": "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    ",
                "MaterialRemarks": "",
                "itemOrder": 0
            },*/
  SpecificationDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    OrderNo = json['OrderNo'] == null ? "" : json['OrderNo'];
    finishProductID =
        json['FinishProductID'] == null ? 0 : json['FinishProductID'];
    finishProductName =
        json['FinishProductName'] == null ? "" : json['FinishProductName'];
    finishProductNameLong = json['FinishProductNameLong'] == null
        ? ""
        : json['FinishProductNameLong'];
    groupHead = json['GroupHead'] == null ? "" : json['GroupHead'];
    materialHead = json['MaterialHead'] == null ? "" : json['MaterialHead'];
    materialSpec = json['MaterialSpec'] == null ? "" : json['MaterialSpec'];
    MaterialRemarks =
        json['MaterialRemarks'] == null ? "" : json['MaterialRemarks'];
    itemOrder = json['ItemOrder'] == null ? 0 : json['ItemOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.OrderNo;
    data['FinishProductID'] = this.finishProductID;
    data['FinishProductName'] = this.finishProductName;
    data['FinishProductNameLong'] = this.finishProductNameLong;
    data['GroupHead'] = this.groupHead;
    data['MaterialHead'] = this.materialHead;
    data['MaterialSpec'] = this.materialSpec;
    data['MaterialRemarks'] = this.MaterialRemarks;
    data['ItemOrder'] = this.itemOrder;
    return data;
  }
}
