part of 'dealer_bloc.dart';

@immutable
abstract class DealerEvents {}

class CustomerSourceCallEvent extends DealerEvents {
  final CustomerSourceRequest request1;
  CustomerSourceCallEvent(this.request1);
}

class CountryCallEvent extends DealerEvents {
  final CountryListRequest countryListRequest;
  CountryCallEvent(this.countryListRequest);
}

class StateCallEvent extends DealerEvents {
  final StateListRequest stateListRequest;
  StateCallEvent(this.stateListRequest);
}

class CityCallEvent extends DealerEvents {
  final CityApiRequest cityApiRequest;
  CityCallEvent(this.cityApiRequest);
}

class QuotationTermsConditionCallEvent extends DealerEvents {
  final QuotationTermsConditionRequest request;

  QuotationTermsConditionCallEvent(this.request);
}

///=============DEALER PURCHASE Product CRUD DB================
class GetDealerPurchaseProductEvent extends DealerEvents {
  GetDealerPurchaseProductEvent();
}

class InsertDealerPurchaseProductDBTableCallEvent extends DealerEvents {
  final DealerPurchaseProductDBTable dealerPurchaseProductDBTable;
  InsertDealerPurchaseProductDBTableCallEvent(
      this.dealerPurchaseProductDBTable);
}

class UpdateDealerPurchaseProductDBTableCallEvent extends DealerEvents {
  final DealerPurchaseProductDBTable dealerPurchaseProductDBTable;
  UpdateDealerPurchaseProductDBTableCallEvent(
      this.dealerPurchaseProductDBTable);
}

class DeleteByIdDealerPurchaseProduct extends DealerEvents {
  int id;
  DeleteByIdDealerPurchaseProduct(this.id);
}

class DeleteAllDealerPurchaseProduct extends DealerEvents {
  DeleteAllDealerPurchaseProduct();
}

///=============DEALER PURCHASE OtherCharges CRUD DB================
class GetDealerPurchaseOtherCharge extends DealerEvents {
  GetDealerPurchaseOtherCharge();
}

class InsertDealerPurchaseOtherChargeTableCallEvent extends DealerEvents {
  final DealerPurchaseOtherChargeTable dealerPurchaseOtherChargeTable;
  InsertDealerPurchaseOtherChargeTableCallEvent(
      this.dealerPurchaseOtherChargeTable);
}

class UpdateDealerPurchaseOtherChargeTableCallEvent extends DealerEvents {
  final DealerPurchaseOtherChargeTable dealerPurchaseOtherChargeTable;
  UpdateDealerPurchaseOtherChargeTableCallEvent(
      this.dealerPurchaseOtherChargeTable);
}

class DeleteAllDealerPurchaseOtherCharge extends DealerEvents {
  DeleteAllDealerPurchaseOtherCharge();
}

///=============DEALER SALEBILL CRUD DB================
class GetDealerSaleBillProduct extends DealerEvents {
  GetDealerSaleBillProduct();
}

class InsertDealerSaleBillProductDBTableCallEvent extends DealerEvents {
  final DealerSaleBillProductDBTable dealerSaleBillProductDBTable;
  InsertDealerSaleBillProductDBTableCallEvent(
      this.dealerSaleBillProductDBTable);
}

class UpdateDealerSaleBillProductDBTableCallEvent extends DealerEvents {
  final DealerSaleBillProductDBTable dealerSaleBillProductDBTable;
  UpdateDealerSaleBillProductDBTableCallEvent(
      this.dealerSaleBillProductDBTable);
}

class DeleteByIdDealerSaleBillProduct extends DealerEvents {
  int id;
  DeleteByIdDealerSaleBillProduct(this.id);
}

class DeleteAllDealerSaleBillProduct extends DealerEvents {
  DeleteAllDealerSaleBillProduct();
}

///=============DEALER SALEBILL OtherCharges CRUD DB================
class GetDealerSaleBillOtherCharge extends DealerEvents {
  GetDealerSaleBillOtherCharge();
}

class InsertDealerSalesBillOtherChargeTableCallEvent extends DealerEvents {
  final DealerSalesBillOtherChargeTable dealerSalesBillOtherChargeTable;
  InsertDealerSalesBillOtherChargeTableCallEvent(
      this.dealerSalesBillOtherChargeTable);
}

class UpdateDealerSalesBillOtherChargeTableCallEvent extends DealerEvents {
  final DealerSalesBillOtherChargeTable dealerSalesBillOtherChargeTable;
  UpdateDealerSalesBillOtherChargeTableCallEvent(
      this.dealerSalesBillOtherChargeTable);
}

class DeleteByIdDealerSaleBillOtherCharge extends DealerEvents {
  int id;
  DeleteByIdDealerSaleBillOtherCharge(this.id);
}

class DeleteAllDealerSaleBillOtherCharge extends DealerEvents {
  DeleteAllDealerSaleBillOtherCharge();
}

///============================================
class OtherChargeCallEvent extends DealerEvents {
  String CompanyID;
  final QuotationOtherChargesListRequest request;

  OtherChargeCallEvent(this.CompanyID, this.request);
}
