import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'purchase_order_event.dart';
part 'purchase_order_state.dart';

class ManagePurchaseBloc
    extends Bloc<PurchaseOrderEvent, ManagePurchaseStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ///Bloc Constructor
  ManagePurchaseBloc(this.baseBloc) : super(ManagePurchaseStatesInitialState());

  @override
  Stream<ManagePurchaseStates> mapEventToState(
      PurchaseOrderEvent event) async* {}
}
