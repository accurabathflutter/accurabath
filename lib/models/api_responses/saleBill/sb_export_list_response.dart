class SBExportListResponse {
  List<SBExportListResponseDetails> details;
  int totalCount;

  SBExportListResponse({this.details, this.totalCount});

  SBExportListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SBExportListResponseDetails.fromJson(v));
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

class SBExportListResponseDetails {
  int rowNum;
  int pkID;
  String invoiceNo;
  String preCarrBy;
  String preCarrRecPlace;
  String flightNo;
  String portOfLoading;
  String portOfDispatch;
  String portOfDestination;
  String marksNo;
  String packages;
  String packageType;
  String netWeight;
  String grossWeight;
  String freeOnBoard;
  int customerID;
  String customerName;
  String createdBy;
  String createdDate;
  String createdEmployeeName;
  int companyID;

  SBExportListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.invoiceNo,
      this.preCarrBy,
      this.preCarrRecPlace,
      this.flightNo,
      this.portOfLoading,
      this.portOfDispatch,
      this.portOfDestination,
      this.marksNo,
      this.packages,
      this.packageType,
      this.netWeight,
      this.grossWeight,
      this.freeOnBoard,
      this.customerID,
      this.customerName,
      this.createdBy,
      this.createdDate,
      this.createdEmployeeName,
      this.companyID});

  SBExportListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    invoiceNo = json['InvoiceNo'] == null ? "" : json['InvoiceNo'];
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
    packageType = json['PackageType'] == null ? "" : json['PackageType'];
    netWeight = json['NetWeight'] == null ? "" : json['NetWeight'];
    grossWeight = json['GrossWeight'] == null ? "" : json['GrossWeight'];
    freeOnBoard = json['FreeOnBoard'] == null ? "" : json['FreeOnBoard'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    createdEmployeeName =
        json['CreatedEmployeeName'] == null ? "" : json['CreatedEmployeeName'];
    companyID = json['CompanyID'] == null ? 0 : json['CompanyID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.invoiceNo;
    data['PreCarrBy'] = this.preCarrBy;
    data['PreCarrRecPlace'] = this.preCarrRecPlace;
    data['FlightNo'] = this.flightNo;
    data['PortOfLoading'] = this.portOfLoading;
    data['PortOfDispatch'] = this.portOfDispatch;
    data['PortOfDestination'] = this.portOfDestination;
    data['MarksNo'] = this.marksNo;
    data['Packages'] = this.packages;
    data['PackageType'] = this.packageType;
    data['NetWeight'] = this.netWeight;
    data['GrossWeight'] = this.grossWeight;
    data['FreeOnBoard'] = this.freeOnBoard;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['CompanyID'] = this.companyID;
    return data;
  }
}
