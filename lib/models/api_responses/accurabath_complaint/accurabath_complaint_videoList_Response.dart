class AccurabathComplaintVideoListResponse {
  List<AccurabathComplaintVideoListResponseDetails> details;
  int totalCount;

  AccurabathComplaintVideoListResponse({this.details, this.totalCount});

  AccurabathComplaintVideoListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details
            .add(new AccurabathComplaintVideoListResponseDetails.fromJson(v));
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

class AccurabathComplaintVideoListResponseDetails {
  int pkID;
  String complaintNo;
  String fileName;
  String fileType;
  String data;
  String createdBy;
  String createdDate;

  AccurabathComplaintVideoListResponseDetails(
      {this.pkID,
      this.complaintNo,
      this.fileName,
      this.fileType,
      this.data,
      this.createdBy,
      this.createdDate});

  AccurabathComplaintVideoListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    fileName = json['FileName'] == null ? "" : json['FileName'];
    fileType = json['FileType'] == null ? "" : json['FileType'];
    data = json['data'] == null ? "" : json['data'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.complaintNo;
    data['FileName'] = this.fileName;
    data['FileType'] = this.fileType;
    data['data'] = this.data;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
