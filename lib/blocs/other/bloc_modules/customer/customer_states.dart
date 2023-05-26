part of 'customer_bloc.dart';

abstract class CustomerStates extends BaseStates {
  const CustomerStates();
}

///all states of AuthenticationStates
class CustomerInitialState extends CustomerStates {}

class CustomerListCallResponseState extends CustomerStates {
  final CustomerDetailsResponse response;
  final int newPage;
  CustomerListCallResponseState(this.response, this.newPage);
}

class CustomerListByNameCallResponseState extends CustomerStates {
  final CustomerLabelvalueRsponse response;

  CustomerListByNameCallResponseState(this.response);
}

class SearchCustomerListByNumberCallResponseState extends CustomerStates {
  final CustomerDetailsResponse response;

  SearchCustomerListByNumberCallResponseState(this.response);
}

class CountryListEventResponseState extends CustomerStates {
  final CountryListResponse countrylistresponse;
  CountryListEventResponseState(this.countrylistresponse);
}

class StateListEventResponseState extends CustomerStates {
  final StateListResponse statelistresponse;
  StateListEventResponseState(this.statelistresponse);
}

class DistrictListEventResponseState extends CustomerStates {
  final DistrictApiResponse districtApiResponseList;
  DistrictListEventResponseState(this.districtApiResponseList);
}

class TalukaListEventResponseState extends CustomerStates {
  final TalukaApiRespose talukaApiRespose;
  TalukaListEventResponseState(this.talukaApiRespose);
}

class CityListEventResponseState extends CustomerStates {
  final CityApiRespose cityApiRespose;
  CityListEventResponseState(this.cityApiRespose);
}

class CustomerAddEditEventResponseState extends CustomerStates {
  BuildContext context;
  final CustomerAddEditApiResponse customerAddEditApiResponse;
  CustomerAddEditEventResponseState(
      this.context, this.customerAddEditApiResponse);
}

class CustomerDeleteCallResponseState extends CustomerStates {
  final CustomerDeleteResponse customerDeleteResponse;

  CustomerDeleteCallResponseState(this.customerDeleteResponse);
}

class CustomerContactSaveResponseState extends CustomerStates {
  final CustomerContactSaveResponse contactSaveResponse;
  CustomerContactSaveResponseState(this.contactSaveResponse);
}

class CustomerIdToCustomerListResponseState extends CustomerStates {
  final CustomerIdToContactListResponse customerIdToContactListResponse;
  CustomerIdToCustomerListResponseState(this.customerIdToContactListResponse);
}

class CustomerIdToDeleteAllContactResponseState extends CustomerStates {
  final CustomerIdToDeleteAllContactResponse response;

  CustomerIdToDeleteAllContactResponseState(this.response);
}

class CustomerCategoryCallEventResponseState extends CustomerStates {
  final CustomerCategoryResponse categoryResponse;
  CustomerCategoryCallEventResponseState(this.categoryResponse);
}

class CustomerSourceCallEventResponseState extends CustomerStates {
  final CustomerSourceResponse sourceResponse;
  CustomerSourceCallEventResponseState(this.sourceResponse);
}

class DesignationListEventResponseState extends CustomerStates {
  final DesignationApiResponse designationApiResponse;
  DesignationListEventResponseState(this.designationApiResponse);
}

class CustomerUploadDocumentResponseState extends CustomerStates {
  final CustomerUploadDocumentResponse designationApiResponse;
  final String HeaderMsg;
  CustomerUploadDocumentResponseState(
      this.HeaderMsg, this.designationApiResponse);
}

class CustomerFetchDocumentResponseState extends CustomerStates {
  bool isforViewDoc;
  CustomerDetails customerDetails;
  final CustomerFetchDocumentResponse customerFetchDocumentResponse;
  CustomerFetchDocumentResponseState(this.isforViewDoc, this.customerDetails,
      this.customerFetchDocumentResponse);
}
//

class CustomerDeleteDocumentResponseState extends CustomerStates {
  final CustomerDeleteDocumentResponse customerDeleteDocumentResponse;
  CustomerDeleteDocumentResponseState(this.customerDeleteDocumentResponse);
}

class UserMenuRightsResponseState extends CustomerStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class BTCountryListResponseState extends CustomerStates {
  final BTCountryListResponse btCountryListResponse;
  BTCountryListResponseState(this.btCountryListResponse);
}

class CityCodeToCustomerListResponseState extends CustomerStates {
  final CityCodeToCustomerListResponse response;
  CityCodeToCustomerListResponseState(this.response);
}
//UserMenuRightsResponse
