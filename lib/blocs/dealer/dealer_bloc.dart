import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_source_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/city_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/country_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/state_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_terms_condition_response.dart';
import 'package:for_practice_the_app/models/common/dealer/purchase_bill/other_charge_db_table.dart';
import 'package:for_practice_the_app/models/common/dealer/purchase_bill/product_db_table.dart';
import 'package:for_practice_the_app/models/common/dealer/sales_bill/other_charge_db_table.dart';
import 'package:for_practice_the_app/models/common/dealer/sales_bill/productl_db_table.dart';
import 'package:for_practice_the_app/repositories/repository.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';

part 'dealer_states.dart';
part 'delaer_events.dart';

class DealerBloc extends Bloc<DealerEvents, DealerStates> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;
  DealerBloc(this.baseBloc) : super(DealerInitialState());

  @override
  Stream<DealerStates> mapEventToState(DealerEvents event) async* {
    if (event is CustomerSourceCallEvent) {
      yield* _mapCustomerSourceCallEventToState(event);
    }
    if (event is CountryCallEvent) {
      yield* _mapCountryListCallEventToState(event);
    }
    if (event is StateCallEvent) {
      yield* _mapStateListCallEventToState(event);
    }
    if (event is CityCallEvent) {
      yield* _mapCityListCallEventToState(event);
    }
    if (event is QuotationTermsConditionCallEvent) {
      yield* _mapQuotationTermsConditionEventToState(event);
    }
    if (event is GetDealerPurchaseProductEvent) {
      yield* _map_GetPurchaseProductList(event);
    }
    if (event is InsertDealerPurchaseProductDBTableCallEvent) {
      yield* _map_InsertDealerPurchaseProductDBTable(event);
    }

    if (event is UpdateDealerPurchaseProductDBTableCallEvent) {
      yield* _map_UpdateDealerPurchaseProductDBTable(event);
    }
    if (event is DeleteByIdDealerPurchaseProduct) {
      yield* _map_DeleteByIdPurchaseProduct(event);
    }
    if (event is DeleteAllDealerPurchaseProduct) {
      yield* _map_DeleteAllPurchaseProduct(event);
    }
    if (event is GetDealerPurchaseOtherCharge) {
      yield* _map_GetDealerPurchaseOtherCharge(event);
    }
    if (event is InsertDealerPurchaseOtherChargeTableCallEvent) {
      yield* _map_InsertDealerPurchaseOtherChargeDBTable(event);
    }
    if (event is UpdateDealerPurchaseOtherChargeTableCallEvent) {
      yield* _map_UpdateDealerPurchaseOtherChargeDBTable(event);
    }
    if (event is DeleteAllDealerPurchaseOtherCharge) {
      yield* _map_DeleteAllDealerPurchaseOtherCharge(event);
    }

    if (event is GetDealerSaleBillProduct) {
      yield* _map_GetDealerSaleBillProduct(event);
    }

    if (event is InsertDealerSaleBillProductDBTableCallEvent) {
      yield* _map_InsertDealerSaleBillProductDBTableCallEvent(event);
    }
    if (event is UpdateDealerSaleBillProductDBTableCallEvent) {
      yield* _map_UpdateDealerSaleBillProductDBTableCallEvent(event);
    }
    if (event is DeleteByIdDealerSaleBillProduct) {
      yield* _map_DeleteByIdDealerSaleBillProduct(event);
    }
    if (event is DeleteAllDealerSaleBillProduct) {
      yield* _map_DeleteAllDealerSaleBillProduct(event);
    }
    if (event is GetDealerSaleBillOtherCharge) {
      yield* _map_GetDealerSaleBillOtherCharge(event);
    }

    if (event is InsertDealerSalesBillOtherChargeTableCallEvent) {
      yield* _map_InsertDealerSalesBillOtherChargeTableCallEvent(event);
    }

    if (event is UpdateDealerSalesBillOtherChargeTableCallEvent) {
      yield* _map_UpdateDealerSalesBillOtherChargeTableCallEvent(event);
    }
    if (event is DeleteAllDealerSaleBillOtherCharge) {
      yield* _map_DeleteAllDealerSaleBillOtherCharge(event);
    }
    if (event is OtherChargeCallEvent) {
      yield* _mapOtherChargeListEventToState(event);
    }

    //
  }

  Stream<DealerStates> _mapCustomerSourceCallEventToState(
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

  Stream<DealerStates> _mapCountryListCallEventToState(
      CountryCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      CountryListResponse respo =
          await userRepository.country_list_call(event.countryListRequest);
      yield CountryListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _mapStateListCallEventToState(
      StateCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      StateListResponse respo =
          await userRepository.state_list_call(event.stateListRequest);
      yield StateListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _mapCityListCallEventToState(
      CityCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      CityApiRespose respo =
          await userRepository.city_list_details(event.cityApiRequest);
      yield CityListEventResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _mapQuotationTermsConditionEventToState(
      QuotationTermsConditionCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationTermsCondtionResponse response =
          await userRepository.getQuotationTermConditionList(event.request);
      yield QuotationTermsCondtionResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///Dealer Purchase Product DB CRUD BLOC

  Stream<DealerStates> _map_GetPurchaseProductList(
      GetDealerPurchaseProductEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<DealerPurchaseProductDBTable> dealerPurchaseProductList =
          await OfflineDbHelper.getInstance().getDelaerPurchaseProduct();

      yield GetDealerPurchaseProductState(dealerPurchaseProductList);
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_InsertDealerPurchaseProductDBTable(
      InsertDealerPurchaseProductDBTableCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .insertDelaerPurchaseProduct(DealerPurchaseProductDBTable(
        event.dealerPurchaseProductDBTable.QuotationNo,
        event.dealerPurchaseProductDBTable.ProductSpecification,
        event.dealerPurchaseProductDBTable.ProductID,
        event.dealerPurchaseProductDBTable.ProductName,
        event.dealerPurchaseProductDBTable.Unit,
        event.dealerPurchaseProductDBTable.Quantity,
        event.dealerPurchaseProductDBTable.UnitRate,
        event.dealerPurchaseProductDBTable.DiscountPercent,
        event.dealerPurchaseProductDBTable.DiscountAmt,
        event.dealerPurchaseProductDBTable.NetRate,
        event.dealerPurchaseProductDBTable.Amount,
        event.dealerPurchaseProductDBTable.TaxRate,
        event.dealerPurchaseProductDBTable.TaxAmount,
        event.dealerPurchaseProductDBTable.NetAmount,
        event.dealerPurchaseProductDBTable.TaxType,
        event.dealerPurchaseProductDBTable.CGSTPer,
        event.dealerPurchaseProductDBTable.SGSTPer,
        event.dealerPurchaseProductDBTable.IGSTPer,
        event.dealerPurchaseProductDBTable.CGSTAmt,
        event.dealerPurchaseProductDBTable.SGSTAmt,
        event.dealerPurchaseProductDBTable.IGSTAmt,
        event.dealerPurchaseProductDBTable.StateCode,
        event.dealerPurchaseProductDBTable.pkID,
        event.dealerPurchaseProductDBTable.LoginUserID,
        event.dealerPurchaseProductDBTable.CompanyId,
        event.dealerPurchaseProductDBTable.BundleId,
        event.dealerPurchaseProductDBTable.HeaderDiscAmt,
      ));

      yield InsertDealerPurchaseProductState("Product Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_UpdateDealerPurchaseProductDBTable(
      UpdateDealerPurchaseProductDBTableCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateDelaerPurchaseProduct(
          DealerPurchaseProductDBTable(
              event.dealerPurchaseProductDBTable.QuotationNo,
              event.dealerPurchaseProductDBTable.ProductSpecification,
              event.dealerPurchaseProductDBTable.ProductID,
              event.dealerPurchaseProductDBTable.ProductName,
              event.dealerPurchaseProductDBTable.Unit,
              event.dealerPurchaseProductDBTable.Quantity,
              event.dealerPurchaseProductDBTable.UnitRate,
              event.dealerPurchaseProductDBTable.DiscountPercent,
              event.dealerPurchaseProductDBTable.DiscountAmt,
              event.dealerPurchaseProductDBTable.NetRate,
              event.dealerPurchaseProductDBTable.Amount,
              event.dealerPurchaseProductDBTable.TaxRate,
              event.dealerPurchaseProductDBTable.TaxAmount,
              event.dealerPurchaseProductDBTable.NetAmount,
              event.dealerPurchaseProductDBTable.TaxType,
              event.dealerPurchaseProductDBTable.CGSTPer,
              event.dealerPurchaseProductDBTable.SGSTPer,
              event.dealerPurchaseProductDBTable.IGSTPer,
              event.dealerPurchaseProductDBTable.CGSTAmt,
              event.dealerPurchaseProductDBTable.SGSTAmt,
              event.dealerPurchaseProductDBTable.IGSTAmt,
              event.dealerPurchaseProductDBTable.StateCode,
              event.dealerPurchaseProductDBTable.pkID,
              event.dealerPurchaseProductDBTable.LoginUserID,
              event.dealerPurchaseProductDBTable.CompanyId,
              event.dealerPurchaseProductDBTable.BundleId,
              event.dealerPurchaseProductDBTable.HeaderDiscAmt,
              id: event.dealerPurchaseProductDBTable.id));

      yield UpdateDealerPurchaseProductState("Product Update Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_DeleteByIdPurchaseProduct(
      DeleteByIdDealerPurchaseProduct event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteDelaerPurchaseProduct(event.id);

      yield DeleteByIdDealerPurchaseProductState(
          "Product Deleted SuccessFully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_DeleteAllPurchaseProduct(
      DeleteAllDealerPurchaseProduct event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().deleteALLDelaerPurchaseProduct();

      yield DeleteAllDealerPurchaseProductState(
          "All Product Deleted SuccessFully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///Dealer Purchase OtherCharges DB CRUD BLOC

  Stream<DealerStates> _map_GetDealerPurchaseOtherCharge(
      GetDealerPurchaseOtherCharge event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      List<DealerPurchaseOtherChargeTable> dealerPurchaseOtherChargeTable =
          await OfflineDbHelper.getInstance().getDealerPurchaseOtherCharge();

      yield DealerPurchaseOtherChargeTableState(dealerPurchaseOtherChargeTable);
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_InsertDealerPurchaseOtherChargeDBTable(
      InsertDealerPurchaseOtherChargeTableCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .insertDealerPurchaseOtherCharge(DealerPurchaseOtherChargeTable(
        event.dealerPurchaseOtherChargeTable.Headerdiscount,
        event.dealerPurchaseOtherChargeTable.Tot_BasicAmt,
        event.dealerPurchaseOtherChargeTable.OtherChargeWithTaxamt,
        event.dealerPurchaseOtherChargeTable.Tot_GstAmt,
        event.dealerPurchaseOtherChargeTable.OtherChargeExcludeTaxamt,
        event.dealerPurchaseOtherChargeTable.Tot_NetAmount,
        event.dealerPurchaseOtherChargeTable.ChargeID1,
        event.dealerPurchaseOtherChargeTable.ChargeAmt1,
        event.dealerPurchaseOtherChargeTable.ChargeBasicAmt1,
        event.dealerPurchaseOtherChargeTable.ChargeGSTAmt1,
        event.dealerPurchaseOtherChargeTable.ChargeID2,
        event.dealerPurchaseOtherChargeTable.ChargeAmt2,
        event.dealerPurchaseOtherChargeTable.ChargeBasicAmt2,
        event.dealerPurchaseOtherChargeTable.ChargeGSTAmt2,
        event.dealerPurchaseOtherChargeTable.ChargeID3,
        event.dealerPurchaseOtherChargeTable.ChargeAmt3,
        event.dealerPurchaseOtherChargeTable.ChargeBasicAmt3,
        event.dealerPurchaseOtherChargeTable.ChargeGSTAmt3,
        event.dealerPurchaseOtherChargeTable.ChargeID4,
        event.dealerPurchaseOtherChargeTable.ChargeAmt4,
        event.dealerPurchaseOtherChargeTable.ChargeBasicAmt4,
        event.dealerPurchaseOtherChargeTable.ChargeGSTAmt4,
        event.dealerPurchaseOtherChargeTable.ChargeID5,
        event.dealerPurchaseOtherChargeTable.ChargeAmt5,
        event.dealerPurchaseOtherChargeTable.ChargeBasicAmt5,
        event.dealerPurchaseOtherChargeTable.ChargeGSTAmt5,
      ));

      yield InsertDealerPurchaseOtherChargeState(
          "OtherCharges Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_UpdateDealerPurchaseOtherChargeDBTable(
      UpdateDealerPurchaseOtherChargeTableCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateDealerPurchaseOtherCharge(
          DealerPurchaseOtherChargeTable(
              event.dealerPurchaseOtherChargeTable.Headerdiscount,
              event.dealerPurchaseOtherChargeTable.Tot_BasicAmt,
              event.dealerPurchaseOtherChargeTable.OtherChargeWithTaxamt,
              event.dealerPurchaseOtherChargeTable.Tot_GstAmt,
              event.dealerPurchaseOtherChargeTable.OtherChargeExcludeTaxamt,
              event.dealerPurchaseOtherChargeTable.Tot_NetAmount,
              event.dealerPurchaseOtherChargeTable.ChargeID1,
              event.dealerPurchaseOtherChargeTable.ChargeAmt1,
              event.dealerPurchaseOtherChargeTable.ChargeBasicAmt1,
              event.dealerPurchaseOtherChargeTable.ChargeGSTAmt1,
              event.dealerPurchaseOtherChargeTable.ChargeID2,
              event.dealerPurchaseOtherChargeTable.ChargeAmt2,
              event.dealerPurchaseOtherChargeTable.ChargeBasicAmt2,
              event.dealerPurchaseOtherChargeTable.ChargeGSTAmt2,
              event.dealerPurchaseOtherChargeTable.ChargeID3,
              event.dealerPurchaseOtherChargeTable.ChargeAmt3,
              event.dealerPurchaseOtherChargeTable.ChargeBasicAmt3,
              event.dealerPurchaseOtherChargeTable.ChargeGSTAmt3,
              event.dealerPurchaseOtherChargeTable.ChargeID4,
              event.dealerPurchaseOtherChargeTable.ChargeAmt4,
              event.dealerPurchaseOtherChargeTable.ChargeBasicAmt4,
              event.dealerPurchaseOtherChargeTable.ChargeGSTAmt4,
              event.dealerPurchaseOtherChargeTable.ChargeID5,
              event.dealerPurchaseOtherChargeTable.ChargeAmt5,
              event.dealerPurchaseOtherChargeTable.ChargeBasicAmt5,
              event.dealerPurchaseOtherChargeTable.ChargeGSTAmt5,
              id: event.dealerPurchaseOtherChargeTable.id));

      yield UpdateDealerPurchaseOtherChargeState(
          "OtherCharges Updated Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_DeleteAllDealerPurchaseOtherCharge(
      DeleteAllDealerPurchaseOtherCharge event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteALLDealerPurchaseOtherCharge();
      yield DeleteAllDealerPurchaseOtherChargeState(
          "All Product Deleted SuccessFully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///Dealer SalesBill Product DB CRUD BLOC

  Stream<DealerStates> _map_GetDealerSaleBillProduct(
      GetDealerSaleBillProduct event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      List<DealerSaleBillProductDBTable> dealerSaleBillProductDBTable =
          await OfflineDbHelper.getInstance().getDelaerSaleBillProduct();
      yield GetDealerSaleBillProductState(dealerSaleBillProductDBTable);
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_InsertDealerSaleBillProductDBTableCallEvent(
      InsertDealerSaleBillProductDBTableCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .insertDelaerSaleBillProduct(DealerSaleBillProductDBTable(
        event.dealerSaleBillProductDBTable.QuotationNo,
        event.dealerSaleBillProductDBTable.ProductSpecification,
        event.dealerSaleBillProductDBTable.ProductID,
        event.dealerSaleBillProductDBTable.ProductName,
        event.dealerSaleBillProductDBTable.Unit,
        event.dealerSaleBillProductDBTable.Quantity,
        event.dealerSaleBillProductDBTable.UnitRate,
        event.dealerSaleBillProductDBTable.DiscountPercent,
        event.dealerSaleBillProductDBTable.DiscountAmt,
        event.dealerSaleBillProductDBTable.NetRate,
        event.dealerSaleBillProductDBTable.Amount,
        event.dealerSaleBillProductDBTable.TaxRate,
        event.dealerSaleBillProductDBTable.TaxAmount,
        event.dealerSaleBillProductDBTable.NetAmount,
        event.dealerSaleBillProductDBTable.TaxType,
        event.dealerSaleBillProductDBTable.CGSTPer,
        event.dealerSaleBillProductDBTable.SGSTPer,
        event.dealerSaleBillProductDBTable.IGSTPer,
        event.dealerSaleBillProductDBTable.CGSTAmt,
        event.dealerSaleBillProductDBTable.SGSTAmt,
        event.dealerSaleBillProductDBTable.IGSTAmt,
        event.dealerSaleBillProductDBTable.StateCode,
        event.dealerSaleBillProductDBTable.pkID,
        event.dealerSaleBillProductDBTable.LoginUserID,
        event.dealerSaleBillProductDBTable.CompanyId,
        event.dealerSaleBillProductDBTable.BundleId,
        event.dealerSaleBillProductDBTable.HeaderDiscAmt,
      ));

      yield InsertDealerSaleBillProductState(
          "SalesBill Product Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_UpdateDealerSaleBillProductDBTableCallEvent(
      UpdateDealerSaleBillProductDBTableCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance().updateDelaerSaleBillProduct(
          DealerSaleBillProductDBTable(
              event.dealerSaleBillProductDBTable.QuotationNo,
              event.dealerSaleBillProductDBTable.ProductSpecification,
              event.dealerSaleBillProductDBTable.ProductID,
              event.dealerSaleBillProductDBTable.ProductName,
              event.dealerSaleBillProductDBTable.Unit,
              event.dealerSaleBillProductDBTable.Quantity,
              event.dealerSaleBillProductDBTable.UnitRate,
              event.dealerSaleBillProductDBTable.DiscountPercent,
              event.dealerSaleBillProductDBTable.DiscountAmt,
              event.dealerSaleBillProductDBTable.NetRate,
              event.dealerSaleBillProductDBTable.Amount,
              event.dealerSaleBillProductDBTable.TaxRate,
              event.dealerSaleBillProductDBTable.TaxAmount,
              event.dealerSaleBillProductDBTable.NetAmount,
              event.dealerSaleBillProductDBTable.TaxType,
              event.dealerSaleBillProductDBTable.CGSTPer,
              event.dealerSaleBillProductDBTable.SGSTPer,
              event.dealerSaleBillProductDBTable.IGSTPer,
              event.dealerSaleBillProductDBTable.CGSTAmt,
              event.dealerSaleBillProductDBTable.SGSTAmt,
              event.dealerSaleBillProductDBTable.IGSTAmt,
              event.dealerSaleBillProductDBTable.StateCode,
              event.dealerSaleBillProductDBTable.pkID,
              event.dealerSaleBillProductDBTable.LoginUserID,
              event.dealerSaleBillProductDBTable.CompanyId,
              event.dealerSaleBillProductDBTable.BundleId,
              event.dealerSaleBillProductDBTable.HeaderDiscAmt,
              id: event.dealerSaleBillProductDBTable.id));

      yield UpdateDealerSaleBillProductState(
          "SalesBill Product Updated Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_DeleteByIdDealerSaleBillProduct(
      DeleteByIdDealerSaleBillProduct event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteDelaerSaleBillProduct(event.id);
      yield DeleteByIdDealerSaleBillProductState(
          "SaleBill Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_DeleteAllDealerSaleBillProduct(
      DeleteAllDealerSaleBillProduct event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteALLDelaerSaleBillProduct();
      yield DeleteAllDealerPurchaseProductState(
          "All SaleBill Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  ///Dealer SaleBill OtherCharges DB CRUD BLOC

  Stream<DealerStates> _map_GetDealerSaleBillOtherCharge(
      GetDealerSaleBillOtherCharge event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      List<DealerSalesBillOtherChargeTable> dealerPurchaseOtherChargeTable =
          await OfflineDbHelper.getInstance().getDealerSaleBillOtherCharge();
      yield DealerSaleBillOtherChargeTableState(dealerPurchaseOtherChargeTable);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_InsertDealerSalesBillOtherChargeTableCallEvent(
      InsertDealerSalesBillOtherChargeTableCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      await OfflineDbHelper.getInstance()
          .insertDealerSaleBillOtherCharge(DealerSalesBillOtherChargeTable(
        event.dealerSalesBillOtherChargeTable.Headerdiscount,
        event.dealerSalesBillOtherChargeTable.Tot_BasicAmt,
        event.dealerSalesBillOtherChargeTable.OtherChargeWithTaxamt,
        event.dealerSalesBillOtherChargeTable.Tot_GstAmt,
        event.dealerSalesBillOtherChargeTable.OtherChargeExcludeTaxamt,
        event.dealerSalesBillOtherChargeTable.Tot_NetAmount,
        event.dealerSalesBillOtherChargeTable.ChargeID1,
        event.dealerSalesBillOtherChargeTable.ChargeAmt1,
        event.dealerSalesBillOtherChargeTable.ChargeBasicAmt1,
        event.dealerSalesBillOtherChargeTable.ChargeGSTAmt1,
        event.dealerSalesBillOtherChargeTable.ChargeID2,
        event.dealerSalesBillOtherChargeTable.ChargeAmt2,
        event.dealerSalesBillOtherChargeTable.ChargeBasicAmt2,
        event.dealerSalesBillOtherChargeTable.ChargeGSTAmt2,
        event.dealerSalesBillOtherChargeTable.ChargeID3,
        event.dealerSalesBillOtherChargeTable.ChargeAmt3,
        event.dealerSalesBillOtherChargeTable.ChargeBasicAmt3,
        event.dealerSalesBillOtherChargeTable.ChargeGSTAmt3,
        event.dealerSalesBillOtherChargeTable.ChargeID4,
        event.dealerSalesBillOtherChargeTable.ChargeAmt4,
        event.dealerSalesBillOtherChargeTable.ChargeBasicAmt4,
        event.dealerSalesBillOtherChargeTable.ChargeGSTAmt4,
        event.dealerSalesBillOtherChargeTable.ChargeID5,
        event.dealerSalesBillOtherChargeTable.ChargeAmt5,
        event.dealerSalesBillOtherChargeTable.ChargeBasicAmt5,
        event.dealerSalesBillOtherChargeTable.ChargeGSTAmt5,
      ));

      yield InsertDealerSaleBillOtherChargeState(
          "SalesBill OtherCharges Inserted Successfully");
      //yield QT_OtherChargeDeleteResponseState(response);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});

      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_UpdateDealerSalesBillOtherChargeTableCallEvent(
      UpdateDealerSalesBillOtherChargeTableCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().updateDealerSaleBillOtherCharge(
          DealerSalesBillOtherChargeTable(
              event.dealerSalesBillOtherChargeTable.Headerdiscount,
              event.dealerSalesBillOtherChargeTable.Tot_BasicAmt,
              event.dealerSalesBillOtherChargeTable.OtherChargeWithTaxamt,
              event.dealerSalesBillOtherChargeTable.Tot_GstAmt,
              event.dealerSalesBillOtherChargeTable.OtherChargeExcludeTaxamt,
              event.dealerSalesBillOtherChargeTable.Tot_NetAmount,
              event.dealerSalesBillOtherChargeTable.ChargeID1,
              event.dealerSalesBillOtherChargeTable.ChargeAmt1,
              event.dealerSalesBillOtherChargeTable.ChargeBasicAmt1,
              event.dealerSalesBillOtherChargeTable.ChargeGSTAmt1,
              event.dealerSalesBillOtherChargeTable.ChargeID2,
              event.dealerSalesBillOtherChargeTable.ChargeAmt2,
              event.dealerSalesBillOtherChargeTable.ChargeBasicAmt2,
              event.dealerSalesBillOtherChargeTable.ChargeGSTAmt2,
              event.dealerSalesBillOtherChargeTable.ChargeID3,
              event.dealerSalesBillOtherChargeTable.ChargeAmt3,
              event.dealerSalesBillOtherChargeTable.ChargeBasicAmt3,
              event.dealerSalesBillOtherChargeTable.ChargeGSTAmt3,
              event.dealerSalesBillOtherChargeTable.ChargeID4,
              event.dealerSalesBillOtherChargeTable.ChargeAmt4,
              event.dealerSalesBillOtherChargeTable.ChargeBasicAmt4,
              event.dealerSalesBillOtherChargeTable.ChargeGSTAmt4,
              event.dealerSalesBillOtherChargeTable.ChargeID5,
              event.dealerSalesBillOtherChargeTable.ChargeAmt5,
              event.dealerSalesBillOtherChargeTable.ChargeBasicAmt5,
              event.dealerSalesBillOtherChargeTable.ChargeGSTAmt5,
              id: event.dealerSalesBillOtherChargeTable.id));
      yield UpdateDealerSaleBillOtherChargeState(
          "SalesBill OtherCharges Updated Successfully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _map_DeleteAllDealerSaleBillOtherCharge(
      DeleteAllDealerSaleBillOtherCharge event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      await OfflineDbHelper.getInstance().deleteALLDealerSaleBillOtherCharge();
      yield DeleteAllDealerSaleBillOtherChargeState(
          "All SaleBill Product Deleted SuccessFully");
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      await Future.delayed(const Duration(milliseconds: 500), () {});
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<DealerStates> _mapOtherChargeListEventToState(
      OtherChargeCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      QuotationOtherChargesListResponse quotationOtherChargesListResponse =
          await userRepository.getQuotationOtherChargeList(
              event.CompanyID, event.request);
      yield OtherChargeListResponseState(quotationOtherChargesListResponse);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }
}
