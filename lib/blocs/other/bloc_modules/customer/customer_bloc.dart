import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/bt_country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/city_code_to_customer_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_add_edit_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_category_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_delete_document_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_fetch_document_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_id_to_contact_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_id_to_delete_all_contacts_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_label_value_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_paggination_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_upload_document_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/designation_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/district_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/taluka_api_request.dart';
import 'package:for_practice_the_app/models/api_responses/customer/bt_country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/city_code_to_customer_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_add_edit_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_category_list.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_contact_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_delete_document_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_fetch_document_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_id_to_contact_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_id_to_delete_all_contact_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_upload_document_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/designation_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/district_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/taluka_api_response.dart';
import 'package:for_practice_the_app/models/common/contact_model.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'customer_events.dart';
part 'customer_states.dart';

class CustomerBloc extends Bloc<CustomerEvents, CustomerStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  CustomerBloc(this.baseBloc) : super(CustomerInitialState());

  @override
  Stream<CustomerStates> mapEventToState(CustomerEvents event) async* {
    /// sets state based on events
    if (event is CustomerListCallEvent) {
      yield* _mapCustomerListCallEventToState(event);
    }
    if (event is SearchCustomerListByNameCallEvent) {
      yield* _mapCustomerListByNameCallEventToState(event);
    }
    if (event is SearchCustomerListByNumberCallEvent) {
      yield* _mapSearchCustomerListByNumberCallEventToState(event);
    }

    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }
    if (event is DistrictCallEvent) {
      yield* _mapDistrictListCallEventToState(event);
    }
    if (event is TalukaCallEvent) {
      yield* _mapTalukaListCallEventToState(event);
    }
    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }

    if (event is CustomerAddEditCallEvent) {
      yield* _mapCustomerAddEditCallEventToState(event);
    }
    if (event is CustomerDeleteByNameCallEvent) {
      yield* _mapDeleteCustomerCallEventToState(event);
    }
    if (event is CustomerContactSaveCallEvent) {
      yield* _mapCustomerContactCallEventToState(event);
    }
    if (event is CustomerIdToCustomerListCallEvent) {
      yield* _mapCustomerIdToContactListEventToState(event);
    }
    if (event is CustomerIdToDeleteAllContactCallEvent) {
      yield* _mapCustomerIdToDeleteAllContactEventToState(event);
    }

    if (event is CustomerCategoryCallEvent) {
      yield* _mapCustomerCategoryCallEventToState(event);
    }

    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }
    if (event is DesignationCallEvent) {
      yield* _mapDesignationListCallEventToState(event);
    }

    if (event is CustomerUploadDocumentApiRequestEvent) {
      yield* _mapCustomerUploadDocumentCallEventToState(event);
    }

    if (event is CustomerFetchDocumentApiRequestEvent) {
      yield* _mapCustomerFetchDocumentApiRequestEventState(event);
    }
    if (event is CustomerDeleteDocumentApiRequestEvent) {
      yield* _mapCustomerDeleteDocumentApiRequestEventState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }

    if (event is BTCountryListRequestEvent) {
      yield* _mapBTCountryListRequestEventState(event);
    }

    //

    if (event is CityCodeToCustomerListRequestEvent) {
      yield* _mapCityCodeToCustomerListRequestEventState(event);
    }

    //BTCountryListRequestEvent
  }

  ///event functions to states implementation
  Stream<CustomerStates> _mapCustomerListCallEventToState(
      CustomerListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerDetailsResponse response = await userRepository.getCustomerList(
          event.pageNo, event.customerPaginationRequest);
      yield CustomerListCallResponseState(response, event.pageNo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapSearchCustomerListByNumberCallEventToState(
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

  Stream<CustomerStates> _mapCustomerListByNameCallEventToState(
      SearchCustomerListByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerLabelvalueRsponse response =
          await userRepository.getCustomerListSearchByName(event.request);
      yield CustomerListByNameCallResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerCategoryCallEventToState(
      CustomerCategoryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerCategoryResponse respo =
          await userRepository.customer_Category_List_call(event.request1);
      yield CustomerCategoryCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCountryListCallEventToState(
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

  Stream<CustomerStates> _mapStateListCallEventToState(
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

  Stream<CustomerStates> _mapDistrictListCallEventToState(
      DistrictCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DistrictApiResponse respo =
          await userRepository.district_list_details(event.districtApiRequest);
      yield DistrictListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapTalukaListCallEventToState(
      TalukaCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      TalukaApiRespose respo =
          await userRepository.taluka_list_details(event.talukaApiRequest);
      yield TalukaListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCityListCallEventToState(
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

  Stream<CustomerStates> _mapCustomerAddEditCallEventToState(
      CustomerAddEditCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerAddEditApiResponse respo = await userRepository
          .customer_add_edit_details(event.customerAddEditApiRequest);
      yield CustomerAddEditEventResponseState(event.context, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapDeleteCustomerCallEventToState(
      CustomerDeleteByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerDeleteResponse customerDeleteResponse = await userRepository
          .deleteCustomer(event.pkID, event.customerDeleteRequest);
      yield CustomerDeleteCallResponseState(customerDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerContactCallEventToState(
      CustomerContactSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerContactSaveResponse respo =
          await userRepository.customerContactSave_details(event._contactsList);
      yield CustomerContactSaveResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerIdToContactListEventToState(
      CustomerIdToCustomerListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerIdToContactListResponse respo = await userRepository
          .getCustomerListFromCustomerID(event.customerIdToCustomerListRequest);
      yield CustomerIdToCustomerListResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerIdToDeleteAllContactEventToState(
      CustomerIdToDeleteAllContactCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerIdToDeleteAllContactResponse respo =
          await userRepository.getCustomerIdToDeleteAllContact(
              event.pkID, event.customerIdToDeleteAllContactRequest);
      yield CustomerIdToDeleteAllContactResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerSourceCallEventToState(
      CustomerSourceCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerSourceResponse respo =
          await userRepository.customer_Source_List_call(event.request1);
      yield CustomerSourceCallEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapDesignationListCallEventToState(
      DesignationCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      DesignationApiResponse respo = await userRepository
          .designation_list_details(event.designationApiRequest);
      yield DesignationListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerUploadDocumentCallEventToState(
      CustomerUploadDocumentApiRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CustomerUploadDocumentResponse response;
      for (int i = 0; i < event.documentList.length; i++) {
        if (event.documentList[i].path != "") {
          var getextention =
              event.documentList[i].path.split('/').last.split(".");
          event.expenseImageUploadServerAPIRequest.Name =
              event.expenseImageUploadServerAPIRequest.CustomerID +
                  "-" +
                  "Attachments" +
                  i.toString() +
                  "." +
                  getextention[1];
          //event.documentList[i].path.split('/').last;
          event.expenseImageUploadServerAPIRequest.file = event.documentList[i];
          response = await userRepository.getCustomerploadDocumentAPI(
              event.documentList[i], event.expenseImageUploadServerAPIRequest);
        }
      }

      // print("RESPPDDDD" +  await userRepository.getuploadImage(event.expenseUploadImageAPIRequest).toString());
      yield CustomerUploadDocumentResponseState(event.HeaderMsg, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerFetchDocumentApiRequestEventState(
      CustomerFetchDocumentApiRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerFetchDocumentResponse respo = await userRepository
          .fetch_customer_document_API(event.designationApiRequest);
      yield CustomerFetchDocumentResponseState(
          event.isforViewDoc, event.customerDetails, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCustomerDeleteDocumentApiRequestEventState(
      CustomerDeleteDocumentApiRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CustomerDeleteDocumentResponse respo =
          await userRepository.delete_customer_document_API(
              event.CustomerpkID, event.customerDeleteDocumentApiRequest);
      yield CustomerDeleteDocumentResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapUserMenuRightsRequestEventState(
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

  Stream<CustomerStates> _mapBTCountryListRequestEventState(
      BTCountryListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      BTCountryListResponse response =
          await userRepository.bt_country_list_api(event.btCountryListRequest);
      yield BTCountryListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<CustomerStates> _mapCityCodeToCustomerListRequestEventState(
      CityCodeToCustomerListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CityCodeToCustomerListResponse response = await userRepository
          .cityCodetoCustomerListAPI(event.CityCode, event.request);
      yield CityCodeToCustomerListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
