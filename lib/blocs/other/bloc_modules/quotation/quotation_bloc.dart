import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/bank_voucher/bank_drop_down_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/cust_id_inq_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_label_value_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_type_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_to_product_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_product_search_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/specification_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/qt_Organization_drop_down_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/qt_spec_save_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_header_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_kind_att_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_no_to_product_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_pdf_generate_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_product_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/save_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/search_quotation_list_by_name_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/search_quotation_list_by_number_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/bank_voucher/bank_drop_down_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/cust_id_to_inq_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_type_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inq_no_to_product_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/specification_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/qt_Organization_drop_down_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/qt_spec_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_email_content_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_header_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_kind_att_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_no_to_product_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_pdf_generate_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_product_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_product_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_project_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_terms_condition_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/save_email_content_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/search_quotation_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/so_currency_list_response.dart';
import 'package:for_practice_the_app/models/common/assembly/qt_assembly_table.dart';
import 'package:for_practice_the_app/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/other_charge_table.dart';
import 'package:for_practice_the_app/models/common/quotationtable.dart';
import 'package:for_practice_the_app/models/common/specification/quotation/quotation_specification.dart';
import 'package:for_practice_the_app/models/pushnotification/fcm_notification_response.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';

part 'quotation_events.dart';
part 'quotation_states.dart';

