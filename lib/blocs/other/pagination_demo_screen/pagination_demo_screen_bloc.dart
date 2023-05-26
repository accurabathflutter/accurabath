import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/other/pagination_demo_list_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'pagination_demo_screen_events.dart';
part 'pagination_demo_screen_states.dart';

class PaginationDemoScreenBloc
    extends Bloc<PaginationDemoScreenEvents, PaginationDemoScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  PaginationDemoScreenBloc(this.baseBloc)
      : super(PaginationDemoScreenInitialState());

  @override
  Stream<PaginationDemoScreenStates> mapEventToState(
      PaginationDemoScreenEvents event) async* {
    /// sets state based on events
    if (event is GetListCallEvent) {
      yield* _mapGetListCallEventToState(event);
    }
  }

  ///event functions to states implementation
  Stream<PaginationDemoScreenStates> _mapGetListCallEventToState(
      GetListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      PaginationDemoListResponse response =
          await userRepository.getList(event.pageNo);
      yield GetListCallEventResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
