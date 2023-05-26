class SbAllProductDeleteRequest {
  String InvoiceNo;
  String CompanyId;

//<editor-fold desc="Data Methods">
  SbAllProductDeleteRequest({
    this.InvoiceNo,
    this.CompanyId,
  });

  Map<String, dynamic> tojson() {
    return {
      'InvoiceNo': this.InvoiceNo,
      'CompanyId': this.CompanyId,
    };
  }

  factory SbAllProductDeleteRequest.fromMap(Map<String, dynamic> map) {
    return SbAllProductDeleteRequest(
      InvoiceNo: map['InvoiceNo'] as String,
      CompanyId: map['CompanyId'] as String,
    );
  }

//</editor-fold>
}
