class QuotationSpecificationTable {
  int id;
  String OrderNo;
  String Group_Description;
  String Head;
  String Specification;
  String Material_Remarks;
  String QuotationNo;
  String ProductID;

  QuotationSpecificationTable(
      this.OrderNo,
      this.Group_Description,
      this.Head,
      this.Specification,
      this.Material_Remarks,
      this.QuotationNo,
      this.ProductID,
      {this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.OrderNo;
    data['Group_Description'] = this.Group_Description;
    data['Head'] = this.Head;
    data['Specification'] = this.Specification;
    data['Material_Remarks'] = this.Material_Remarks;
    data['QuotationNo'] = this.QuotationNo;
    data['ProductID'] = this.ProductID;

    return data;
  }

  @override
  String toString() {
    return 'QuotationSpecificationTable{id: $id, OrderNo: $OrderNo, Group_Description: $Group_Description, Head: $Head, Specification: $Specification, Material_Remarks: $Material_Remarks, QuotationNo: $QuotationNo, ProductID: $ProductID}';
  }
}
