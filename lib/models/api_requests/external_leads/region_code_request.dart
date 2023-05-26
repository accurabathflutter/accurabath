/*CountryName:India
StateName:Gujarat
CityName:Bhavnagar
CompanyId:4134*/

class RegionCodeRequest {
  String CountryName;
  String StateName;
  String CityName;
  String CompanyId;

  RegionCodeRequest(
      {this.CountryName, this.StateName, this.CityName, this.CompanyId});

  RegionCodeRequest.fromJson(Map<String, dynamic> json) {
    CountryName = json['CountryName'];
    StateName = json['StateName'];
    CityName = json['CityName'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['CountryName'] = this.CountryName;
    data['StateName'] = this.StateName;
    data['CityName'] = this.CityName;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
