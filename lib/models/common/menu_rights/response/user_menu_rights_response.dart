class UserMenuRightsResponse {
  List<UserMenuRightsResponseDetails> details;
  int totalCount;

  UserMenuRightsResponse({this.details, this.totalCount});

  UserMenuRightsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new UserMenuRightsResponseDetails.fromJson(v));
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

class UserMenuRightsResponseDetails {
  int menuID;
  String menuName;
  String menuText;
  String menuURL;
  String addFlag1;
  String editFlag1;
  String delFlag1;

  UserMenuRightsResponseDetails(
      {this.menuID,
      this.menuName,
      this.menuText,
      this.menuURL,
      this.addFlag1,
      this.editFlag1,
      this.delFlag1});

  UserMenuRightsResponseDetails.fromJson(Map<String, dynamic> json) {
    menuID = json['MenuID'] == null ? 0 : json['MenuID'];
    menuName = json['MenuName'] == null ? "" : json['MenuName'];
    menuText = json['MenuText'] == null ? "" : json['MenuText'];
    menuURL = json['MenuURL'] == null ? "" : json['MenuURL'];
    addFlag1 = json['AddFlag1'] == null ? "true" : json['AddFlag1'];
    editFlag1 = json['EditFlag1'] == null ? "true" : json['EditFlag1'];
    delFlag1 = json['DelFlag1'] == null ? "true" : json['DelFlag1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MenuID'] = this.menuID;
    data['MenuName'] = this.menuName;
    data['MenuText'] = this.menuText;
    data['MenuURL'] = this.menuURL;
    data['AddFlag1'] = this.addFlag1;
    data['EditFlag1'] = this.editFlag1;
    data['DelFlag1'] = this.delFlag1;
    return data;
  }
}
