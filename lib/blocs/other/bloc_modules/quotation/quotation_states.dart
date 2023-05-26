part of 'quotation_bloc.dart';

abstract class QuotationStates extends BaseStates {
  const QuotationStates();
}

///all states of AuthenticationStates
class QuotationInitialState extends QuotationStates {}

class QuotationListCallResponseState extends QuotationStates {
  final QuotationListResponse response;
  final int newPage;
  QuotationListCallResponseState(this.response, this.newPage);
}

class SearchQuotationListByNameCallResponseState extends QuotationStates {
  final SearchQuotationListResponse response;

  SearchQuotationListByNameCallResponseState(this.response);
}

class SearchQuotationListByNumberCallResponseState extends QuotationStates {
  final QuotationListResponse response;

  SearchQuotationListByNumberCallResponseState(this.response);
}

class QuotationPDFGenerateResponseState extends QuotationStates {
  final QuotationPDFGenerateResponse response;

  QuotationPDFGenerateResponseState(this.response);
}

class QuotationCustomerListByNameCallResponseState extends QuotationStates {
  final CustomerLabelvalueRsponse response;

  QuotationCustomerListByNameCallResponseState(this.response);
}

class QuotationNoToProductListCallResponseState extends QuotationStates {
  final QuotationNoToProductResponse response;
  int StateCode;
  QuotationNoToProductListCallResponseState(this.StateCode, this.response);
}

class SpecificationListResponseState extends QuotationStates {
  final SpecificationListResponse response;

  SpecificationListResponseState(this.response);
}

class QuotationKindAttListResponseState extends QuotationStates {
  final QuotationKindAttListResponse response;

  QuotationKindAttListResponseState(this.response);
}

class QuotationProjectListResponseState extends QuotationStates {
  final QuotationProjectListResponse response;

  QuotationProjectListResponseState(this.response);
}

class QuotationTermsCondtionResponseState extends QuotationStates {
  final QuotationTermsCondtionResponse response;

  QuotationTermsCondtionResponseState(this.response);
}

class CustIdToInqListResponseState extends QuotationStates {
  final CustIdToInqListResponse response;

  CustIdToInqListResponseState(this.response);
}

class InqNoToProductListResponseState extends QuotationStates {
  final InqNoToProductListResponse response;

  InqNoToProductListResponseState(this.response);
}

class InquiryProductSearchByStateCodeResponseState extends QuotationStates {
  int ProductID;
  String ProductName;
  double Quantity;
  double UnitRate;
  final InquiryProductSearchResponse inquiryProductSearchResponse;
  InquiryProductSearchByStateCodeResponseState(this.ProductID, this.ProductName,
      this.Quantity, this.UnitRate, this.inquiryProductSearchResponse);
}

class QuotationHeaderSaveResponseState extends QuotationStates {
  int pkID;
  final QuotationSaveHeaderResponse response;
  BuildContext context;
  QuotationHeaderSaveResponseState(this.context, this.pkID, this.response);
}

class QuotationProductSaveResponseState extends QuotationStates {
  final QuotationProductSaveResponse quotationProductSaveResponse;
  BuildContext context;
  final List<QuotationTable> quotationProductModel;

  String RetrunQtNo;
  QuotationProductSaveResponseState(
      this.context,
      this.quotationProductSaveResponse,
      this.quotationProductModel,
      this.RetrunQtNo);
}

class QTSpecSaveResponseState extends QuotationStates {
  final QTSpecSaveResponse qTSpecSaveResponse;

  QTSpecSaveResponseState(this.qTSpecSaveResponse);
}
//QTSpecSaveResponse

class QuotationProductDeleteResponseState extends QuotationStates {
  final QuotationProductDeleteResponse response;

  QuotationProductDeleteResponseState(this.response);
}

class QuotationDeleteCallResponseState extends QuotationStates {
  BuildContext context;
  final QuotationDeleteResponse quotationDeleteResponse;

  QuotationDeleteCallResponseState(this.context, this.quotationDeleteResponse);
}

class QuotationOtherChargeListResponseState extends QuotationStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  String headerDiscountController;
  QuotationOtherChargeListResponseState(
      this.headerDiscountController, this.quotationOtherChargesListResponse);
}

class QuotationBankDropDownResponseState extends QuotationStates {
  final BankDorpDownResponse response;

  QuotationBankDropDownResponseState(this.response);
}

class SearchCustomerListByNumberCallResponseState extends QuotationStates {
  final CustomerDetailsResponse response;

  SearchCustomerListByNumberCallResponseState(this.response);
}

class FCMNotificationResponseState extends QuotationStates {
  final FCMNotificationResponse response;

  FCMNotificationResponseState(this.response);
}

class GetReportToTokenResponseState extends QuotationStates {
  final GetReportToTokenResponse response;

  GetReportToTokenResponseState(this.response);
}

class QT_OtherChargeDeleteResponseState extends QuotationStates {
  final String response;

  QT_OtherChargeDeleteResponseState(this.response);
}

class QT_OtherChargeInsertResponseState extends QuotationStates {
  final String response;

