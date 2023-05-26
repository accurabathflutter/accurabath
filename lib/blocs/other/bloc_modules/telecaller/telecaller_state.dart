part of 'telecaller_bloc.dart';

abstract class TeleCallerStates extends BaseStates {
  const TeleCallerStates();
}

///all states of AuthenticationStates
class TeleCallerInitialState extends TeleCallerStates {}

class TeleCallerListCallResponseState extends TeleCallerStates {
  final TeleCallerListResponse response;
  final int newPage;
  TeleCallerListCallResponseState(this.response, this.newPage);
}

class CountryListEventResponseState extends TeleCallerStates {
  final CountryListResponse countrylistresponse;
  CountryListEventResponseState(this.countrylistresponse);
}

class StateListEventResponseState extends TeleCallerStates {
  final StateListResponse statelistresponse;
  StateListEventResponseState(this.statelistresponse);
}

class CityListEventResponseState extends TeleCallerStates {
  final CityApiRespose cityApiRespose;
  CityListEventResponseState(this.cityApiRespose);
}

class CustomerSourceCallEventResponseState extends TeleCallerStates {
  final CustomerSourceResponse sourceResponse;
  CustomerSourceCallEventResponseState(this.sourceResponse);
}

class TeleCallerDeleteCallResponseState extends TeleCallerStates {
  final CustomerDeleteResponse customerDeleteResponse;

  TeleCallerDeleteCallResponseState(this.customerDeleteResponse);
}

class TeleCallerSearchByNameResponseState extends TeleCallerStates {
  final TeleCallerSearchResponseByName sourceResponse;
  TeleCallerSearchByNameResponseState(this.sourceResponse);
}

class TeleCallerSearchByIDResponseState extends TeleCallerStates {
  final TeleCallerListResponse response;
  TeleCallerSearchByIDResponseState(this.response);
}

class ExternalLeadSaveResponseState extends TeleCallerStates {
  final ExternalLeadSaveResponse response;
  BuildContext contextfromHeader;
  ExternalLeadSaveResponseState(this.contextfromHeader, this.response);
}

class CustomerListByNameCallResponseState extends TeleCallerStates {
  final CustomerLabelvalueRsponse response;

  CustomerListByNameCallResponseState(this.response);
}

class TeleCallerUploadImgApiResponseState extends TeleCallerStates {
  final Telecaller_image_upload_response response;
  BuildContext contextFromAddEditScreen;
  TeleCallerUploadImgApiResponseState(
      this.contextFromAddEditScreen, this.response);
}

class TeleCallerImageDeleteResponseState extends TeleCallerStates {
  final TeleCallerImageDeleteResponse response;

  TeleCallerImageDeleteResponseState(this.response);
}

class FCMNotificationResponseState extends TeleCallerStates {
  final FCMNotificationResponse response;

  FCMNotificationResponseState(this.response);
}

class GetReportToTokenResponseState extends TeleCallerStates {
  final GetReportToTokenResponse response;

  GetReportToTokenResponseState(this.response);
}

class TeleCallerFollowupSaveResponseState extends TeleCallerStates {
  final TeleCallerFollowupSaveResponse response;

  TeleCallerFollowupSaveResponseState(this.response);
}

//TeleCallerFollowupSaveResponse
class FollowupTypeListCallResponseState extends TeleCallerStates {
  final FollowupTypeListResponse followupTypeListResponse;

  FollowupTypeListCallResponseState(this.followupTypeListResponse);
}

class CloserReasonListCallResponseState extends TeleCallerStates {
  final CloserReasonListResponse closerReasonListResponse;

  CloserReasonListCallResponseState(this.closerReasonListResponse);
}

class UserMenuRightsResponseState extends TeleCallerStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class ProductBrandResponseState extends TeleCallerStates {
  final ProductBrandResponse productBrandResponse;

  ProductBrandResponseState(this.productBrandResponse);
}
