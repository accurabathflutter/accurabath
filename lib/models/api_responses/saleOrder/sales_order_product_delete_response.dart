class SaleOrderProductDeleteResponse {
  List<Null> details;
  int totalCount;

  SaleOrderProductDeleteResponse({this.details, this.totalCount});

  SaleOrderProductDeleteResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['TotalCount'] = this.totalCount;
    return data;
  }
}