  QT_OtherChargeInsertResponseState(this.response);
}

class QuotationEmailContentResponseState extends QuotationStates {
  final QuotationEmailContentResponse response;

  QuotationEmailContentResponseState(this.response);
}

class SaveEmailContentResponseState extends QuotationStates {
  final SaveEmailContentResponse response;

  SaveEmailContentResponseState(this.response);
}

class QuotationOtherCharge1ListResponseState extends QuotationStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge1ListResponseState(
      this.quotationOtherChargesListResponse);
}

class QuotationOtherCharge2ListResponseState extends QuotationStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge2ListResponseState(
      this.quotationOtherChargesListResponse);
}

class QuotationOtherCharge3ListResponseState extends QuotationStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge3ListResponseState(
      this.quotationOtherChargesListResponse);
}

class QuotationOtherCharge4ListResponseState extends QuotationStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge4ListResponseState(
      this.quotationOtherChargesListResponse);
}

class QuotationOtherCharge5ListResponseState extends QuotationStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge5ListResponseState(
      this.quotationOtherChargesListResponse);
}

class InsertQuotationSpecificationTableState extends QuotationStates {
  final String response;

  InsertQuotationSpecificationTableState(this.response);
}

class UpdateQuotationSpecificationTableState extends QuotationStates {
  BuildContext context;
  final String response;

  UpdateQuotationSpecificationTableState(this.context, this.response);
}

class GetQuotationSpecificationTableState extends QuotationStates {
  final List<QuotationSpecificationTable> response;

  GetQuotationSpecificationTableState(this.response);
}

class GetQuotationSpecificationQTnoTableState extends QuotationStates {
  final List<QuotationSpecificationTable> response;

  String QtNo;
  GetQuotationSpecificationQTnoTableState(this.response, this.QtNo);
}

class DeleteQuotationSpecificationTableState extends QuotationStates {
  final String response;

  DeleteQuotationSpecificationTableState(this.response);
}

class DeleteALLQuotationSpecificationTableState extends QuotationStates {
  final String response;

  DeleteALLQuotationSpecificationTableState(this.response);
}

class GetQuotationProductListState extends QuotationStates {
  final List<QuotationTable> response;

  GetQuotationProductListState(this.response);
}

class QuotationOneProductDeleteState extends QuotationStates {
  final String response;

  QuotationOneProductDeleteState(this.response);
}

class InsertProductSucessResponseState extends QuotationStates {
  final String response;

  InsertProductSucessResponseState(this.response);
}

class DeleteALLQuotationProductTableState extends QuotationStates {
  final String response;

  DeleteALLQuotationProductTableState(this.response);
}

class UserMenuRightsResponseState extends QuotationStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class GenericOtherCharge1ListResponseState extends QuotationStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  GenericOtherCharge1ListResponseState(this.quotationOtherChargesListResponse);
}

class GetGenericAddditionalChargesState extends QuotationStates {
  final GenericAddditionalCharges quotationOtherChargesListResponse;

  GetGenericAddditionalChargesState(this.quotationOtherChargesListResponse);
}

class AddGenericAddditionalChargesState extends QuotationStates {
  String response;
  AddGenericAddditionalChargesState(this.response);
}

class DeleteAllGenericAddditionalChargesState extends QuotationStates {
  String response;
  DeleteAllGenericAddditionalChargesState(this.response);
}

class SOCurrencyListResponseState extends QuotationStates {
  final SOCurrencyListResponse response;

  SOCurrencyListResponseState(this.response);
}

class FollowupTypeListCallResponseState extends QuotationStates {
  final FollowupTypeListResponse followupTypeListResponse;

  FollowupTypeListCallResponseState(this.followupTypeListResponse);
}

class QTAssemblyTableListState extends QuotationStates {
  final List<QTAssemblyTable> response;

  QTAssemblyTableListState(this.response);
}

class QTAssemblyTableInsertState extends QuotationStates {
  BuildContext context;
  String response;
  QTAssemblyTableInsertState(this.context, this.response);
}

class QTAssemblyTableUpdateState extends QuotationStates {
  BuildContext context;
  String response;
  QTAssemblyTableUpdateState(this.context, this.response);
}

class QTAssemblyTableOneItemDeleteState extends QuotationStates {
  String response;
  QTAssemblyTableOneItemDeleteState(this.response);
}

class QTAssemblyTableDeleteALLState extends QuotationStates {
  String response;
  QTAssemblyTableDeleteALLState(this.response);
}

class InquiryProductSearchResponseState extends QuotationStates {
  final InquiryProductSearchResponse inquiryProductSearchResponse;
  InquiryProductSearchResponseState(this.inquiryProductSearchResponse);
}

class DeleteQuotationSpecificationByFinishProductIDState
    extends QuotationStates {
  String response;
  DeleteQuotationSpecificationByFinishProductIDState(this.response);
}

class QuotationOrganizationListResponseState extends QuotationStates {
  final QuotationOrganizationListResponse quotationOrganizationListResponse;
  QuotationOrganizationListResponseState(
      this.quotationOrganizationListResponse);
}
//