class QuotationBloc extends Bloc<QuotationEvents, QuotationStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  QuotationBloc(this.baseBloc) : super(QuotationInitialState());

  @override
  Stream<QuotationStates> mapEventToState(QuotationEvents event) async* {
    /// sets state based on events
    if (event is QuotationListCallEvent) {
      yield* _mapQuotationListCallEventToState(event);
    }
    if (event is SearchQuotationListByNameCallEvent) {
      yield* _mapSearchQuotationListByNameCallEventToState(event);
    }
    if (event is SearchQuotationListByNumberCallEvent) {
      yield* _mapSearchQuotationListByNumberCallEventToState(event);
    }

    if (event is QuotationPDFGenerateCallEvent) {
      yield* _mapQuotationPDFGenerateCallEventToState(event);
    }

    if (event is SearchQuotationCustomerListByNameCallEvent) {
      yield* _mapCustomerListByNameCallEventToState(event);
    }
    if (event is QuotationNoToProductListCallEvent) {
      yield* _mapQuotationNoToProductListCallEventToState(event);
    }

    if (event is QuotationSpecificationCallEvent) {
      yield* _mapSpecificationListCallEventToState(event);
    }

    if (event is QuotationKindAttListCallEvent) {
      yield* _mapQuotationKindAttListCallEventToState(event);
    }
    if (event is QuotationProjectListCallEvent) {
      yield* _mapQuotationProjectListCallEventToState(event);
    }

    if (event is QuotationTermsConditionCallEvent) {
      yield* _mapQuotationTermsConditionEventToState(event);
    }

    if (event is CustIdToInqListCallEvent) {
      yield* _mapCustIdToInqListEventToState(event);
    }

    if (event is InqNoToProductListCallEvent) {
      yield* _mapInqNoToProductListEventToState(event);
    }

    if (event is InquiryProductSearchNameWithStateCodeCallEvent) {
      yield* _mapInquiryProductSearchCallEventToState(event);
    }

    if (event is QuotationHeaderSaveCallEvent) {
      yield* _mapQuotationHeaderSaveEventToState(event);
    }

    if (event is QuotationProductSaveCallEvent) {
      yield* _mapQuotationProductSaveEventToState(event);
    }
    if (event is QuotationProductSpecificationSaveCallEvent) {
      yield* _mapQuotationProductSpecificationSaveCallEventToState(event);
    }

    if (event is QuotationDeleteProductCallEvent) {
      yield* _mapqtNoToDeleteProductEventToState(event);
    }

    if (event is QuotationDeleteRequestCallEvent) {
      yield* _mapDeleteQuotationCallEventToState(event);
    }

    if (event is QuotationOtherChargeCallEvent) {
      yield* _mapQuotationOtherChargeListEventToState(event);
    }
    if (event is QuotationBankDropDownCallEvent) {
      yield* _mapBankDropDownEventToState(event);
    }

    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }

    if (event is FCMNotificationRequestEvent) {
      yield* _map_fcm_notificationEvent_state(event);
    }

    if (event is GetReportToTokenRequestEvent) {
      yield* _map_GetReportToTokenRequestEventState(event);
    }

    if (event is QT_OtherChargeDeleteRequestEvent) {
      yield* _map_QTOtherChargeDeleteEventState(event);
    }
    if (event is QT_OtherChargeInsertRequestEvent) {
      yield* _map_QTOtherChargeInsertEventState(event);
    }

    if (event is QuotationEmailContentRequestEvent) {
      yield* _mapSalesBillEmailContentEventState(event);
    }
    if (event is SaveEmailContentRequestEvent) {
      yield* _mapSaveEmailContentRequestEventState(event);
    }

    if (event is QuotationOtherCharge1CallEvent) {
      yield* _mapQuotationOtherCharge1ListEventToState(event);
    }

    if (event is QuotationOtherCharge2CallEvent) {
      yield* _mapQuotationOtherCharge2ListEventToState(event);
    }
    if (event is QuotationOtherCharge3CallEvent) {
      yield* _mapQuotationOtherCharge3ListEventToState(event);
    }
    if (event is QuotationOtherCharge4CallEvent) {
      yield* _mapQuotationOtherCharge4ListEventToState(event);
    }
    if (event is QuotationOtherCharge5CallEvent) {
      yield* _mapQuotationOtherCharge5ListEventToState(event);
    }
    if (event is InsertQuotationSpecificationTableEvent) {
      yield* _mapInsertQuotationSpecificationTableEventState(event);
    }
    if (event is UpdateQuotationSpecificationTableEvent) {
      yield* _mapUpdateQuotationSpecificationTableEventState(event);
    }
    if (event is GetQuotationSpecificationTableEvent) {
      yield* _mapGetQuotationSpecificationTableEventState(event);
    }

    if (event is GetQuotationSpecificationwithQTNOTableEvent) {
      yield* _mapGetQuotationSpecificationwithQTNOTableEventState(event);
    }
    if (event is GetQuotationProductListEvent) {
      yield* _mapGetQuotationProductListEventState(event);
    }
    if (event is QuotationOneProductDeleteEvent) {
      yield* _mapQuotationOneProductDeleteEventState(event);
    }

    //GetQuotationProductListEvent
    if (event is DeleteQuotationSpecificationTableEvent) {
      yield* _mapDeleteQuotationSpecificationTableEventState(event);
    }

    if (event is DeleteQuotationSpecificationByFinishProductIDEvent) {
      yield* _mapDeleteQuotationSpecificationByFinishProductIDEventState(event);
    }

    if (event is DeleteAllQuotationSpecificationTableEvent) {
      yield* _mapDeleteAllQuotationSpecificationTableEventState(event);
    }

    if (event is InsertProductEvent) {
      yield* _map_InsertProductEventState(event);
    }

    if (event is DeleteAllQuotationProductEvent) {
      yield* _mapDeleteAllQuotationProductEventState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }
    if (event is GenericOtherChargeCallEvent) {
      yield* _mapGenericOtherChargeCallEventToState(event);
    }

    if (event is GetGenericAddditionalChargesEvent) {
      yield* _mapGetGenericAddditionalChargesEventToState(event);
    }

    if (event is AddGenericAddditionalChargesEvent) {
      yield* mapAddGeneric(event);
    }

    if (event is DeleteGenericAddditionalChargesEvent) {
      yield* _mapDeleteGenericAddditionalChargesEventToState(event);
    }

    if (event is SOCurrencyListRequestEvent) {
      yield* _mapSOCurrencyListRequestEventToState(event);
    }
    if (event is FollowupTypeListByNameCallEvent) {
      yield* _mapFollowupTypeListCallEventToState(event);
    }
    if (event is QTAssemblyTableListEvent) {
      yield* _mapQTAssemblyTableListEventState(event);
    }
    if (event is QTAssemblyTableInsertEvent) {
      yield* mapQTAssemblyTableInsertEventState(event);
    }
    if (event is QTAssemblyTableUpdateEvent) {
      yield* mapQTAssemblyTableUpdateEventState(event);
    }
    if (event is QTAssemblyTableOneItemDeleteEvent) {
      yield* _mapQTAssemblyTableOneItemDeleteEventToState(event);
    }
    if (event is QTAssemblyTableALLDeleteEvent) {
      yield* _mapQTAssemblyTableALLDeleteEventToState(event);
    }
    if (event is InquiryProductSearchNameCallEvent) {
      yield* _mapGeneralProductSearchCallEventToState(event);
    }

    if (event is QuotationOrganazationListRequestEvent) {
      yield* _mapQuotationOrganazationListRequestEventToState(event);
    }
    //InquiryProductSearchNameCallEvent
  }

  ///event functions to states implementation
  Stream<QuotationStates> _mapQuotationListCallEventToState(
      QuotationListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationListResponse response = await userRepository.getQuotationList(
          event.pageNo, event.quotationListApiRequest);
      yield QuotationListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSearchQuotationListByNumberCallEventToState(
      SearchQuotationListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationListResponse response = await userRepository
          .getQuotationListSearchByNumber(event.pkID, event.request);
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
  }

  Stream<QuotationStates> _mapQuotationPDFGenerateCallEventToState(
      QuotationPDFGenerateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationPDFGenerateResponse response =
          await userRepository.getQuotationPDFGenerate(event.request);
      yield QuotationPDFGenerateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapCustomerListByNameCallEventToState(
      SearchQuotationCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield QuotationCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationNoToProductListCallEventToState(
      QuotationNoToProductListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationNoToProductResponse response =
          await userRepository.getQTNotoProductList(event.request);
      yield QuotationNoToProductListCallResponseState(
          event.StateCode, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSpecificationListCallEventToState(
      QuotationSpecificationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SpecificationListResponse response = await userRepository
          .getProductSpecificationList(event.ModuleName, event.request);

      for (int i = 0; i < response.details.length; i++) {
        await OfflineDbHelper.getInstance().insertQuotationSpecificationTable(
            QuotationSpecificationTable(
                response.details[i].itemOrder.toString(),
                response.details[i].groupHead,
                response.details[i].materialHead,
                response.details[i].materialSpec.replaceAll("  ", ""),
                response.details[i].MaterialRemarks,
                response.details[i].OrderNo,
                response.details[i].finishProductID.toString()));
      }

      yield SpecificationListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationKindAttListCallEventToState(
      QuotationKindAttListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationKindAttListResponse response =
          await userRepository.getQuotationKindAttList(event.request);
      yield QuotationKindAttListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationProjectListCallEventToState(
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

  Stream<QuotationStates> _mapQuotationTermsConditionEventToState(
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

  Stream<QuotationStates> _mapCustIdToInqListEventToState(
      CustIdToInqListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustIdToInqListResponse response =
          await userRepository.getCustIdToInqList(event.request);
      yield CustIdToInqListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapInqNoToProductListEventToState(
      InqNoToProductListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InqNoToProductListResponse response =
          await userRepository.getInqNoProductList(event.request);
      yield InqNoToProductListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapInquiryProductSearchCallEventToState(
      InquiryProductSearchNameWithStateCodeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryProductSearchResponse response = await userRepository
          .getInquiryProductSearchList(event.inquiryProductSearchRequest);
      yield InquiryProductSearchByStateCodeResponseState(event.ProductID,
          event.ProductName, event.Quantity, event.UnitRate, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationHeaderSaveEventToState(
      QuotationHeaderSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      print("refdfd" +
          " AssumptionRemarks : " +
          event.request.AssumptionRemarks +
          " Addtional Remarks : " +
          event.request.AdditionalRemarks);

      QuotationSaveHeaderResponse response = await userRepository
          .getQuotationHeaderSaveResponse(event.pkID, event.request);
      yield QuotationHeaderSaveResponseState(
          event.context, event.pkID, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationProductSaveEventToState(
      QuotationProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      QuotationProductSaveResponse respo =
          await userRepository.quotationProductSaveDetails(
              event.QT_No, event.quotationProductModel);
      yield QuotationProductSaveResponseState(
          event.context, respo, event.quotationProductModel, event.QT_No);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationProductSpecificationSaveCallEventToState(
      QuotationProductSpecificationSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      QTSpecSaveResponse respo = await userRepository
          .quotationProductSpecificationSaveDetails(event.qTSpecSaveRequest);
      yield QTSpecSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
  //QuotationProductSpecificationSaveCallEvent

  Stream<QuotationStates> _mapqtNoToDeleteProductEventToState(
      QuotationDeleteProductCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationProductDeleteResponse response = await userRepository
          .getQtNoToDeleteProductList(event.qt_No, event.request);
      yield QuotationProductDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapDeleteQuotationCallEventToState(
      QuotationDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationDeleteResponse inquiryDeleteResponse = await userRepository
          .deleteQuotation(event.pkID, event.quotationDeleteRequest);
      yield QuotationDeleteCallResponseState(
          event.context, inquiryDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationOtherChargeListEventToState(
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

  Stream<QuotationStates> _mapBankDropDownEventToState(
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

  Stream<QuotationStates> _mapSearchCustomerListByNumberCallEventToState(
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

  Stream<QuotationStates> _map_fcm_notificationEvent_state(
      FCMNotificationRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FCMNotificationResponse response =
          await userRepository.fcm_get_api(event.request123);
      yield FCMNotificationResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _map_GetReportToTokenRequestEventState(
      GetReportToTokenRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      GetReportToTokenResponse response =
          await userRepository.getreporttoTokenAPI(event.request);
      yield GetReportToTokenResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _map_QTOtherChargeDeleteEventState(
      QT_OtherChargeDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLQuotationOtherCharge();

      yield QT_OtherChargeDeleteResponseState("deleted SucessFully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _map_QTOtherChargeInsertEventState(
      QT_OtherChargeInsertRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .insertQuotationOtherCharge(QT_OtherChargeTable(
        event.qt_otherChargeTable.Headerdiscount,
        event.qt_otherChargeTable.Tot_BasicAmt,
        event.qt_otherChargeTable.OtherChargeWithTaxamt,
        event.qt_otherChargeTable.Tot_GstAmt,
        event.qt_otherChargeTable.OtherChargeExcludeTaxamt,
        event.qt_otherChargeTable.Tot_NetAmount,
        event.qt_otherChargeTable.ChargeID1,
        event.qt_otherChargeTable.ChargeAmt1,
        event.qt_otherChargeTable.ChargeBasicAmt1,
        event.qt_otherChargeTable.ChargeGSTAmt1,
        event.qt_otherChargeTable.ChargeID2,
        event.qt_otherChargeTable.ChargeAmt2,
        event.qt_otherChargeTable.ChargeBasicAmt2,
        event.qt_otherChargeTable.ChargeGSTAmt2,
        event.qt_otherChargeTable.ChargeID3,
        event.qt_otherChargeTable.ChargeAmt3,
        event.qt_otherChargeTable.ChargeBasicAmt3,
        event.qt_otherChargeTable.ChargeGSTAmt3,
        event.qt_otherChargeTable.ChargeID4,
        event.qt_otherChargeTable.ChargeAmt4,
        event.qt_otherChargeTable.ChargeBasicAmt4,
        event.qt_otherChargeTable.ChargeGSTAmt4,
        event.qt_otherChargeTable.ChargeID5,
        event.qt_otherChargeTable.ChargeAmt5,
        event.qt_otherChargeTable.ChargeBasicAmt5,
        event.qt_otherChargeTable.ChargeGSTAmt5,
      ));

      yield QT_OtherChargeInsertResponseState("Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSalesBillEmailContentEventState(
      QuotationEmailContentRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationEmailContentResponse response =
          await userRepository.getQuotationEmailContentAPI(event.request);
      yield QuotationEmailContentResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapSaveEmailContentRequestEventState(
      SaveEmailContentRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaveEmailContentResponse response =
          await userRepository.getSaveEmailContentAPI(event.request);
      yield SaveEmailContentResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationOtherCharge1ListEventToState(
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

  Stream<QuotationStates> _mapGenericOtherChargeCallEventToState(
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

  Stream<QuotationStates> _mapQuotationOtherCharge2ListEventToState(
      QuotationOtherCharge2CallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherCharge2ListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationOtherCharge3ListEventToState(
      QuotationOtherCharge3CallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherCharge3ListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationOtherCharge4ListEventToState(
      QuotationOtherCharge4CallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherCharge4ListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationOtherCharge5ListEventToState(
      QuotationOtherCharge5CallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield QuotationOtherCharge5ListResponseState(
          quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapInsertQuotationSpecificationTableEventState(
      InsertQuotationSpecificationTableEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().insertQuotationSpecificationTable(
          QuotationSpecificationTable(
              event.quotationSpecificationTable.OrderNo,
              event.quotationSpecificationTable.Group_Description,
              event.quotationSpecificationTable.Head,
              event.quotationSpecificationTable.Specification,
              event.quotationSpecificationTable.Material_Remarks,
              event.quotationSpecificationTable.QuotationNo,
              event.quotationSpecificationTable.ProductID));

      yield InsertQuotationSpecificationTableState(
          "Specification Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapUpdateQuotationSpecificationTableEventState(
      UpdateQuotationSpecificationTableEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateQuotationSpecificationTable(
          QuotationSpecificationTable(
              event.quotationSpecificationTable.OrderNo,
              event.quotationSpecificationTable.Group_Description,
              event.quotationSpecificationTable.Head,
              event.quotationSpecificationTable.Specification,
              event.quotationSpecificationTable.Material_Remarks,
              event.quotationSpecificationTable.QuotationNo,
              event.quotationSpecificationTable.ProductID,
              id: event.quotationSpecificationTable.id));

      yield UpdateQuotationSpecificationTableState(
          event.context, "Updated Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapGetQuotationSpecificationTableEventState(
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

  Stream<QuotationStates> _mapGetQuotationSpecificationwithQTNOTableEventState(
      GetQuotationSpecificationwithQTNOTableEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<QuotationSpecificationTable> response =
          await OfflineDbHelper.getInstance()
              .getQuotationSpecificationTableList();
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield GetQuotationSpecificationQTnoTableState(response, event.QTNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapGetQuotationProductListEventState(
      GetQuotationProductListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<QuotationTable> response =
          await OfflineDbHelper.getInstance().getQuotationProduct();
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield GetQuotationProductListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationOneProductDeleteEventState(
      QuotationOneProductDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteQuotationProduct(event.tableid);
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield QuotationOneProductDeleteState("Product Deleted SucessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapDeleteQuotationSpecificationTableEventState(
      DeleteQuotationSpecificationTableEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .deleteQuotationSpecificationTable(event.id);

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield DeleteQuotationSpecificationTableState("Deleted Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates>
      _mapDeleteQuotationSpecificationByFinishProductIDEventState(
          DeleteQuotationSpecificationByFinishProductIDEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .deleteQuotationSpecificationByFinishProductID(event.id);

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield DeleteQuotationSpecificationByFinishProductIDState(
          "Deleted Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapDeleteAllQuotationSpecificationTableEventState(
      DeleteAllQuotationSpecificationTableEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .deleteALLQuotationSpecificationTable();

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield DeleteALLQuotationSpecificationTableState(
          "Deleted All Item in Table Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _map_InsertProductEventState(
      InsertProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      for (int i = 0; i < event.quotationTable.length; i++) {
        //event.quotationTable[i]
        await OfflineDbHelper.getInstance().insertQuotationProduct(
            QuotationTable(
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
                event.quotationTable[i].HeaderDiscAmt));
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

  Stream<QuotationStates> _mapDeleteAllQuotationProductEventState(
      DeleteAllQuotationProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLQuotationProduct();

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

  Stream<QuotationStates> _mapUserMenuRightsRequestEventState(
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

  Stream<QuotationStates> _mapGetGenericAddditionalChargesEventToState(
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

  Stream<QuotationStates> mapAddGeneric(
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

  Stream<QuotationStates> _mapDeleteGenericAddditionalChargesEventToState(
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

  Stream<QuotationStates> _mapSOCurrencyListRequestEventToState(
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

  Stream<QuotationStates> _mapFollowupTypeListCallEventToState(
      FollowupTypeListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupTypeListResponse response = await userRepository
          .getFollowupTypeList(event.followupTypeListRequest);
      yield FollowupTypeListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQTAssemblyTableListEventState(
      QTAssemblyTableListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<QTAssemblyTable> response = await OfflineDbHelper.getInstance()
          .getQtAssemblyItems(event.finishProductID);
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield QTAssemblyTableListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> mapQTAssemblyTableInsertEventState(
      QTAssemblyTableInsertEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().insertQtAssemblyItems(QTAssemblyTable(
        event.qtAssemblyTable.FinishProductID,
        event.qtAssemblyTable.ProductID,
        event.qtAssemblyTable.ProductName,
        event.qtAssemblyTable.Quantity,
        event.qtAssemblyTable.Unit,
        event.qtAssemblyTable.QuotationNo,
      ));

      yield QTAssemblyTableInsertState(
          event.context, "Assembly Added SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> mapQTAssemblyTableUpdateEventState(
      QTAssemblyTableUpdateEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateQtAssemblyItems(QTAssemblyTable(
          event.qtAssemblyTable.FinishProductID,
          event.qtAssemblyTable.ProductID,
          event.qtAssemblyTable.ProductName,
          event.qtAssemblyTable.Quantity,
          event.qtAssemblyTable.Unit,
          event.qtAssemblyTable.QuotationNo,
          id: event.qtAssemblyTable.id));

      yield QTAssemblyTableUpdateState(
          event.context, "Assembly Updated SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQTAssemblyTableOneItemDeleteEventToState(
      QTAssemblyTableOneItemDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteQtAssemblyItem(event.tableid);
      yield QTAssemblyTableOneItemDeleteState(
          "Assembly Item Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQTAssemblyTableALLDeleteEventToState(
      QTAssemblyTableALLDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteAllQtAssemblyItems();
      yield QTAssemblyTableDeleteALLState(
          "Assembly All Item Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapGeneralProductSearchCallEventToState(
      InquiryProductSearchNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryProductSearchResponse response = await userRepository
          .getInquiryProductSearchList(event.inquiryProductSearchRequest);
      yield InquiryProductSearchResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuotationStates> _mapQuotationOrganazationListRequestEventToState(
      QuotationOrganazationListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOrganizationListResponse response =
          await userRepository.getQuotationOrganizationListAPI(
              event.quotationOrganazationListRequest);
      yield QuotationOrganizationListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
