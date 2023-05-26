class VkComplaintListResponse {
  List<VkComplaintListResponseDetails> details;
  int totalCount;

  VkComplaintListResponse({this.details, this.totalCount});

  VkComplaintListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new VkComplaintListResponseDetails.fromJson(v));
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

class VkComplaintListResponseDetails {
  int rowNum;
  int pkID;
  String complaintNo;
  String complaintDate;
  String customerName;
  String complaintNotes;
  String complaintStatus;
  String complaintType;
  int CustomerID;

  VkComplaintListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.complaintNo,
      this.complaintDate,
      this.customerName,
      this.complaintNotes,
      this.complaintStatus,
      this.complaintType,
      this.CustomerID});

  VkComplaintListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    complaintDate = json['ComplaintDate'] == null ? "" : json['ComplaintDate'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    complaintNotes =
        json['ComplaintNotes'] == null ? "" : json['ComplaintNotes'];
    complaintStatus =
        json['ComplaintStatus'] == null ? "" : json['ComplaintStatus'];
    complaintType = json['ComplaintType'] == null ? "" : json['ComplaintType'];
    CustomerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.complaintNo;
    data['ComplaintDate'] = this.complaintDate;
    data['CustomerName'] = this.customerName;
    data['ComplaintNotes'] = this.complaintNotes;
    data['ComplaintStatus'] = this.complaintStatus;
    data['ComplaintType'] = this.complaintType;
    data['CustomerID'] = this.CustomerID;

    return data;
  }
}
