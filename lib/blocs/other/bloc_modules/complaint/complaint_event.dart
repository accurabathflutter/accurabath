part of 'complaint_bloc.dart';

@immutable
abstract class ComplaintScreenEvents {}

///all events of AuthenticationEvents

class ComplaintListCallEvent extends ComplaintScreenEvents {
  final int pageNo;
  final ComplaintListRequest complaintListRequest;

  ComplaintListCallEvent(this.pageNo, this.complaintListRequest);
}

class AccuraBathComplaintListRequestEvent extends ComplaintScreenEvents {
  final int pageNo;
  final AccuraBathComplaintListRequest accuraBathComplaintListRequest;

  AccuraBathComplaintListRequestEvent(
      this.pageNo, this.accuraBathComplaintListRequest);
}

class ComplaintSearchByNameCallEvent extends ComplaintScreenEvents {
  final ComplaintSearchRequest complaintSearchRequest;

  ComplaintSearchByNameCallEvent(this.complaintSearchRequest);
}

class ComplaintSearchByIDCallEvent extends ComplaintScreenEvents {
  final int pkID;

  final ComplaintSearchByIDRequest complaintSearchByIDRequest;

  ComplaintSearchByIDCallEvent(this.pkID, this.complaintSearchByIDRequest);
}

class ComplaintDeleteCallEvent extends ComplaintScreenEvents {
  final int pkID;
  final ComplaintDeleteRequest complaintDeleteRequest;

  ComplaintDeleteCallEvent(this.pkID, this.complaintDeleteRequest);
}

class SearchFollowupCustomerListByNameCallEvent extends ComplaintScreenEvents {
  final CustomerLabelValueRequest request;

  SearchFollowupCustomerListByNameCallEvent(this.request);
}

class CustomerSourceCallEvent extends ComplaintScreenEvents {
  final CustomerSourceRequest request1;
  CustomerSourceCallEvent(this.request1);
}

class ComplaintSaveCallEvent extends ComplaintScreenEvents {
  final int pkID;
  final ComplaintSaveRequest complaintSaveRequest;

  ComplaintSaveCallEvent(this.pkID, this.complaintSaveRequest);
}

class TransectionModeCallEvent extends ComplaintScreenEvents {
  final TransectionModeListRequest request;

  TransectionModeCallEvent(this.request);
}

class FetchAccuraBathComplaintImageListRequestEvent
    extends ComplaintScreenEvents {
  final AccuraBathComplaintListResponseDetails
      accuraBathComplaintListResponseDetails;
  final FetchAccuraBathComplaintImageListRequest
      fetchAccuraBathComplaintImageListRequest;
  final AccuraBathComplaintVideoListRequest accuraBathComplaintVideoListRequest;

  String ImageBaseURL;
  String VideoFileURL;

  //

  FetchAccuraBathComplaintImageListRequestEvent(
      this.accuraBathComplaintListResponseDetails,
      this.fetchAccuraBathComplaintImageListRequest,
      this.accuraBathComplaintVideoListRequest,
      this.ImageBaseURL,
      this.VideoFileURL);
}

class AccuraBathComplaintEmpFollowerListRequestEvent
    extends ComplaintScreenEvents {
  final AccuraBathComplaintEmpFollowerListRequest
      complaintEmpFollowerListRequest;
  AccuraBathComplaintEmpFollowerListRequestEvent(
      this.complaintEmpFollowerListRequest);
}

class AccuraBathComplaintSaveRequestEvent extends ComplaintScreenEvents {
  final int pkID;
  final AccuraBathComplaintSaveRequest complaintSaveRequest;

  List<File> imageFileList = [];
  // AccuraBathComplaintUploadImageAPIRequest imageApiRequest;

  List<File> videoFileList = [];
  // AccuraBathComplaintUploadVideoAPIRequest videoApiRequest;

  AccuraBathComplaintSaveRequestEvent(
    this.pkID,
    this.complaintSaveRequest,
    this.imageFileList,
    // this.imageApiRequest,
    this.videoFileList,
    /*this.videoApiRequest*/
  );
}

class AccurabathComplaintImageDeleteRequestEvent extends ComplaintScreenEvents {
  final String ComplaintNo;
  final AccurabathComplaintImageDeleteRequest
      complaintNoToDeleteImageVideoRequest;
  AccurabathComplaintImageDeleteRequestEvent(
      this.ComplaintNo, this.complaintNoToDeleteImageVideoRequest);
}

class AccurabathComplaintVideoDeleteRequestEvent extends ComplaintScreenEvents {
  final String ComplaintNo;
  final AccurabathComplaintVideoDeleteRequest
      accurabathComplaintVideoDeleteRequest;
  AccurabathComplaintVideoDeleteRequestEvent(
      this.ComplaintNo, this.accurabathComplaintVideoDeleteRequest);
}

class AccuraBathComplaintUploadImageAPIRequestEvent
    extends ComplaintScreenEvents {
  final List<File> expenseImageFile;
  final AccuraBathComplaintUploadImageAPIRequest complaintUploadImageAPIRequest;

  AccuraBathComplaintUploadImageAPIRequestEvent(
      this.expenseImageFile, this.complaintUploadImageAPIRequest);
}

class AccuraBathComplaintUploadVideoAPIRequestEvent
    extends ComplaintScreenEvents {
  final List<File> expenseImageFile;
  final AccuraBathComplaintUploadVideoAPIRequest complaintUploadImageAPIRequest;

  AccuraBathComplaintUploadVideoAPIRequestEvent(
      this.expenseImageFile, this.complaintUploadImageAPIRequest);
}

class CountryCallEvent extends ComplaintScreenEvents {
  final CountryListRequest countryListRequest;
  CountryCallEvent(this.countryListRequest);
}

class StateCallEvent extends ComplaintScreenEvents {
  final StateListRequest stateListRequest;
  StateCallEvent(this.stateListRequest);
}

class CityCallEvent extends ComplaintScreenEvents {
  final CityApiRequest cityApiRequest;
  CityCallEvent(this.cityApiRequest);
}

class UserMenuRightsRequestEvent extends ComplaintScreenEvents {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}
