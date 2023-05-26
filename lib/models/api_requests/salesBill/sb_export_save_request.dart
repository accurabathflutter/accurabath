/*InvoiceNo:Inv-AUG22-003
PreCarrBy:Test FromAPI Pre Carriage By (Transporter Name)
PreCarrRecPlace:Test FromAPI PreCarrRecPlace
FlightNo:Test
PortOfLoading:Test FromAPI PortOfLoading
PortOfDispatch:Test FromAPI PortOfDispatch
PortOfDestination:Test FromAPI PortOfDestination
MarksNo:Test FromAPI MarksNo
Packages:120
NetWeight:120
GrossWeight:1
PackageType:Test FromAPI PackageType
FreeOnBoard:Test FromAPI FreeOnBoard
LoginUserID:admin
CompanyId:4132*/

class SBExportSaveRequest {
  String InvoiceNo;
  String PreCarrBy;
  String PreCarrRecPlace;
  String FlightNo;
  String PortOfLoading;
  String PortOfDispatch;
  String PortOfDestination;
  String MarksNo;
  String Packages;
  String NetWeight;
  String GrossWeight;
  String PackageType;
  String FreeOnBoard;
  String LoginUserID;
  String CompanyId;

  SBExportSaveRequest(
      {this.InvoiceNo,
      this.PreCarrBy,
      this.PreCarrRecPlace,
      this.FlightNo,
      this.PortOfLoading,
      this.PortOfDispatch,
      this.PortOfDestination,
      this.MarksNo,
      this.Packages,
      this.NetWeight,
      this.GrossWeight,
      this.PackageType,
      this.FreeOnBoard,
      this.LoginUserID,
      this.CompanyId});

  SBExportSaveRequest.fromJson(Map<String, dynamic> json) {
    InvoiceNo = json['InvoiceNo'];
    PreCarrBy = json['PreCarrBy'];
    PreCarrRecPlace = json['PreCarrRecPlace'];
    FlightNo = json['FlightNo'];
    PortOfLoading = json['PortOfLoading'];
    PortOfDispatch = json['PortOfDispatch'];
    PortOfDestination = json['PortOfDestination'];
    MarksNo = json['MarksNo'];
    Packages = json['Packages'];
    NetWeight = json['NetWeight'];
    GrossWeight = json['GrossWeight'];
    PackageType = json['PackageType'];
    FreeOnBoard = json['FreeOnBoard'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['InvoiceNo'] = this.InvoiceNo;
    data['PreCarrBy'] = this.PreCarrBy;
    data['PreCarrRecPlace'] = this.PreCarrRecPlace;
    data['FlightNo'] = this.FlightNo;
    data['PortOfLoading'] = this.PortOfLoading;
    data['PortOfDispatch'] = this.PortOfDispatch;
    data['PortOfDestination'] = this.PortOfDestination;
    data['MarksNo'] = this.MarksNo;
    data['Packages'] = this.Packages;
    data['NetWeight'] = this.NetWeight;
    data['GrossWeight'] = this.GrossWeight;
    data['PackageType'] = this.PackageType;
    data['FreeOnBoard'] = this.FreeOnBoard;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
