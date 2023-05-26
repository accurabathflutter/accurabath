class VkComplaintHistoryResponse {
  List<VkComplaintHistoryResponseDetails> details;
  int totalCount;

  VkComplaintHistoryResponse({this.details, this.totalCount});

  VkComplaintHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new VkComplaintHistoryResponseDetails.fromJson(v));
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

class VkComplaintHistoryResponseDetails {
  int rowNum;
  int pkID;
  String complaintNo;
  String complaintDate;
  int customerID;
  String customerName;
  String complaintNotes;
  String initiatedBy;

  VkComplaintHistoryResponseDetails(
      {this.rowNum,
      this.pkID,
      this.complaintNo,
      this.complaintDate,
      this.customerID,
      this.customerName,
      this.complaintNotes,
      this.initiatedBy});

  VkComplaintHistoryResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    complaintNo = json['ComplaintNo'] == null ? "" : json['ComplaintNo'];
    complaintDate = json['ComplaintDate'] == null ? "" : json['ComplaintDate'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    complaintNotes =
        json['ComplaintNotes'] == null ? "" : json['ComplaintNotes'];
    initiatedBy = json['InitiatedBy'] == null ? "" : json['InitiatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.complaintNo;
    data['ComplaintDate'] = this.complaintDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ComplaintNotes'] = this.complaintNotes;
    data['InitiatedBy'] = this.initiatedBy;
    return data;
  }
}
