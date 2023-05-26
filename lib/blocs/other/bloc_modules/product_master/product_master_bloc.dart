import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/product/product_master_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/product_master/product_master_list_response.dart';
import 'package:for_practice_the_app/repositories/repository.dart';

part 'product_master_event.dart';
part 'product_master_state.dart';

class ManagePurchaseBloc extends Bloc<ProductMasterEvent, ProductMasterState> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ///Bloc Constructor
  ManagePurchaseBloc(this.baseBloc) : super(ProductMasterStateInitialState());

  @override
  Stream<ProductMasterState> mapEventToState(ProductMasterEvent event) async* {
    if (event is ProductMasterListEvent) {
      yield* _mapProductMasterListEventToState(event);
    }
  }

  Stream<ProductMasterState> _mapProductMasterListEventToState(
      ProductMasterListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      print("hi");
      ProductMasterResponse respo = await userRepository.productmasterListAPi(
          event.pageNo, event.productMasterListRequest);

      yield ProductMasterResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      print(error.toString());

      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
