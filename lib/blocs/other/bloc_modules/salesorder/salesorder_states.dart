part of 'salesorder_bloc.dart';

abstract class SalesOrderStates extends BaseStates {
  const SalesOrderStates();
}

///all states of AuthenticationStates
class SalesOrderInitialState extends SalesOrderStates {}

class SalesOrderListCallResponseState extends SalesOrderStates {
  final SalesOrderListResponse response;
  final int newPage;
  SalesOrderListCallResponseState(this.response, this.newPage);
}

class SearchSalesOrderListByNameCallResponseState extends SalesOrderStates {
  final SearchSalesOrderListResponse response;

  SearchSalesOrderListByNameCallResponseState(this.response);
}

class SearchSalesOrderListByNumberCallResponseState extends SalesOrderStates {
  final SalesOrderListResponse response;

  SearchSalesOrderListByNumberCallResponseState(this.response);
}

class SalesOrderPDFGenerateResponseState extends SalesOrderStates {
  final SalesOrderPDFGenerateResponse response;

  SalesOrderPDFGenerateResponseState(this.response);
}

class BankDetailsListResponseState extends SalesOrderStates {
  final BankDetailsListResponse response;

  BankDetailsListResponseState(this.response);
}

class QuotationProjectListResponseState extends SalesOrderStates {
  final QuotationProjectListResponse response;

  QuotationProjectListResponseState(this.response);
}

class QuotationTermsCondtionResponseState extends SalesOrderStates {
  final QuotationTermsCondtionResponse response;

  QuotationTermsCondtionResponseState(this.response);
}

class SearchCustomerListByNumberCallResponseState extends SalesOrderStates {
  String IsFromDialog;
  final CustomerDetailsResponse response;

  SearchCustomerListByNumberCallResponseState(this.IsFromDialog, this.response);
}

class SalesBill_INQ_QT_SO_NO_ListResponseState extends SalesOrderStates {
  final SalesBill_INQ_QT_SO_NO_ListResponse response;
  SalesBill_INQ_QT_SO_NO_ListResponseState(this.response);
}

class MultiNoToProductDetailsResponseState extends SalesOrderStates {
  String FetchFromWhichScreen;
  final MultiNoToProductDetailsResponse response;
  MultiNoToProductDetailsResponseState(
      this.FetchFromWhichScreen, this.response);
}

class SaleBillEmailContentResponseState extends SalesOrderStates {
  final SaleBillEmailContentResponse response;

  SaleBillEmailContentResponseState(this.response);
}

//MultiNoToProductDetailsResponse
class FCMNotificationResponseState extends SalesOrderStates {
  final FCMNotificationResponse response;

  FCMNotificationResponseState(this.response);
}

class PaymentScheduleResponseState extends SalesOrderStates {
  final String response;

  PaymentScheduleResponseState(this.response);
}

class PaymentScheduleListResponseState extends SalesOrderStates {
  final List<SoPaymentScheduleTable> response;

  PaymentScheduleListResponseState(this.response);
}

class PaymentScheduleDeleteResponseState extends SalesOrderStates {
  final String response;

  PaymentScheduleDeleteResponseState(this.response);
}

class PaymentScheduleEditResponseState extends SalesOrderStates {
  final String response;

  PaymentScheduleEditResponseState(this.response);
}

class PaymentScheduleDeleteAllResponseState extends SalesOrderStates {
  final String response;

  PaymentScheduleDeleteAllResponseState(this.response);
}
//SaleOrderHeaderSaveResponse

class SaleOrderHeaderSaveResponseState extends SalesOrderStates {
  int pkID;
  final SaleOrderHeaderSaveResponse response;
  BuildContext context;
  SaleOrderHeaderSaveResponseState(this.context, this.pkID, this.response);
}

class SaleOrderProductSaveResponseState extends SalesOrderStates {
  final SaleOrderProductSaveResponse response;

  SaleOrderProductSaveResponseState(this.response);
}

class SaleOrderProductDeleteResponseState extends SalesOrderStates {
  final SaleOrderProductDeleteResponse response;

  SaleOrderProductDeleteResponseState(this.response);
}

