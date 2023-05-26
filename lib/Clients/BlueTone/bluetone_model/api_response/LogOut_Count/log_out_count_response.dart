class LogOutCountResponse {
  List<LogOutCountResponseDetails> details;
  int totalCount;

  LogOutCountResponse({this.details, this.totalCount});

  LogOutCountResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new LogOutCountResponseDetails.fromJson(v));
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

class LogOutCountResponseDetails {
  int todayCount;
  int missedCount;
  int futureCount;

  LogOutCountResponseDetails(
      {this.todayCount, this.missedCount, this.futureCount});

  LogOutCountResponseDetails.fromJson(Map<String, dynamic> json) {
    todayCount = json['TodayCount'] == null ? 0 : json['TodayCount'];
    missedCount = json['MissedCount'] == null ? 0 : json['MissedCount'];
    futureCount = json['FutureCount'] == null ? 0 : json['FutureCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TodayCount'] = this.todayCount;
    data['MissedCount'] = this.missedCount;
    data['FutureCount'] = this.futureCount;
    return data;
  }
}
