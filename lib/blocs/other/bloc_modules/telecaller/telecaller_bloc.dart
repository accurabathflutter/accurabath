import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_label_value_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_type_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/general_telecaller_img_upload_request/telecaller_upload_img_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/closer_reason_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/district_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/taluka_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/product/product_brand_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/tele_caller_followup_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/tele_caller_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/tele_caller_search_by_name_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/telecaller_delete_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/telecaller_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/external_leads/external_lead_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_type_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/general_telecaller_img_upload_response/telecaller_upload_img_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/closer_reason_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/product_master/product_brand_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/telecaller/tele_caller_delete_image_response.dart';
import 'package:for_practice_the_app/models/api_responses/telecaller/tele_caller_followup_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/telecaller/tele_caller_search_by_name_response.dart';
import 'package:for_practice_the_app/models/api_responses/telecaller/telecaller_list_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/models/pushnotification/fcm_notification_response.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'telecaller_event.dart';
part 'telecaller_state.dart';

class TeleCallerBloc extends Bloc<TeleCallerEvents, TeleCallerStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  TeleCallerBloc(this.baseBloc) : super(TeleCallerInitialState());

  @override
  Stream<TeleCallerStates> mapEventToState(TeleCallerEvents event) async* {
    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }

    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }

    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }

    if (event is TeleCallerListCallEvent) {
      yield* _mapExternalLeadListCallEventToState(event);
    }
    if (event is TeleCallerDeleteCallEvent) {
      yield* _mapDeleteCustomerCallEventToState(event);
    }
    if (event is TeleCallerSearchByNameCallEvent) {
      yield* _mapExternalLeadSearchByNameCallEventToState(event);
    }
    if (event is TeleCallerSearchByIDCallEvent) {
      yield* _mapExternalLeadSearchByIDCallEventToState(event);
    }
    if (event is TeleCallerSaveCallEvent) {
      yield* _mapExternalLeadSaveCallEventToState(event);
    }
    if (event is SearchCustomerListByNameCallEvent) {
      yield* _mapCustomerListByNameCallEventToState(event);
    }

    if (event is TeleCallerUploadImageNameCallEvent) {
      yield* _mapTeleCallerUploadImageCallEventToState(event);
    }
    if (event is TeleCallerImageDeleteRequestCallEvent) {
      yield* _mapTeleCallerImageDeleteCallEventToState(event);
    }

    if (event is FCMNotificationRequestEvent) {
      yield* _map_fcm_notificationEvent_state(event);
    }
    if (event is GetReportToTokenRequestEvent) {
      yield* _map_GetReportToTokenRequestEventState(event);
    }

    if (event is TeleCallerFollowupSaveRequestEvent) {
      yield* _mapTeleCallerSaveRequestEventToState(event);
    }

    if (event is FollowupTypeListByNameCallEvent) {
      yield* _mapFollowupTypeListCallEventToState(event);
    }

    if (event is CloserReasonTypeListByNameCallEvent) {
      yield* _mapCloserReasonStatusListCallEventToState(event);
    }
    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }

    if (event is ProductBrandListRequestEvent) {
      yield* _mapProductBrandListRequestEventState(event);
    }
  }

  Stream<TeleCallerStates> _mapCountryListCallEventToState(
      CountryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CountryListResponse respo =
          await userRepository.country_list_call(event.countryListRequest);
      yield CountryListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapStateListCallEventToState(
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

  Stream<TeleCallerStates> _mapCityListCallEventToState(
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

  Stream<TeleCallerStates> _mapCustomerSourceCallEventToState(
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

  Stream<TeleCallerStates> _mapExternalLeadListCallEventToState(
      TeleCallerListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TeleCallerListResponse response =
          await userRepository.getTeleCallerList(event.pageNo, event.request1);
      yield TeleCallerListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapDeleteCustomerCallEventToState(
      TeleCallerDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerDeleteResponse customerDeleteResponse = await userRepository
          .deleteTeleCaller(event.pkID, event.customerDeleteRequest);
      yield TeleCallerDeleteCallResponseState(customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapExternalLeadSearchByNameCallEventToState(
      TeleCallerSearchByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TeleCallerSearchResponseByName respo =
          await userRepository.getTeleCallerSearchByNamedetails(event.request1);
      yield TeleCallerSearchByNameResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapExternalLeadSearchByIDCallEventToState(
      TeleCallerSearchByIDCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TeleCallerListResponse respo = await userRepository
          .getTeleCallerLeadSearchByIDDetails(event.request1);
      yield TeleCallerSearchByIDResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapExternalLeadSaveCallEventToState(
      TeleCallerSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ExternalLeadSaveResponse respo = await userRepository
          .teleCallerSaveDetails(event.pkID, event.request1);
      yield ExternalLeadSaveResponseState(event.contextfromHeader, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapCustomerListByNameCallEventToState(
      SearchCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response = await userRepository
          .getTeleCallerCustomerListSearchByName(event.request);
      yield CustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapTeleCallerUploadImageCallEventToState(
      TeleCallerUploadImageNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      Telecaller_image_upload_response expenseUploadImageResponse =
          await userRepository.getuploadImageTeleCaller(
              event.telecallerImageFile, event.teleCallerUploadImgApiRequest);

      yield TeleCallerUploadImgApiResponseState(
          event.contextFromAddEditScreen, expenseUploadImageResponse);
    } catch (error, stacktrace) {
      print(error);
      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapTeleCallerImageDeleteCallEventToState(
      TeleCallerImageDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      TeleCallerImageDeleteResponse response = await userRepository
          .getTeleCallerImageDeleteByPkID(event.pkID, event.request1);
      yield TeleCallerImageDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _map_fcm_notificationEvent_state(
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

  Stream<TeleCallerStates> _map_GetReportToTokenRequestEventState(
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

  Stream<TeleCallerStates> _mapTeleCallerSaveRequestEventToState(
      TeleCallerFollowupSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TeleCallerFollowupSaveResponse respo =
          await userRepository.teleCallerFollowupSaveDetails(event.request);
      yield TeleCallerFollowupSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<TeleCallerStates> _mapFollowupTypeListCallEventToState(
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

  Stream<TeleCallerStates> _mapCloserReasonStatusListCallEventToState(
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

  Stream<TeleCallerStates> _mapUserMenuRightsRequestEventState(
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

  Stream<TeleCallerStates> _mapProductBrandListRequestEventState(
      ProductBrandListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProductBrandResponse respo = await userRepository
          .productBrandListAPI(event.productBrandListRequest);
      yield ProductBrandResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

// Ab pata chal raha he me kar lunga agar kuch dikkat aati toh bolunga thik he
}
