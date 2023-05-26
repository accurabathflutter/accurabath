import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/product_drop_down_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/product_group_drop_down_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/packing/delete_all_packing_assambly_request.dart';
import 'package:for_practice_the_app/models/api_requests/packing/out_word_no_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/packing/packing_assambly_edit_mode_request.dart';
import 'package:for_practice_the_app/models/api_requests/packing/packing_check_list_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/packing/packing_checklist_list.dart';
import 'package:for_practice_the_app/models/api_requests/packing/packing_productassambly_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/packing/packing_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/packing/search_packingchecklist_request.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response_for_packing_checking.dart';
import 'package:for_practice_the_app/models/api_responses/other/product_drop_down_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/product_group_dropdown_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/packing/delete_all_packing_assambly_response.dart';
import 'package:for_practice_the_app/models/api_responses/packing/out_word_no_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/packing/packing_assambly_edit_mode_response.dart';
import 'package:for_practice_the_app/models/api_responses/packing/packing_assambly_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/packing/packing_check_list_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/packing/packing_checking_list.dart';
import 'package:for_practice_the_app/models/api_responses/packing/packing_product_assambly_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/packing/packing_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/packing/search_packingchecklist_label_response.dart';
import 'package:for_practice_the_app/models/common/packingProductAssamblyTable.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'packing_checklist_event.dart';
part 'packing_checklist_state.dart';

class PackingChecklistBloc
    extends Bloc<PackingChecklistListEvent, PackingChecklistListState> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ///Bloc Constructor
  PackingChecklistBloc(this.baseBloc)
      : super(PackingChecklistListInitialState());

  @override
  Stream<PackingChecklistListState> mapEventToState(
      PackingChecklistListEvent event) async* {
    /// Check If Event is Exist from below Function
    if (event is PackingChecklistListCallEvent) {
      yield* _mapPackingChecklistListEventToState(event);
    }
    if (event is SearchPackingChecklistCallEvent) {
      yield* _mapSearchPackingChecklistCallEventToState(event);
    }
    if (event is SearchPackingChecklistLabelCallEvent) {
      yield* _mapSearchPackingChecklistLabelCallEventToState(event);
    }

    if (event is PackingDeleteRequestCallEvent) {
      yield* _mapDeletePackingCheckListCallEventToState(event);
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

    if (event is OutWordCallEvent) {
      yield* _mapOutWordCallEventToState(event);
    }

    if (event is PackingProductAssamblyListRequestCallEvent) {
      yield* _mapPackingProductAssamblyListCallEventToState(event);
    }

    if (event is ProductGroupDropDownRequestCallEvent) {
      yield* _mapProductGroupDropDownCallEventToState(event);
    }
    if (event is ProductDropDownRequestCallEvent) {
      yield* _mapProductDropDownCallEventToState(event);
    }

    if (event is PackingSaveCallEvent) {
      yield* _mapPackingSaveCallEventToState(event);
    }
    if (event is PackingAssamblySaveCallEvent) {
      yield* _mapPackingAssamblySaveEventToState(event);
    }
    if (event is DeleteALLPackingAssamblyCallEvent) {
      yield* _mapDeleteAllPackingAssamblyCallEventToState(event);
    }

    if (event is PackingAssamblyEditModeRequestCallEvent) {
      yield* _mapPackingAssamblyEditModeCallEventToState(event);
    }
  }

  Stream<PackingChecklistListState> _mapPackingChecklistListEventToState(
      PackingChecklistListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      print("hi");
      PackingChecklistListResponse respo =
          await userRepository.PackingChecklistCall(
              event.pageNo, event.packingChecklistListRequest);

      yield PackingChecklistListCallResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      print(error.toString());

      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapSearchPackingChecklistCallEventToState(
      SearchPackingChecklistCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      print("hi");
      PackingChecklistListResponse respo = await userRepository
          .searchpackingchecklist(event.searchPackingChecklistRequest);

      yield SearchPackingChecklistCallResponseState(respo);
    } catch (error, stacktrace) {
      print(error.toString());

      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState>
      _mapSearchPackingChecklistLabelCallEventToState(
          SearchPackingChecklistLabelCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      print("hi");
      SearchPackingchecklistLabelResponse respo = await userRepository
          .searchpackingchecklistlabel(event.searchPackingChecklistRequest);

      yield SearchPackingChecklistLabelCallResponseState(respo);
    } catch (error, stacktrace) {
      print(error.toString());

      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapDeletePackingCheckListCallEventToState(
      PackingDeleteRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      PackingCheckListDeleteResponse inquiryDeleteResponse =
          await userRepository.deletePackingCheckList(
              event.pkID, event.packingCheckListDeleteRequest);
      yield PackingDeleteCallResponseState(
          event.context, inquiryDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapCountryListCallEventToState(
      CountryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CountryListResponseForPacking respo = await userRepository
          .country_list_call_For_Packing(event.countryListRequest);
      yield CountryListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapStateListCallEventToState(
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

  Stream<PackingChecklistListState> _mapCityListCallEventToState(
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

  Stream<PackingChecklistListState> _mapOutWordCallEventToState(
      OutWordCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      OutWordNoListResponse respo =
          await userRepository.OutWordAPI(event.outWordNoListRequest);
      yield OutWordResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState>
      _mapPackingProductAssamblyListCallEventToState(
          PackingProductAssamblyListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PackingProductAssamblyListResponse respo =
          await userRepository.PackingProductAssamblyListAPI(
              event.packingProductAssamblyListRequest);
      yield PackingProductAssamblyListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapProductGroupDropDownCallEventToState(
      ProductGroupDropDownRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProductGroupDropDownResponse respo =
          await userRepository.ProductGroupDropDownAPi(
              event.packingProductAssamblyListRequest);
      yield ProductGroupDropDownResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapProductDropDownCallEventToState(
      ProductDropDownRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProductDropDownResponse respo =
          await userRepository.ProductDropDownAPi(event.productDropDownRequest);
      yield ProductDropDownResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapPackingSaveCallEventToState(
      PackingSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PackingSaveResponse respo = await userRepository.PackingSaveAPi(
          event.pkID, event.packingSaveRequest);
      yield PackingSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapPackingAssamblySaveEventToState(
      PackingAssamblySaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PackingAssamblySaveResponse respo = await userRepository
          .packingAssamblySaveAPI(event.packingAssamblyList);
      yield PackingAssamblySaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState>
      _mapDeleteAllPackingAssamblyCallEventToState(
          DeleteALLPackingAssamblyCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      Delete_ALL_Assambly_Response respo =
          await userRepository.DeleteAllPackingAssamblyAPI(
              event.pcNo, event.deleteAllPakingAssamblyRequest);
      yield DeleteAllPackingAssamblyResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<PackingChecklistListState> _mapPackingAssamblyEditModeCallEventToState(
      PackingAssamblyEditModeRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      PackingAssamblyEditModeResponse respo =
          await userRepository.PackingAssamblyEditModeAPI(
              event.packingAssamblyEditModeRequest);
      yield PackingAssamblyEditModeResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
