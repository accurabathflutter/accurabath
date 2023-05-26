import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesOrder/bank_details_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesOrder/multi_no_to_product_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/specification_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/save_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/SO_Export/so_export_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/SO_Export/so_export_save_api.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sale_order_header_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sale_order_product_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sales_order_all_product_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sales_order_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sales_order_generate_pdf_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/salesorder_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/search_salesorder_list_by_name_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/search_salesorder_list_by_number_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/shipment/so_shipment_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/shipment/so_shipment_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/shipment/so_shipmnet_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/sales_target/sales_target_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/SaleBill/sale_bill_email_content_response.dart';
import 'package:for_practice_the_app/models/api_responses/SaleBill/sales_bill_INQ_QT_SO_NO_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/SaleOrder/bank_details_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/SaleOrder/multi_no_to_product_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/specification_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_project_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_terms_condition_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/save_email_content_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/salesOrder_Product_Save_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/sales_order_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/sales_order_header_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/sales_order_pdf_generate_pdf_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/sales_order_product_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/salesorder_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/search_salesorder_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/shipment/so_shipment_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/shipment/so_shipment_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/so_currency_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/so_export/so_export_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/sales_target/sales_target_list_response.dart';
import 'package:for_practice_the_app/models/common/assembly/so_assembly_table.dart';
import 'package:for_practice_the_app/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/sales_order_table.dart';
import 'package:for_practice_the_app/models/common/specification/quotation/quotation_specification.dart';
import 'package:for_practice_the_app/models/pushnotification/fcm_notification_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/sales_order_payment_schedule.dart';

part 'salesorder_events.dart';
part 'salesorder_states.dart';

