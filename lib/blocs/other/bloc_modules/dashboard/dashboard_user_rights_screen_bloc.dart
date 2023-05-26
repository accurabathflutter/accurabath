import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_request/Logout_Count/logout_count_request.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/api_response/LogOut_Count/log_out_count_response.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/api_token/api_token_update_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/punch_attendence_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/punch_without_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/company_details/company_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/constant_master/constant_request.dart';
import 'package:for_practice_the_app/models/api_requests/employee/employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_status_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/all_employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/follower_employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/menu_rights_request.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/attendance_response_list.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/attendance_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/punch_attendence_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/punch_without_image_response.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/constant_master/constant_response.dart';
import 'package:for_practice_the_app/models/api_responses/employee/employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/firebase_token/firebase_token_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_status_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/all_employee_List_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'dashboard_user_rights_screen_event.dart';
part 'dashboard_user_rights_screen_state.dart';

class DashBoardScreenBloc
    extends Bloc<DashBoardScreenEvents, DashBoardScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  DashBoardScreenBloc(this.baseBloc) : super(MenuRightsScreenInitialState());

  @override
  Stream<DashBoardScreenStates> mapEventToState(
      DashBoardScreenEvents event) async* {
    // TODO: implement mapEventToState
    if (event is MenuRightsCallEvent) {
      yield* _mapMenuRightsCallEventToState(event);
    }
    /*if(event is CustomerCategoryCallEvent)
    {
      yield* _mapCustomerCategoryCallEventToState(event);
    }*/
    /* if(event is CustomerSourceCallEvent)
    {
      yield* _mapCustomerSourceCallEventToState(event);
    }*/
    /* if(event is DesignationCallEvent)
    {
      yield* _mapDesignationListCallEventToState(event);
    }*/
    /* if(event is InquiryLeadStatusTypeListByNameCallEvent){
      yield* _mapFollowupInquiryStatusListCallEventToState(event);
    }*/
    if (event is FollowerEmployeeListCallEvent) {
      yield* _mapFollowerEmployeeByStatusCallEventToState(event);
    }
    if (event is ALLEmployeeNameCallEvent) {
      yield* _mapALLEmployeeNameListCallEventToState(event);
    }

    if (event is AttendanceCallEvent) {
      yield* _mapAttendanceCallEventToState(event);
    }

    if (event is AttendanceSaveCallEvent) {
      yield* _mapAttendanceSaveCallEventToState(event);
    }

    if (event is EmployeeListCallEvent) {
      yield* _mapBankVoucherListCallEventToState(event);
    }
    if (event is APITokenUpdateRequestEvent) {
      yield* _map_api_token_updateEventState(event);
    }
    if (event is PunchOutWebMethodEvent) {
      yield* _map_api_PunchOut_webMethod(event);
    }

    if (event is PunchAttendanceSaveRequestEvent) {
      yield* _mapPunchAttendanceSaveRequestEventToState(event);
    }

    if (event is PunchWithoutImageAttendanceSaveRequestEvent) {
      yield* _mapPunchWithoutImageAttendanceSaveRequestEventToState(event);
    }

    if (event is ConstantRequestEvent) {
      yield* _mapConstantRequestEventToState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }

    if (event is CompanyDetailsCallEvent) {
      yield* _mapCompanyDetailsCallEventToState(event);
    }

    if (event is LogoutCountRequestEvent) {
      yield* _mapLogoutCountRequestEventState(event);
    }
/*    if(event is CloserReasonTypeListByNameCallEvent)
    {
      yield* _mapCloserReasonStatusListCallEventToState(event);

    }*/
/*    if(event is LeaveRequestTypeCallEvent)
    {
      yield* _mapLeaveRequestTypeCallEventToState(event);
    }*/
    /*if(event is ExpenseTypeByNameCallEvent)
    {
      yield* _mapExpenseTypeCallEventToState(event);

    }*/
  }

  Stream<DashBoardScreenStates> _mapMenuRightsCallEventToState(
      MenuRightsCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      // CustomerCategoryResponse loginResponse =

      /* List<CustomerCategoryResponse> customercategoryresponse*/
      MenuRightsResponse respo =
          await userRepository.menu_rights_api(event.menuRightsRequest);
      //print("TypeErrorSolved : " + respo.toString());
      //CustomerCategoryResponseFromJson(respo);
      yield MenuRightsEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

/*  Stream<InquiryStates> _mapSearchInquiryListByNumberCallEventToState(
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
  }*/
  /* Stream<DashBoardScreenStates> _mapCustomerCategoryCallEventToState(
      CustomerCategoryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerCategoryResponse respo =  await userRepository.customer_Category_List_call(event.request1);
      yield CustomerCategoryCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/
  /*Stream<DashBoardScreenStates> _mapCustomerSourceCallEventToState(
      CustomerSourceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerSourceResponse respo =  await userRepository.customer_Source_List_call(event.request1);
      yield CustomerSourceCallEventResponseState(respo);

    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

/*  Stream<DashBoardScreenStates> _mapDesignationListCallEventToState(
      DesignationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DesignationApiResponse respo =  await userRepository.designation_list_details(event.designationApiRequest);
      yield DesignationListEventResponseState(respo);

    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  /* Stream<DashBoardScreenStates> _mapFollowupInquiryStatusListCallEventToState(
      InquiryLeadStatusTypeListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      InquiryStatusListResponse response =
      await userRepository.getFollowupInquiryStatusList(event.followupInquiryStatusTypeListRequest);
      yield InquiryLeadStatusListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/
  Stream<DashBoardScreenStates> _mapFollowerEmployeeByStatusCallEventToState(
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

  ///event functions to states implementation
  /* Stream<DashBoardScreenStates> _mapFollowupTypeListCallEventToState(
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

  /* Stream<DashBoardScreenStates> _mapCloserReasonStatusListCallEventToState(
      CloserReasonTypeListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CloserReasonListResponse response =
      await userRepository.getCloserReasonStatusList(event.closerReasonTypeListRequest);
      yield CloserReasonListCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

/*  Stream<DashBoardScreenStates> _mapLeaveRequestTypeCallEventToState(
      LeaveRequestTypeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      LeaveRequestTypeResponse response =
      await userRepository.getLeaveRequestType(event.leaveRequestTypeAPIRequest);
      yield LeaveRequestTypeResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  /* Stream<DashBoardScreenStates> _mapExpenseTypeCallEventToState(
      ExpenseTypeByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ExpenseTypeResponse response =
      await userRepository.getExpenseType(event.expenseTypeAPIRequest);
      yield ExpenseTypeCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }*/

  Stream<DashBoardScreenStates> _mapALLEmployeeNameListCallEventToState(
      ALLEmployeeNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ALL_EmployeeList_Response response =
          await userRepository.getALLEmployeeList(event.allEmployeeNameRequest);
      yield ALL_EmployeeNameListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _mapAttendanceCallEventToState(
      AttendanceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      // CustomerCategoryResponse loginResponse =

      /* List<CustomerCategoryResponse> customercategoryresponse*/
      Attendance_List_Response respo =
          await userRepository.getAttendanceList(event.attendanceApiRequest);

      yield AttendanceListCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _mapAttendanceSaveCallEventToState(
      AttendanceSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendanceSaveResponse respo =
          await userRepository.DashBoardattendanceSave(
              event.attendanceSaveApiRequest);
      yield AttendanceSaveCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _mapBankVoucherListCallEventToState(
      EmployeeListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      EmployeeListResponse response = await userRepository
          .getEmployeeListWithOneImage(event.pageNo, event.employeeListRequest);
      yield EmployeeListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _map_api_token_updateEventState(
      APITokenUpdateRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      FirebaseTokenResponse response = await userRepository
          .getAPIUpdateTokenAPI(event.apiTokenUpdateRequest);

      // print("ldjdsf" + response);
      yield APITokenUpdateState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _map_api_PunchOut_webMethod(
      PunchOutWebMethodEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      var response =
          await userRepository.getPunchOutWebMethodAPI(event.getrequest);

      print("ldjdsf" + response.toString());
      yield PunchOutWebMethodState(response.toString());
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _mapPunchAttendanceSaveRequestEventToState(
      PunchAttendanceSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PunchAttendenceSaveResponse response = await userRepository
          .getPunchIN_API(event.file, event.punchAttendanceSaveRequest);
      yield PunchAttendenceSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates>
      _mapPunchWithoutImageAttendanceSaveRequestEventToState(
          PunchWithoutImageAttendanceSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PunchWithoutAttendenceSaveResponse respo =
          await userRepository.getwithoutImageAttendanceSaveAPI(event.request);
      yield PunchWithoutAttendenceSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _mapConstantRequestEventToState(
      ConstantRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ConstantResponse respo =
          await userRepository.getConstantAPI(event.CompanyID, event.request);
      yield ConstantResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _mapUserMenuRightsRequestEventState(
      UserMenuRightsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      UserMenuRightsResponse respo = await userRepository.user_menurightsapi(
          event.MenuID, event.userMenuRightsRequest);
      yield UserMenuRightsResponseState(event.MenuScreenName, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _mapCompanyDetailsCallEventToState(
      CompanyDetailsCallEvent event) async* {
    try {
      print("uuuuuuu");
      baseBloc.emit(ShowProgressIndicatorState(true));

      //call your api as follows
      CompanyDetailsResponse companyDetailsResponse =
          await userRepository.CompanyDetailsCallApi(
              event.companyDetailsApiRequest);
      yield ComapnyDetailsEventResponseState(companyDetailsResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DashBoardScreenStates> _mapLogoutCountRequestEventState(
      LogoutCountRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      LogOutCountResponse response =
          await userRepository.getLogoutCount(event.request);
      yield LogOutCountResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
