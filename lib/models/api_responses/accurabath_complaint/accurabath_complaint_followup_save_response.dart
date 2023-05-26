class AccuraBathComplaintFollowupSaveResponse {
  List<AccuraBathComplaintFollowupSaveResponseDetails> details;
  int totalCount;

  AccuraBathComplaintFollowupSaveResponse({this.details, this.totalCount});

  AccuraBathComplaintFollowupSaveResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new AccuraBathComplaintFollowupSaveResponseDetails.fromJson(v));
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

class AccuraBathComplaintFollowupSaveResponseDetails {
  int column1;
  String column2;

  AccuraBathComplaintFollowupSaveResponseDetails({this.column1, this.column2});

  AccuraBathComplaintFollowupSaveResponseDetails.fromJson(
      Map<String, dynamic> json) {
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
