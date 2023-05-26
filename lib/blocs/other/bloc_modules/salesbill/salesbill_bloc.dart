import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sales_bill_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sales_bill_search_by_name_request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesOrder/multi_no_to_product_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/bank_voucher/bank_drop_down_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/headerToDetailsRequest.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sales_bill_generate_pdf_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sales_bill_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_all_product_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_export_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_export_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_product_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/search_sale_bill_list_by_name_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/SaleBill/sale_bill_email_content_response.dart';
import 'package:for_practice_the_app/models/api_responses/SaleBill/sales_bill_INQ_QT_SO_NO_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/SaleBill/sales_bill_search_by_name_response.dart';
import 'package:for_practice_the_app/models/api_responses/SaleOrder/multi_no_to_product_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/bank_voucher/bank_drop_down_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_project_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_terms_condition_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/headerToDetailsResponse.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/sales_bill_generate_pdf_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/sales_bill_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/sb_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/sb_export_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/sb_export_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/sb_header_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/sb_product_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/search_sales_bill_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/so_currency_list_response.dart';
import 'package:for_practice_the_app/models/common/assembly/sb_assembly_table.dart';
import 'package:for_practice_the_app/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/sales_bill_table.dart';
import 'package:for_practice_the_app/models/common/specification/quotation/quotation_specification.dart';
import 'package:for_practice_the_app/repositories/repository.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';

part 'salebill_states.dart';
part 'salesbill_event.dart';

