part of 'vk_sound_complaint_bloc.dart';

@immutable
abstract class VkComplaintScreenEvents {}

///all events of AuthenticationEvents

//VkComplaintListRequest
class VkComplaintListRequestEvent extends VkComplaintScreenEvents {
  int pageNo;
  final VkComplaintListRequest vkComplaintListRequest;
  VkComplaintListRequestEvent(this.pageNo, this.vkComplaintListRequest);
}

class VkComplaintSaveRequestEvent extends VkComplaintScreenEvents {
  int pkID;
  final VkComplaintSaveRequest vkComplaintSaveRequest;
  VkComplaintSaveRequestEvent(this.pkID, this.vkComplaintSaveRequest);
}

class VkComplaintDeleteRequestEvent extends VkComplaintScreenEvents {
  int pkID;
  final VkComplaintDeleteRequest vkComplaintDeleteRequest;
  VkComplaintDeleteRequestEvent(this.pkID, this.vkComplaintDeleteRequest);
}

class VkComplaintpkIDtoDetailsRequestEvent extends VkComplaintScreenEvents {
  int pkID;
  final VkComplaintpkIDtoDetailsRequest vkComplaintpkIDtoDetailsRequest;
  VkComplaintpkIDtoDetailsRequestEvent(
      this.pkID, this.vkComplaintpkIDtoDetailsRequest);
}

class CountryCallEvent extends VkComplaintScreenEvents {
  final CountryListRequest countryListRequest;
  CountryCallEvent(this.countryListRequest);
}

class StateCallEvent extends VkComplaintScreenEvents {
  final StateListRequest stateListRequest;
  StateCallEvent(this.stateListRequest);
}

class CityCallEvent extends VkComplaintScreenEvents {
  final CityApiRequest cityApiRequest;
  CityCallEvent(this.cityApiRequest);
}

class VkComplaintHistoryRequestEvent extends VkComplaintScreenEvents {
  String pkID;
  final VkComplaintHistoryRequest vkComplaintHistoryRequest;
  VkComplaintHistoryRequestEvent(this.pkID, this.vkComplaintHistoryRequest);
}

class SearchCustomerListByNumberCallEvent extends VkComplaintScreenEvents {
  final CustomerSearchByIdRequest request;

  SearchCustomerListByNumberCallEvent(this.request);
}