class UserMenuRightsResponseState extends SalesOrderStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class QuotationOtherCharge1ListResponseState extends SalesOrderStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge1ListResponseState(
      this.quotationOtherChargesListResponse);
}

class GetGenericAddditionalChargesState extends SalesOrderStates {
  final GenericAddditionalCharges quotationOtherChargesListResponse;

  GetGenericAddditionalChargesState(this.quotationOtherChargesListResponse);
}

class QuotationOtherChargeListResponseState extends SalesOrderStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  String headerDiscountController;
  QuotationOtherChargeListResponseState(
      this.headerDiscountController, this.quotationOtherChargesListResponse);
}

class GetQuotationProductListState extends SalesOrderStates {
  final List<SalesOrderTable> response;

  GetQuotationProductListState(this.response);
}

class InsertProductSucessResponseState extends SalesOrderStates {
  final String response;

  InsertProductSucessResponseState(this.response);
}

class DeleteALLQuotationProductTableState extends SalesOrderStates {
  final String response;

  DeleteALLQuotationProductTableState(this.response);
}

class AddGenericAddditionalChargesState extends SalesOrderStates {
  String response;
  AddGenericAddditionalChargesState(this.response);
}

class DeleteAllGenericAddditionalChargesState extends SalesOrderStates {
  String response;
  DeleteAllGenericAddditionalChargesState(this.response);
}
//

class GetQuotationSpecificationTableState extends SalesOrderStates {
  final List<QuotationSpecificationTable> response;

  GetQuotationSpecificationTableState(this.response);
}

class SpecificationListResponseState extends SalesOrderStates {
  final SpecificationListResponse response;

  SpecificationListResponseState(this.response);
}

class GenericOtherCharge1ListResponseState extends SalesOrderStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  GenericOtherCharge1ListResponseState(this.quotationOtherChargesListResponse);
}

class SalesOrderDeleteResponseState extends SalesOrderStates {
  final SalesOrderDeleteResponse salesOrderDeleteResponse;

  SalesOrderDeleteResponseState(this.salesOrderDeleteResponse);
}

class SOCurrencyListResponseState extends SalesOrderStates {
  final SOCurrencyListResponse response;

  SOCurrencyListResponseState(this.response);
}

class SaveEmailContentResponseState extends SalesOrderStates {
  final SaveEmailContentResponse response;

  SaveEmailContentResponseState(this.response);
}

class SOProductOneDeleteState extends SalesOrderStates {
  final String response;

  SOProductOneDeleteState(this.response);
}

///SO Assembly offline DB CRUD
///
class SOAssemblyTableListState extends SalesOrderStates {
  final List<SOAssemblyTable> response;

  SOAssemblyTableListState(this.response);
}

class SOAssemblyTableInsertState extends SalesOrderStates {
  BuildContext context;
  String response;
  SOAssemblyTableInsertState(this.context, this.response);
}

class SOAssemblyTableUpdateState extends SalesOrderStates {
  BuildContext context;
  String response;
  SOAssemblyTableUpdateState(this.context, this.response);
}

class SOAssemblyTableOneItemDeleteState extends SalesOrderStates {
  String response;
  SOAssemblyTableOneItemDeleteState(this.response);
}

class SOAssemblyTableDeleteALLState extends SalesOrderStates {
  String response;
  SOAssemblyTableDeleteALLState(this.response);
}

class SalesTargetListCallResponseState extends SalesOrderStates {
  final SalesTargetListResponse response;
  final int newPage;
  SalesTargetListCallResponseState(this.response, this.newPage);
}

class SOShipmentlistResponseState extends SalesOrderStates {
  SOShipmentlistResponse response;
  SalesOrderDetails salesOrderDetails;
  SOExportListResponse soExportListResponse;
  SOShipmentlistResponseState(
      this.response, this.salesOrderDetails, this.soExportListResponse);
}

class SOShipmentSaveResponseState extends SalesOrderStates {
  SOShipmentSaveResponse response;
  SOShipmentSaveResponseState(this.response);
}

class SOShipmentDeleteResponseState extends SalesOrderStates {
  String response;
  SOShipmentDeleteResponseState(this.response);
}
