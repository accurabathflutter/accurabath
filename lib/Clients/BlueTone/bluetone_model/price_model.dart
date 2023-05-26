class PriceModel {
  int id;
  String ProductID;
  String ProductName;
  String SizeID;
  String SizeName;
  String isChecked;

  PriceModel(this.ProductID, this.ProductName, this.SizeID, this.SizeName,
      this.isChecked,
      {this.id});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.ProductID;
    data['ProductName'] = this.ProductName;
    data['SizeID'] = this.SizeID;
    data['SizeName'] = this.SizeName;
    data['isChecked'] = this.isChecked;

    return data;
  }

  @override
  String toString() {
    return 'PriceModel{id: $id, ProductID: $ProductID, ProductName: $ProductName, SizeID: $SizeID, SizeName: $SizeName, isChecked: $isChecked}';
  }
}
