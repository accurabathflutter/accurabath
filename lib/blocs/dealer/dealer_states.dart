part of 'dealer_bloc.dart';

abstract class DealerStates extends BaseStates {
  const DealerStates();
}

///all states of AuthenticationStates
class DealerInitialState extends DealerStates {}

class CustomerSourceCallEventResponseState extends DealerStates {
  final CustomerSourceResponse sourceResponse;
  CustomerSourceCallEventResponseState(this.sourceResponse);
}

class CountryListEventResponseState extends DealerStates {
  final CountryListResponse countrylistresponse;
  CountryListEventResponseState(this.countrylistresponse);
}

class StateListEventResponseState extends DealerStates {
  final StateListResponse statelistresponse;
  StateListEventResponseState(this.statelistresponse);
}

class CityListEventResponseState extends DealerStates {
  final CityApiRespose cityApiRespose;
  CityListEventResponseState(this.cityApiRespose);
}

class QuotationTermsCondtionResponseState extends DealerStates {
  final QuotationTermsCondtionResponse response;

  QuotationTermsCondtionResponseState(this.response);
}

///++++++++++++Purchase Products++++++++++++++++
class GetDealerPurchaseProductState extends DealerStates {
  List<DealerPurchaseProductDBTable> dealerPurchaseProductList;
  GetDealerPurchaseProductState(this.dealerPurchaseProductList);
}

class InsertDealerPurchaseProductState extends DealerStates {
  String response;
  InsertDealerPurchaseProductState(this.response);
}

class UpdateDealerPurchaseProductState extends DealerStates {
  String response;
  UpdateDealerPurchaseProductState(this.response);
}

class DeleteByIdDealerPurchaseProductState extends DealerStates {
  String response;
  DeleteByIdDealerPurchaseProductState(this.response);
}

class DeleteAllDealerPurchaseProductState extends DealerStates {
  String response;
  DeleteAllDealerPurchaseProductState(this.response);
}

///++++++++++++Purchase OtherCharge++++++++++++++++
class DealerPurchaseOtherChargeTableState extends DealerStates {
  List<DealerPurchaseOtherChargeTable> dealerPurchaseOtherChargeTable;
  DealerPurchaseOtherChargeTableState(this.dealerPurchaseOtherChargeTable);
}

class InsertDealerPurchaseOtherChargeState extends DealerStates {
  String response;
  InsertDealerPurchaseOtherChargeState(this.response);
}

class UpdateDealerPurchaseOtherChargeState extends DealerStates {
  String response;
  UpdateDealerPurchaseOtherChargeState(this.response);
}

class DeleteAllDealerPurchaseOtherChargeState extends DealerStates {
  String response;
  DeleteAllDealerPurchaseOtherChargeState(this.response);
}

///++++++++++++SaleBill Products++++++++++++++++
class GetDealerSaleBillProductState extends DealerStates {
  List<DealerSaleBillProductDBTable> dealerSaleBillProductDBTable;
  GetDealerSaleBillProductState(this.dealerSaleBillProductDBTable);
}

class InsertDealerSaleBillProductState extends DealerStates {
  String response;
  InsertDealerSaleBillProductState(this.response);
}

class UpdateDealerSaleBillProductState extends DealerStates {
  String response;
  UpdateDealerSaleBillProductState(this.response);
}

class DeleteByIdDealerSaleBillProductState extends DealerStates {
  String response;
  DeleteByIdDealerSaleBillProductState(this.response);
}

class DeleteAllDealerSaleBillProductState extends DealerStates {
  String response;
  DeleteAllDealerSaleBillProductState(this.response);
}

///++++++++++++SaleBill OtherCharge++++++++++++++++
class DealerSaleBillOtherChargeTableState extends DealerStates {
  List<DealerSalesBillOtherChargeTable> dealerSalesBillOtherChargeTable;
  DealerSaleBillOtherChargeTableState(this.dealerSalesBillOtherChargeTable);
}

class InsertDealerSaleBillOtherChargeState extends DealerStates {
  String response;
  InsertDealerSaleBillOtherChargeState(this.response);
}

class UpdateDealerSaleBillOtherChargeState extends DealerStates {
  String response;
  UpdateDealerSaleBillOtherChargeState(this.response);
}

class DeleteAllDealerSaleBillOtherChargeState extends DealerStates {
  String response;
  DeleteAllDealerSaleBillOtherChargeState(this.response);
}
class OtherChargeListResponseState extends DealerStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  OtherChargeListResponseState(this.quotationOtherChargesListResponse);
}