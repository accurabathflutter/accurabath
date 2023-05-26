part of 'quotation_bloc.dart';

@immutable
abstract class QuotationEvents {}

///all events of AuthenticationEvents
class QuotationListCallEvent extends QuotationEvents {
  final int pageNo;
  final QuotationListApiRequest quotationListApiRequest;
  QuotationListCallEvent(this.pageNo, this.quotationListApiRequest);
}

class SearchQuotationListByNameCallEvent extends QuotationEvents {
  final SearchQuotationListByNameRequest request;

  SearchQuotationListByNameCallEvent(this.request);
}

class SearchQuotationListByNumberCallEvent extends QuotationEvents {
  final int pkID;
  final SearchQuotationListByNumberRequest request;

  SearchQuotationListByNumberCallEvent(this.pkID, this.request);
}

class QuotationPDFGenerateCallEvent extends QuotationEvents {
  final QuotationPDFGenerateRequest request;

  QuotationPDFGenerateCallEvent(this.request);
}

class SearchQuotationCustomerListByNameCallEvent extends QuotationEvents {
  final CustomerLabelValueRequest request;

  SearchQuotationCustomerListByNameCallEvent(this.request);
}

class QuotationNoToProductListCallEvent extends QuotationEvents {
  final QuotationNoToProductListRequest request;
  int StateCode;
  QuotationNoToProductListCallEvent(this.StateCode, this.request);
}

class QuotationSpecificationCallEvent extends QuotationEvents {
  String ModuleName;
  final SpecificationListRequest request;

  QuotationSpecificationCallEvent(this.ModuleName, this.request);
}

class QuotationKindAttListCallEvent extends QuotationEvents {
  final QuotationKindAttListApiRequest request;

  QuotationKindAttListCallEvent(this.request);
}

class QuotationProjectListCallEvent extends QuotationEvents {
  final QuotationProjectListRequest request;

  QuotationProjectListCallEvent(this.request);
}

class QuotationTermsConditionCallEvent extends QuotationEvents {
  final QuotationTermsConditionRequest request;

  QuotationTermsConditionCallEvent(this.request);
}

class CustIdToInqListCallEvent extends QuotationEvents {
  final CustIdToInqListRequest request;

  CustIdToInqListCallEvent(this.request);
}

class InqNoToProductListCallEvent extends QuotationEvents {
  final InquiryNoToProductListRequest request;

  InqNoToProductListCallEvent(this.request);
}

class InquiryProductSearchNameWithStateCodeCallEvent extends QuotationEvents {
  int ProductID;
  String ProductName;
  double Quantity;
  double UnitRate;
  final InquiryProductSearchRequest inquiryProductSearchRequest;

  InquiryProductSearchNameWithStateCodeCallEvent(
      this.ProductID,
      this.ProductName,
      this.Quantity,
      this.UnitRate,
      this.inquiryProductSearchRequest);
}

class QuotationHeaderSaveCallEvent extends QuotationEvents {
  int pkID;
  BuildContext context;
  final QuotationHeaderSaveRequest request;

  QuotationHeaderSaveCallEvent(this.context, this.pkID, this.request);
}

class QuotationProductSaveCallEvent extends QuotationEvents {
  String QT_No;
  BuildContext context;
  final List<QuotationTable> quotationProductModel;
  QuotationProductSaveCallEvent(
      this.context, this.QT_No, this.quotationProductModel);
}

class QuotationProductSpecificationSaveCallEvent extends QuotationEvents {
  final List<QTSpecSaveRequest> qTSpecSaveRequest;
  QuotationProductSpecificationSaveCallEvent(this.qTSpecSaveRequest);
}

class QuotationDeleteProductCallEvent extends QuotationEvents {
  String qt_No;
  final QuotationProductDeleteRequest request;

  QuotationDeleteProductCallEvent(this.qt_No, this.request);
}

class QuotationDeleteRequestCallEvent extends QuotationEvents {
  BuildContext context;
  final int pkID;

  final QuotationDeleteRequest quotationDeleteRequest;

  QuotationDeleteRequestCallEvent(
      this.context, this.pkID, this.quotationDeleteRequest);
}

class QuotationOtherChargeCallEvent extends QuotationEvents {
  String CompanyID;
  String headerDiscountController;
  final QuotationOtherChargesListRequest request;

  QuotationOtherChargeCallEvent(
      this.headerDiscountController, this.CompanyID, this.request);
}

class QuotationBankDropDownCallEvent extends QuotationEvents {
  final BankDropDownRequest request;

  QuotationBankDropDownCallEvent(this.request);
}

class SearchCustomerListByNumberCallEvent extends QuotationEvents {
  final CustomerSearchByIdRequest request;

  SearchCustomerListByNumberCallEvent(this.request);
}

class FCMNotificationRequestEvent extends QuotationEvents {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestEvent(this.request123);
}

class GetReportToTokenRequestEvent extends QuotationEvents {
  final GetReportToTokenRequest request;

  GetReportToTokenRequestEvent(this.request);
}

class QT_OtherChargeDeleteRequestEvent extends QuotationEvents {
  QT_OtherChargeDeleteRequestEvent();
}

class QT_OtherChargeInsertRequestEvent extends QuotationEvents {
  final QT_OtherChargeTable qt_otherChargeTable;
  QT_OtherChargeInsertRequestEvent(this.qt_otherChargeTable);
}

class QuotationEmailContentRequestEvent extends QuotationEvents {
  final QuotationEmailContentRequest request;
  QuotationEmailContentRequestEvent(this.request);
}