class SalesOrderBloc extends Bloc<SalesOrderEvents, SalesOrderStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  SalesOrderBloc(this.baseBloc) : super(SalesOrderInitialState());

  @override
  Stream<SalesOrderStates> mapEventToState(SalesOrderEvents event) async* {
    /// sets state based on events
    if (event is SalesOrderListCallEvent) {
      yield* _mapSalesOrderListCallEventToState(event);
    }
    if (event is SearchSalesOrderListByNameCallEvent) {
      yield* _mapSearchSalesOrderListByNameCallEventToState(event);
    }
    if (event is SearchSalesOrderListByNumberCallEvent) {
      yield* _mapSearchSalesOrderListByNumberCallEventToState(event);
    }

    if (event is SalesOrderPDFGenerateCallEvent) {
      yield* _mapSalesOrderPDFGenerateCallEventToState(event);
    }

    if (event is SaleOrderBankDetailsListRequestEvent) {
      yield* _map_bankDetailsEvent_state(event);
    }

    if (event is QuotationProjectListCallEvent) {
      yield* _mapQuotationProjectListCallEventToState(event);
    }

    if (event is QuotationTermsConditionCallEvent) {
      yield* _mapQuotationTermsConditionEventToState(event);
    }
    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }
    if (event is SaleBill_INQ_QT_SO_NO_ListRequestEvent) {
      yield* _mapSaleBill_INQ_QT_SO_NO_ListEventState(event);
    }

    if (event is MultiNoToProductDetailsRequestEvent) {
      yield* _mapMultiNoToProductDetailsRequestEventState(event);
    }
    if (event is SalesBillEmailContentRequestEvent) {
      yield* _mapSalesBillEmailContentEventState(event);
    }

    if (event is FCMNotificationRequestEvent) {
      yield* _map_fcm_notificationEvent_state(event);
    }
    if (event is PaymentScheduleEvent) {
      yield* _mapPaymentScheduleEventState(event);
    }
    if (event is PaymentScheduleListEvent) {
      yield* _mapPaymentScheduleListEventState(event);
    }
    if (event is PaymentScheduleDeleteEvent) {
      yield* _mapPaymentScheduleDeleteEventState(event);
    }
    if (event is PaymentScheduleEditEvent) {
      yield* _mapPaymentScheduleEditEventState(event);
    }
    if (event is PaymentScheduleDeleteAllItemEvent) {
      yield* _mapPaymentScheduleDeleteAllEventState(event);
    }

    if (event is SaleOrderHeaderSaveRequestEvent) {
      yield* _mapSaleOrderHeaderSaveRequestEventState(event);
    }
    if (event is SaleOrderProductSaveCallEvent) {
      yield* _mapSaleOrderProductSaveCallEventState(event);
    }

    if (event is SalesOrderProductDeleteRequestEvent) {
      yield* _mapSalesOrderProductDeleteRequestEventState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
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

    if (event is GetQuotationProductListEvent) {
      yield* _mapGetQuotationProductListEventState(event);
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
    if (event is GetQuotationSpecificationTableEvent) {
      yield* _mapGetQuotationSpecificationTableEventState(event);
    }

    if (event is QuotationSpecificationCallEvent) {
      yield* _mapSpecificationListCallEventToState(event);
    }

    if (event is GenericOtherChargeCallEvent) {
      yield* _mapGenericOtherChargeCallEventToState(event);
    }

    if (event is SalesOrderDeleteRequestEvent) {
      yield* _mapSalesOrderDeleteRequestEventToState(event);
    }

    if (event is SOCurrencyListRequestEvent) {
      yield* _mapSOCurrencyListRequestEventToState(event);
    }

    if (event is SaveEmailContentRequestEvent) {
      yield* _mapSaveEmailContentRequestEventState(event);
    }
    if (event is SOProductOneDeleteEvent) {
      yield* _mapQuotationOneProductDeleteEventState(event);
    }
    if (event is SOAssemblyTableListEvent) {
      yield* _mapSOAssemblyTableListEventState(event);
    }
    if (event is SOAssemblyTableInsertEvent) {
      yield* mapSOAssemblyTableInsertEventState(event);
    }
    if (event is SOAssemblyTableUpdateEvent) {
      yield* mapSOAssemblyTableUpdateEventState(event);
    }
    if (event is SOAssemblyTableOneItemDeleteEvent) {
      yield* _mapSOAssemblyTableOneItemDeleteEventToState(event);
    }
    if (event is SOAssemblyTableALLDeleteEvent) {
      yield* _mapSOAssemblyTableALLDeleteEventToState(event);
    }

    if (event is SalesTargetListCallEvent) {
      yield* _mapSalesTargetListCallEventToState(event);
    }

    if (event is SOShipmentListRequestEvent) {
      yield* _mapSOShipmentListRequestEventToState(event);
    }
    if (event is SOShipmentSaveRequestEvent) {
      yield* _mapSOShipmentSaveRequestEventToState(event);
    }

    if (event is SOShipmentDeleteRequestEvent) {
      yield* _mapSOShipmentDeleteRequestEventToState(event);
    }
  }

  ///event functions to states implementation
  Stream<SalesOrderStates> _mapSalesOrderListCallEventToState(
      SalesOrderListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderListResponse response = await userRepository.getSalesOrderList(
          event.pageNo, event.salesOrderListApiRequest);
      yield SalesOrderListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSearchSalesOrderListByNumberCallEventToState(
      SearchSalesOrderListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderListResponse response = await userRepository
          .getSalesOrderListSearchByNumber(event.pkID, event.request);
      yield SearchSalesOrderListByNumberCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSearchSalesOrderListByNameCallEventToState(
      SearchSalesOrderListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SearchSalesOrderListResponse response =
          await userRepository.getSalesOrderListSearchByName(event.request);
      yield SearchSalesOrderListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSalesOrderPDFGenerateCallEventToState(
      SalesOrderPDFGenerateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderPDFGenerateResponse response =
          await userRepository.getSalesOrderPDFGenerate(event.request);
      yield SalesOrderPDFGenerateResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _map_bankDetailsEvent_state(
      SaleOrderBankDetailsListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      BankDetailsListResponse response =
          await userRepository.getBankDetailsAPI(event.request);
      yield BankDetailsListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapQuotationProjectListCallEventToState(
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

  Stream<SalesOrderStates> _mapQuotationTermsConditionEventToState(
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

  Stream<SalesOrderStates> _mapSearchCustomerListByNumberCallEventToState(
      SearchCustomerListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerDetailsResponse response =
          await userRepository.getCustomerListSearchByNumber(event.request);
      yield SearchCustomerListByNumberCallResponseState(
          event.IsFromDialog, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSaleBill_INQ_QT_SO_NO_ListEventState(
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

  Stream<SalesOrderStates> _mapMultiNoToProductDetailsRequestEventState(
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

  Stream<SalesOrderStates> _mapSalesBillEmailContentEventState(
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

  Stream<SalesOrderStates> _map_fcm_notificationEvent_state(
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

  Stream<SalesOrderStates> _mapPaymentScheduleEventState(
      PaymentScheduleEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().insertPaymentScheduleItems(
          SoPaymentScheduleTable(
              event.soPaymentScheduleTable.amount,
              event.soPaymentScheduleTable.dueDate,
              event.soPaymentScheduleTable.revdueDate));
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleResponseState("Added Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapPaymentScheduleListEventState(
      PaymentScheduleListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<SoPaymentScheduleTable> response =
          await OfflineDbHelper.getInstance().getPaymentScheduleItems();
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapPaymentScheduleDeleteEventState(
      PaymentScheduleDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deletePaymentScheduleItem(event.id);

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleDeleteResponseState("Deleted Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapPaymentScheduleEditEventState(
      PaymentScheduleEditEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .updatePaymentScheduleItems(event.soPaymentScheduleTable);

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleEditResponseState("Updated Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapPaymentScheduleDeleteAllEventState(
      PaymentScheduleDeleteAllItemEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteAllPaymentScheduleItems();

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield PaymentScheduleDeleteAllResponseState(
          "Deleted All Item in Table Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSaleOrderHeaderSaveRequestEventState(
      SaleOrderHeaderSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleOrderHeaderSaveResponse response =
          await userRepository.getSalesOrderHeaderSaveAPI(
              event.pkID, event.saleOrderHeaderSaveRequest);

      SOShipmentSaveRequest soShipmentSaveRequest = SOShipmentSaveRequest(
        OrderNo: response.details[0].column4,
        SCompanyName: event.soShipmentSaveRequest.SCompanyName,
        SGSTNo: event.soShipmentSaveRequest.SGSTNo,
        SContactNo: event.soShipmentSaveRequest.SContactNo,
        SContactPersonName: event.soShipmentSaveRequest.SContactPersonName,
        SAddress: event.soShipmentSaveRequest.SAddress,
        SArea: event.soShipmentSaveRequest.SArea,
        SCountryCode: event.soShipmentSaveRequest.SCountryCode,
        SCityCode: event.soShipmentSaveRequest.SCityCode,
        SStateCode: event.soShipmentSaveRequest.SStateCode,
        SPincode: event.soShipmentSaveRequest.SPincode,
        LoginUserID: event.soShipmentSaveRequest.LoginUserID,
        CompanyId: event.soShipmentSaveRequest.CompanyId.toString(),
      );
      //soShipmentSaveRequest.OrderNo = response.details[0].column4;
      // soShipmentSaveRequest.

      SOExportSaveRequest soExportSaveRequest = SOExportSaveRequest(
        OrderNo: response.details[0].column4.toString(),
        PreCarrBy: event.soExportSaveRequest.PreCarrBy,
        PreCarrRecPlace: event.soExportSaveRequest.PreCarrRecPlace,
        FlightNo: event.soExportSaveRequest.FlightNo,
        PortOfLoading: event.soExportSaveRequest.PortOfLoading,
        PortOfDispatch: event.soExportSaveRequest.PortOfDispatch,
        PortOfDestination: event.soExportSaveRequest.PortOfDestination,
        MarksNo: event.soExportSaveRequest.MarksNo,
        Packages: event.soExportSaveRequest.Packages,
        NetWeight: event.soExportSaveRequest.NetWeight,
        GrossWeight: event.soExportSaveRequest.GrossWeight,
        PackageType: event.soExportSaveRequest.PackageType,
        FreeOnBoard: event.soExportSaveRequest.FreeOnBoard,
        LoginUserID: event.soExportSaveRequest.LoginUserID,
        CompanyId: event.soExportSaveRequest.CompanyId,
      );

      print("dslksdjfksf" + event.soExportSaveRequest.PreCarrBy.toString());

      await userRepository.saveSoShipmentListAPI(soShipmentSaveRequest);

      await userRepository.soExportSaveAPI(
          soExportSaveRequest, response.details[0].column4);

      yield SaleOrderHeaderSaveResponseState(
          event.context, event.pkID, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSaleOrderProductSaveCallEventState(
      SaleOrderProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      print("dlddd" + event.arrSalesOrderProductList.length.toString());
      SaleOrderProductSaveResponse response = await userRepository
          .salesOrderProductSaveDetails(event.arrSalesOrderProductList);
      yield SaleOrderProductSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSalesOrderProductDeleteRequestEventState(
      SalesOrderProductDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SaleOrderProductDeleteResponse response =
          await userRepository.saleorder_productDelete(
              event.pkID, event.SalesOrderProductDeleteRequest);
      yield SaleOrderProductDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapUserMenuRightsRequestEventState(
      UserMenuRightsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      UserMenuRightsResponse respo = await userRepository.user_menurightsapi(
          event.MenuID, event.userMenuRightsRequest);

      print("dsjfd455444oopppp" + respo.details[0].addFlag1);
      yield UserMenuRightsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapQuotationOtherCharge1ListEventToState(
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

  Stream<SalesOrderStates> _mapGetGenericAddditionalChargesEventToState(
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

  Stream<SalesOrderStates> _mapQuotationOtherChargeListEventToState(
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

  Stream<SalesOrderStates> _mapGetQuotationProductListEventState(
      GetQuotationProductListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<SalesOrderTable> response =
          await OfflineDbHelper.getInstance().getSalesOrderProduct();
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield GetQuotationProductListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _map_InsertProductEventState(
      InsertProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      for (int i = 0; i < event.quotationTable.length; i++) {
        //event.quotationTable[i]
        await OfflineDbHelper.getInstance()
            .insertSalesOrderProduct(SalesOrderTable(
          event.quotationTable[i].SalesOrderNo,
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
          event.quotationTable[i].DeliveryDate,
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

  Stream<SalesOrderStates> _mapDeleteAllQuotationProductEventState(
      DeleteAllQuotationProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLSalesOrderProduct();

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

  Stream<SalesOrderStates> mapAddGeneric(
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

  Stream<SalesOrderStates> _mapDeleteGenericAddditionalChargesEventToState(
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

  //SalesOrderProductDeleteRequestEvent

  Stream<SalesOrderStates> _mapGetQuotationSpecificationTableEventState(
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

  Stream<SalesOrderStates> _mapSpecificationListCallEventToState(
      QuotationSpecificationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SpecificationListResponse
          response; /*=
          await userRepository.getProductSpecificationList(event.request,"");
*/
      for (int i = 0; i < response.details.length; i++) {
        await OfflineDbHelper.getInstance().insertQuotationSpecificationTable(
            QuotationSpecificationTable(
                response.details[i].itemOrder.toString(),
                response.details[i].groupHead,
                response.details[i].materialHead,
                response.details[i].materialSpec,
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

  Stream<SalesOrderStates> _mapGenericOtherChargeCallEventToState(
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

  Stream<SalesOrderStates> _mapSalesOrderDeleteRequestEventToState(
      SalesOrderDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesOrderDeleteResponse inquiryDeleteResponse =
          await userRepository.deleteSalesOrder(event.pkID, event.request);
      yield SalesOrderDeleteResponseState(inquiryDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSOCurrencyListRequestEventToState(
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

  Stream<SalesOrderStates> _mapSaveEmailContentRequestEventState(
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

  Stream<SalesOrderStates> _mapQuotationOneProductDeleteEventState(
      SOProductOneDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .deleteSalesOrderProduct(event.tableId);
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield SOProductOneDeleteState("Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSOAssemblyTableListEventState(
      SOAssemblyTableListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<SOAssemblyTable> response = await OfflineDbHelper.getInstance()
          .getSOAssemblyItems(event.finishProductID);
      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield SOAssemblyTableListState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> mapSOAssemblyTableInsertEventState(
      SOAssemblyTableInsertEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().insertSOAssemblyItems(SOAssemblyTable(
        event.soAssemblyTable.FinishProductID,
        event.soAssemblyTable.ProductID,
        event.soAssemblyTable.ProductName,
        event.soAssemblyTable.Quantity,
        event.soAssemblyTable.Unit,
        event.soAssemblyTable.OrderNo,
      ));

      yield SOAssemblyTableInsertState(
          event.context, "Sales Order Assembly Added SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> mapSOAssemblyTableUpdateEventState(
      SOAssemblyTableUpdateEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateSOAssemblyItems(SOAssemblyTable(
          event.soAssemblyTable.FinishProductID,
          event.soAssemblyTable.ProductID,
          event.soAssemblyTable.ProductName,
          event.soAssemblyTable.Quantity,
          event.soAssemblyTable.Unit,
          event.soAssemblyTable.OrderNo,
          id: event.soAssemblyTable.id));

      yield SOAssemblyTableUpdateState(
          event.context, "Sales Order Assembly Updated SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSOAssemblyTableOneItemDeleteEventToState(
      SOAssemblyTableOneItemDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteSOAssemblyItem(event.tableid);
      yield SOAssemblyTableOneItemDeleteState(
          "SalesOrder Assembly Item Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSOAssemblyTableALLDeleteEventToState(
      SOAssemblyTableALLDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteAllSOAssemblyItems();
      yield SOAssemblyTableDeleteALLState(
          "SalesOrder Assembly All Item Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSalesTargetListCallEventToState(
      SalesTargetListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SalesTargetListResponse response = await userRepository
          .getSalesTargetList(event.pageNo, event.salaryTargetListRequest);
      yield SalesTargetListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSOShipmentListRequestEventToState(
      SOShipmentListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SOShipmentlistResponse response = await userRepository
          .getSoShipmentListAPI(event.soShipmentListRequest);

      SOExportListResponse soExportListResponse =
          await userRepository.getSOExportListAPI(event.soExportListRequest);
      yield SOShipmentlistResponseState(
          response, event.salesOrderDetails, soExportListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSOShipmentSaveRequestEventToState(
      SOShipmentSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SOShipmentSaveResponse response = await userRepository
          .saveSoShipmentListAPI(event.soShipmentSaveRequest);
      yield SOShipmentSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<SalesOrderStates> _mapSOShipmentDeleteRequestEventToState(
      SOShipmentDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      String response = await userRepository
          .deleteSoShipmentListAPI(event.soShipmentDeleteRequest);
      yield SOShipmentDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
