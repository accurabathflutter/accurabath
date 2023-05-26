part of 'vk_sound_complaint_bloc.dart';

abstract class VkComplaintScreenStates extends BaseStates {
  const VkComplaintScreenStates();
}

///all states of AuthenticationStates

class VkComplaintScreenInitialState extends VkComplaintScreenStates {}

class VkComplaintListResponseState extends VkComplaintScreenStates {
  int newPage;
  final VkComplaintListResponse vkComplaintListResponse;

  VkComplaintListResponseState(this.newPage, this.vkComplaintListResponse);
}

class VkComplaintSaveResponseState extends VkComplaintScreenStates {
  final VkComplaintSaveResponse response;
  VkComplaintSaveResponseState(this.response);
}

class VkComplainPkIDtoDetailsResponseState extends VkComplaintScreenStates {
  final VkComplainPkIDtoDetailsResponse response;
  VkComplainPkIDtoDetailsResponseState(this.response);
}

class CountryListEventResponseState extends VkComplaintScreenStates {
  final CountryListResponse countrylistresponse;
  CountryListEventResponseState(this.countrylistresponse);
}

class StateListEventResponseState extends VkComplaintScreenStates {
  final StateListResponse statelistresponse;
  StateListEventResponseState(this.statelistresponse);
}

class CityListEventResponseState extends VkComplaintScreenStates {
  final CityApiRespose cityApiRespose;
  CityListEventResponseState(this.cityApiRespose);
}

class VkComplaintDeleteResponseState extends VkComplaintScreenStates {
  final VkComplaintDeleteResponse response;
  VkComplaintDeleteResponseState(this.response);
}

class VkComplaintHistoryResponseState extends VkComplaintScreenStates {
  final VkComplaintHistoryResponse response;
  VkComplaintHistoryResponseState(this.response);
}

class SearchCustomerListByNumberCallResponseState
    extends VkComplaintScreenStates {
  final CustomerDetailsResponse response;

  SearchCustomerListByNumberCallResponseState(this.response);
}
