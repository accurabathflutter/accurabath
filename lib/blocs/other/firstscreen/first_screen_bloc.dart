import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/company_details/company_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/constant_master/constant_request.dart';
import 'package:for_practice_the_app/models/api_requests/login/login_user_details_api_request.dart';
import 'package:for_practice_the_app/models/api_responses/MasterBaseURL/master_base_url_response.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/constant_master/constant_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'first_screen_events.dart';
part 'first_screen_states.dart';

class FirstScreenBloc extends Bloc<FirstScreenEvents, FirstScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  FirstScreenBloc(this.baseBloc) : super(FirstScreenInitialState());

  @override
  Stream<FirstScreenStates> mapEventToState(FirstScreenEvents event) async* {
    /// sets state based on events
    if (event is CompanyDetailsCallEvent) {
      yield* _mapCompanyDetailsCallEventToState(event);
    }

    if (event is MasterBaseURLCallEvent) {
      yield* _mapMasterBaseURLCallEventState(event);
    }
    if (event is LoginUserDetailsCallEvent) {
      yield* _mapLoginUserDetailsCallEventToState(event);
    }
    if (event is ConstantRequestEvent) {
      yield* _mapConstantRequestEventToState(event);
    }
  }

  ///event functions to states implementation
  Stream<FirstScreenStates> _mapCompanyDetailsCallEventToState(
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

  Stream<FirstScreenStates> _mapMasterBaseURLCallEventState(
      MasterBaseURLCallEvent event) async* {
    try {
      print("uuuuuuu");
      baseBloc.emit(ShowProgressIndicatorState(true));

      //call your api as follows
      MasterBaseURLResponse companyDetailsResponse =
          await userRepository.MasterBaseURLAPI(event.companyDetailsApiRequest);
      yield MasterBaseURLResponseState(companyDetailsResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///event functions to states implementation
  Stream<FirstScreenStates> _mapLoginUserDetailsCallEventToState(
      LoginUserDetailsCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      LoginUserDetialsResponse loginResponse =
          await userRepository.loginUserDetailsCall(event.request);
      yield LoginUserDetialsCallEventResponseState(loginResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<FirstScreenStates> _mapConstantRequestEventToState(
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
}
