import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'petty_cash_voucher_events.dart';
part 'petty_cash_voucher_states.dart';

class PettyCashVoucherBloc
    extends Bloc<PettyCashVoucherEvents, PettyCashVoucherStates> {
  Repository repository = Repository.getInstance();
  BaseBloc baseBloc;

  PettyCashVoucherBloc(this.baseBloc) : super(PettyCashVoucherInitialStates());

  @override
  Stream<PettyCashVoucherStates> mapEventToState(PettyCashVoucherEvents event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
