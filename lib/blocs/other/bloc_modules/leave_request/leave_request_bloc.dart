import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/leave_request/leave_approval_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/leave_request/leave_request_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/leave_request/leave_request_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/leave_request/leave_request_type_request.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/attendance_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/leave_request/leave_approval_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/leave_request/leave_request_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/leave_request/leave_request_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/leave_request/leave_request_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/leave_request/leave_request_type_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/models/pushnotification/fcm_notification_response.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'leave_request_event.dart';
part 'leave_request_states.dart';

class LeaveRequestScreenBloc
    extends Bloc<LeaveRequestEvents, LeaveRequestStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  LeaveRequestScreenBloc(this.baseBloc)
      : super(LeaveRequestStatesInitialState());

  @override
  Stream<LeaveRequestStates> mapEventToState(LeaveRequestEvents event) async* {
    // TODO: implement mapEventToState
    if (event is LeaveRequestCallEvent) {
      yield* _mapLeaveRequestListCallEventToState(event);
    }
    if (event is LeaveRequestEmployeeListCallEvent) {
      yield* _mapAttendanceEmployeeListCallEventToState(event);
    }
    if (event is LeaveRequestDeleteByNameCallEvent) {
      yield* _mapDeleteLeaveRequestCallEventToState(event);
    }

    if (event is LeaveRequestSaveCallEvent) {
      yield* _mapLeaveRequestSaveCallEventToState(event);
    }
    if (event is LeaveRequestApprovalSaveCallEvent) {
      yield* _mapLeaveApprovalSaveCallEventToState(event);
    }

    if (event is LeaveRequestTypeCallEvent) {
      yield* _mapLeaveRequestTypeCallEventToState(event);
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
  }

  Stream<LeaveRequestStates> _mapLeaveRequestListCallEventToState(
      LeaveRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      LeaveRequestListResponse response = await userRepository
          .getLeaveRequestList(event.pageNo, event.leaveRequestListAPIRequest);
      yield LeaveRequestStatesResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LeaveRequestStates> _mapAttendanceEmployeeListCallEventToState(
      LeaveRequestEmployeeListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendanceEmployeeListResponse respo = await userRepository
          .attendanceEmployeeList(event.attendanceEmployeeListRequest);
      yield LeaveRequestEmployeeListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LeaveRequestStates> _mapDeleteLeaveRequestCallEventToState(
      LeaveRequestDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      LeaveRequestDeleteResponse leaveRequestDeleteResponse =
          await userRepository.deleteLeaveRequest(
              event.pkID, event.leaverequestdelete);
      yield LeaveRequestDeleteCallResponseState(leaveRequestDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///event functions to states implementation

  Stream<LeaveRequestStates> _mapLeaveRequestSaveCallEventToState(
      LeaveRequestSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      LeaveRequestSaveResponse response = await userRepository
          .getLeaveRequestSave(event.pkID, event.leaveRequestSaveAPIRequest);
      yield LeaveRequestSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LeaveRequestStates> _mapLeaveApprovalSaveCallEventToState(
      LeaveRequestApprovalSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      LeaveApprovalSaveResponse response = await userRepository
          .getLeaveApprovalSave(event.pkID, event.leaveApprovalSaveAPIRequest);
      yield LeaveApprovalSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LeaveRequestStates> _mapLeaveRequestTypeCallEventToState(
      LeaveRequestTypeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      LeaveRequestTypeResponse response = await userRepository
          .getLeaveRequestType(event.leaveRequestTypeAPIRequest);
      yield LeaveRequestTypeResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LeaveRequestStates> _map_fcm_notificationEvent_state(
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

  Stream<LeaveRequestStates> _map_GetReportToTokenRequestEventState(
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

  Stream<LeaveRequestStates> _mapUserMenuRightsRequestEventState(
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
}
