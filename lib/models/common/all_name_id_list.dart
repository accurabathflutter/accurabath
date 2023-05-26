class ALL_Name_ID {
  int pkID;
  String Name;
  String Name1;
  String PresentDate;
  String Taxtype;
  String TaxRate;
  bool isChecked;

  String GoogleAddress;
  String Latitude;
  String Longitude;

  String MenuName;
  String IsAddField;
  String IsEditField;
  String IsDeleteField;

  String CityCode;
  String CityName;
  String StateCode;
  String StateName;

  String CountryCode;
  String CountryName;

  ALL_Name_ID({
    this.pkID,
    this.Name,
    this.Name1,
    this.PresentDate,
    this.isChecked,
    this.GoogleAddress,
    this.Latitude,
    this.Longitude,
    this.MenuName,
    this.IsAddField,
    this.IsEditField,
    this.IsDeleteField,
    this.CityCode,
    this.CityName,
    this.StateCode,
    this.StateName,
    this.CountryCode,
    this.CountryName,
  });
}
