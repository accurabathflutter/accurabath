class RegionCodeResponse {
  List<RegionCodeResponseDetails> details;
  int totalCount;

  RegionCodeResponse({this.details, this.totalCount});

  RegionCodeResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new RegionCodeResponseDetails.fromJson(v));
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

class RegionCodeResponseDetails {
  String country;
  String state;
  String city;

  RegionCodeResponseDetails({this.country, this.state, this.city});

  RegionCodeResponseDetails.fromJson(Map<String, dynamic> json) {
    country = json['Country'] == null ? "" : json['Country'];
    state = json['State'] == null ? "" : json['State'];
    city = json['City'] == null ? "" : json['City'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Country'] = this.country;
    data['State'] = this.state;
    data['City'] = this.city;
    return data;
  }
}
