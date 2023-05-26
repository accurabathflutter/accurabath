part of 'product_master_bloc.dart';

abstract class ProductMasterState extends BaseStates {
  const ProductMasterState();
}

///all states of AuthenticationStates
class ProductMasterStateInitialState extends ProductMasterState {}
//ProductMasterResponse

class ProductMasterResponseState
    extends ProductMasterState // Maint State Class Declare Here
{
  final int newPage;

  final ProductMasterResponse response;
  ProductMasterResponseState(this.newPage, this.response);
}
