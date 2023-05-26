import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_complain_history_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_complain_pkid_to_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_sound_complain_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_sound_complain_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_sound_complaint_save_request.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/vk_sound_complaint/vk_complain_history_response.dart';
import 'package:for_practice_the_app/models/api_responses/vk_sound_complaint/vk_complain_pkid_to_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/vk_sound_complaint/vk_sound_complain_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/vk_sound_complaint/vk_sound_complaint_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/vk_sound_complaint/vk_sound_complaint_save_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'vk_sound_complaint_event.dart';
part 'vk_sound_complaint_state.dart';

class VkComplaintScreenBloc
    extends Bloc<VkComplaintScreenEvents, VkComplaintScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  VkComplaintScreenBloc(this.baseBloc) : super(VkComplaintScreenInitialState());

  @override
  Stream<VkComplaintScreenStates> mapEventToState(
      VkComplaintScreenEvents event) async* {
    if (event is VkComplaintListRequestEvent) {
      yield* _mapComplaintListCallEventToState(event);
    }

    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }

    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }

    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }

    if (event is VkComplaintSaveRequestEvent) {
      yield* _mapVkComplaintSaveRequestEventToState(event);
    }
    if (event is VkComplaintpkIDtoDetailsRequestEvent) {
      yield* _mapVkComplaintpkIDtoDetailsRequestEventToState(event);
    }

    if (event is VkComplaintDeleteRequestEvent) {
      yield* _mapVkComplaintDeleteRequestEventToState(event);
    }

    if (event is VkComplaintHistoryRequestEvent) {
      yield* _mapVkComplaintHistoryRequestEventToState(event);
    }

    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }
  }

  Stream<VkComplaintScreenStates> _mapComplaintListCallEventToState(
      VkComplaintListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      VkComplaintListResponse respo = await userRepository.vkComplaintListAPI(
          event.pageNo, event.vkComplaintListRequest);
      yield VkComplaintListResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<VkComplaintScreenStates> _mapCountryListCallEventToState(
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

  Stream<VkComplaintScreenStates> _mapStateListCallEventToState(
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

  Stream<VkComplaintScreenStates> _mapCityListCallEventToState(
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

  Stream<VkComplaintScreenStates> _mapVkComplaintSaveRequestEventToState(
      VkComplaintSaveRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      VkComplaintSaveResponse respo = await userRepository.vkComplaintSaveAPI(
          event.pkID, event.vkComplaintSaveRequest);
      yield VkComplaintSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<VkComplaintScreenStates>
      _mapVkComplaintpkIDtoDetailsRequestEventToState(
          VkComplaintpkIDtoDetailsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      VkComplainPkIDtoDetailsResponse respo =
          await userRepository.vkComplaintpkIDtoDetailsAPI(
              event.pkID, event.vkComplaintpkIDtoDetailsRequest);
      yield VkComplainPkIDtoDetailsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<VkComplaintScreenStates> _mapVkComplaintDeleteRequestEventToState(
      VkComplaintDeleteRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      VkComplaintDeleteResponse respo = await userRepository
          .vkComplaintDeleteAPI(event.pkID, event.vkComplaintDeleteRequest);
      yield VkComplaintDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<VkComplaintScreenStates> _mapVkComplaintHistoryRequestEventToState(
      VkComplaintHistoryRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      VkComplaintHistoryResponse respo = await userRepository
          .vkComplaintHistroyAPI(event.pkID, event.vkComplaintHistoryRequest);
      yield VkComplaintHistoryResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<VkComplaintScreenStates>
      _mapSearchCustomerListByNumberCallEventToState(
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
}