class SalesBillBloc extends Bloc<SalesBillEvents, SalesBillStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  SalesBillBloc(this.baseBloc) : super(SalesBillInitialState());

  @override
  Stream<SalesBillStates> mapEventToState(SalesBillEvents event) async* {
    /// sets state based on events
    if (event is SalesBillListCallEvent) {
      yield* _mapQuotationListCallEventToState(event);
    }
    /*if (event is SearchQuotationListByNameCallEvent) {
      yield* _mapSearchQuotationListByNameCallEventToState(event);
    }*/
    if (event is SearchSaleBillListByNameCallEvent) {
      yield* _mapSearchSaleBillListByNameCallEventToState(event);
    }

    if (event is SalesBillPDFGenerateCallEvent) {
      yield* _mapSalesBillPDFGenerateCallEventToState(event);
    }

    if (event is SalesBillSearchByIdRequestCallEvent) {
      yield* _mapSearchSaleBillListByIDCallEventToState(event);
    }
    if (event is QuotationBankDropDownCallEvent) {
      yield* _mapBankDropDownEventToState(event);
    }

    if (event is QuotationTermsConditionCallEvent) {
      yield* _mapQuotationTermsConditionEventToState(event);
    }

    if (event is SalesBillEmailContentRequestEvent) {
      yield* _mapSalesBillEmailContentEventState(event);
    }

    if (event is SaleBill_INQ_QT_SO_NO_ListRequestEvent) {
      yield* _mapSaleBill_INQ_QT_SO_NO_ListEventState(event);
    }
    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }

    if (event is MultiNoToProductDetailsRequestEvent) {
      yield* _mapMultiNoToProductDetailsRequestEventState(event);
    }
    if (event is GetQuotationProductListEvent) {
      yield* _mapGetQuotationProductListEventState(event);
    }

    if (event is GetQuotationSpecificationTableEvent) {
      yield* _mapGetQuotationSpecificationTableEventState(event);
    }

    if (event is QuotationOtherCharge1CallEvent) {
      yield* _mapQuotationOtherCharge1ListEventToState(event);
    }

    if (event is GetGenericAddditionalChargesEvent) {
      yield* _mapGetGenericAddditionalChargesEventToState(event);
    }

    if (event is QuotationOtherChargeCallEvent) {
      yield* _mapQuotationOtherChargeListEventToState(event);
    }

    if (event is InsertProductEvent) {
      yield* _map_InsertProductEventState(event);
    }

    if (event is DeleteAllQuotationProductEvent) {
      yield* _mapDeleteAllQuotationProductEventState(event);
    }

    if (event is AddGenericAddditionalChargesEvent) {
      yield* mapAddGeneric(event);
    }

    if (event is DeleteGenericAddditionalChargesEvent) {
      yield* _mapDeleteGenericAddditionalChargesEventToState(event);
    }

    if (event is SBHeaderSaveRequestEvent) {
      yield* _mapSBHeaderSaveRequestEventToState(event);
    }

    if (event is GenericOtherChargeCallEvent) {
      yield* _mapGenericOtherChargeCallEventToState(event);
    }

    if (event is SBProductSaveRequestEvent) {
      yield* _mapSBProductSaveRequestEventState(event);
    }
    if (event is SBProductOneDeleteEvent) {
      yield* _mapSBOneProductDeleteEventState(event);
    }

    if (event is SBExportListRequestEvent) {
      yield* _mapSBExportListRequestEventToState(event);
    }

    /*  if (event is SBExportSaveRequestEvent) {
      yield* _mapSBExportSaveRequestEventToState(event);
    }*/
    if (event is SBAssemblyTableListEvent) {
      yield* _mapSBAssemblyTableListEventState(event);
    }
    if (event is SBAssemblyTableInsertEvent) {
      yield* mapSBAssemblyTableInsertEventState(event);
    }
    if (event is SBAssemblyTableUpdateEvent) {
      yield* mapSBAssemblyTableUpdateEventState(event);
    }
    if (event is SBAssemblyTableOneItemDeleteEvent) {
      yield* _mapSBAssemblyTableOneItemDeleteEventToState(event);
    }
    if (event is SBAssemblyTableALLDeleteEvent) {
      yield* _mapSBAssemblyTableALLDeleteEventToState(event);
    }

    if (event is SBDeleteRequestEvent) {
      yield* _mapSBDeleteRequestEventToState(event);
    }

    if (event is SOCurrencyListRequestEvent) {
      yield* _mapSOCurrencyListRequestEventToState(event);
    }

    if (event is HeaderToDetailsRequestEvent) {
      yield* _mapHeaderToDetailsRequestEventToState(event);
    }

    if (event is QuotationProjectListCallEvent) {
      yield* _mapQuotationProjectListCallEventToState(event);
    }

    /* if (event is SbAllProductDeleteRequestCallEvent) {
      yield* _mapSbAllProductDeleteRequestCallEventToState(event);
    }*/
  }

  ///event functions to states implementation
  Stream<SalesBillStates> _mapQuotationListCallEventToState(
      SalesBillListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesBillListResponse response = await userRepository.getSalesBillList(
          event.pageNo, event.salesBillListRequest);
      yield SalesBillListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSearchSaleBillListByNameCallEventToState(
      SearchSaleBillListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SearchSalesBillListResponse response =
          await userRepository.getSalesBillListSearchByName(event.request);
      yield SearchSalesBillListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSearchSaleBillListByIDCallEventToState(
      SalesBillSearchByIdRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesBillListResponse response = await userRepository
          .getSalesBillSearchDetailsAPI(event.custID, event.request);
      yield SalesBillSearchByIDResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

/*  Stream<QuotationStates> _mapSearchQuotationListByNumberCallEventToState(
      SearchQuotationListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationListResponse response =
      await userRepository.getQuotationListSearchByNumber(event.pkID,event.request);
      yield SearchQuotationListByNumberCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSearchQuotationListByNameCallEventToState(
      SearchQuotationListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SearchQuotationListResponse response =
      await userRepository.getQuotationListSearchByName(event.request);
      yield SearchQuotationListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  Stream<SalesBillStates> _mapSalesBillPDFGenerateCallEventToState(
      SalesBillPDFGenerateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesBillPDFGenerateResponse response =
          await userRepository.getSalesBillPDFGenerate(event.request);
      yield SalesBillPDFGenerateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapBankDropDownEventToState(
      QuotationBankDropDownCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      BankDorpDownResponse response =
          await userRepository.getBankDropDown(event.request);
      yield QuotationBankDropDownResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapQuotationTermsConditionEventToState(
      QuotationTermsConditionCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationTermsCondtionResponse response =
          await userRepository.getQuotationTermConditionList(event.request);
      yield QuotationTermsCondtionResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSalesBillEmailContentEventState(
      SalesBillEmailContentRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleBillEmailContentResponse response =
          await userRepository.getEmailContentAPI(event.request);
      yield SaleBillEmailContentResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSaleBill_INQ_QT_SO_NO_ListEventState(
      SaleBill_INQ_QT_SO_NO_ListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesBill_INQ_QT_SO_NO_ListResponse response =
          await userRepository.getINQ_QT_SO_NO_API(event.request);
      yield SalesBill_INQ_QT_SO_NO_ListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSearchCustomerListByNumberCallEventToState(
      SearchCustomerListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerDetailsResponse response =
          await userRepository.getCustomerListSearchByNumber(event.request);
      yield SearchCustomerListByNumberCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapUserMenuRightsRequestEventState(
      UserMenuRightsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      UserMenuRightsResponse respo = await userRepository.user_menurightsapi(
          event.MenuID, event.userMenuRightsRequest);
      yield UserMenuRightsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapMultiNoToProductDetailsRequestEventState(
      MultiNoToProductDetailsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      MultiNoToProductDetailsResponse response =
          await userRepository.getProductDetailsFrom_No(event.request);
      yield MultiNoToProductDetailsResponseState(
          event.FromWhichScreen, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapGetQuotationProductListEventState(
      GetQuotationProductListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<SaleBillTable> response =
          await OfflineDbHelper.getInstance().getSalesBillProduct();
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield GetQuotationProductListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapGetQuotationSpecificationTableEventState(
      GetQuotationSpecificationTableEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<QuotationSpecificationTable> response =
          await OfflineDbHelper.getInstance()
              .getQuotationSpecificationTableList();
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield GetQuotationSpecificationTableState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapQuotationOtherCharge1ListEventToState(
      QuotationOtherCharge1CallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherCharge1ListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapGetGenericAddditionalChargesEventToState(
      GetGenericAddditionalChargesEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      List<GenericAddditionalCharges> quotationOtherChargesListResponse =
          await OfflineDbHelper.getInstance().getGenericAddditionalCharges();

      GenericAddditionalCharges genericAddditionalCharges;
      for (int i = 0; i < quotationOtherChargesListResponse.length; i++) {
        genericAddditionalCharges = quotationOtherChargesListResponse[i];
      }
      yield GetGenericAddditionalChargesState(genericAddditionalCharges);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapQuotationOtherChargeListEventToState(
      QuotationOtherChargeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherChargeListResponseState(
          event.headerDiscountController, quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _map_InsertProductEventState(
      InsertProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      for (int i = 0; i < event.quotationTable.length; i++) {
        //event.quotationTable[i]
        await OfflineDbHelper.getInstance()
            .insertSalesBillProduct(SaleBillTable(
          event.quotationTable[i].QuotationNo,
          event.quotationTable[i].ProductSpecification,
          event.quotationTable[i].ProductID,
          event.quotationTable[i].ProductName,
          event.quotationTable[i].Unit,
          event.quotationTable[i].Quantity,
          event.quotationTable[i].UnitRate,
          event.quotationTable[i].DiscountPercent,
          event.quotationTable[i].DiscountAmt,
          event.quotationTable[i].NetRate,
          event.quotationTable[i].Amount,
          event.quotationTable[i].TaxRate,
          event.quotationTable[i].TaxAmount,
          event.quotationTable[i].NetAmount,
          event.quotationTable[i].TaxType,
          event.quotationTable[i].CGSTPer,
          event.quotationTable[i].SGSTPer,
          event.quotationTable[i].IGSTPer,
          event.quotationTable[i].CGSTAmt,
          event.quotationTable[i].SGSTAmt,
          event.quotationTable[i].IGSTAmt,
          event.quotationTable[i].StateCode,
          event.quotationTable[i].pkID,
          event.quotationTable[i].LoginUserID,
          event.quotationTable[i].CompanyId,
          event.quotationTable[i].BundleId,
          event.quotationTable[i].HeaderDiscAmt,
        ));
      }

      yield InsertProductSucessResponseState("Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapDeleteAllQuotationProductEventState(
      DeleteAllQuotationProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLSalesBillProduct();

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield DeleteALLQuotationProductTableState(
          "Deleted All Item in Table Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> mapAddGeneric(
      AddGenericAddditionalChargesEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .insertGenericAddditionalCharges(GenericAddditionalCharges(
        event.genericAddditionalCharges.DiscountAmt,
        event.genericAddditionalCharges.ChargeID1,
        event.genericAddditionalCharges.ChargeAmt1,
        event.genericAddditionalCharges.ChargeID2,
        event.genericAddditionalCharges.ChargeAmt2,
        event.genericAddditionalCharges.ChargeID3,
        event.genericAddditionalCharges.ChargeAmt3,
        event.genericAddditionalCharges.ChargeID4,
        event.genericAddditionalCharges.ChargeAmt4,
        event.genericAddditionalCharges.ChargeID5,
        event.genericAddditionalCharges.ChargeAmt5,
        event.genericAddditionalCharges.ChargeName1,
        event.genericAddditionalCharges.ChargeName2,
        event.genericAddditionalCharges.ChargeName3,
        event.genericAddditionalCharges.ChargeName4,
        event.genericAddditionalCharges.ChargeName5,
      ));

      yield AddGenericAddditionalChargesState("Added SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapDeleteGenericAddditionalChargesEventToState(
      DeleteGenericAddditionalChargesEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteALLGenericAddditionalCharges();
      yield DeleteAllGenericAddditionalChargesState("Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSBHeaderSaveRequestEventToState(
      SBHeaderSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SBHeaderSaveResponse response = await userRepository
          .getSaleBillHeaderSaveCallAPI(event.pkId, event.sbHeaderSaveRequest);

      SBExportSaveRequest sbExportSaveRequest = SBExportSaveRequest();

      sbExportSaveRequest.InvoiceNo = response.details[0].column3;
      sbExportSaveRequest.PreCarrBy = event.sbExportSaveRequest.PreCarrBy;
      sbExportSaveRequest.PreCarrRecPlace =
          event.sbExportSaveRequest.PreCarrRecPlace;
      sbExportSaveRequest.FlightNo = event.sbExportSaveRequest.FlightNo;
      sbExportSaveRequest.PortOfLoading =
          event.sbExportSaveRequest.PortOfLoading;
      sbExportSaveRequest.PortOfDispatch =
          event.sbExportSaveRequest.PortOfDispatch;
      sbExportSaveRequest.PortOfDestination =
          event.sbExportSaveRequest.PortOfDestination;
      sbExportSaveRequest.MarksNo = event.sbExportSaveRequest.MarksNo;
      sbExportSaveRequest.Packages = event.sbExportSaveRequest.Packages;
      sbExportSaveRequest.NetWeight = event.sbExportSaveRequest.NetWeight;
      sbExportSaveRequest.GrossWeight = event.sbExportSaveRequest.GrossWeight;
      sbExportSaveRequest.PackageType = event.sbExportSaveRequest.PackageType;
      sbExportSaveRequest.FreeOnBoard = event.sbExportSaveRequest.FreeOnBoard;
      sbExportSaveRequest.LoginUserID = event.sbExportSaveRequest.LoginUserID;
      sbExportSaveRequest.CompanyId = event.sbExportSaveRequest.CompanyId;

      await userRepository.sb_ExportSaveAPI(
          response.details[0].column3, sbExportSaveRequest);

      SbAllProductDeleteRequest sbAllProductDeleteRequest =
          SbAllProductDeleteRequest();
      sbAllProductDeleteRequest.InvoiceNo = response.details[0].column3;
      sbAllProductDeleteRequest.CompanyId =
          event.sbAllProductDeleteRequest.CompanyId;

      await userRepository.sales_bill_deleteAllProductAPI(
          response.details[0].column3, sbAllProductDeleteRequest);

      yield SBHeaderSaveResponseState(event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapGenericOtherChargeCallEventToState(
      GenericOtherChargeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield GenericOtherCharge1ListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSBProductSaveRequestEventState(
      SBProductSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      SBProductSaveResponse response =
          await userRepository.salesBillProductSaveDetails(
              event.InvoiceNo, event.arrsbProductsaveRequest);
      yield SBProductSaveResponseState(event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSBOneProductDeleteEventState(
      SBProductOneDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteSalesBillProduct(event.tableId);
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield SBProductOneDeleteState("Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSBExportListRequestEventToState(
      SBExportListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SBExportListResponse response =
          await userRepository.getSBExportListAPI(event.request);
      yield SBExportListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

/*  Stream<SalesBillStates> _mapSBExportSaveRequestEventToState(
      SBExportSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SBExportSaveResponse response =
          await userRepository.sb_ExportSaveAPI(event.request);
      yield SBExportSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  Stream<SalesBillStates> _mapSBAssemblyTableListEventState(
      SBAssemblyTableListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<SBAssemblyTable> response = await OfflineDbHelper.getInstance()
          .getSBAssemblyItems(event.finishProductID);
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield SBAssemblyTableListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> mapSBAssemblyTableInsertEventState(
      SBAssemblyTableInsertEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().insertSBAssemblyItems(SBAssemblyTable(
        event.sbAssemblyTable.FinishProductID,
        event.sbAssemblyTable.ProductID,
        event.sbAssemblyTable.ProductName,
        event.sbAssemblyTable.Quantity,
        event.sbAssemblyTable.Unit,
        event.sbAssemblyTable.InvoiceNo,
      ));

      yield SBAssemblyTableInsertState(
          event.context, "Sales BILL Assembly Added SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> mapSBAssemblyTableUpdateEventState(
      SBAssemblyTableUpdateEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateSBAssemblyItems(SBAssemblyTable(
          event.sbAssemblyTable.FinishProductID,
          event.sbAssemblyTable.ProductID,
          event.sbAssemblyTable.ProductName,
          event.sbAssemblyTable.Quantity,
          event.sbAssemblyTable.Unit,
          event.sbAssemblyTable.InvoiceNo,
          id: event.sbAssemblyTable.id));

      yield SBAssemblyTableUpdateState(
          event.context, "Sales BILL Assembly Updated SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSBAssemblyTableOneItemDeleteEventToState(
      SBAssemblyTableOneItemDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteSBAssemblyItem(event.tableid);
      yield SBAssemblyTableOneItemDeleteState(
          "SalesOrder Assembly Item Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSBAssemblyTableALLDeleteEventToState(
      SBAssemblyTableALLDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteAllSBAssemblyItems();
      yield SBAssemblyTableDeleteALLState(
          "SalesOrder Assembly All Item Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSBDeleteRequestEventToState(
      SBDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SBDeleteResponse response = await userRepository.getSBHeaderDeleteAPI(
          event.headerpkID, event.request);
      yield SBDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapSOCurrencyListRequestEventToState(
      SOCurrencyListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SOCurrencyListResponse inquiryDeleteResponse =
          await userRepository.SOCurrencyListAPI(event.request);
      yield SOCurrencyListResponseState(inquiryDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapHeaderToDetailsRequestEventToState(
      HeaderToDetailsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      HeaderToDetailsResponse inquiryDeleteResponse =
          await userRepository.SalesBillHeaderIdToDetailsAPI(
              event.hedarpkID, event.request);
      yield HeaderToDetailsResponseState(inquiryDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesBillStates> _mapQuotationProjectListCallEventToState(
      QuotationProjectListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationProjectListResponse response =
          await userRepository.getQuotationProjectList(event.request);
      yield QuotationProjectListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

/*  Stream<SalesBillStates> _mapSbAllProductDeleteRequestCallEventToState(
      SbAllProductDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      String response =
          await userRepository.sales_bill_deleteAllProductAPI(event.request);
      yield SBAllProductDeleteState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/
}
