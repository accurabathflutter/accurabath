part of 'product_master_bloc.dart';

@immutable
abstract class ProductMasterEvent {}

///all events of AuthenticationEvents
class ProductMasterListEvent extends ProductMasterEvent //Main Event Class
{
  final int pageNo;
  final ProductMasterListRequest productMasterListRequest;
  ProductMasterListEvent(this.pageNo, this.productMasterListRequest);
}
