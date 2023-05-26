import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_employee_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/attendance/attendance_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/location_address_request.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/attendance_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/attendance_response_list.dart';
import 'package:for_practice_the_app/models/api_responses/attendance/attendance_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/location_address_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'attendance_events.dart';
part 'attendance_states.dart';

class AttendanceBloc extends Bloc<AttendanceEvents, AttendanceStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  AttendanceBloc(this.baseBloc) : super(AttendanceInitialState());

  @override
  Stream<AttendanceStates> mapEventToState(AttendanceEvents event) async* {
    /// sets state based on events
    if (event is AttendanceCallEvent) {
      yield* _mapAttendanceCallEventToState(event);
    }
    if (event is AttendanceSaveCallEvent) {
      yield* _mapAttendanceSaveCallEventToState(event);
    }
    if (event is AttendanceEmployeeListCallEvent) {
      yield* _mapAttendanceEmployeeListCallEventToState(event);
    }
    if (event is LocationAddressCallEvent) {
      yield* _mapLocationAddressEventToState(event);
    }
  }

  Stream<AttendanceStates> _mapAttendanceCallEventToState(
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

  Stream<AttendanceStates> _mapAttendanceEmployeeListCallEventToState(
      AttendanceEmployeeListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendanceEmployeeListResponse respo = await userRepository
          .attendanceEmployeeList(event.attendanceEmployeeListRequest);
      yield AttendanceEmployeeListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendanceStates> _mapAttendanceSaveCallEventToState(
      AttendanceSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendanceSaveResponse respo =
          await userRepository.attendanceSave(event.attendanceSaveApiRequest);
      yield AttendanceSaveCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendanceStates> _mapLocationAddressEventToState(
      LocationAddressCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      LocationAddressResponse locationAddressResponse =
          await userRepository.location_address(event.locationAddressRequest);
      yield LocationAddressResponseState(locationAddressResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
