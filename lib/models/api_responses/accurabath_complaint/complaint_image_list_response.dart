class FetchAccuraBathComplaintImageListResponse {
  List<FetchAccuraBathComplaintImageListResponseDetails> details;
  int totalCount;

  FetchAccuraBathComplaintImageListResponse({this.details, this.totalCount});

  FetchAccuraBathComplaintImageListResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new FetchAccuraBathComplaintImageListResponseDetails.fromJson(v));
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

class FetchAccuraBathComplaintImageListResponseDetails {
  int pkID;
  String moduleName;
  String keyValue;
  String docName;
  String docType;
  String docData;
  String createdBy;
  String createdDate;

  FetchAccuraBathComplaintImageListResponseDetails(
      {this.pkID,
      this.moduleName,
      this.keyValue,
      this.docName,
      this.docType,
      this.docData,
      this.createdBy,
      this.createdDate});

  FetchAccuraBathComplaintImageListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'];
    moduleName = json['ModuleName'];
    keyValue = json['KeyValue'];
    docName = json['DocName'];
    docType = json['DocType'];
    docData = json['DocData'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ModuleName'] = this.moduleName;
    data['KeyValue'] = this.keyValue;
    data['DocName'] = this.docName;
    data['DocType'] = this.docType;
    data['DocData'] = this.docData;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
