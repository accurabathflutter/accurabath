part of 'todo_bloc.dart';

abstract class ToDoStates extends BaseStates {
  const ToDoStates();
}

///all states of AuthenticationStates
class ToDoInitialState extends ToDoStates {}

class ToDoListCallResponseState extends ToDoStates {
  final ToDoListResponse response;
  final int newPage;
  ToDoListCallResponseState(this.response, this.newPage);
}

class ToDoTodayListCallResponseState extends ToDoStates {
  final OfficeToDoListResponse response;
  int newPage;
  ToDoTodayListCallResponseState(this.response, this.newPage);
}

class ToDoPendingOverDueListResponseState extends ToDoStates {
  final OfficeToDoListResponse response;
  int newPage;
  ToDoPendingOverDueListResponseState(this.response, this.newPage);
}

class ToDoFutureListCallResponseState extends ToDoStates {
  final OfficeToDoListResponse response;
  int newPage;

  ToDoFutureListCallResponseState(this.response, this.newPage);
}

class ToDoOverDueListCallResponseState extends ToDoStates {
  final OfficeToDoListResponse response;
  int newPage;

  ToDoOverDueListCallResponseState(this.response, this.newPage);
}

class ToDoCompletedListCallResponseState extends ToDoStates {
  final OfficeToDoListResponse response;
  int newPage;
  ToDoCompletedListCallResponseState(this.response, this.newPage);
}

class TaskCategoryCallResponseState extends ToDoStates {
  final TaskCategoryResponse taskCategoryResponse;

  TaskCategoryCallResponseState(this.taskCategoryResponse);
}

class ToDoSaveHeaderState extends ToDoStates {
  BuildContext context;
  final ToDoSaveHeaderResponse toDoSaveHeaderResponse;

  ToDoSaveHeaderState(this.context, this.toDoSaveHeaderResponse);
}

class ToDoSaveSubDetailsState extends ToDoStates {
  BuildContext context;
  final ToDoSaveSubDetailsResponse toDoSaveSubDetailsResponse;

  ToDoSaveSubDetailsState(this.context, this.toDoSaveSubDetailsResponse);
}

class ToDoWorkLogListState extends ToDoStates {
  final ToDoWorkLogListResponse toDoWorkLogListResponse;

  ToDoWorkLogListState(this.toDoWorkLogListResponse);
}

class ToDoDeleteResponseState extends ToDoStates {
  final ToDoDeleteResponse toDoDeleteResponse;

  ToDoDeleteResponseState(this.toDoDeleteResponse);
}

class FollowupCustomerListByNameCallResponseState extends ToDoStates {
  final CustomerLabelvalueRsponse response;

  FollowupCustomerListByNameCallResponseState(this.response);
}

class FCMNotificationResponseState extends ToDoStates {
  final FCMNotificationResponse response;

  FCMNotificationResponseState(this.response);
}

class GetReportToTokenResponseState extends ToDoStates {
  final GetReportToTokenResponse response;

  GetReportToTokenResponseState(this.response);
}

class UserMenuRightsResponseState extends ToDoStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class FollowupFilterListCallResponseState extends ToDoStates {
  final FollowupFilterListResponse followupFilterListResponse;
  final int newPage;

  FollowupFilterListCallResponseState(
      this.newPage, this.followupFilterListResponse);
}

class FollowupMissedFilterListCallResponseState extends ToDoStates {
  final FollowupFilterListResponse followupFilterListResponse;
  final int newPage;

  FollowupMissedFilterListCallResponseState(
      this.newPage, this.followupFilterListResponse);
}

class FollowupFutureFilterListCallResponseState extends ToDoStates {
  final FollowupFilterListResponse followupFilterListResponse;
  final int newPage;

  FollowupFutureFilterListCallResponseState(
      this.newPage, this.followupFilterListResponse);
}

class AttendanceListCallResponseState extends ToDoStates {
  final Attendance_List_Response response;
  AttendanceListCallResponseState(this.response);
}

class ConstantResponseState extends ToDoStates {
  final ConstantResponse response;

  ConstantResponseState(this.response);
}

class PunchAttendenceSaveResponseState extends ToDoStates {
  final PunchAttendenceSaveResponse punchAttendenceSaveResponse;

  PunchAttendenceSaveResponseState(this.punchAttendenceSaveResponse);
}

class AttendanceSaveCallResponseState extends ToDoStates {
  final AttendanceSaveResponse response;
  AttendanceSaveCallResponseState(this.response);
}

class PunchWithoutAttendenceSaveResponseState extends ToDoStates {
  final PunchWithoutAttendenceSaveResponse response;

  PunchWithoutAttendenceSaveResponseState(this.response);
}
