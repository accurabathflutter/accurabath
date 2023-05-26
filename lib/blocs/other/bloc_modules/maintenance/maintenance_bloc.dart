import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/bank_voucher/bank_voucher_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/maintenance/maintenance_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/maintenance/maintenance_search_request.dart';
import 'package:for_practice_the_app/models/api_responses/bank_voucher/bank_voucher_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/maintenance/maintenance_list_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'maintenance_event.dart';
part 'maintenance_state.dart';

class MaintenanceScreenBloc
    extends Bloc<MaintenanceScreenEvents, MaintenanceScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  MaintenanceScreenBloc(this.baseBloc) : super(MaintenanceScreenInitialState());

  @override
  Stream<MaintenanceScreenStates> mapEventToState(
      MaintenanceScreenEvents event) async* {
    if (event is MaintenanceListCallEvent) {
      yield* _mapBankVoucherListCallEventToState(event);
    }

    if (event is MaintenanceSearchCallEvent) {
      yield* _mapMaintenanceScreenCallEventToState(event);
    }

    if (event is MaintenanceDeleteCallEvent) {
      yield* _mapDeletedMaintenanceCallEventToState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }

    /* if (event is LoanSearchCallEvent) {
      yield* _mapEmployeeSearchCallEventToState(event);
    }
    if (event is LoanDeleteCallEvent) {
      yield* _mapDeletedBankVoucherCallEventToState(event);
    }
    if (event is LoanApprovalListCallEvent) {
      yield* _mapLoanApprovalListCallEventToState(event);
    }*/
  }

  Stream<MaintenanceScreenStates> _mapBankVoucherListCallEventToState(
      MaintenanceListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaintenanceListResponse response = await userRepository
          .getMaintenanceList(event.pageNo, event.maintenanceListRequest);
      yield MaintenanceListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MaintenanceScreenStates> _mapMaintenanceScreenCallEventToState(
      MaintenanceSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      MaintenanceListResponse response = await userRepository
          .getMaintenanceSearch(event.maintenanceSearchRequest);
      yield MaintenanceSearchResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MaintenanceScreenStates> _mapDeletedMaintenanceCallEventToState(
      MaintenanceDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      BankVoucherDeleteResponse bankVoucherDeleteResponse = await userRepository
          .getMaintenanceDelete(event.pkID, event.bankVoucherDeleteRequest);
      yield MaintenanceDeleteResponseState(bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<MaintenanceScreenStates> _mapUserMenuRightsRequestEventState(
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
