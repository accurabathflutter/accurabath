import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/Loan/loan_approval_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/bank_voucher/bank_voucher_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/loan/loan_approval_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/loan/loan_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/loan/loan_search_request.dart';
import 'package:for_practice_the_app/models/api_responses/Loan/loan_approval_save_response.dart';
import 'package:for_practice_the_app/models/api_responses/bank_voucher/bank_voucher_delete_response.dart';
import 'package:for_practice_the_app/models/api_responses/loan/loan_list_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'loan_event.dart';
part 'loan_state.dart';

class LoanScreenBloc extends Bloc<LoanScreenEvents, LoanScreenStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  LoanScreenBloc(this.baseBloc) : super(LoanScreenInitialState());

  @override
  Stream<LoanScreenStates> mapEventToState(LoanScreenEvents event) async* {
    if (event is LoanListCallEvent) {
      yield* _mapBankVoucherListCallEventToState(event);
    }
    if (event is LoanSearchCallEvent) {
      yield* _mapEmployeeSearchCallEventToState(event);
    }
    if (event is LoanDeleteCallEvent) {
      yield* _mapDeletedBankVoucherCallEventToState(event);
    }
    if (event is LoanApprovalListCallEvent) {
      yield* _mapLoanApprovalListCallEventToState(event);
    }

    if (event is LoanApprovalSaveRequestCallEvent) {
      yield* _mapLoanApprovalSaveCallEventToState(event);
    }

    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }
  }

  Stream<LoanScreenStates> _mapBankVoucherListCallEventToState(
      LoanListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      LoanListResponse response =
          await userRepository.getLoanList(event.pageNo, event.listRequest);
      yield LoanListResponseState(event.pageNo, response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LoanScreenStates> _mapEmployeeSearchCallEventToState(
      LoanSearchCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      LoanListResponse response =
          await userRepository.getLoanSearchResult(event.employeeSearchRequest);
      yield LoanSearchResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LoanScreenStates> _mapDeletedBankVoucherCallEventToState(
      LoanDeleteCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      BankVoucherDeleteResponse bankVoucherDeleteResponse = await userRepository
          .getLoanDelete(event.pkID, event.bankVoucherDeleteRequest);
      yield LoanDeleteResponseState(bankVoucherDeleteResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LoanScreenStates> _mapLoanApprovalListCallEventToState(
      LoanApprovalListCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      LoanListResponse response = await userRepository
          .getLoanApprovalList(event.loanApprovalListRequest);
      yield LoanApprovalListResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LoanScreenStates> _mapLoanApprovalSaveCallEventToState(
      LoanApprovalSaveRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      LoanApprovalSaveResponse response = await userRepository
          .getLoanApprovalSAve(event.pkID, event.loanApprovalSaveRequest);
      yield LoanApprovalSaveResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<LoanScreenStates> _mapUserMenuRightsRequestEventState(
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
