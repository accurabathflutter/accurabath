class PunchAttendenceSaveResponse {
  List<PunchAttendenceSaveResponseDetails> details;
  int totalCount;

  PunchAttendenceSaveResponse({this.details, this.totalCount});

  PunchAttendenceSaveResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PunchAttendenceSaveResponseDetails.fromJson(v));
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

class PunchAttendenceSaveResponseDetails {
  /*int column1;
  String column2;*/
  String column1;
  PunchAttendenceSaveResponseDetails({this.column1});

  PunchAttendenceSaveResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}
