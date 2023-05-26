import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/daily_activity/daily_activity_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/daily_activity/daily_activity_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/daily_activity/daily_activity_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/toDo_request/task_category_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/daily_activity/daily_activity_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/daily_activity/daily_activity_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/daily_activity/daily_activity_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/to_do/task_category_list_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'dailyactivity_events.dart';
part 'dailyactivity_states.dart';

class DailyActivityScreenBloc
    extends Bloc<DailyActivityScreenEvents, DailyActivityScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  DailyActivityScreenBloc(this.baseBloc)
      : super(DailyActivityScreenInitialState());

  @override
  Stream<DailyActivityScreenStates> mapEventToState(
      DailyActivityScreenEvents event) async* {
    if (event is DailyActivityListCallEvent) {
      yield* _mapDailyActivityListCallEventToState(event);
    }
    if (event is DailyActivityDeleteByNameCallEvent) {
      yield* _mapDeletedDailyActivityCallEventToState(event);
    }

    if (event is TaskCategoryListCallEvent) {
      yield* _mapTaskCategoryCallEventToState(event);
    }

    if (event is DailyActivitySaveByNameCallEvent) {
      yield* _mapSaveDailyActivityCallEventToState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }
  }

  Stream<DailyActivityScreenStates> _mapDailyActivityListCallEventToState(
      DailyActivityListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DailyActivityListResponse response = await userRepository
          .getDailyActivityList(event.pageNo, event.dailyActivityListRequest);
      yield DailyActivityCallResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DailyActivityScreenStates> _mapDeletedDailyActivityCallEventToState(
      DailyActivityDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      DailyActivityDeleteResponse customerDeleteResponse = await userRepository
          .deleteDailyActivity(event.pkID, event.dailyActivityDeleteRequest);
      yield DailyActivityDeleteCallResponseState(customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DailyActivityScreenStates> _mapTaskCategoryCallEventToState(
      TaskCategoryListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      TaskCategoryResponse customerDeleteResponse = await userRepository
          .taskCategoryDetails(event.taskCategoryListRequest);
      yield TaskCategoryCallResponseState(customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DailyActivityScreenStates> _mapSaveDailyActivityCallEventToState(
      DailyActivitySaveByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      DailyActivitySaveResponse dailyActivitySaveResponse = await userRepository
          .saveDailyActivity(event.pkID, event.dailyActivitySaveRequest);
      yield DailyActivitySaveCallResponseState(dailyActivitySaveResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DailyActivityScreenStates> _mapUserMenuRightsRequestEventState(
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
