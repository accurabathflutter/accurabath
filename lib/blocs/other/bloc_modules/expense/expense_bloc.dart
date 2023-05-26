import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/expense/expense_delete_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/expense/expense_image_upload_server_request.dart';
import 'package:for_practice_the_app/models/api_requests/expense/expense_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/expense/expense_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/expense/expense_type_request.dart';
import 'package:for_practice_the_app/models/api_requests/expense/expense_upload_image_request.dart';
import 'package:for_practice_the_app/models/api_requests/expense/fetc_image_list_by_expense_pk_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_request.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/attendance_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_delete_image_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_image_upload_server_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_type_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_upload_image_response.dart';
import 'package:for_practice_the_app/models/api_responses/external_leads/fetch_image_by_expense_pk_id_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'expense_events.dart';
part 'expense_states.dart';

class ExpenseBloc extends Bloc<ExpenseEvents, ExpenseStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ExpenseBloc(this.baseBloc) : super(ExpenseInitialState());

  @override
  Stream<ExpenseStates> mapEventToState(ExpenseEvents event) async* {
    /// sets state based on events
    if (event is ExpenseEventsListCallEvent) {
      yield* _mapExpenseListCallEventToState(event);
    }
    if (event is ExpenseDeleteByNameCallEvent) {
      yield* _mapDeleteExpenseCallEventToState(event);
    }

    if (event is ExpenseSaveByNameCallEvent) {
      yield* _mapExpenseSaveStatusListCallEventToState(event);
    }
    if (event is ExpenseUploadImageNameCallEvent) {
      yield* _mapExpenseUploadImageCallEventToState(event);
    }
    if (event is ExpenseImageUploadServerNameCallEvent) {
      yield* _mapExpenseImageUploadServerCallEventToState(event);
    }
    if (event is ExpenseDeleteImageNameCallEvent) {
      yield* _mapExpenseDeleteImageCallEventToState(event);
    }

    if (event is ExpenseEmployeeListCallEvent) {
      yield* _mapAttendanceEmployeeListCallEventToState(event);
    }
    if (event is FetchImageListByExpensePKID_RequestCallEvent) {
      yield* _mapFetchImageListByExpenseIDEventToState(event);
    }

    if (event is ExpenseTypeByNameCallEvent) {
      yield* _mapExpenseTypeCallEventToState(event);
    }
    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }
  }

  Stream<ExpenseStates> _mapExpenseListCallEventToState(
      ExpenseEventsListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ExpenseListResponse response = await userRepository.getExpenseList(
          event.pageNo, event.expenseListAPIRequest);
      yield ExpenseListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ExpenseStates> _mapDeleteExpenseCallEventToState(
      ExpenseDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ExpenseDeleteResponse expenseDeleteResponse = await userRepository
          .deleteExpense(event.pkID, event.followupDeleteRequest);
      yield ExpenseDeleteCallResponseState(expenseDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ExpenseStates> _mapExpenseSaveStatusListCallEventToState(
      ExpenseSaveByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ExpsenseSaveResponse response = await userRepository.getExpenseSave(
          event.pkID, event.expenseSaveAPIRequest);
      yield ExpenseSaveCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ExpenseStates> _mapExpenseUploadImageCallEventToState(
      ExpenseUploadImageNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      /*  for(var i=0;i<event.expenseImageFile.length;i++)
        {*/
      ExpenseUploadImageResponse expenseUploadImageResponse =
          await userRepository.getuploadImage(
              event.expenseImageFile[0],
              /*event.expenseUploadImageAPIRequest.ExpenseID,

              event.expenseUploadImageAPIRequest.CompanyId,
              event.expenseUploadImageAPIRequest.LoginUserId,
              event.expenseImageFile[i].path.split('/').last,event.expenseUploadImageAPIRequest.Type,event.expenseUploadImageAPIRequest.pkID*/
              event.expenseUploadImageAPIRequest);

      /* }*/
      // print("RESPPDDDD" +  await userRepository.getuploadImage(event.expenseUploadImageAPIRequest).toString());
      yield ExpenseUploadImageCallResponseState(expenseUploadImageResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ExpenseStates> _mapExpenseImageUploadServerCallEventToState(
      ExpenseImageUploadServerNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ExpenseImageUploadServerAPIResponse response = await userRepository
          .getExpenseImageUploadserer(event.expenseImageUploadServerAPIRequest);
      yield ExpenseImageUploadServerCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ExpenseStates> _mapExpenseDeleteImageCallEventToState(
      ExpenseDeleteImageNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      ExpenseDeleteImageResponse response = await userRepository
          .getDeleteExpenseImage(event.pkID, event.expenseDeleteImageRequest);
      yield ExpenseDeleteImageCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ExpenseStates> _mapAttendanceEmployeeListCallEventToState(
      ExpenseEmployeeListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendanceEmployeeListResponse respo = await userRepository
          .attendanceEmployeeList(event.attendanceEmployeeListRequest);
      yield ExpenseEmployeeListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ExpenseStates> _mapFetchImageListByExpenseIDEventToState(
      FetchImageListByExpensePKID_RequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      FetchImageListByExpensePKID_Response respo =
          await userRepository.fetchImageListbyExpensePKID(
              event.fetchImageListByExpensePKID_Request);
      yield FetchImageListByExpensePKID_ResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ExpenseStates> _mapExpenseTypeCallEventToState(
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
  }

  Stream<ExpenseStates> _mapUserMenuRightsRequestEventState(
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
