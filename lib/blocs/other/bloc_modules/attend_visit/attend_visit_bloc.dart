import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/AttendVisit/attend_visit_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/AttendVisit/attend_visit_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/AttendVisit/attend_visit_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_no_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_search_by_Id_request.dart';
import 'package:for_practice_the_app/models/api_requests/complaint/complaint_search_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/toDo_request/transection_mode_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/AttendVisit/attend_visit_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/attendVisit/attend_visit_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/attendVisit/attend_visit_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_no_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/to_do/transection_mode_list_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/models/hema_automation/api_request/quick_complaint/quick_complaint_list_request.dart';
import 'package:for_practice_the_app/models/hema_automation/api_request/quick_complaint/quick_complaint_save_request.dart';
import 'package:for_practice_the_app/models/hema_automation/api_response/quick_complaint/quick_complaint_list_response.dart';
import 'package:for_practice_the_app/models/hema_automation/api_response/quick_complaint/quick_complaint_save_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'attend_visit_events.dart';
part 'attend_visit_states.dart';

class AttendVisitBloc extends Bloc<AttendVisitEvents, AttendVisitStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  AttendVisitBloc(this.baseBloc) : super(AttendVisitInitialState());

  @override
  Stream<AttendVisitStates> mapEventToState(AttendVisitEvents event) async* {
    if (event is AttendVisitListCallEvent) {
      yield* _mapAttenVisitCallEventToState(event);
    }
    if (event is ComplaintNoListCallEvent) {
      yield* _mapComplaintNoListEventToState(event);
    }

    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }

    if (event is TransectionModeCallEvent) {
      yield* _mapTransectionModeCallEventToState(event);
    }
    if (event is AttendVisitSaveCallEvent) {
      yield* _mapAttendVisitSaveCallEventToState(event);
    }
    if (event is ComplaintSearchByNameCallEvent) {
      yield* _mapSearchByNameCallEventToState(event);
    }

    if (event is AttendVisitSearchByIDCallEvent) {
      yield* _mapSearchByIDCallEventToState(event);
    }

    if (event is AttendVisitDeleteEvent) {
      yield* _mapAttendVisitEventToState(event);
    }
    if (event is ComplaintSearchByIDCallEvent) {
      yield* _mapSearchByComplaintIDCallEventToState(event);
    }
    if (event is QuickComplaintListRequestCallEvent) {
      yield* _mapQuickComplaintListRequestCallEventToState(event);
    }
    if (event is QuickComplaintSaveRequestCallEvent) {
      yield* _mapQuickComplaintSaveRequestCallEventToState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }
    //
  }

  Stream<AttendVisitStates> _mapAttenVisitCallEventToState(
      AttendVisitListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      // CustomerCategoryResponse loginResponse =

      /* List<CustomerCategoryResponse> customercategoryresponse*/
      AttendVisitListResponse respo = await userRepository.getAttenVisitList(
          event.pageNo, event.attendVisitListRequest);

      yield AttendVisitListCallResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapComplaintNoListEventToState(
      ComplaintNoListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      // CustomerCategoryResponse loginResponse =

      /* List<CustomerCategoryResponse> customercategoryresponse*/
      ComplaintNoListResponse respo =
          await userRepository.getComplaintNoList(event.complaintNoListRequest);

      yield ComplaintNoListCallResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapCustomerSourceCallEventToState(
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

  Stream<AttendVisitStates> _mapTransectionModeCallEventToState(
      TransectionModeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      TransectionModeListResponse bankVoucherDeleteResponse =
          await userRepository.getTransectionModeList(event.request);
      yield TransectionModeResponseState(bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapAttendVisitSaveCallEventToState(
      AttendVisitSaveCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      AttendVisitSaveResponse bankVoucherDeleteResponse =
          await userRepository.getAttendVisitSave(event.pkID, event.request);
      yield AttendVisitSaveResponseState(
          event.context, bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapSearchByNameCallEventToState(
      ComplaintSearchByNameCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintSearchResponse response = await userRepository
          .getVisitSearchByName(event.complaintSearchRequest);
      yield ComplaintSearchByNameResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapSearchByIDCallEventToState(
      AttendVisitSearchByIDCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AttendVisitListResponse response = await userRepository
          .getVisitSearchByID(event.pkID, event.complaintSearchByIDRequest);
      yield AttendVisitSearchByIDResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapAttendVisitEventToState(
      AttendVisitDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      AttendVisitDeleteResponse response = await userRepository
          .getAttendVisitDeleteAPI(event.attendVisitDeleteRequest);
      yield AttendVisitDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapSearchByComplaintIDCallEventToState(
      ComplaintSearchByIDCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ComplaintListResponse response = await userRepository
          .getComplaintSearchByID(event.pkID, event.complaintSearchByIDRequest);
      yield ComplaintSearchByIDResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapQuickComplaintListRequestCallEventToState(
      QuickComplaintListRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      QucikComplaintListResponse response = await userRepository
          .getQuickComplaintListAPI(event.quickComplaintListRequest);
      yield QuickComplaintListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapQuickComplaintSaveRequestCallEventToState(
      QuickComplaintSaveRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      QucikComplaintSaveResponse response =
          await userRepository.getQuickComplaintSaveAPI(
              event.pkID, event.quickComplaintSaveRequest);
      yield QuickComplaintSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<AttendVisitStates> _mapUserMenuRightsRequestEventState(
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
}