class SaveEmailContentRequestEvent extends QuotationEvents {
  final SaveEmailContentRequest request;
  SaveEmailContentRequestEvent(this.request);
}

class QuotationOtherCharge1CallEvent extends QuotationEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  QuotationOtherCharge1CallEvent(this.CompanyID, this.request);
}

class QuotationOtherCharge2CallEvent extends QuotationEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  QuotationOtherCharge2CallEvent(this.CompanyID, this.request);
}

class QuotationOtherCharge3CallEvent extends QuotationEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  QuotationOtherCharge3CallEvent(this.CompanyID, this.request);
}

class QuotationOtherCharge4CallEvent extends QuotationEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  QuotationOtherCharge4CallEvent(this.CompanyID, this.request);
}

class QuotationOtherCharge5CallEvent extends QuotationEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  QuotationOtherCharge5CallEvent(this.CompanyID, this.request);
}

class InsertQuotationSpecificationTableEvent extends QuotationEvents {
  final QuotationSpecificationTable quotationSpecificationTable;
  InsertQuotationSpecificationTableEvent(this.quotationSpecificationTable);
}

class UpdateQuotationSpecificationTableEvent extends QuotationEvents {
  BuildContext context;
  final QuotationSpecificationTable quotationSpecificationTable;
  UpdateQuotationSpecificationTableEvent(
      this.context, this.quotationSpecificationTable);
}

class GetQuotationSpecificationTableEvent extends QuotationEvents {
  //final FCMNotificationRequest request;
  GetQuotationSpecificationTableEvent();
}

class GetQuotationSpecificationwithQTNOTableEvent extends QuotationEvents {
  //final FCMNotificationRequest request;
  String QTNo;
  GetQuotationSpecificationwithQTNOTableEvent(this.QTNo);
}

class DeleteQuotationSpecificationTableEvent extends QuotationEvents {
  //final FCMNotificationRequest request;

  int id;
  DeleteQuotationSpecificationTableEvent(this.id);
}

class DeleteQuotationSpecificationByFinishProductIDEvent
    extends QuotationEvents {
  //final FCMNotificationRequest request;

  int id;
  DeleteQuotationSpecificationByFinishProductIDEvent(this.id);
}

//

class DeleteAllQuotationSpecificationTableEvent extends QuotationEvents {
  //final FCMNotificationRequest request;
  DeleteAllQuotationSpecificationTableEvent();
}

class GetQuotationProductListEvent extends QuotationEvents {
  //final FCMNotificationRequest request;
  GetQuotationProductListEvent();
}

class QuotationOneProductDeleteEvent extends QuotationEvents {
  //final FCMNotificationRequest request;

  int tableid;
  QuotationOneProductDeleteEvent(this.tableid);
}

class InsertProductEvent extends QuotationEvents {
  List<QuotationTable> quotationTable;
  InsertProductEvent(this.quotationTable);
}

class DeleteAllQuotationProductEvent extends QuotationEvents {
  //final FCMNotificationRequest request;
  DeleteAllQuotationProductEvent();
}

class UserMenuRightsRequestEvent extends QuotationEvents {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}

class GenericOtherChargeCallEvent extends QuotationEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  GenericOtherChargeCallEvent(this.CompanyID, this.request);
}

//GenericAddditionalCharges

class GetGenericAddditionalChargesEvent extends QuotationEvents {
  GetGenericAddditionalChargesEvent();
}

class AddGenericAddditionalChargesEvent extends QuotationEvents {
  final GenericAddditionalCharges genericAddditionalCharges;

  AddGenericAddditionalChargesEvent(this.genericAddditionalCharges);
}

class DeleteGenericAddditionalChargesEvent extends QuotationEvents {
  DeleteGenericAddditionalChargesEvent();
}

class SOCurrencyListRequestEvent extends QuotationEvents {
  final SOCurrencyListRequest request;

  SOCurrencyListRequestEvent(this.request);
}

class FollowupTypeListByNameCallEvent extends QuotationEvents {
  final FollowupTypeListRequest followupTypeListRequest;

  FollowupTypeListByNameCallEvent(this.followupTypeListRequest);
}

class QTAssemblyTableListEvent extends QuotationEvents {
  String finishProductID;
  QTAssemblyTableListEvent(this.finishProductID);
}

class QTAssemblyTableInsertEvent extends QuotationEvents {
  BuildContext context;
  final QTAssemblyTable qtAssemblyTable;

  QTAssemblyTableInsertEvent(this.context, this.qtAssemblyTable);
}

class QTAssemblyTableUpdateEvent extends QuotationEvents {
  BuildContext context;
  final QTAssemblyTable qtAssemblyTable;
  QTAssemblyTableUpdateEvent(this.context, this.qtAssemblyTable);
}

class QTAssemblyTableOneItemDeleteEvent extends QuotationEvents {
  int tableid;
  QTAssemblyTableOneItemDeleteEvent(this.tableid);
}

class QTAssemblyTableALLDeleteEvent extends QuotationEvents {
  QTAssemblyTableALLDeleteEvent();
}

class InquiryProductSearchNameCallEvent extends QuotationEvents {
  final InquiryProductSearchRequest inquiryProductSearchRequest;

  InquiryProductSearchNameCallEvent(this.inquiryProductSearchRequest);
}

class QuotationOrganazationListRequestEvent extends QuotationEvents {
  final QuotationOrganazationListRequest quotationOrganazationListRequest;

  QuotationOrganazationListRequestEvent(this.quotationOrganazationListRequest);
}
