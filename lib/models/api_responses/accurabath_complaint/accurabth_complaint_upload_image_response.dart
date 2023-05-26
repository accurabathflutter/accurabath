class AccuraBathComplaintImageUploadResponse {
  List<AccuraBathComplaintImageUploadResponseDetails> details;
  int totalCount;

  AccuraBathComplaintImageUploadResponse({this.details, this.totalCount});

  AccuraBathComplaintImageUploadResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details
            .add(new AccuraBathComplaintImageUploadResponseDetails.fromJson(v));
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

class AccuraBathComplaintImageUploadResponseDetails {
  String column1;

  AccuraBathComplaintImageUploadResponseDetails({this.column1});

  AccuraBathComplaintImageUploadResponseDetails.fromJson(
      Map<String, dynamic> json) {
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}
