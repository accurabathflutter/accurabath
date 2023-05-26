class SOAssemblyTable {
  int id;
  String FinishProductID;
  String ProductID;
  String ProductName;
  String Quantity;
  String Unit;
  String OrderNo;

  SOAssemblyTable(this.FinishProductID, this.ProductID, this.ProductName,
      this.Quantity, this.Unit, this.OrderNo,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FinishProductID'] = this.FinishProductID;
    data['ProductID'] = this.ProductID;
    data['ProductName'] = this.ProductName;
    data['Quantity'] = this.Quantity;
    data['Unit'] = this.Unit;
    data['OrderNo'] = this.OrderNo;

    return data;
  }

  @override
  String toString() {
    return 'SOAssemblyTable{id: $id, FinishProductID: $FinishProductID, ProductID: $ProductID, ProductName: $ProductName, Quantity: $Quantity, Unit: $Unit, OrderNo: $OrderNo}';
  }
}
