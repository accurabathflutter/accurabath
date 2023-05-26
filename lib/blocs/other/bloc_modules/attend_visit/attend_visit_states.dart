part of 'attend_visit_bloc.dart';

abstract class AttendVisitStates extends BaseStates {
  const AttendVisitStates();
}

///all states of AuthenticationStates
class AttendVisitInitialState extends AttendVisitStates {}

class AttendVisitListCallResponseState extends AttendVisitStates {
  final int newPage;

  final AttendVisitListResponse response;
  AttendVisitListCallResponseState(this.newPage, this.response);
}

class ComplaintNoListCallResponseState extends AttendVisitStates {
  final ComplaintNoListResponse response;
  ComplaintNoListCallResponseState(this.response);
}

class CustomerSourceCallEventResponseState extends AttendVisitStates {
  final CustomerSourceResponse sourceResponse;
  CustomerSourceCallEventResponseState(this.sourceResponse);
}

class TransectionModeResponseState extends AttendVisitStates {
  final TransectionModeListResponse transectionModeListResponse;

  TransectionModeResponseState(this.transectionModeListResponse);
}

class AttendVisitSaveResponseState extends AttendVisitStates {
  final AttendVisitSaveResponse attendVisitSaveResponse;
  BuildContext context;
  AttendVisitSaveResponseState(this.context, this.attendVisitSaveResponse);
}

class ComplaintSearchByNameResponseState extends AttendVisitStates {
  final ComplaintSearchResponse complaintSearchResponse;

  ComplaintSearchByNameResponseState(this.complaintSearchResponse);
}

class AttendVisitSearchByIDResponseState extends AttendVisitStates {
  final AttendVisitListResponse complaintSearchByIDResponse;

  AttendVisitSearchByIDResponseState(this.complaintSearchByIDResponse);
}

class AttendVisitDeleteResponseState extends AttendVisitStates {
  final AttendVisitDeleteResponse attendVisitDeleteResponse;

  AttendVisitDeleteResponseState(this.attendVisitDeleteResponse);
}

class ComplaintSearchByIDResponseState extends AttendVisitStates {
  final ComplaintListResponse complaintSearchByIDResponse;

  ComplaintSearchByIDResponseState(this.complaintSearchByIDResponse);
}

class QuickComplaintListResponseState extends AttendVisitStates {
  final QucikComplaintListResponse response;

  QuickComplaintListResponseState(this.response);
}

class QuickComplaintSaveResponseState extends AttendVisitStates {
  final QucikComplaintSaveResponse response;

  QuickComplaintSaveResponseState(this.response);
}

class UserMenuRightsResponseState extends AttendVisitStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}
