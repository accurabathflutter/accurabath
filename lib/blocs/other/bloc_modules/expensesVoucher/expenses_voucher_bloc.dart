import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'expenses_voucher_events.dart';
part 'expenses_voucher_states.dart';

class ExpensesVoucherBloc
    extends Bloc<ExpensesVoucherEvents, ExpensesVoucherStates> {
  Repository repository = Repository.getInstance();
  BaseBloc baseBloc;

  ExpensesVoucherBloc(this.baseBloc)
      : super(ExpensesVoucherStatesInitialStates());

  @override
  Stream<ExpensesVoucherStates> mapEventToState(ExpensesVoucherEvents event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
