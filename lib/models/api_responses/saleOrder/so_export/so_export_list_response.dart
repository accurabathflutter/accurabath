class SOExportListResponse {
  List<SOExportListResponseDetails> details;
  int totalCount;

  SOExportListResponse({this.details, this.totalCount});

  SOExportListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SOExportListResponseDetails.fromJson(v));
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

class SOExportListResponseDetails {
  int rowNum;
  int pkID;
  String orderNo;
  String preCarrBy;
  String preCarrRecPlace;
  String flightNo;
  String portOfLoading;
  String portOfDispatch;
  String portOfDestination;
  String marksNo;
  String packages;
  String netWeight;
  String grossWeight;
  String packageType;
  String freeOnBoard;
  String createdBy;
  String createdDate;

  SOExportListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.orderNo,
      this.preCarrBy,
      this.preCarrRecPlace,
      this.flightNo,
      this.portOfLoading,
      this.portOfDispatch,
      this.portOfDestination,
      this.marksNo,
      this.packages,
      this.netWeight,
      this.grossWeight,
      this.packageType,
      this.freeOnBoard,
      this.createdBy,
      this.createdDate});

  SOExportListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    orderNo = json['OrderNo'] == null ? "" : json['OrderNo'];
    preCarrBy = json['PreCarrBy'] == null ? "" : json['PreCarrBy'];
    preCarrRecPlace =
        json['PreCarrRecPlace'] == null ? "" : json['PreCarrRecPlace'];
    flightNo = json['FlightNo'] == null ? "" : json['FlightNo'];
    portOfLoading = json['PortOfLoading'] == null ? "" : json['PortOfLoading'];
    portOfDispatch =
        json['PortOfDispatch'] == null ? "" : json['PortOfDispatch'];
    portOfDestination =
        json['PortOfDestination'] == null ? "" : json['PortOfDestination'];
    marksNo = json['MarksNo'] == null ? "" : json['MarksNo'];
    packages = json['Packages'] == null ? "" : json['Packages'];
    netWeight = json['NetWeight'] == null ? "" : json['NetWeight'];
    grossWeight = json['GrossWeight'] == null ? "" : json['GrossWeight'];
    packageType = json['PackageType'] == null ? "" : json['PackageType'];
    freeOnBoard = json['FreeOnBoard'] == null ? "" : json['FreeOnBoard'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.orderNo;
    data['PreCarrBy'] = this.preCarrBy;
    data['PreCarrRecPlace'] = this.preCarrRecPlace;
    data['FlightNo'] = this.flightNo;
    data['PortOfLoading'] = this.portOfLoading;
    data['PortOfDispatch'] = this.portOfDispatch;
    data['PortOfDestination'] = this.portOfDestination;
    data['MarksNo'] = this.marksNo;
    data['Packages'] = this.packages;
    data['NetWeight'] = this.netWeight;
    data['GrossWeight'] = this.grossWeight;
    data['PackageType'] = this.packageType;
    data['FreeOnBoard'] = this.freeOnBoard;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
