import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_add_edit_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_category_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_label_value_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_type_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inqiory_header_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/designation_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/district_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/taluka_api_request.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_add_edit_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_category_list.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_type_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_header_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_status_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/designation_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/district_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/taluka_api_response.dart';
import 'package:for_practice_the_app/models/common/inquiry_product_model.dart';
import 'package:for_practice_the_app/models/pushnotification/fcm_notification_response.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'quick_inquiry_events.dart';
part 'quick_inquiry_states.dart';

class QuickInquiryBloc extends Bloc<QuickInquiryEvents, QuickInquiryStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  QuickInquiryBloc(this.baseBloc) : super(QuickInquiryInitialState());

  @override
  Stream<QuickInquiryStates> mapEventToState(QuickInquiryEvents event) async* {
    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }
    if (event is DistrictCallEvent) {
      yield* _mapDistrictListCallEventToState(event);
    }
    if (event is TalukaCallEvent) {
      yield* _mapTalukaListCallEventToState(event);
    }
    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }

    if (event is CustomerAddEditCallEvent) {
      yield* _mapCustomerAddEditCallEventToState(event);
    }

    if (event is CustomerCategoryCallEvent) {
      yield* _mapCustomerCategoryCallEventToState(event);
    }

    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }
    if (event is DesignationCallEvent) {
      yield* _mapDesignationListCallEventToState(event);
    }

    if (event is InquiryLeadStatusTypeListByNameCallEvent) {
      yield* _mapFollowupInquiryStatusListCallEventToState(event);
    }
    if (event is InquiryHeaderSaveNameCallEvent) {
      yield* _mapInquiryHeaderSaveEventToState(event);
    }
    if (event is InquiryProductSaveCallEvent) {
      yield* _mapInquiryProductSaveEventToState(event);
    }
    if (event is FollowupTypeListByNameCallEvent) {
      yield* _mapFollowupTypeListCallEventToState(event);
    }

    if (event is SearchCustomerListByNameCallEvent) {
      yield* _mapCustomerListByNameCallEventToState(event);
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
  }

  Stream<QuickInquiryStates> _mapCustomerCategoryCallEventToState(
      CustomerCategoryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerCategoryResponse respo =
          await userRepository.customer_Category_List_call(event.request1);
      yield CustomerCategoryCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuickInquiryStates> _mapCountryListCallEventToState(
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

  Stream<QuickInquiryStates> _mapStateListCallEventToState(
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

  Stream<QuickInquiryStates> _mapDistrictListCallEventToState(
      DistrictCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DistrictApiResponse respo =
          await userRepository.district_list_details(event.districtApiRequest);
      yield DistrictListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuickInquiryStates> _mapTalukaListCallEventToState(
      TalukaCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TalukaApiRespose respo =
          await userRepository.taluka_list_details(event.talukaApiRequest);
      yield TalukaListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuickInquiryStates> _mapCityListCallEventToState(
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

  Stream<QuickInquiryStates> _mapCustomerAddEditCallEventToState(
      CustomerAddEditCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerAddEditApiResponse respo = await userRepository
          .customer_add_edit_details(event.customerAddEditApiRequest);
      yield CustomerAddEditEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<QuickInquiryStates> _mapCustomerSourceCallEventToState(
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

  Stream<QuickInquiryStates> _mapDesignationListCallEventToState(
      DesignationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DesignationApiResponse respo = await userRepository
          .designation_list_details(event.designationApiRequest);
      yield DesignationListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///____________________Inquiry Details_______________________________________
  Stream<QuickInquiryStates> _mapFollowupInquiryStatusListCallEventToState(
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

  Stream<QuickInquiryStates> _mapInquiryHeaderSaveEventToState(
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

  Stream<QuickInquiryStates> _mapInquiryProductSaveEventToState(
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

  Stream<QuickInquiryStates> _mapFollowupTypeListCallEventToState(
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

  Stream<QuickInquiryStates> _mapCustomerListByNameCallEventToState(
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

  Stream<QuickInquiryStates> _mapSearchCustomerListByNumberCallEventToState(
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

  Stream<QuickInquiryStates> _map_fcm_notificationEvent_state(
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

  Stream<QuickInquiryStates> _map_GetReportToTokenRequestEventState(
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
}
