/*ConstantHead:AttendenceWithImage
CompanyId:4132*/

class ConstantResponse {
  List<ConstantResponseDetails> details;
  int totalCount;

  ConstantResponse({this.details, this.totalCount});

  ConstantResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ConstantResponseDetails.fromJson(v));
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

class ConstantResponseDetails {
  String value;

  ConstantResponseDetails({this.value});

  ConstantResponseDetails.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;

    return data;
  }
}
