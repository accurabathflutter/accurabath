part of 'followup_bloc.dart';

@immutable
abstract class FollowupEvents {}

///all events of AuthenticationEvents
class FollowupListCallEvent extends FollowupEvents {
  final int pageNo;
  final FollowupListApiRequest followupListApiRequest;
  FollowupListCallEvent(this.pageNo, this.followupListApiRequest);
}

class SearchFollowupListByNameCallEvent extends FollowupEvents {
  final SearchFollowupListByNameRequest request;

  SearchFollowupListByNameCallEvent(this.request);
}

class SearchFollowupCustomerListByNameCallEvent extends FollowupEvents {
  final CustomerLabelValueRequest request;

  SearchFollowupCustomerListByNameCallEvent(this.request);
}

class FollowupInquiryNoListByNameCallEvent extends FollowupEvents {
  final FollowerInquiryNoListRequest followerInquiryNoListRequest;

  FollowupInquiryNoListByNameCallEvent(this.followerInquiryNoListRequest);
}

class FollowupSaveByNameCallEvent extends FollowupEvents {
  final int pkID;
  final BuildContext context;
  final FollowupSaveApiRequest followupSaveApiRequest;
  final String Msg;
  FollowupSaveByNameCallEvent(
      this.Msg, this.context, this.pkID, this.followupSaveApiRequest);
}

class QuickFollowupSaveByNameCallEvent extends FollowupEvents {
  final int pkID;
  final BuildContext context;
  final FollowupSaveApiRequest followupSaveApiRequest;
  final String Msg;
  QuickFollowupSaveByNameCallEvent(
      this.Msg, this.context, this.pkID, this.followupSaveApiRequest);
}

class FollowupDeleteByNameCallEvent extends FollowupEvents {
  final int pkID;

  final FollowupDeleteRequest followupDeleteRequest;

  FollowupDeleteByNameCallEvent(this.pkID, this.followupDeleteRequest);
}

class QuickFollowupDeleteByNameCallEvent extends FollowupEvents {
  final int pkID;

  final FollowupDeleteRequest followupDeleteRequest;

  QuickFollowupDeleteByNameCallEvent(this.pkID, this.followupDeleteRequest);
}

class FollowupFilterListCallEvent extends FollowupEvents {
  String filtername;
  final FollowupFilterListRequest followupFilterListRequest;

  FollowupFilterListCallEvent(this.filtername, this.followupFilterListRequest);
}

class FollowupInquiryByCustomerIDCallEvent extends FollowupEvents {
  final FollowerInquiryByCustomerIDRequest followerInquiryByCustomerIDRequest;

  FollowupInquiryByCustomerIDCallEvent(this.followerInquiryByCustomerIDRequest);
}

class FollowupUploadImageNameCallEvent extends FollowupEvents {
  final File expenseImageFile;
  final FollowUpUploadImageAPIRequest expenseUploadImageAPIRequest;

  FollowupUploadImageNameCallEvent(
      this.expenseImageFile, this.expenseUploadImageAPIRequest);
}

class FollowupUploadImageNameFromMainFollowupCallEvent extends FollowupEvents {
  final File expenseImageFile;
  final FollowUpUploadImageAPIRequest expenseUploadImageAPIRequest;
  BuildContext context;

  FollowupUploadImageNameFromMainFollowupCallEvent(
      this.context, this.expenseImageFile, this.expenseUploadImageAPIRequest);
}

class FollowupImageDeleteCallEvent extends FollowupEvents {
  final int pkID;

  final FollowupImageDeleteRequest followupImageDeleteRequest;

  FollowupImageDeleteCallEvent(this.pkID, this.followupImageDeleteRequest);
}

class FollowupTypeListByNameCallEvent extends FollowupEvents {
  final FollowupTypeListRequest followupTypeListRequest;

  FollowupTypeListByNameCallEvent(this.followupTypeListRequest);
}

class InquiryLeadStatusTypeListByNameCallEvent extends FollowupEvents {
  final FollowupInquiryStatusTypeListRequest
      followupInquiryStatusTypeListRequest;

  InquiryLeadStatusTypeListByNameCallEvent(
      this.followupInquiryStatusTypeListRequest);
}

class CloserReasonTypeListByNameCallEvent extends FollowupEvents {
  final CloserReasonTypeListRequest closerReasonTypeListRequest;

  CloserReasonTypeListByNameCallEvent(this.closerReasonTypeListRequest);
}

class FollowupHistoryListRequestCallEvent extends FollowupEvents {
  final FollowupHistoryListRequest followupHistoryListRequest;

  FollowupHistoryListRequestCallEvent(this.followupHistoryListRequest);
}

class QuickFollowupListRequestEvent extends FollowupEvents {
  final QuickFollowupListRequest quickFollowupListRequest;

  QuickFollowupListRequestEvent(this.quickFollowupListRequest);
}

class FCMNotificationRequestEvent extends FollowupEvents {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestEvent(this.request123);
}

class GetReportToTokenRequestEvent extends FollowupEvents {
  final GetReportToTokenRequest request;
  GetReportToTokenRequestEvent(this.request);
}

class AccuraBathComplaintFollowupHistoryListRequestEvent
    extends FollowupEvents {
  final AccuraBathComplaintFollowupHistoryListRequest
      complaintFollowupHistoryListRequest;

  AccuraBathComplaintFollowupHistoryListRequestEvent(
      this.complaintFollowupHistoryListRequest);
}

class AccuraBathComplaintFollowupSaveRequestEvent extends FollowupEvents {
  final int pkID;
  final BuildContext context;
  final AccuraBathComplaintFollowupSaveRequest complaintFollowupSaveRequest;
  final String Msg;

  AccuraBathComplaintFollowupSaveRequestEvent(
      this.pkID, this.context, this.Msg, this.complaintFollowupSaveRequest);
}

class TeleCallerFollowupHistoryRequestEvent extends FollowupEvents {
  final TeleCallerFollowupHistoryRequest request;
  TeleCallerFollowupHistoryRequestEvent(this.request);
}

class InquiryShareEmpListRequestEvent extends FollowupEvents {
  final InquiryShareEmpListRequest inquiryShareEmpListRequest;
  InquiryShareEmpListRequestEvent(this.inquiryShareEmpListRequest);
}

class UserMenuRightsRequestEvent extends FollowupEvents {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}

class TeleCallerFollowupSaveRequestEvent extends FollowupEvents {
  BuildContext context;
  int followuppkID;
  final TeleCallerFollowupSaveRequest request;

  TeleCallerFollowupSaveRequestEvent(
      this.context, this.followuppkID, this.request);
}

class FollowupImageListRequestEvent extends FollowupEvents {
  int pkID;

  final FollowupImageListRequest request;
  FollowupImageListRequestEvent(this.pkID, this.request);
}

class FollowupCountRequestEvent extends FollowupEvents {
  String Status;

  final FollowupCountRequest request;
  FollowupCountRequestEvent(this.Status, this.request);
}


class FollowupPkIdDetailsRequestEvent extends FollowupEvents {
  final FollowupPkIdDetailsRequest followupPkIdDetailsRequest;
  FollowupPkIdDetailsRequestEvent(this.followupPkIdDetailsRequest);
}