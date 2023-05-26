part of 'salesbill_bloc.dart';

abstract class SalesBillStates extends BaseStates {
  const SalesBillStates();
}

///all states of AuthenticationStates
class SalesBillInitialState extends SalesBillStates {}

class SalesBillListCallResponseState extends SalesBillStates {
  final SalesBillListResponse response;
  final int newPage;
  SalesBillListCallResponseState(this.response, this.newPage);
}

class SearchSalesBillListByNameCallResponseState extends SalesBillStates {
  final SearchSalesBillListResponse response;

  SearchSalesBillListByNameCallResponseState(this.response);
}

class SalesBillPDFGenerateResponseState extends SalesBillStates {
  final SalesBillPDFGenerateResponse response;

  SalesBillPDFGenerateResponseState(this.response);
}

class SalesBillSearchByNameResponseState extends SalesBillStates {
  final SalesBillSearchByNameResponse response;

  SalesBillSearchByNameResponseState(this.response);
}

class SalesBillSearchByIDResponseState extends SalesBillStates {
  final SalesBillListResponse response;

  SalesBillSearchByIDResponseState(this.response);
}

class QuotationBankDropDownResponseState extends SalesBillStates {
  final BankDorpDownResponse response;

  QuotationBankDropDownResponseState(this.response);
}

class QuotationTermsCondtionResponseState extends SalesBillStates {
  final QuotationTermsCondtionResponse response;

  QuotationTermsCondtionResponseState(this.response);
}

class SaleBillEmailContentResponseState extends SalesBillStates {
  final SaleBillEmailContentResponse response;

  SaleBillEmailContentResponseState(this.response);
}

class SalesBill_INQ_QT_SO_NO_ListResponseState extends SalesBillStates {
  final SalesBill_INQ_QT_SO_NO_ListResponse response;
  SalesBill_INQ_QT_SO_NO_ListResponseState(this.response);
}

class SalesBill_QT_ResponseState extends SalesBillStates {
  final SalesBill_INQ_QT_SO_NO_ListResponse response;
  SalesBill_QT_ResponseState(this.response);
}

class SalesBill_SO_ListResponseState extends SalesBillStates {
  final SalesBill_INQ_QT_SO_NO_ListResponse response;
  SalesBill_SO_ListResponseState(this.response);
}

class SearchCustomerListByNumberCallResponseState extends SalesBillStates {
  final CustomerDetailsResponse response;

  SearchCustomerListByNumberCallResponseState(this.response);
}

class UserMenuRightsResponseState extends SalesBillStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class MultiNoToProductDetailsResponseState extends SalesBillStates {
  String FetchFromWhichScreen;
  final MultiNoToProductDetailsResponse response;
  MultiNoToProductDetailsResponseState(
      this.FetchFromWhichScreen, this.response);
}

class GetQuotationProductListState extends SalesBillStates {
  final List<SaleBillTable> response;

  GetQuotationProductListState(this.response);
}

class GetQuotationSpecificationTableState extends SalesBillStates {
  final List<QuotationSpecificationTable> response;

  GetQuotationSpecificationTableState(this.response);
}

class QuotationOtherCharge1ListResponseState extends SalesBillStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge1ListResponseState(
      this.quotationOtherChargesListResponse);
}

class GetGenericAddditionalChargesState extends SalesBillStates {
  final GenericAddditionalCharges quotationOtherChargesListResponse;

  GetGenericAddditionalChargesState(this.quotationOtherChargesListResponse);
}

class QuotationOtherChargeListResponseState extends SalesBillStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  String headerDiscountController;
  QuotationOtherChargeListResponseState(
      this.headerDiscountController, this.quotationOtherChargesListResponse);
}

class InsertProductSucessResponseState extends SalesBillStates {
  final String response;

  InsertProductSucessResponseState(this.response);
}

class DeleteALLQuotationProductTableState extends SalesBillStates {
  final String response;

  DeleteALLQuotationProductTableState(this.response);
}

class AddGenericAddditionalChargesState extends SalesBillStates {
  String response;
  AddGenericAddditionalChargesState(this.response);
}

class DeleteAllGenericAddditionalChargesState extends SalesBillStates {
  String response;
  DeleteAllGenericAddditionalChargesState(this.response);
}

class SBHeaderSaveResponseState extends SalesBillStates {
  BuildContext context;
  SBHeaderSaveResponse sbHeaderSaveResponse;

  SBHeaderSaveResponseState(this.context, this.sbHeaderSaveResponse);
}

class GenericOtherCharge1ListResponseState extends SalesBillStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  GenericOtherCharge1ListResponseState(this.quotationOtherChargesListResponse);
}

class SBProductSaveResponseState extends SalesBillStates {
  BuildContext context;

  SBProductSaveResponse sbProductSaveResponse;

  SBProductSaveResponseState(this.context, this.sbProductSaveResponse);
}

//

/*

class SearchQuotationListByNameCallResponseState extends QuotationStates {
  final SearchQuotationListResponse response;

  SearchQuotationListByNameCallResponseState(this.response);
}

class SearchQuotationListByNumberCallResponseState extends QuotationStates {
  final QuotationListResponse response;

  SearchQuotationListByNumberCallResponseState(this.response);
}*/
class SBProductOneDeleteState extends SalesBillStates {
  final String response;

  SBProductOneDeleteState(this.response);
}

class SBExportListResponseState extends SalesBillStates {
  final SBExportListResponse response;

  SBExportListResponseState(this.response);
}

class SBExportSaveResponseState extends SalesBillStates {
  final SBExportSaveResponse response;

  SBExportSaveResponseState(this.response);
}

///SO Assembly offline DB CRUD
///
class SBAssemblyTableListState extends SalesBillStates {
  final List<SBAssemblyTable> response;

  SBAssemblyTableListState(this.response);
}

class SBAssemblyTableInsertState extends SalesBillStates {
  BuildContext context;
  String response;
  SBAssemblyTableInsertState(this.context, this.response);
}

class SBAssemblyTableUpdateState extends SalesBillStates {
  BuildContext context;
  String response;
  SBAssemblyTableUpdateState(this.context, this.response);
}

class SBAssemblyTableOneItemDeleteState extends SalesBillStates {
  String response;
  SBAssemblyTableOneItemDeleteState(this.response);
}

class SBAssemblyTableDeleteALLState extends SalesBillStates {
  String response;
  SBAssemblyTableDeleteALLState(this.response);
}

class SBDeleteResponseState extends SalesBillStates {
  SBDeleteResponse response;
  SBDeleteResponseState(this.response);
}

class SOCurrencyListResponseState extends SalesBillStates {
  final SOCurrencyListResponse response;

  SOCurrencyListResponseState(this.response);
}

class HeaderToDetailsResponseState extends SalesBillStates {
  final HeaderToDetailsResponse response;

  HeaderToDetailsResponseState(this.response);
}

class QuotationProjectListResponseState extends SalesBillStates {
  final QuotationProjectListResponse response;

  QuotationProjectListResponseState(this.response);
}

class SBAllProductDeleteState extends SalesBillStates {
  String response;
  SBAllProductDeleteState(this.response);
}
//
