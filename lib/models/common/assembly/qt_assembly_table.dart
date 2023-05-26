class QTAssemblyTable {
  int id;
  String FinishProductID;
  String ProductID;
  String ProductName;
  String Quantity;
  String Unit;
  String QuotationNo;

  QTAssemblyTable(this.FinishProductID, this.ProductID, this.ProductName,
      this.Quantity, this.Unit, this.QuotationNo,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FinishProductID'] = this.FinishProductID;
    data['ProductID'] = this.ProductID;
    data['ProductName'] = this.ProductName;
    data['Quantity'] = this.Quantity;
    data['Unit'] = this.Unit;
    data['QuotationNo'] = this.QuotationNo;

    return data;
  }

  @override
  String toString() {
    return 'QTAssemblyTable{id: $id, FinishProductID: $FinishProductID, ProductID: $ProductID, ProductName: $ProductName, Quantity: $Quantity, Unit: $Unit, QuotationNo: $QuotationNo}';
  }
}
