import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/SizedList/size_list_request.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/SizedList/size_list_response.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_request/SizedList_INS_UPD_API/sized_list_ins_update_api_request.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_request/Sized_multi_delete_API/sized_multi_delete_api_request.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_request/inquiry_no_to_fetch_product_sized_list_request.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_response/SizedList_INS_UPD_API/sized_list_ins_update_api_response.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_response/inq_no_to_customized_sizedList_response.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_response/inquiry_no_to_fetch_product_sized_list_response.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/bluetone_inquiry_product.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/price_model.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/product_with_sized_list_model.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_label_value_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/InquiryShareModel.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inqiory_header_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_followup_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_to_delete_product.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_to_product_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_product_search_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_search_by_pk_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_share_emp_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/search_inquiry_fillter_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/search_inquiry_list_by_name_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/search_inquiry_list_by_number_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/closer_reason_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/follower_employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_history_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_header_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_list_reponse.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_no_to_delete_product_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_no_to_product_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_share_emp_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_share_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_status_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/search_inquiry_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/closer_reason_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response_for_packing_checking.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/common/inquiry_product_model.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/models/pushnotification/fcm_notification_response.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';

part 'inquiry_events.dart';
part 'inquiry_states.dart';

class InquiryBloc extends Bloc<InquiryEvents, InquiryStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  InquiryBloc(this.baseBloc) : super(InquiryInitialState());

  @override
  Stream<InquiryStates> mapEventToState(InquiryEvents event) async* {
    /// sets state based on events
    if (event is InquiryListCallEvent) {
      yield* _mapInquiryListCallEventToState(event);
    }
    if (event is SearchInquiryListByNameCallEvent) {
      yield* _mapSearchInquiryListByNameCallEventToState(event);
    }
    if (event is SearchInquiryListByNumberCallEvent) {
      yield* _mapSearchInquiryListByNumberCallEventToState(event);
    }

    /* if(event is InquiryLeadSourceCallEvent)
      {
        yield* _mapCustomerSourceCallEventToState(event);
      }*/

    if (event is InquiryDeleteByNameCallEvent) {
      yield* _mapDeleteInquiryCallEventToState(event);
    }
    if (event is InquiryProductSearchNameCallEvent) {
      yield* _mapInquiryProductSearchCallEventToState(event);
    }
    if (event is InquiryHeaderSaveNameCallEvent) {
      yield* _mapInquiryHeaderSaveEventToState(event);
    }
    if (event is InquiryProductSaveCallEvent) {
      yield* _mapInquiryProductSaveEventToState(event);
    }

    if (event is BluetoneInquiryProductSaveCallEvent) {
      yield* _mapBlueToneInquiryProductSaveEventToState(event);
    }
    if (event is InquiryNotoProductCallEvent) {
      yield* _mapInquryNoToProductEventToState(event);
    }

    if (event is BluetoneInquiryNotoProductCallEvent) {
      yield* _mapBlueToneInquryNoToProductEventToState(event);
    }
    if (event is InquiryNotoDeleteProductCallEvent) {
      yield* _mapInquryNoToDeleteProductEventToState(event);
    }
    if (event is InquirySearchByPkIDCallEvent) {
      yield* _mapInqurySearchByEventToState(event);
    }
    if (event is SearchInquiryCustomerListByNameCallEvent) {
      yield* _mapCustomerListByNameCallEventToState(event);
    }

    if (event is InquiryLeadStatusTypeListByNameCallEvent) {
      yield* _mapFollowupInquiryStatusListCallEventToState(event);
    }

    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }
    if (event is InquiryNoToFollowupDetailsRequestCallEvent) {
      yield* _mapInquiry_No_To_CallEventToState(event);
    }

    if (event is InquiryShareModelCallEvent) {
      yield* _mapInquiryShareSaveEventToState(event);
    }

    if (event is FollowerEmployeeListCallEvent) {
      yield* _mapFollowerEmployeeByStatusCallEventToState(event);
    }

    if (event is InquiryShareEmpListRequestEvent) {
      yield* _mapInquiryShareEmpListEventToState(event);
    }

    if (event is CloserReasonTypeListByNameCallEvent) {
      yield* _mapCloserReasonStatusListCallEventToState(event);
    }

    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }

    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }
    if (event is SearchInquiryListFillterByNameRequestEvent) {
      yield* _mapSearchInquiryFillterCallEventToState(event);
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

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }

    if (event is BlueToneProductModelListEvent) {
      yield* _mapBlueToneProductModelListEventState(event);
    }

    if (event is BlueToneProductModelInsertEvent) {
      yield* mapBlueToneProductModelInsertEventState(event);
    }

    if (event is BlueToneProductModelUpdateEvent) {
      yield* mapBlueToneProductModelUpdateEventState(event);
    }

    if (event is BlueToneProductModelOneItemDeleteEvent) {
      yield* _mapBlueToneProductModelOneItemDeleteEventToState(event);
    }

    if (event is BlueToneProductModelALLDeleteEvent) {
      yield* _mapBlueToneProductModelALLDeleteEventToState(event);
    }

    if (event is SizeListRequestEvent) {
      yield* _mapSizeListRequestEventState(event);
    }

    if (event is InquiryNoToFetchProductSizedListRequestEvent) {
      yield* _mapInquiryNoToFetchProductSizedListRequestEventState(event);
    }

    if (event is SizedListInsUpdateApiRequestEvent) {
      yield* _mapSizedListInsUpdateApiRequestEventState(event);
    }
    //
  }

  ///event functions to states implementation
  Stream<InquiryStates> _mapInquiryListCallEventToState(
      InquiryListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryListResponse response = await userRepository.getInquiryList(
          event.pageNo, event.inquiryListApiRequest);
      yield InquiryListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapSearchInquiryListByNumberCallEventToState(
      SearchInquiryListByNumberCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryListResponse response =
          await userRepository.getInquiryListSearchByNumber(event.request);
      yield SearchInquiryListByNumberCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapSearchInquiryListByNameCallEventToState(
      SearchInquiryListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SearchInquiryListResponse response =
          await userRepository.getInquiryListSearchByName(event.request);
      yield SearchInquiryListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /* Stream<InquiryStates> _mapCustomerSourceCallEventToState(
      InquiryLeadSourceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerSourceResponse respo =  await userRepository.customer_Source_List_call(event.request1);
      yield InquirySourceCallEventResponseState(respo);

    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
*/
  Stream<InquiryStates> _mapDeleteInquiryCallEventToState(
      InquiryDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryDeleteResponse inquiryDeleteResponse = await userRepository
          .deleteInquiry(event.pkID, event.followupDeleteRequest);
      yield InquiryDeleteCallResponseState(inquiryDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInquiryProductSearchCallEventToState(
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

  Stream<InquiryStates> _mapInquiryHeaderSaveEventToState(
      InquiryHeaderSaveNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryHeaderSaveResponse response = await userRepository
          .getInquiryHeaderSave(event.pkID, event.inquiryHeaderSaveRequest);
      yield InquiryHeaderSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInquiryProductSaveEventToState(
      InquiryProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryProductSaveResponse respo = await userRepository
          .inquiryProductSaveDetails(event.inquiryProductModel);

      yield InquiryProductSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapBlueToneInquiryProductSaveEventToState(
      BluetoneInquiryProductSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryProductSaveResponse respo = await userRepository
          .inquiryProductSaveDetails(event.inquiryProductModel);

      ///multi_delete_sizedListAPI
      SizedMultiDeleteApiRequest sizedMultiDeleteApiRequest =
          SizedMultiDeleteApiRequest();
      sizedMultiDeleteApiRequest.CompanyId =
          event.inquiryProductModel[0].CompanyId;
      String responsemultidelete =
          await userRepository.multi_delete_sizedListAPI(
              sizedMultiDeleteApiRequest,
              event.inquiryProductModel[0].InquiryNo);
      print("multideleteSizedList" + responsemultidelete.toString());

      ///ProductSizedList Ins_Upd
      String tempresponse = "";

      for (int i = 0; i < event.dbarraysizedlist.length; i++) {
        if (event.dbarraysizedlist[i].isChecked == "true") {
          SizedListInsUpdateApiRequest sizedListInsUpdateApiRequest =
              SizedListInsUpdateApiRequest();
          sizedListInsUpdateApiRequest.ProductID =
              event.dbarraysizedlist[i].ProductID;
          sizedListInsUpdateApiRequest.SizeID =
              event.dbarraysizedlist[i].SizeID;
          sizedListInsUpdateApiRequest.InquiryNo =
              event.inquiryProductModel[0].InquiryNo;
          sizedListInsUpdateApiRequest.CompanyId =
              event.inquiryProductModel[0].CompanyId;
          sizedListInsUpdateApiRequest.LoginUserID =
              event.inquiryProductModel[0].LoginUserID;

          SizedListInsUpdateApiResponse response = await userRepository
              .insert_update_sizedListAPI(sizedListInsUpdateApiRequest);

          tempresponse = response.details[0].column2;
        }
      }

      yield BluetoneInquiryProductSaveResponseState(respo, tempresponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInquryNoToProductEventToState(
      InquiryNotoProductCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryNoToProductResponse response = await userRepository
          .getInquiryNoToProductList(event.inquiryNoToProductListRequest);

      yield InquiryNotoProductResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapBlueToneInquryNoToProductEventToState(
      BluetoneInquiryNotoProductCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryNoToProductResponse response = await userRepository
          .getInquiryNoToProductList(event.inquiryNoToProductListRequest);

      List<InquiryProductWithSizedListDetails>
          inquiryNotoProductAndTwoSizedList = [];

      for (int i = 0; i < response.details.length; i++) {
        List<InquiryNoToFetchProductSizedListResponseDetails>
            productIDtoSizedList = [];
        List<InquiryNoToFetchProductSizedListResponseDetails>
            inquiryNotoSizedList = [];

        InquiryNoToFetchProductSizedListRequest
            inquiryNoToFetchProductSizedListRequest =
            InquiryNoToFetchProductSizedListRequest();
        inquiryNoToFetchProductSizedListRequest.InquiryNo =
            event.inquiryNoToProductListRequest.InquiryNo;
        inquiryNoToFetchProductSizedListRequest.ProductID =
            response.details[i].productID.toString();
        inquiryNoToFetchProductSizedListRequest.LoginUserID =
            event.inquiryNoToProductListRequest.LoginUserID;
        inquiryNoToFetchProductSizedListRequest.CompanyId =
            event.inquiryNoToProductListRequest.CompanyId;

        SizeListRequest sizeListRequest = SizeListRequest();
        sizeListRequest.ProductID = response.details[i].productID.toString();
        sizeListRequest.LoginUserID =
            event.inquiryNoToProductListRequest.LoginUserID;
        sizeListRequest.CompanyId =
            event.inquiryNoToProductListRequest.CompanyId;

        ///InquiryNo to ProductSized List
        InquiryNoToFetchProductSizedListResponse sizedresponsefromINQNo =
            await userRepository.getproductSizedListfromInquiryNo(
                inquiryNoToFetchProductSizedListRequest);

        ///ProductID to ProductSized List
        SizeListResponse sizedresponsefromProductID =
            await userRepository.getSizeListFromProductID(sizeListRequest);

        for (int j = 0; j < sizedresponsefromProductID.details.length; j++) {
          print("ASDsdo" + sizedresponsefromProductID.details[j].sizeName);

          InquiryNoToFetchProductSizedListResponseDetails sizedModel =
              InquiryNoToFetchProductSizedListResponseDetails();
          sizedModel.inquiryNo = event.inquiryNoToProductListRequest.InquiryNo;
          sizedModel.productID =
              sizedresponsefromProductID.details[j].productID;
          sizedModel.productName =
              sizedresponsefromProductID.details[j].productName;
          sizedModel.sizeID = sizedresponsefromProductID.details[j].sizeID;
          sizedModel.sizeName = sizedresponsefromProductID.details[j].sizeName;
          productIDtoSizedList.add(sizedModel);
        }

        for (int k = 0; k < sizedresponsefromINQNo.details.length; k++) {
          InquiryNoToFetchProductSizedListResponseDetails sizedModel =
              InquiryNoToFetchProductSizedListResponseDetails();
          sizedModel.inquiryNo = event.inquiryNoToProductListRequest.InquiryNo;
          sizedModel.productID = sizedresponsefromINQNo.details[k].productID;
          sizedModel.productName =
              sizedresponsefromINQNo.details[k].productName;
          sizedModel.sizeID = sizedresponsefromINQNo.details[k].sizeID;
          sizedModel.sizeName = sizedresponsefromINQNo.details[k].sizeName;
          inquiryNotoSizedList.add(sizedModel);
        }

        InquiryProductWithSizedListDetails inquiryProductWithSizedListDetails =
            InquiryProductWithSizedListDetails();
        inquiryProductWithSizedListDetails.rowNum = response.details[i].rowNum;
        inquiryProductWithSizedListDetails.pkID = response.details[i].pkID;
        inquiryProductWithSizedListDetails.inquiryNo =
            response.details[i].inquiryNo;
        inquiryProductWithSizedListDetails.unitPrice =
            response.details[i].unitPrice;
        inquiryProductWithSizedListDetails.taxRate =
            response.details[i].taxRate;
        inquiryProductWithSizedListDetails.unit = response.details[i].unit;
        inquiryProductWithSizedListDetails.productID =
            response.details[i].productID;
        inquiryProductWithSizedListDetails.productName =
            response.details[i].productName;
        inquiryProductWithSizedListDetails.quantity =
            response.details[i].quantity;
        inquiryProductWithSizedListDetails.productNameLong =
            response.details[i].productNameLong;
        inquiryProductWithSizedListDetails.productAlias =
            response.details[i].productAlias;
        inquiryProductWithSizedListDetails.taxType =
            response.details[i].taxType;

        inquiryProductWithSizedListDetails.all_sized_with_productID =
            productIDtoSizedList;
        inquiryProductWithSizedListDetails.custom_sized_with_InquiryNo =
            inquiryNotoSizedList;
        inquiryNotoProductAndTwoSizedList
            .add(inquiryProductWithSizedListDetails);
      }

      /* for (int i = 0; i < response.details.length; i++) {
        //

        InquiryNoToFetchProductSizedListRequest
            inquiryNoToFetchProductSizedListRequest =
            InquiryNoToFetchProductSizedListRequest();
        inquiryNoToFetchProductSizedListRequest.InquiryNo =
            event.inquiryNoToProductListRequest.InquiryNo;
        inquiryNoToFetchProductSizedListRequest.ProductID =
            response.details[i].productID.toString();
        inquiryNoToFetchProductSizedListRequest.LoginUserID =
            event.inquiryNoToProductListRequest.LoginUserID;
        inquiryNoToFetchProductSizedListRequest.CompanyId =
            event.inquiryNoToProductListRequest.CompanyId;

        SizeListRequest sizeListRequest = SizeListRequest();
        sizeListRequest.ProductID = response.details[i].productID.toString();
        sizeListRequest.LoginUserID =
            event.inquiryNoToProductListRequest.LoginUserID;
        sizeListRequest.CompanyId =
            event.inquiryNoToProductListRequest.CompanyId;

        ///InquiryNo to ProductSized List
        InquiryNoToFetchProductSizedListResponse sizedresponsefromINQNo =
            await userRepository.getproductSizedListfromInquiryNo(
                inquiryNoToFetchProductSizedListRequest);

        ///ProductID to ProductSized List
        SizeListResponse sizedresponsefromProductID =
            await userRepository.getSizeListFromProductID(sizeListRequest);

        List<PriceModel> arrrdbsizedList = [];



        for (int j = 0; j < sizedresponsefromProductID.details.length; j++) {
          print("sjkfj43erdr" + sizedresponsefromProductID.details[j].sizeName);

           await  OfflineDbHelper.getInstance().insertProductPriceList(PriceModel(
              response.details[j].productID.toString(),
              response.details[j].productName.toString(),
              sizedresponsefromProductID.details[j].sizeID.toString(),
              sizedresponsefromProductID.details[j].sizeName.toString(),
              "false"));

          arrrdbsizedList = await OfflineDbHelper.getInstance()
              .getProductPriceList(response.details[j].productID.toString());
        }
        for (int k = 0; k < arrrdbsizedList.length; k++) {
          print("sjkfj43erdr" + sizedresponsefromProductID.details[k].sizeName);

             for (int l = 0; l < sizedresponsefromINQNo.details.length; l++) {
            if (arrrdbsizedList[k].SizeID ==
                sizedresponsefromINQNo.details[l].sizeID.toString()) {
              await OfflineDbHelper.getInstance().updateProductPriceItem(
                  PriceModel(
                      arrrdbsizedList[k].ProductID.toString(),
                      arrrdbsizedList[k].ProductName.toString(),
                      arrrdbsizedList[k].SizeID.toString(),
                      arrrdbsizedList[k].SizeName.toString(),
                      "true",
                      id: arrrdbsizedList[k].id));
            }
          }
        }
      }*/

      yield BluetoneInquiryNotoProductResponseState(
          response, inquiryNotoProductAndTwoSizedList);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInquryNoToDeleteProductEventToState(
      InquiryNotoDeleteProductCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryNoToDeleteProductResponse response =
          await userRepository.getInquiryNoToDeleteProductList(
              event.InqNo, event.inquiryNoToDeleteProductRequest);
      yield InquiryNotoDeleteProductResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInqurySearchByEventToState(
      InquirySearchByPkIDCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryListResponse response = await userRepository.getInquiryByPkID(
          event.pkID, event.inquirySearchByPkIdRequest);
      yield InquirySearchByPkIDResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapCustomerListByNameCallEventToState(
      SearchInquiryCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield InquiryCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapFollowupInquiryStatusListCallEventToState(
      InquiryLeadStatusTypeListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryStatusListResponse response =
          await userRepository.getFollowupInquiryStatusList(
              event.followupInquiryStatusTypeListRequest);
      yield InquiryLeadStatusListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapCustomerSourceCallEventToState(
      CustomerSourceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerSourceResponse respo =
          await userRepository.customer_Source_List_call(event.request1);
      yield CustomerSourceCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInquiry_No_To_CallEventToState(
      InquiryNoToFollowupDetailsRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      FollowupHistoryListResponse respo =
          await userRepository.inquiry_no_to_followup_details(
              event.inquiryNoToFollowupDetailsRequest);
      yield FollowupHistoryListResponseState(event.inquiryDetails, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInquiryShareSaveEventToState(
      InquiryShareModelCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      InquiryShareResponse respo =
          await userRepository.inquiryShareSaveDetails(event.inquiryShareModel);
      yield InquiryShareResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapFollowerEmployeeByStatusCallEventToState(
      FollowerEmployeeListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowerEmployeeListResponse response = await userRepository
          .getFollowerEmployeeList(event.followerEmployeeListRequest);
      yield FollowerEmployeeListByStatusCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInquiryShareEmpListEventToState(
      InquiryShareEmpListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryShareEmpListResponse response = await userRepository
          .getInquiryShareEmpList(event.inquiryShareEmpListRequest);
      yield InquiryShareEmpListResponseState(
          event.inquiryShareEmpListRequest.InquiryNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapCloserReasonStatusListCallEventToState(
      CloserReasonTypeListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CloserReasonListResponse response = await userRepository
          .getCloserReasonStatusList(event.closerReasonTypeListRequest);
      yield CloserReasonListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapCountryListCallEventToState(
      CountryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CountryListResponseForPacking respo = await userRepository
          .country_list_call_For_Packing(event.countryListRequest);
      yield CountryListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapStateListCallEventToState(
      StateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      StateListResponse respo =
          await userRepository.state_list_call(event.stateListRequest);
      yield StateListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapCityListCallEventToState(
      CityCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CityApiRespose respo =
          await userRepository.city_list_details(event.cityApiRequest);
      yield CityListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapSearchInquiryFillterCallEventToState(
      SearchInquiryListFillterByNameRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryListResponse response =
          await userRepository.getInquiryListSearchByNameFillter(
              event.searchInquiryListFillterByNameRequest);
      yield SearchInquiryFillterResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapSearchCustomerListByNumberCallEventToState(
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

  Stream<InquiryStates> _map_fcm_notificationEvent_state(
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

  Stream<InquiryStates> _map_GetReportToTokenRequestEventState(
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

  //SearchInquiryListFillterByNameRequestEvent

  Stream<InquiryStates> _mapUserMenuRightsRequestEventState(
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

  /// Blueton Inquiry Product CRUD
  Stream<InquiryStates> _mapBlueToneProductModelListEventState(
      BlueToneProductModelListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<BlueToneProductModel> response =
          await OfflineDbHelper.getInstance().getBlueTonProductList();

      List<ProductWithSizedList> productwithsizedmodel = [];
      List<PriceModel> temparraylist = [];
      List<PriceModel> finalSizedList = [];

      for (int i = 0; i < response.length; i++) {
        temparraylist = await OfflineDbHelper.getInstance()
            .getProductPriceList(response[i].ProductID);

        for (int j = 0; j < temparraylist.length; j++) {
          if (temparraylist[j].isChecked == "true") {
            finalSizedList.add(temparraylist[j]);
          }
        }

        /* int id;
  String InquiryNo;
  String LoginUserID;
  String CompanyId;
  String ProductName;
  String ProductID;
  String UnitPrice;*/

        ProductWithSizedList productWithSizedList = ProductWithSizedList();
        productWithSizedList.id = response[i].id;
        productWithSizedList.InquiryNo = response[i].InquiryNo;
        productWithSizedList.LoginUserID = response[i].LoginUserID;
        productWithSizedList.CompanyId = response[i].CompanyId;
        productWithSizedList.ProductName = response[i].ProductName;
        productWithSizedList.ProductID = response[i].ProductID;
        productWithSizedList.UnitPrice = response[i].UnitPrice;
        productWithSizedList.SizedList = finalSizedList;
        productwithsizedmodel.add(productWithSizedList);
      }

      // await userRepository.getQuotationTermConditionList(event.all_name_id.Name,event.all_name_id.PresentDate);
      yield BlueToneProductModelListState(productwithsizedmodel);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> mapBlueToneProductModelInsertEventState(
      BlueToneProductModelInsertEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
/*String InquiryNo,   String LoginUserID,   String CompanyId,   String ProductName,   String ProductID,   String UnitPrice, */
      await OfflineDbHelper.getInstance()
          .insertBlueTonProductItems(BlueToneProductModel(
        event.blueToneProductModel.InquiryNo,
        event.blueToneProductModel.LoginUserID,
        event.blueToneProductModel.CompanyId,
        event.blueToneProductModel.ProductName,
        event.blueToneProductModel.ProductID,
        event.blueToneProductModel.UnitPrice,
      ));

      yield BlueToneProductModelInsertState(
          event.context, "Product Added SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> mapBlueToneProductModelUpdateEventState(
      BlueToneProductModelUpdateEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateBlueToneProductItems(
          BlueToneProductModel(
              event.blueToneProductModel.InquiryNo,
              event.blueToneProductModel.LoginUserID,
              event.blueToneProductModel.CompanyId,
              event.blueToneProductModel.ProductName,
              event.blueToneProductModel.ProductID,
              event.blueToneProductModel.UnitPrice,
              id: event.blueToneProductModel.id));

      yield BlueToneProductModelInsertState(
          event.context, "Product Updated SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapBlueToneProductModelOneItemDeleteEventToState(
      BlueToneProductModelOneItemDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance()
          .deleteBlueToneProductItem(event.tableid);
      yield BlueToneProductModelOneItemDeleteState(
          "Product Item Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapBlueToneProductModelALLDeleteEventToState(
      BlueToneProductModelALLDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteAllBlueToneProductItems();
      yield BlueToneProductModelDeleteALLState(
          "Product All Item Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapSizeListRequestEventState(
      SizeListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SizeListResponse response =
          await userRepository.getSizeListFromProductID(event.request);
      await OfflineDbHelper.getInstance()
          .deleteProductPriceList(event.request.ProductID);
      for (int i = 0; i < response.details.length; i++) {
        //deleteProductPriceList
        await OfflineDbHelper.getInstance().insertProductPriceList(PriceModel(
            response.details[i].productID.toString(),
            response.details[i].productName.toString(),
            response.details[i].sizeID.toString(),
            response.details[i].sizeName.toString(),
            "true"));
      }

      List<PriceModel> arrSizeList = await OfflineDbHelper.getInstance()
          .getProductPriceList(event.request.ProductID);

      yield SizeListResponseState(arrSizeList);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapInquiryNoToFetchProductSizedListRequestEventState(
      InquiryNoToFetchProductSizedListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryNoToFetchProductSizedListResponse response =
          await userRepository.getproductSizedListfromInquiryNo(event.request);
      yield InquiryNoToFetchProductSizedListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      // await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<InquiryStates> _mapSizedListInsUpdateApiRequestEventState(
      SizedListInsUpdateApiRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      SizedListInsUpdateApiResponse response =
          await userRepository.insert_update_sizedListAPI(event.request);
      yield SizedListInsUpdateApiResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      // await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
