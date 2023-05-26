class AccuraBathComplaintDeleteVideoResponse {
  List<AccuraBathComplaintDeleteVideoResponseDetails> details;
  int totalCount;

  AccuraBathComplaintDeleteVideoResponse({this.details, this.totalCount});

  AccuraBathComplaintDeleteVideoResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details
            .add(new AccuraBathComplaintDeleteVideoResponseDetails.fromJson(v));
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

class AccuraBathComplaintDeleteVideoResponseDetails {
  String Name;

  AccuraBathComplaintDeleteVideoResponseDetails({this.Name});

  AccuraBathComplaintDeleteVideoResponseDetails.fromJson(
      Map<String, dynamic> json) {
    Name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.Name;
    return data;
  }
}
