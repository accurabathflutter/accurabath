import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_complaint_followup_history_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_complaint_followup_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_label_value_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_count_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_filter_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_history_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_image_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_inquiry_by_customer_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_inquiry_no_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_pkId_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_type_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_upload_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/quick_followup_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/search_followup_by_status_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/telecaller_followup_history_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_share_emp_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/closer_reason_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/telecaller/tele_caller_followup_save_request.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/accurabath_complaint_followup_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/accurabath_complaint_followup_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_Image_Upload_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_delete_Image_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_filter_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_history_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_image_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_inquiry_by_customer_id_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_inquiry_no_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_pkId_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_save_success_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/followup_type_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/quick_followup_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/telecaller_followup_history_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_share_emp_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_status_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/closer_reason_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/telecaller/tele_caller_followup_save_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/models/pushnotification/fcm_notification_response.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'followup_events.dart';
part 'followup_states.dart';

class FollowupBloc extends Bloc<FollowupEvents, FollowupStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  FollowupBloc(this.baseBloc) : super(FollowupInitialState());

  @override
  Stream<FollowupStates> mapEventToState(FollowupEvents event) async* {
    /// sets state based on events
    if (event is FollowupListCallEvent) {
      yield* _mapFollowupListCallEventToState(event);
    }
    if (event is SearchFollowupListByNameCallEvent) {
      yield* _mapFollowupListbyStatusCallEventToState(event);
    }

    if (event is SearchFollowupCustomerListByNameCallEvent) {
      yield* _mapFollowupCustomerListByNameCallEventToState(event);
    }

    if (event is FollowupInquiryNoListByNameCallEvent) {
      yield* _mapFollowupInquiryNoStatusListCallEventToState(event);
    }

    if (event is FollowupSaveByNameCallEvent) {
      yield* _mapFollowupSaveStatusListCallEventToState(event);
    }
    if (event is QuickFollowupSaveByNameCallEvent) {
      yield* _mapQuickFollowupSaveStatusListCallEventToState(event);
    }

    if (event is FollowupDeleteByNameCallEvent) {
      yield* _mapDeleteInquiryCallEventToState(event);
    }

    if (event is QuickFollowupDeleteByNameCallEvent) {
      yield* _mapQuickFollowupDeleteInquiryCallEventToState(event);
    }

    if (event is FollowupFilterListCallEvent) {
      yield* _mapFollowupFilterListCallEventToState(event);
    }

    if (event is FollowupInquiryByCustomerIDCallEvent) {
      yield* _mapFollowupInquiryByCustomerCallEventToState(event);
    }
    if (event is FollowupUploadImageNameCallEvent) {
      yield* _mapFollowupUploadImageCallEventToState(event);
    }

    if (event is FollowupUploadImageNameFromMainFollowupCallEvent) {
      yield* _mapFollowupUploadImageFromMainFollowupCallEventToState(event);
    }
    if (event is FollowupImageDeleteCallEvent) {
      yield* _mapFollowupImageDeleteCallEventToState(event);
    }

    if (event is FollowupTypeListByNameCallEvent) {
      yield* _mapFollowupTypeListCallEventToState(event);
    }

    if (event is InquiryLeadStatusTypeListByNameCallEvent) {
      yield* _mapFollowupInquiryStatusListCallEventToState(event);
    }

    if (event is CloserReasonTypeListByNameCallEvent) {
      yield* _mapCloserReasonStatusListCallEventToState(event);
    }
    if (event is FollowupHistoryListRequestCallEvent) {
      yield* _mapFollowupHistoryListCallEventToState(event);
    }

    if (event is QuickFollowupListRequestEvent) {
      yield* _mapQuickFollowupEventToState(event);
    }

    if (event is FCMNotificationRequestEvent) {
      yield* _map_fcm_notificationEvent_state(event);
    }

    if (event is GetReportToTokenRequestEvent) {
      yield* _map_GetReportToTokenRequestEventState(event);
    }

    if (event is AccuraBathComplaintFollowupHistoryListRequestEvent) {
      yield* _mapComlaintFollowupHistoryListEventToState(event);
    }

    if (event is AccuraBathComplaintFollowupSaveRequestEvent) {
      yield* _mapAccuraBathComlaintFollowupEventToState(event);
    }

    if (event is TeleCallerFollowupHistoryRequestEvent) {
      yield* _mapTeleCallerFollowupHistoryRequestEventToState(event);
    }
    if (event is InquiryShareEmpListRequestEvent) {
      yield* _mapInquiryShareEmpListEventToState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }

    if (event is TeleCallerFollowupSaveRequestEvent) {
      yield* _mapTeleCallerSaveRequestEventToState(event);
    }
    if (event is FollowupImageListRequestEvent) {
      yield* _mapFollowupImageListRequestEventToState(event);
    }

    if (event is FollowupCountRequestEvent) {
      yield* _mapFollowupCountRequestEventState(event);
    }

    if (event is FollowupPkIdDetailsRequestEvent) {
      yield* _mapFollowupPkIdDetailsRequestEventState(event);
    }
    //
  }

  ///event functions to states implementation
  Stream<FollowupStates> _mapFollowupListCallEventToState(
      FollowupListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupListResponse response = await userRepository.getFollowupList(
          event.pageNo, event.followupListApiRequest);
      yield FollowupListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///event functions to states implementation
  Stream<FollowupStates> _mapFollowupListbyStatusCallEventToState(
      SearchFollowupListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupListResponse response =
          await userRepository.getFollowupListbyStatus(event.request);
      yield SearchFollowupListByStatusCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupCustomerListByNameCallEventToState(
      SearchFollowupCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield FollowupCustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupInquiryNoStatusListCallEventToState(
      FollowupInquiryNoListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupInquiryNoListResponse response = await userRepository
          .getInquiryNoStatusList(event.followerInquiryNoListRequest);
      yield FollowupInquiryNoListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupSaveStatusListCallEventToState(
      FollowupSaveByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupSaveSuccessResponse response = await userRepository
          .getFollowupSaveStatus(event.pkID, event.followupSaveApiRequest);
      yield FollowupSaveCallResponseState(event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapQuickFollowupSaveStatusListCallEventToState(
      QuickFollowupSaveByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupSaveSuccessResponse response = await userRepository
          .getQuickFollowupSaveStatus(event.pkID, event.followupSaveApiRequest);
      yield FollowupSaveCallResponseState(event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

/*  Stream<FollowupStates> _mapFollowupDeleteCallEventToState(
      FollowupDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupDeleteResponse response =
      await userRepository.getFollowupDeleteStatus(event.pkID,event.followupDeleteRequest);
      yield FollowupDeleteCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  Stream<FollowupStates> _mapDeleteInquiryCallEventToState(
      FollowupDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupDeleteResponse followupDeleteResponse = await userRepository
          .deleteFollowup(event.pkID, event.followupDeleteRequest);
      yield FollowupDeleteCallResponseState(followupDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapQuickFollowupDeleteInquiryCallEventToState(
      QuickFollowupDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupDeleteResponse followupDeleteResponse = await userRepository
          .deleteQuickFollowup(event.pkID, event.followupDeleteRequest);
      yield FollowupDeleteCallResponseState(followupDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupFilterListCallEventToState(
      FollowupFilterListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupFilterListResponse response =
          await userRepository.getFollowupFilterList(
              event.filtername, event.followupFilterListRequest);
      yield FollowupFilterListCallResponseState(
          event.followupFilterListRequest.PageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupInquiryByCustomerCallEventToState(
      FollowupInquiryByCustomerIDCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupInquiryByCustomerIDResponse response =
          await userRepository.getFollowupInquiryByCustomerID(
              event.followerInquiryByCustomerIDRequest);
      yield FollowupInquiryByCustomerIdCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  /* Stream<FollowupStates> _mapFollowupTypeListCallEventToState(
      FollowupTypeListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupTypeListResponse response =
      await userRepository.getFollowupTypeList(event.followupTypeListRequest);
      yield FollowupTypeListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  Stream<FollowupStates> _mapFollowupUploadImageCallEventToState(
      FollowupUploadImageNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupImageUploadResponse response =
          await userRepository.getFollowupuploadImage(
              event.expenseImageFile, event.expenseUploadImageAPIRequest);
      // print("RESPPDDDD" +  await userRepository.getuploadImage(event.expenseUploadImageAPIRequest).toString());
      yield FollowupUploadImageCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates>
      _mapFollowupUploadImageFromMainFollowupCallEventToState(
          FollowupUploadImageNameFromMainFollowupCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupImageUploadResponse response =
          await userRepository.getFollowupuploadImage(
              event.expenseImageFile, event.expenseUploadImageAPIRequest);
      // print("RESPPDDDD" +  await userRepository.getuploadImage(event.expenseUploadImageAPIRequest).toString());
      yield FollowupUploadImageFromMainFollowupCallResponseState(
          event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupImageDeleteCallEventToState(
      FollowupImageDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupDeleteImageResponse response =
          await userRepository.getFollowupImageDeleteByPkID(
              event.pkID, event.followupImageDeleteRequest);
      yield FollowupImageDeleteCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupTypeListCallEventToState(
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

  Stream<FollowupStates> _mapFollowupInquiryStatusListCallEventToState(
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

  Stream<FollowupStates> _mapCloserReasonStatusListCallEventToState(
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

  Stream<FollowupStates> _mapFollowupHistoryListCallEventToState(
      FollowupHistoryListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FollowupHistoryListResponse response = await userRepository
          .getFollowupHistoryList(event.followupHistoryListRequest);
      yield FollowupHistoryListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapQuickFollowupEventToState(
      QuickFollowupListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuickFollowupListResponse response = await userRepository
          .getQuickFollowupListAPi(event.quickFollowupListRequest);
      yield QuickFollowupListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _map_fcm_notificationEvent_state(
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

  Stream<FollowupStates> _map_GetReportToTokenRequestEventState(
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

  Stream<FollowupStates> _mapComlaintFollowupHistoryListEventToState(
      AccuraBathComplaintFollowupHistoryListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AccuraBathComplaintFollowupHistoryListResponse response =
          await userRepository.getComplaintFollowupHistoryListAPI(
              event.complaintFollowupHistoryListRequest);
      yield AccuraBathComplaintFollowupHistoryListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapAccuraBathComlaintFollowupEventToState(
      AccuraBathComplaintFollowupSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AccuraBathComplaintFollowupSaveResponse response =
          await userRepository.getComplaintFollowupSaveAPI(
              event.pkID, event.complaintFollowupSaveRequest);
      yield AccuraBathComplaintFollowupSaveResponseState(
          event.context, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapTeleCallerFollowupHistoryRequestEventToState(
      TeleCallerFollowupHistoryRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      TeleCallerFollowupHestoryResponse response =
          await userRepository.getTeleCallerFollowupHistoryList(event.request);
      yield TeleCallerFollowupHestoryResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapInquiryShareEmpListEventToState(
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

  Stream<FollowupStates> _mapUserMenuRightsRequestEventState(
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

  Stream<FollowupStates> _mapTeleCallerSaveRequestEventToState(
      TeleCallerFollowupSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TeleCallerFollowupSaveResponse respo =
          await userRepository.teleCallerFollowupFromFollowupSaveDetails(
              event.followuppkID, event.request);
      yield TeleCallerFollowupSaveResponseState(event.context, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupImageListRequestEventToState(
      FollowupImageListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      FollowupImageListResponse respo =
          await userRepository.followupImageListAPI(event.pkID, event.request);
      yield FollowupImageListResponseState(event.pkID, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupCountRequestEventState(
      FollowupCountRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo =
          await userRepository.followupCount(event.Status, event.request);
      yield FollowUpCountState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FollowupStates> _mapFollowupPkIdDetailsRequestEventState(
      FollowupPkIdDetailsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      FollowupPkIdDetailsResponse respo = await userRepository
          .followuppkIDtoDetailsAPI(event.followupPkIdDetailsRequest);
      yield FollowupPkIdDetailsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
