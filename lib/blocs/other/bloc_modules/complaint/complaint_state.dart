part of 'complaint_bloc.dart';

abstract class ComplaintScreenStates extends BaseStates {
  const ComplaintScreenStates();
}

///all states of AuthenticationStates

class ComplaintScreenInitialState extends ComplaintScreenStates {}

class ComplaintListResponseState extends ComplaintScreenStates {
  final ComplaintListResponse complaintListResponse;
  final int newPage;

  ComplaintListResponseState(this.newPage, this.complaintListResponse);
}

class ComplaintSearchByNameResponseState extends ComplaintScreenStates {
  final ComplaintSearchResponse complaintSearchResponse;

  ComplaintSearchByNameResponseState(this.complaintSearchResponse);
}

class ComplaintSearchByIDResponseState extends ComplaintScreenStates {
  final ComplaintListResponse complaintSearchByIDResponse;

  ComplaintSearchByIDResponseState(this.complaintSearchByIDResponse);
}

class ComplaintDeleteResponseState extends ComplaintScreenStates {
  final ComplaintDeleteResponse complaintDeleteResponse;

  ComplaintDeleteResponseState(this.complaintDeleteResponse);
}

class FollowupCustomerListByNameCallResponseState
    extends ComplaintScreenStates {
  final CustomerLabelvalueRsponse response;

  FollowupCustomerListByNameCallResponseState(this.response);
}

class CustomerSourceCallEventResponseState extends ComplaintScreenStates {
  final CustomerSourceResponse sourceResponse;
  CustomerSourceCallEventResponseState(this.sourceResponse);
}

class ComplaintSaveResponseState extends ComplaintScreenStates {
  final ComplaintSaveResponse complaintSaveResponse;

  ComplaintSaveResponseState(this.complaintSaveResponse);
}

class AccuraBathComplaintListResponseState extends ComplaintScreenStates {
  final AccuraBathComplaintListResponse accuraBathComplaintListResponse;
  final int newPage;

  AccuraBathComplaintListResponseState(
      this.newPage, this.accuraBathComplaintListResponse);
}

class FetchAccuraBathComplaintImageListResponseState
    extends ComplaintScreenStates {
  final AccuraBathComplaintListResponseDetails
      accuraBathComplaintListResponseDetails;
  final FetchAccuraBathComplaintImageListResponse
      fetchAccuraBathComplaintImageListResponse;

  final AccurabathComplaintVideoListResponse
      accurabathComplaintVideoListResponse;

  List<File> ImageFileListFromAPI = [];

  List<File> VideoFileList = [];
  FetchAccuraBathComplaintImageListResponseState(
      this.fetchAccuraBathComplaintImageListResponse,
      this.accuraBathComplaintListResponseDetails,
      this.accurabathComplaintVideoListResponse,
      this.ImageFileListFromAPI,
      this.VideoFileList);
}

class AccuraBathComplaintEmployeeListResponseState
    extends ComplaintScreenStates {
  final AccuraBathComplaintEmployeeListResponse
      accuraBathComplaintEmployeeListResponse;

  AccuraBathComplaintEmployeeListResponseState(
      this.accuraBathComplaintEmployeeListResponse);
}

class AccuraBathComplaintSaveResponseState extends ComplaintScreenStates {
  final AccuraBathComplaintSaveResponse complaintSaveResponse;

  AccuraBathComplaintSaveResponseState(this.complaintSaveResponse);
}

class AccuraBathComplaintNoToDeleteImageResponseState
    extends ComplaintScreenStates {
  final AccuraBathComplaintNoToDeleteImageResponse
      complaintNoToDeleteImageResponse;

  AccuraBathComplaintNoToDeleteImageResponseState(
      this.complaintNoToDeleteImageResponse);
}

class AccuraBathComplaintNoToDeleteVideoResponseState
    extends ComplaintScreenStates {
  final AccuraBathComplaintDeleteVideoResponse
      accuraBathComplaintDeleteVideoResponse;

  AccuraBathComplaintNoToDeleteVideoResponseState(
      this.accuraBathComplaintDeleteVideoResponse);
}

class AccuraBathComplaintUploadImageCallResponseState
    extends ComplaintScreenStates {
  final AccuraBathComplaintImageUploadResponse complaintImageUploadResponse;
  AccuraBathComplaintUploadImageAPIRequest complaintUploadImageAPIRequest;

  AccuraBathComplaintUploadImageCallResponseState(
      this.complaintImageUploadResponse, this.complaintUploadImageAPIRequest);
}

class AccuraBathComplaintUploadVideoCallResponseState
    extends ComplaintScreenStates {
  final AccuraBathComplaintVideoUploadResponse complaintVideoUploadResponse;

  AccuraBathComplaintUploadVideoCallResponseState(
      this.complaintVideoUploadResponse);
}

class CountryListEventResponseState extends ComplaintScreenStates {
  final CountryListResponse countrylistresponse;
  CountryListEventResponseState(this.countrylistresponse);
}

class StateListEventResponseState extends ComplaintScreenStates {
  final StateListResponse statelistresponse;
  StateListEventResponseState(this.statelistresponse);
}

class CityListEventResponseState extends ComplaintScreenStates {
  final CityApiRespose cityApiRespose;
  CityListEventResponseState(this.cityApiRespose);
}

class UserMenuRightsResponseState extends ComplaintScreenStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}
