part of 'salesbill_bloc.dart';

@immutable
abstract class SalesBillEvents {}

///all events of AuthenticationEvents
class SalesBillListCallEvent extends SalesBillEvents {
  final int pageNo;
  final SalesBillListRequest salesBillListRequest;
  SalesBillListCallEvent(this.pageNo, this.salesBillListRequest);
}

class SearchSaleBillListByNameCallEvent extends SalesBillEvents {
  final SearchSalesBillListByNameRequest request;

  SearchSaleBillListByNameCallEvent(this.request);
}

class SearchCustomerListByNumberCallEvent extends SalesBillEvents {
  final CustomerSearchByIdRequest request;

  SearchCustomerListByNumberCallEvent(this.request);
}

/*
class SearchQuotationListByNameCallEvent extends QuotationEvents {
  final SearchQuotationListByNameRequest request;

  SearchQuotationListByNameCallEvent(this.request);
}

class SearchQuotationListByNumberCallEvent extends QuotationEvents {
  final int pkID;
  final SearchQuotationListByNumberRequest request;

  SearchQuotationListByNumberCallEvent(this.pkID,this.request);
}*/
class SalesBillPDFGenerateCallEvent extends SalesBillEvents {
  final SalesBillPDFGenerateRequest request;

  SalesBillPDFGenerateCallEvent(this.request);
}

class SalesBillSearchByNameRequestCallEvent extends SalesBillEvents {
  final SalesBillSearchByNameRequest request;

  SalesBillSearchByNameRequestCallEvent(this.request);
}

class SalesBillSearchByIdRequestCallEvent extends SalesBillEvents {
  int custID;
  final SalesBillSearchByIdRequest request;

  SalesBillSearchByIdRequestCallEvent(this.custID, this.request);
}

class QuotationBankDropDownCallEvent extends SalesBillEvents {
  final BankDropDownRequest request;

  QuotationBankDropDownCallEvent(this.request);
}

class QuotationTermsConditionCallEvent extends SalesBillEvents {
  final QuotationTermsConditionRequest request;
  QuotationTermsConditionCallEvent(this.request);
}

class SalesBillEmailContentRequestEvent extends SalesBillEvents {
  final SalesBillEmailContentRequest request;
  SalesBillEmailContentRequestEvent(this.request);
}

class SaleBill_INQ_QT_SO_NO_ListRequestEvent extends SalesBillEvents {
  final SaleBill_INQ_QT_SO_NO_ListRequest request;
  SaleBill_INQ_QT_SO_NO_ListRequestEvent(this.request);
}

class UserMenuRightsRequestEvent extends SalesBillEvents {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}

class MultiNoToProductDetailsRequestEvent extends SalesBillEvents {
  String FromWhichScreen;
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsRequestEvent(this.FromWhichScreen, this.request);
}

class GetQuotationProductListEvent extends SalesBillEvents {
  //final FCMNotificationRequest request;
  GetQuotationProductListEvent();
}

class GetQuotationSpecificationTableEvent extends SalesBillEvents {
  //final FCMNotificationRequest request;
  GetQuotationSpecificationTableEvent();
}

class QuotationOtherCharge1CallEvent extends SalesBillEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  QuotationOtherCharge1CallEvent(this.CompanyID, this.request);
}

class GetGenericAddditionalChargesEvent extends SalesBillEvents {
  GetGenericAddditionalChargesEvent();
}

class QuotationOtherChargeCallEvent extends SalesBillEvents {
  String CompanyID;
  String headerDiscountController;
  final QuotationOtherChargesListRequest request;

  QuotationOtherChargeCallEvent(
      this.headerDiscountController, this.CompanyID, this.request);
}

class InsertProductEvent extends SalesBillEvents {
  List<SaleBillTable> quotationTable;
  InsertProductEvent(this.quotationTable);
}

class DeleteAllQuotationProductEvent extends SalesBillEvents {
  //final FCMNotificationRequest request;
  DeleteAllQuotationProductEvent();
}

class AddGenericAddditionalChargesEvent extends SalesBillEvents {
  final GenericAddditionalCharges genericAddditionalCharges;

  AddGenericAddditionalChargesEvent(this.genericAddditionalCharges);
}

class DeleteGenericAddditionalChargesEvent extends SalesBillEvents {
  DeleteGenericAddditionalChargesEvent();
}

class SBHeaderSaveRequestEvent extends SalesBillEvents {
  BuildContext context;
  int pkId;

  SBHeaderSaveRequest sbHeaderSaveRequest;
  SBExportSaveRequest sbExportSaveRequest;
  SbAllProductDeleteRequest sbAllProductDeleteRequest;
  SBHeaderSaveRequestEvent(this.context, this.pkId, this.sbHeaderSaveRequest,
      this.sbExportSaveRequest, this.sbAllProductDeleteRequest);
}

class GenericOtherChargeCallEvent extends SalesBillEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  GenericOtherChargeCallEvent(this.CompanyID, this.request);
}

class SBProductSaveRequestEvent extends SalesBillEvents {
  BuildContext context;
  String InvoiceNo;
  List<SBProductSaveRequest> arrsbProductsaveRequest;

  SBProductSaveRequestEvent(
      this.context, this.InvoiceNo, this.arrsbProductsaveRequest);
}

class SBProductOneDeleteEvent extends SalesBillEvents {
  final int tableId;

  SBProductOneDeleteEvent(this.tableId);
}

class SBExportListRequestEvent extends SalesBillEvents {
  final SBExportListRequest request;

  SBExportListRequestEvent(this.request);
}

class SBExportSaveRequestEvent extends SalesBillEvents {
  final SBExportSaveRequest request;

  SBExportSaveRequestEvent(this.request);
}

///Asembly OfflineDB CRUD
///
class SBAssemblyTableListEvent extends SalesBillEvents {
  String finishProductID;
  SBAssemblyTableListEvent(this.finishProductID);
}

class SBAssemblyTableInsertEvent extends SalesBillEvents {
  BuildContext context;
  final SBAssemblyTable sbAssemblyTable;

  SBAssemblyTableInsertEvent(this.context, this.sbAssemblyTable);
}

class SBAssemblyTableUpdateEvent extends SalesBillEvents {
  BuildContext context;
  final SBAssemblyTable sbAssemblyTable;
  SBAssemblyTableUpdateEvent(this.context, this.sbAssemblyTable);
}

class SBAssemblyTableOneItemDeleteEvent extends SalesBillEvents {
  int tableid;
  SBAssemblyTableOneItemDeleteEvent(this.tableid);
}

class SBAssemblyTableALLDeleteEvent extends SalesBillEvents {
  SBAssemblyTableALLDeleteEvent();
}

class SBDeleteRequestEvent extends SalesBillEvents {
  String headerpkID;
  final SBDeleteRequest request;
  SBDeleteRequestEvent(this.headerpkID, this.request);
}

class SOCurrencyListRequestEvent extends SalesBillEvents {
  final SOCurrencyListRequest request;

  SOCurrencyListRequestEvent(this.request);
}

class HeaderToDetailsRequestEvent extends SalesBillEvents {
  int hedarpkID;
  final HeaderToDetailsRequest request;

  HeaderToDetailsRequestEvent(this.hedarpkID, this.request);
}

class QuotationProjectListCallEvent extends SalesBillEvents {
  final QuotationProjectListRequest request;

  QuotationProjectListCallEvent(this.request);
}

class SbAllProductDeleteRequestCallEvent extends SalesBillEvents {
  final SbAllProductDeleteRequest request;

  SbAllProductDeleteRequestCallEvent(this.request);
}
