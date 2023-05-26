class MasterBaseURLResponse {
  List<MasterBaseURLResponseDetails> details;
  int totalCount;

  MasterBaseURLResponse({this.details, this.totalCount});

  MasterBaseURLResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MasterBaseURLResponseDetails.fromJson(v));
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

class MasterBaseURLResponseDetails {
  int pkId;
  String companyName;
  String baseURL;
  String expiryDate;
  String androidApp;
  String iOSApp;

  MasterBaseURLResponseDetails(
      {this.pkId,
      this.companyName,
      this.baseURL,
      this.expiryDate,
      this.androidApp,
      this.iOSApp});

  MasterBaseURLResponseDetails.fromJson(Map<String, dynamic> json) {
    pkId = json['pkId'];
    companyName = json['CompanyName'];
    baseURL = json['BaseURL'];
    expiryDate = json['ExpiryDate'];
    androidApp = json['AndroidApp'];
    iOSApp = json['IOSApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkId'] = this.pkId;
    data['CompanyName'] = this.companyName;
    data['BaseURL'] = this.baseURL;
    data['ExpiryDate'] = this.expiryDate;
    data['AndroidApp'] = this.androidApp;
    data['IOSApp'] = this.iOSApp;
    return data;
  }
}
