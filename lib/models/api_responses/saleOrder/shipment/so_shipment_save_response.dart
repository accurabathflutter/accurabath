class SOShipmentSaveResponse {
  List<SOShipmentSaveResponseDetails> details;
  int totalCount;

  SOShipmentSaveResponse({this.details, this.totalCount});

  SOShipmentSaveResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SOShipmentSaveResponseDetails.fromJson(v));
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

class SOShipmentSaveResponseDetails {
  int column1;
  String column2;
  String column3;
  String column4;

  SOShipmentSaveResponseDetails(
      {this.column1, this.column2, this.column3, this.column4});

  SOShipmentSaveResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
    column2 = json['Column2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    data['Column2'] = this.column2;

    return data;
  }
}
