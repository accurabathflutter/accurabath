part of 'followup_bloc.dart';

abstract class FollowupStates extends BaseStates {
  const FollowupStates();
}

///all states of AuthenticationStates
class FollowupInitialState extends FollowupStates {}

class FollowupListCallResponseState extends FollowupStates {
  final FollowupListResponse response;
  final int newPage;
  FollowupListCallResponseState(this.response, this.newPage);
}

class SearchFollowupListByStatusCallResponseState extends FollowupStates {
  final FollowupListResponse response;

  SearchFollowupListByStatusCallResponseState(this.response);
}

class FollowupCustomerListByNameCallResponseState extends FollowupStates {
  final CustomerLabelvalueRsponse response;

  FollowupCustomerListByNameCallResponseState(this.response);
}

class FollowupInquiryStatusListCallResponseState extends FollowupStates {
  final InquiryStatusListResponse inquiryStatusListResponse;

  FollowupInquiryStatusListCallResponseState(this.inquiryStatusListResponse);
}

class FollowupInquiryNoListCallResponseState extends FollowupStates {
  final FollowupInquiryNoListResponse followupInquiryNoListResponse;

  FollowupInquiryNoListCallResponseState(this.followupInquiryNoListResponse);
}

class FollowupSaveCallResponseState extends FollowupStates {
  final FollowupSaveSuccessResponse followupSaveResponse;
  final BuildContext context;
  FollowupSaveCallResponseState(this.context, this.followupSaveResponse);
}

class FollowupDeleteCallResponseState extends FollowupStates {
  final FollowupDeleteResponse followupDeleteResponse;

  FollowupDeleteCallResponseState(this.followupDeleteResponse);
}

class FollowupFilterListCallResponseState extends FollowupStates {
  final FollowupFilterListResponse followupFilterListResponse;
  final int newPage;

  FollowupFilterListCallResponseState(
      this.newPage, this.followupFilterListResponse);
}

class FollowupInquiryByCustomerIdCallResponseState extends FollowupStates {
  final FollowupInquiryByCustomerIDResponse followupInquiryByCustomerIDResponse;

  FollowupInquiryByCustomerIdCallResponseState(
      this.followupInquiryByCustomerIDResponse);
}

class FollowupUploadImageCallResponseState extends FollowupStates {
  final FollowupImageUploadResponse followupImageUploadResponse;

  FollowupUploadImageCallResponseState(this.followupImageUploadResponse);
}

class FollowupUploadImageFromMainFollowupCallResponseState
    extends FollowupStates {
  final FollowupImageUploadResponse followupImageUploadResponse;
  BuildContext context;

  FollowupUploadImageFromMainFollowupCallResponseState(
      this.context, this.followupImageUploadResponse);
}

class FollowupImageDeleteCallResponseState extends FollowupStates {
  final FollowupDeleteImageResponse followupDeleteImageResponse;

  FollowupImageDeleteCallResponseState(this.followupDeleteImageResponse);
}

class FollowupTypeListCallResponseState extends FollowupStates {
  final FollowupTypeListResponse followupTypeListResponse;

  FollowupTypeListCallResponseState(this.followupTypeListResponse);
}

class InquiryLeadStatusListCallResponseState extends FollowupStates {
  final InquiryStatusListResponse inquiryStatusListResponse;

  InquiryLeadStatusListCallResponseState(this.inquiryStatusListResponse);
}

class CloserReasonListCallResponseState extends FollowupStates {
  final CloserReasonListResponse closerReasonListResponse;

  CloserReasonListCallResponseState(this.closerReasonListResponse);
}

class FollowupHistoryListResponseState extends FollowupStates {
  final FollowupHistoryListResponse followupHistoryListResponse;

  FollowupHistoryListResponseState(this.followupHistoryListResponse);
}

class QuickFollowupListResponseState extends FollowupStates {
  final QuickFollowupListResponse quickFollowupListResponse;

  QuickFollowupListResponseState(this.quickFollowupListResponse);
}

class FCMNotificationResponseState extends FollowupStates {
  final FCMNotificationResponse response;

  FCMNotificationResponseState(this.response);
}

class GetReportToTokenResponseState extends FollowupStates {
  final GetReportToTokenResponse response;

  GetReportToTokenResponseState(this.response);
}

class AccuraBathComplaintFollowupHistoryListResponseState
    extends FollowupStates {
  final AccuraBathComplaintFollowupHistoryListResponse
      complaintFollowupHistoryListResponse;

  AccuraBathComplaintFollowupHistoryListResponseState(
      this.complaintFollowupHistoryListResponse);
}

class AccuraBathComplaintFollowupSaveResponseState extends FollowupStates {
  final AccuraBathComplaintFollowupSaveResponse complaintFollowupSaveResponse;
  final BuildContext context;

  AccuraBathComplaintFollowupSaveResponseState(
      this.context, this.complaintFollowupSaveResponse);
}

class TeleCallerFollowupHestoryResponseState extends FollowupStates {
  final TeleCallerFollowupHestoryResponse response;

  TeleCallerFollowupHestoryResponseState(this.response);
}

class InquiryShareEmpListResponseState extends FollowupStates {
  final InquiryShareEmpListResponse response;
  String InquiryNo;
  InquiryShareEmpListResponseState(this.InquiryNo, this.response);
}

class UserMenuRightsResponseState extends FollowupStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class TeleCallerFollowupSaveResponseState extends FollowupStates {
  BuildContext context;
  final TeleCallerFollowupSaveResponse response;

  TeleCallerFollowupSaveResponseState(this.context, this.response);
}

class FollowupImageListResponseState extends FollowupStates {
  int followuppkID;
  final FollowupImageListResponse response;
  FollowupImageListResponseState(this.followuppkID, this.response);
}

class FollowUpCountState extends FollowupStates {
  final String count;
  FollowUpCountState(this.count);
}

class FollowupPkIdDetailsResponseState extends FollowupStates {
  final FollowupPkIdDetailsResponse followupPkIdDetailsResponse;

  FollowupPkIdDetailsResponseState(this.followupPkIdDetailsResponse);
}
