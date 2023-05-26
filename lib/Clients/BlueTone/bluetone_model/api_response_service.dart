class API_Response {
  List<Details> details;
  int totalCount;

  API_Response({this.details, this.totalCount});

  API_Response.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
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

class Details {
  int TodayCount;
  int MissedCount;
  int FutureCount;

  Details({this.TodayCount, this.MissedCount, this.FutureCount});

  Details.fromJson(Map<String, dynamic> json) {
    TodayCount = json['TodayCount'] == null ? 0 : json['TodayCount'];
    MissedCount = json['MissedCount'] == null ? 0 : json['MissedCount'];
    FutureCount = json['FutureCount'] == null ? 0 : json['FutureCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TodayCount'] = this.TodayCount;
    data['MissedCount'] = this.MissedCount;
    data['FutureCount'] = this.FutureCount;
    return data;
  }
}
