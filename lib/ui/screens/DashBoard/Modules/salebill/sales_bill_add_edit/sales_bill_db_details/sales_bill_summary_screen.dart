import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/salesbill/salesbill_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/headerToDetailsResponse.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:for_practice_the_app/models/common/sales_bill_table.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/calculation/additional_charges_calculation.dart';
import 'package:for_practice_the_app/utils/calculation/model/additonalChargeDetails.dart';
import 'package:for_practice_the_app/utils/calculation/sales_bill_calculation/sales_bill_header_discount_calculation.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

class NewSalesBillOtherChargesScreenArguments {
  int StateCode;
  String HeaderDiscFromAddEditScreen;
  HeaderToDetailsResponseDetails editModel;
  String ISCalculation;

  AddditionalCharges addditionalCharges;

  NewSalesBillOtherChargesScreenArguments(
      this.StateCode,
      this.editModel,
      this.HeaderDiscFromAddEditScreen,
      this.ISCalculation,
      this.addditionalCharges);
}

class NewSalesBillOtherChargeScreen extends BaseStatefulWidget {
  static const routeName = '/NewSalesBillOtherChargeScreen';
  final NewSalesBillOtherChargesScreenArguments arguments;

  NewSalesBillOtherChargeScreen(this.arguments);

  @override
  _NewSalesBillOtherChargeScreenState createState() =>
      _NewSalesBillOtherChargeScreenState();
}

class _NewSalesBillOtherChargeScreenState
    extends BaseState<NewSalesBillOtherChargeScreen>
    with BasicScreen, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  SalesBillBloc _inquiryBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHeight = 35;
  TextEditingController _headerDiscountController = TextEditingController();
  TextEditingController _basicAmountController = TextEditingController();
  TextEditingController _otherChargeWithTaxController = TextEditingController();

  TextEditingController _totalCGSST_AMOUNT_Controller = TextEditingController();
  TextEditingController _totalSGSST_AMOUNT_Controller = TextEditingController();
  TextEditingController _totalIGSST_AMOUNT_Controller = TextEditingController();

  TextEditingController _totalGstController = TextEditingController();

  TextEditingController otherChargeGstBasicAmnt1Controller =
      TextEditingController();
  TextEditingController otherChargeGstBasicAmnt2Controller =
      TextEditingController();
  TextEditingController otherChargeGstBasicAmnt3Controller =
      TextEditingController();
  TextEditingController otherChargeGstBasicAmnt4Controller =
      TextEditingController();
  TextEditingController otherChargeGstBasicAmnt5Controller =
      TextEditingController();

  TextEditingController otherChargeGstAmnt1Controller = TextEditingController();
  TextEditingController otherChargeGstAmnt2Controller = TextEditingController();
  TextEditingController otherChargeGstAmnt3Controller = TextEditingController();
  TextEditingController otherChargeGstAmnt4Controller = TextEditingController();
  TextEditingController otherChargeGstAmnt5Controller = TextEditingController();

  //otherChargeGstAmnt1

  TextEditingController _otherChargeExcludeTaxController =
      TextEditingController();
  TextEditingController _netAmountController = TextEditingController();
  TextEditingController _roundOFController = TextEditingController();
  List<SaleBillTable> _inquiryProductList = [];
  double HeaderDisAmnt = 0.00;
  double Tot_BasicAmount = 0.00;
  double Tot_otherChargeWithTax = 0.00;
  double Tot_GSTAmt = 0.00;
  double Tot_otherChargeExcludeTax = 0.00;
  double Tot_NetAmt = 0.00;
  List<SaleBillTable> productList = [];

  //_roundOFController
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList1 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList2 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList3 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList4 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList5 = [];

  TextEditingController _otherChargeNameController1 = TextEditingController();
  TextEditingController _otherChargeNameController2 = TextEditingController();
  TextEditingController _otherChargeNameController3 = TextEditingController();
  TextEditingController _otherChargeNameController4 = TextEditingController();
  TextEditingController _otherChargeNameController5 = TextEditingController();

  TextEditingController _otherChargeIDController1 = TextEditingController();
  TextEditingController _otherChargeIDController2 = TextEditingController();
  TextEditingController _otherChargeIDController3 = TextEditingController();
  TextEditingController _otherChargeIDController4 = TextEditingController();
  TextEditingController _otherChargeIDController5 = TextEditingController();

  TextEditingController _otherChargeTaxTypeController1 =
      TextEditingController();
  TextEditingController _otherChargeTaxTypeController2 =
      TextEditingController();
  TextEditingController _otherChargeTaxTypeController3 =
      TextEditingController();
  TextEditingController _otherChargeTaxTypeController4 =
      TextEditingController();
  TextEditingController _otherChargeTaxTypeController5 =
      TextEditingController();

  TextEditingController _otherChargeGSTPerController1 = TextEditingController();
  TextEditingController _otherChargeGSTPerController2 = TextEditingController();
  TextEditingController _otherChargeGSTPerController3 = TextEditingController();
  TextEditingController _otherChargeGSTPerController4 = TextEditingController();
  TextEditingController _otherChargeGSTPerController5 = TextEditingController();

  TextEditingController _otherChargeBeForeGSTController1 =
      TextEditingController();
  TextEditingController _otherChargeBeForeGSTController2 =
      TextEditingController();
  TextEditingController _otherChargeBeForeGSTController3 =
      TextEditingController();
  TextEditingController _otherChargeBeForeGSTController4 =
      TextEditingController();
  TextEditingController _otherChargeBeForeGSTController5 =
      TextEditingController();

  TextEditingController _otherAmount1 = TextEditingController();
  TextEditingController _otherAmount2 = TextEditingController();
  TextEditingController _otherAmount3 = TextEditingController();
  TextEditingController _otherAmount4 = TextEditingController();
  TextEditingController _otherAmount5 = TextEditingController();

  AddditionalCharges _addditionalCharges;

  List<OtherChargeDetails> arrGenericOtheCharge = [];

  @override
  void initState() {
    super.initState();

    _otherChargeNameController1.text = "";
    _otherChargeNameController2.text = "";
    _otherChargeNameController3.text = "";
    _otherChargeNameController4.text = "";
    _otherChargeNameController5.text = "";
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId;

    _inquiryBloc = SalesBillBloc(baseBloc);

    _headerDiscountController.text =
        widget.arguments.HeaderDiscFromAddEditScreen == null
            ? "0.00"
            : widget.arguments.HeaderDiscFromAddEditScreen;

    print("sjdjdf223" +
        " HeaderDiscount : " +
        _headerDiscountController.text.toString());
    _inquiryBloc.add(QuotationOtherCharge1CallEvent(
        CompanyID.toString(), QuotationOtherChargesListRequest(pkID: "")));

    _inquiryBloc.add(GetGenericAddditionalChargesEvent());

    _inquiryBloc.add(QuotationOtherChargeCallEvent(
        _headerDiscountController.text,
        CompanyID.toString(),
        QuotationOtherChargesListRequest(pkID: "")));

    _addditionalCharges = widget.arguments.addditionalCharges;

    _inquiryBloc.add(GetQuotationProductListEvent());

    //  _headerDiscountController.text = "0.00";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<SalesBillBloc, SalesBillStates>(
        builder: (BuildContext context, SalesBillStates state) {
          if (state is GetQuotationProductListState) {
            _OnGetQuotationProductList(state);
          }
          if (state is QuotationOtherChargeListResponseState) {
            _onOtherChargeListResponse(state);
          }
          if (state is QuotationOtherCharge1ListResponseState) {
            _OnChargID1Response(state);
          }
          if (state is GetGenericAddditionalChargesState) {
            _OngetAdditionalCharges(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetQuotationProductListState ||
              currentState is QuotationOtherChargeListResponseState ||
              currentState is QuotationOtherCharge1ListResponseState ||
              currentState is GetGenericAddditionalChargesState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, SalesBillStates state) {
          if (state is InsertProductSucessResponseState) {
            _OnProductSucessResponse(state);
          }

          if (state is DeleteALLQuotationProductTableState) {
            _OnProductDeleteSucessResponse(state);
          }

          if (state is AddGenericAddditionalChargesState) {
            _OnGenericIsertCallSucess(state);
          }

          if (state is DeleteAllGenericAddditionalChargesState) {
            _onDeleteAllGenericAddtionalAmount(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is InsertProductSucessResponseState ||
              currentState is DeleteALLQuotationProductTableState ||
              currentState is AddGenericAddditionalChargesState ||
              currentState is DeleteAllGenericAddditionalChargesState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();

    _headerDiscountController.dispose();
    _basicAmountController.dispose();
    _otherChargeWithTaxController.dispose();
    _totalGstController.dispose();
    _otherChargeExcludeTaxController.dispose();
    _netAmountController.dispose();
    _roundOFController.dispose();

    _otherChargeNameController1.dispose();
    _otherChargeNameController2.dispose();
    _otherChargeNameController3.dispose();
    _otherChargeNameController4.dispose();
    _otherChargeNameController5.dispose();

    _otherChargeIDController1.dispose();
    _otherChargeIDController2.dispose();
    _otherChargeIDController3.dispose();
    _otherChargeIDController4.dispose();
    _otherChargeIDController5.dispose();

    _otherChargeTaxTypeController1.dispose();
    _otherChargeTaxTypeController2.dispose();
    _otherChargeTaxTypeController3.dispose();
    _otherChargeTaxTypeController4.dispose();
    _otherChargeTaxTypeController5.dispose();

    _otherChargeGSTPerController1.dispose();
    _otherChargeGSTPerController2.dispose();
    _otherChargeGSTPerController3.dispose();
    _otherChargeGSTPerController4.dispose();
    _otherChargeGSTPerController5.dispose();

    _otherChargeBeForeGSTController1.dispose();
    _otherChargeBeForeGSTController2.dispose();
    _otherChargeBeForeGSTController3.dispose();
    _otherChargeBeForeGSTController4.dispose();
    _otherChargeBeForeGSTController5.dispose();

    _otherAmount1.dispose();
    _otherAmount2.dispose();
    _otherAmount3.dispose();
    _otherAmount4.dispose();
    _otherAmount5.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Column(
        children: [
          getCommonAppBar(
              context,
              baseTheme,
              widget.arguments.ISCalculation == "Calculation"
                  ? "Final Summary"
                  : "Additional Charges",
              showBack: true,
              showHome: false, onTapOfBack: () {
            _onBackPressed();
            // Navigator.of(context).pop();
          }),
          Expanded(
            child: SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    widget.arguments.ISCalculation == "Calculation"
                        ? Column(children: [
                            Row(
                              children: [
                                Expanded(flex: 1, child: DiscountAmount()),
                                Expanded(flex: 1, child: BasicAmount())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(flex: 1, child: OtherChargeWithTax()),
                              Expanded(flex: 1, child: TotalGST())
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                  flex: 1, child: OtherChargeExcludingTax()),
                              Expanded(flex: 1, child: RoundOff())
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            NetAmount(),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ])
                        : Container(),
                    widget.arguments.ISCalculation == "OtherCharge"
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                Expanded(
                                    flex: 2,
                                    child: Text("  Charge Type",
                                        style: TextStyle(
                                            color: colorPrimary,
                                            fontSize: 15))),
                                Expanded(
                                    flex: 1,
                                    child: Text("  Amount",
                                        style: TextStyle(
                                            color: colorPrimary, fontSize: 15)))
                              ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: OtherChargeDropDown1(
                                          "Other Charge 1",
                                          enable1: false,
                                          title: "Other Charge 1",
                                          hintTextvalue: "Select Other Charge",
                                          icon: Icon(Icons.arrow_drop_down),
                                          controllerForLeft:
                                              _otherChargeNameController1,
                                          controllerpkID:
                                              _otherChargeIDController1,
                                          Custom_values1:
                                              arr_ALL_Name_ID_For_ProjectList1),
                                    ),
                                    Expanded(flex: 1, child: OtherAmount1())
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: OtherChargeDropDown2(
                                          "Other Charge 1",
                                          enable1: false,
                                          title: "Other Charge 1",
                                          hintTextvalue: "Select Other Charge",
                                          icon: Icon(Icons.arrow_drop_down),
                                          controllerForLeft:
                                              _otherChargeNameController2,
                                          controllerpkID:
                                              _otherChargeIDController2,
                                          Custom_values1:
                                              arr_ALL_Name_ID_For_ProjectList2),
                                    ),
                                    Expanded(flex: 1, child: OtherAmount2())
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: OtherChargeDropDown3(
                                          "Other Charge 1",
                                          enable1: false,
                                          title: "Other Charge 1",
                                          hintTextvalue: "Select Other Charge",
                                          icon: Icon(Icons.arrow_drop_down),
                                          controllerForLeft:
                                              _otherChargeNameController3,
                                          controllerpkID:
                                              _otherChargeIDController3,
                                          Custom_values1:
                                              arr_ALL_Name_ID_For_ProjectList3),
                                    ),
                                    Expanded(flex: 1, child: OtherAmount3())
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: OtherChargeDropDown4(
                                          "Other Charge 1",
                                          enable1: false,
                                          title: "Other Charge 1",
                                          hintTextvalue: "Select Other Charge",
                                          icon: Icon(Icons.arrow_drop_down),
                                          controllerForLeft:
                                              _otherChargeNameController4,
                                          controllerpkID:
                                              _otherChargeIDController4,
                                          Custom_values1:
                                              arr_ALL_Name_ID_For_ProjectList4),
                                    ),
                                    Expanded(flex: 1, child: OtherAmount4())
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: OtherChargeDropDown5(
                                          "Other Charge 1",
                                          enable1: false,
                                          title: "Other Charge 1",
                                          hintTextvalue: "Select Other Charge",
                                          icon: Icon(Icons.arrow_drop_down),
                                          controllerForLeft:
                                              _otherChargeNameController5,
                                          controllerpkID:
                                              _otherChargeIDController5,
                                          Custom_values1:
                                              arr_ALL_Name_ID_For_ProjectList5),
                                    ),
                                    Expanded(flex: 1, child: OtherAmount5())
                                  ]),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          )
                        : Container(),
                    getCommonButton(baseTheme, () {
                      _OnTaptoSave();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("OtherCharges Update SucessFully !"),
                      ));
                    }, "Submit")
                  ],
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    _OnTaptoSave();
    _OnTaptoSave();

    AddditionalCharges addditionalCharges = AddditionalCharges(
      DiscountAmt: _headerDiscountController.text.toString(),
      SGSTAmt: _totalSGSST_AMOUNT_Controller.text.toString(),
      CGSTAmt: _totalCGSST_AMOUNT_Controller.text.toString(),
      IGSTAmt: _totalIGSST_AMOUNT_Controller.text.toString(),
      ChargeID1: _otherChargeIDController1.text.toString(),
      ChargeAmt1: _otherAmount1.text.toString(),
      ChargeBasicAmt1: otherChargeGstBasicAmnt1Controller.text.toString(),
      ChargeGSTAmt1: otherChargeGstAmnt1Controller.text.toString(),
      ChargeID2: _otherChargeIDController2.text.toString(),
      ChargeAmt2: _otherAmount2.text.toString(),
      ChargeBasicAmt2: otherChargeGstBasicAmnt2Controller.text.toString(),
      ChargeGSTAmt2: otherChargeGstAmnt2Controller.text.toString(),
      ChargeID3: _otherChargeIDController3.text.toString(),
      ChargeAmt3: _otherAmount3.text.toString(),
      ChargeBasicAmt3: otherChargeGstBasicAmnt3Controller.text.toString(),
      ChargeGSTAmt3: otherChargeGstAmnt3Controller.text.toString(),
      ChargeID4: _otherChargeIDController4.text.toString(),
      ChargeAmt4: _otherAmount4.text.toString(),
      ChargeBasicAmt4: otherChargeGstBasicAmnt4Controller.text.toString(),
      ChargeGSTAmt4: otherChargeGstAmnt4Controller.text.toString(),
      ChargeID5: _otherChargeIDController5.text.toString(),
      ChargeAmt5: _otherAmount5.text.toString(),
      ChargeBasicAmt5: otherChargeGstBasicAmnt5Controller.toString(),
      ChargeGSTAmt5: otherChargeGstAmnt5Controller.text.toString(),
      NetAmt: _netAmountController.text.toString(),
      BasicAmt: _basicAmountController.text.toString(),
      ROffAmt: _roundOFController.text.toString(),
      ChargePer1: _otherChargeGSTPerController1.text.toString(),
      ChargePer2: _otherChargeGSTPerController2.text.toString(),
      ChargePer3: _otherChargeGSTPerController3.text.toString(),
      ChargePer4: _otherChargeGSTPerController4.text.toString(),
      ChargePer5: _otherChargeGSTPerController5.text.toString(),
    );

    print("_headerDiscountController.text.toString()," +
        _headerDiscountController.text.toString());

    Navigator.of(context).pop(addditionalCharges);
    print("Tap To BackEvent");
  }

  Widget DiscountAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Discount Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: TextFormField(
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Please enter this field";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _headerDiscountController,
                onTap: () => {
                      _headerDiscountController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _headerDiscountController.text.length,
                      )
                    },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10),
                  hintText: "0.00",
                  labelStyle: TextStyle(
                    color: Color(0xFF000000),
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF000000),
                ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
        )
      ],
    );
  }

  Widget BasicAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Basic Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: TextFormField(
                // key: Key(totalCalculated()),

                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Please enter this field";
                  }
                  return null;
                },
                enabled: false,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _basicAmountController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 10),
                  hintText: "0.00",
                  labelStyle: TextStyle(
                    color: Color(0xFF000000),
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF000000),
                ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
        )
      ],
    );
  }

  Widget OtherChargeWithTax() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("OtherCharge(With Tax)",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _otherChargeWithTaxController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget TotalGST() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Total GST",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _totalGstController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget OtherChargeExcludingTax() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("OtherCharge(Exc.Tax)",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _otherChargeExcludeTaxController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget NetAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Net Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _netAmountController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget RoundOff() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Round Off",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 3,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _roundOFController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _OnGetQuotationProductList(GetQuotationProductListState state) {
    if (state.response != null) {
      String CustomerStateID = state.response[0].StateCode.toString();
      productList.clear();
      for (int i = 0; i < state.response.length; i++) {
        productList.add(state.response[i]);
      }

      //_headerDiscountController.text = "100.00";
      HeaderDisAmnt = _headerDiscountController.text.isNotEmpty
          ? double.parse(_headerDiscountController.text)
          : 0.00;

      // HeaderDisAmnt = 100;
      String CompanyStateCode =
          _offlineLoggedInData.details[0].stateCode.toString();

      print("jfjjfd" + HeaderDisAmnt.toString());

      List<SaleBillTable> TempproductList1 =
          SalesBillOrderHeaderDiscountCalculation.txtHeadDiscount_WithZero(
              productList, HeaderDisAmnt, CompanyStateCode, CustomerStateID);

      List<SaleBillTable> TempproductList =
          SalesBillOrderHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
              TempproductList1,
              HeaderDisAmnt,
              CompanyStateCode,
              CustomerStateID);

      for (int i = 0; i < productList.length; i++) {
        print("productList" +
            " AmountFromProductList : " +
            productList[i].DiscountPercent.toString() +
            " NetAmountFromProductList : " +
            productList[i].DiscountAmt.toString() +
            " NetRate : " +
            productList[i].NetRate.toString() +
            " BasicAmount : " +
            productList[i].Amount.toString() +
            " NetAmnount : " +
            productList[i].NetAmount.toString());
      }

      for (int i = 0; i < TempproductList1.length; i++) {
        print("TempproductList1" +
            " AmountCalculation : " +
            TempproductList1[i].DiscountPercent.toString() +
            " NetAmountCalculation : " +
            TempproductList1[i].DiscountAmt.toString() +
            " NetRate : " +
            TempproductList1[i].NetRate.toString() +
            " BasicAmount : " +
            TempproductList1[i].Amount.toString() +
            " NetAmount : " +
            TempproductList1[i].NetAmount.toString());
      }

      for (int i = 0; i < TempproductList.length; i++) {
        print("TempproductList" +
            " AmountCalculation : " +
            TempproductList[i].DiscountPercent.toString() +
            " NetAmountCalculation : " +
            TempproductList[i].DiscountAmt.toString() +
            " NetRate : " +
            TempproductList[i].NetRate.toString() +
            " BasicAmount : " +
            TempproductList[i].Amount.toString() +
            " NetAmount : " +
            TempproductList[i].NetAmount.toString());
      }
      UpdateHeaderDiscountCalculation(TempproductList);
    }
    /* double Tot_BasicAmount = 0.00;
      double Tot_GSTAmt = 0.00;
      double Tot_NetAmt = 0.00;
      productList.clear();
      for (int i = 0; i < state.response.length; i++) {
        productList.add(state.response[i]);
        Tot_BasicAmount += state.response[i].Amount;
        Tot_otherChargeWithTax = 0.00;

        ///Before Gst
        Tot_GSTAmt += state.response[i].TaxAmount;
        Tot_otherChargeExcludeTax = 0.00;

        ///AFTER gst
        Tot_NetAmt += state.response[i].NetAmount;
      }
      _basicAmountController.text = Tot_BasicAmount.toStringAsFixed(2);
      _totalGstController.text = Tot_GSTAmt.toStringAsFixed(2);
      _netAmountController.text = Tot_NetAmt.toStringAsFixed(2);
    }*/

    _inquiryBloc.add(QuotationOtherChargeCallEvent(
        _headerDiscountController.text,
        CompanyID.toString(),
        QuotationOtherChargesListRequest(pkID: "")));
  }

  void _OnTaptoSave() {
    String CustomerStateID = "";
    if (productList != null) {
      CustomerStateID = productList[0].StateCode.toString();

      HeaderDisAmnt = _headerDiscountController.text.isNotEmpty
          ? double.parse(_headerDiscountController.text)
          : 0.00;
      String CompanyStateCode =
          _offlineLoggedInData.details[0].stateCode.toString();

      List<SaleBillTable> TempproductList1 =
          SalesBillOrderHeaderDiscountCalculation.txtHeadDiscount_WithZero(
              productList, HeaderDisAmnt, CompanyStateCode, CustomerStateID);

      List<SaleBillTable> TempproductList =
          SalesBillOrderHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
              TempproductList1,
              HeaderDisAmnt,
              CompanyStateCode,
              CustomerStateID);

      UpdateHeaderDiscountCalculation(TempproductList);

      _inquiryBloc.add(DeleteAllQuotationProductEvent());
      _inquiryBloc.add(InsertProductEvent(TempproductList));

      _inquiryBloc.add(DeleteGenericAddditionalChargesEvent());

      GenericAddditionalCharges newGenericAddditionalCharges =
          GenericAddditionalCharges(
        _headerDiscountController.text.toString(),
        _otherChargeIDController1.text.toString(),
        _otherAmount1.text.toString(),
        _otherChargeIDController2.text.toString(),
        _otherAmount2.text.toString(),
        _otherChargeIDController3.text.toString(),
        _otherAmount3.text.toString(),
        _otherChargeIDController4.text.toString(),
        _otherAmount4.text.toString(),
        _otherChargeIDController5.text.toString(),
        _otherAmount5.text.toString(),
        _otherChargeNameController1.text,
        _otherChargeNameController2.text,
        _otherChargeNameController3.text,
        _otherChargeNameController4.text,
        _otherChargeNameController5.text,
      );

      _inquiryBloc
          .add(AddGenericAddditionalChargesEvent(newGenericAddditionalCharges));
    }
  }

  void UpdateHeaderDiscountCalculation(List<SaleBillTable> tempproductList) {
    if (tempproductList != null) {
      double Tot_BasicAmount = 0.00;
      double Tot_GSTAmt = 0.00;
      double Tot_CGSTAmt = 0.00;
      double Tot_SGSTAmt = 0.00;
      double Tot_IGSTAmt = 0.00;

      double Tot_NetAmt = 0.00;
      // productList.clear();

      for (int i = 0; i < tempproductList.length; i++) {
        print("Amount" +
            tempproductList[i].Amount.toString() +
            "NetAmount : " +
            tempproductList[i].Amount.toString());
        // productList.add(tempproductList[i]);
        Tot_BasicAmount += tempproductList[i].Amount;
        Tot_otherChargeWithTax = 0.00;

        ///Before Gst
        Tot_GSTAmt += tempproductList[i].TaxAmount;
        Tot_CGSTAmt += tempproductList[i].CGSTAmt;
        Tot_SGSTAmt += tempproductList[i].SGSTAmt;
        Tot_IGSTAmt += tempproductList[i].IGSTAmt;

        Tot_otherChargeExcludeTax = 0.00;

        ///AFTER gst
        Tot_NetAmt += tempproductList[i].NetAmount;
      }

      print("FinalAmount" +
          " BasicAmount : " +
          Tot_BasicAmount.toString() +
          " TotalGST Amnt : " +
          Tot_GSTAmt.toString() +
          " Tot_NetAmt : " +
          Tot_NetAmt.toString());
      HeaderDisAmnt = _headerDiscountController.text.isNotEmpty
          ? double.parse(_headerDiscountController.text)
          : 0.00;

      /*print("jsf" +
          int.parse(_otherChargeIDController1.text).toString() +
          " = " +
          double.parse(_otherAmount1.text).toString() +
          " = " +
          double.parse(_otherChargeGSTPerController1.text).toString() +
          " = " +
          int.parse(_otherChargeTaxTypeController1.text).toString() +
          " = " +
          _otherChargeBeForeGSTController1.text.toLowerCase().toString());*/

      List<double> hdnOthChrgGST1hdnOthChrgBasic1 = [],
          hdnOthChrgGST1hdnOthChrgBasic2 = [],
          hdnOthChrgGST1hdnOthChrgBasic3 = [],
          hdnOthChrgGST1hdnOthChrgBasic4 = [],
          hdnOthChrgGST1hdnOthChrgBasic5 = [];

      Tot_otherChargeWithTax = 0.00;

      for (int i = 0; i < arrGenericOtheCharge.length; i++) {
        print("TAXXXXX" + arrGenericOtheCharge[i].chargeName);
        if (_otherChargeIDController1.text ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController1.text =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController1.text =
              arrGenericOtheCharge[i].beforeGST.toString();
        }

        if (_otherChargeIDController2.text ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController2.text =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController2.text =
              arrGenericOtheCharge[i].beforeGST.toString();
        }
        if (_otherChargeIDController3.text ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController3.text =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController3.text =
              arrGenericOtheCharge[i].beforeGST.toString();
        }
        if (_otherChargeIDController4.text ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController4.text =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController4.text =
              arrGenericOtheCharge[i].beforeGST.toString();
        }
        if (_otherChargeIDController5.text ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController5.text =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController5.text =
              arrGenericOtheCharge[i].beforeGST.toString();
        }
      }

      if (_otherChargeNameController1.text.isNotEmpty) {
        if (_otherChargeNameController1.text.toString() != "null") {
          print("AA1" + _otherChargeBeForeGSTController1.text.toString());

          hdnOthChrgGST1hdnOthChrgBasic1 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController1.text.isNotEmpty
                      ? int.parse(_otherChargeIDController1.text)
                      : 0,
                  _otherAmount1.text.isNotEmpty
                      ? double.parse(_otherAmount1.text)
                      : 0.00,
                  _otherChargeGSTPerController1.text.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController1.text)
                      : 0.00,
                  _otherChargeTaxTypeController1.text.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController1.text.toString() ==
                                  "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController1.text.toString())
                      : 0,
                  _otherChargeBeForeGSTController1.text.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController1.text == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic1[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic1[1];
          }
        } else {
          _otherChargeNameController1.text = "";
        }
      }
      if (_otherChargeNameController2.text.isNotEmpty) {
        if (_otherChargeNameController2.text.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic2 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController2.text.isNotEmpty
                      ? int.parse(_otherChargeIDController2.text)
                      : 0,
                  _otherAmount2.text.isNotEmpty
                      ? double.parse(_otherAmount2.text)
                      : 0.00,
                  _otherChargeGSTPerController2.text.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController2.text)
                      : 0.00,
                  _otherChargeTaxTypeController2.text.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController2.text.toString() ==
                                  "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController2.text.toString())
                      : 0,
                  _otherChargeBeForeGSTController2.text.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController2.text == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic2[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic2[1];
          }
        } else {
          _otherChargeNameController2.text = "";
        }
      }

      print("ds9980" + _otherChargeNameController3.text.toString());
      if (_otherChargeNameController3.text.isNotEmpty) {
        if (_otherChargeNameController3.text.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic3 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController3.text.isNotEmpty
                      ? int.parse(_otherChargeIDController3.text)
                      : 0,
                  _otherAmount3.text.isNotEmpty
                      ? double.parse(_otherAmount3.text)
                      : 0.00,
                  _otherChargeGSTPerController3.text.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController3.text)
                      : 0.00,
                  _otherChargeTaxTypeController3.text.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController3.text.toString() ==
                                  "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController3.text.toString())
                      : 0,
                  _otherChargeBeForeGSTController3.text.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController3.text == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic3[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic3[1];
          }
        } else {
          _otherChargeNameController3.text = "";
        }
      }

      if (_otherChargeNameController4.text.isNotEmpty) {
        if (_otherChargeNameController4.text.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic4 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController4.text.isNotEmpty
                      ? int.parse(_otherChargeIDController4.text)
                      : 0,
                  _otherAmount4.text.isNotEmpty
                      ? double.parse(_otherAmount4.text)
                      : 0.00,
                  _otherChargeGSTPerController4.text.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController4.text)
                      : 0.00,
                  _otherChargeTaxTypeController4.text.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController4.text.toString() ==
                                  "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController4.text.toString())
                      : 0,
                  _otherChargeBeForeGSTController4.text.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController4.text == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          }
        } else {
          _otherChargeNameController4.text = "";
        }
      }

      if (_otherChargeNameController5.text.isNotEmpty) {
        if (_otherChargeNameController5.text.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic5 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController5.text.isNotEmpty
                      ? int.parse(_otherChargeIDController5.text)
                      : 0,
                  _otherAmount5.text.isNotEmpty
                      ? double.parse(_otherAmount5.text)
                      : 0.00,
                  _otherChargeGSTPerController5.text.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController5.text)
                      : 0.00,
                  _otherChargeTaxTypeController5.text.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController5.text.toString() ==
                                  "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController5.text.toString())
                      : 0,
                  _otherChargeBeForeGSTController5.text.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController5.text == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          }
        } else {
          _otherChargeNameController5.text = "";
        }
      }

      /*  if (_otherChargeNameController4.text.isNotEmpty) {
        if (_otherChargeNameController4.text.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic4 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  int.parse(_otherChargeIDController4.text),
                  double.parse(_otherAmount4.text),
                  double.parse(_otherChargeGSTPerController4.text),
                  int.parse(
                      _otherChargeTaxTypeController4.text.toString() == "0.00"
                          ? "0"
                          : _otherChargeTaxTypeController4.text.toString()),
                  _otherChargeBeForeGSTController4.text.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController4.text == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          }
        } else {
          _otherChargeNameController4.text = "";
        }
      }
      if (_otherChargeNameController5.text.isNotEmpty) {
        if (_otherChargeNameController5.text.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic5 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  int.parse(_otherChargeIDController5.text),
                  double.parse(_otherAmount5.text),
                  double.parse(_otherChargeGSTPerController5.text),
                  int.parse(
                      _otherChargeTaxTypeController5.text.toString() == "0.00"
                          ? "0"
                          : _otherChargeTaxTypeController5.text.toString()),
                  _otherChargeBeForeGSTController5.text.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController5.text == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          }
        } else {
          _otherChargeNameController5.text = "";
        }
      }*/

      /* print("llll" +
          "hdnOthChrgGST1" +
          hdnOthChrgGST1hdnOthChrgBasic1[0].toString() +
          " hdnOthChrgBasic1 : " +
          hdnOthChrgGST1hdnOthChrgBasic1[1].toString());*/

      double otherChargeGstAmnt1 = hdnOthChrgGST1hdnOthChrgBasic1.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic1[0]
          : 0.00;
      double otherChargeGstBasicAmnt1 =
          hdnOthChrgGST1hdnOthChrgBasic1.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic1[1]
              : 0.00;
      double otherChargeGstAmnt2 = hdnOthChrgGST1hdnOthChrgBasic2.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic2[0]
          : 0.00;
      double otherChargeGstBasicAmnt2 =
          hdnOthChrgGST1hdnOthChrgBasic2.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic2[1]
              : 0.00;
      double otherChargeGstAmnt3 = hdnOthChrgGST1hdnOthChrgBasic3.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic3[0]
          : 0.00;
      double otherChargeGstBasicAmnt3 =
          hdnOthChrgGST1hdnOthChrgBasic3.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic3[1]
              : 0.00;
      double otherChargeGstAmnt4 = hdnOthChrgGST1hdnOthChrgBasic4.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic4[0]
          : 0.00;
      double otherChargeGstBasicAmnt4 =
          hdnOthChrgGST1hdnOthChrgBasic4.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic4[1]
              : 0.00;

      double otherChargeGstAmnt5 = hdnOthChrgGST1hdnOthChrgBasic5.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic5[0]
          : 0.00;
      double otherChargeGstBasicAmnt5 =
          hdnOthChrgGST1hdnOthChrgBasic5.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic5[1]
              : 0.00;

      List<double> TempproductList =
          SalesBillOrderHeaderDiscountCalculation.funCalculateTotal(
              otherChargeGstAmnt1,
              otherChargeGstAmnt2,
              otherChargeGstAmnt3,
              otherChargeGstAmnt4,
              otherChargeGstAmnt5,
              otherChargeGstBasicAmnt1,
              otherChargeGstBasicAmnt2,
              otherChargeGstBasicAmnt3,
              otherChargeGstBasicAmnt4,
              otherChargeGstBasicAmnt5,
              Tot_CGSTAmt,
              Tot_SGSTAmt,
              Tot_IGSTAmt,
              Tot_BasicAmount,
              Tot_NetAmt,
              HeaderDisAmnt,
              Tot_otherChargeWithTax,
              Tot_otherChargeExcludeTax);

      double totalGstController = 0.00,
          netAmountController = 0.00,
          roundOFController = 0.00;
      totalGstController = TempproductList[2];
      netAmountController = TempproductList[4];
      roundOFController = TempproductList[5];

      _basicAmountController.text = Tot_BasicAmount.toStringAsFixed(2);
      _otherChargeWithTaxController.text =
          Tot_otherChargeWithTax.toStringAsFixed(2);
      //TempproductList[0].toStringAsFixed(2);
      _otherChargeExcludeTaxController.text =
          Tot_otherChargeExcludeTax.toStringAsFixed(2);
      // TempproductList[3].toStringAsFixed(2);

      _totalCGSST_AMOUNT_Controller.text = Tot_CGSTAmt.toStringAsFixed(2);
      _totalSGSST_AMOUNT_Controller.text = Tot_SGSTAmt.toStringAsFixed(2);
      _totalIGSST_AMOUNT_Controller.text = Tot_IGSTAmt.toStringAsFixed(2);

      otherChargeGstBasicAmnt1Controller.text =
          otherChargeGstBasicAmnt1.toStringAsFixed(2);
      otherChargeGstBasicAmnt2Controller.text =
          otherChargeGstBasicAmnt2.toStringAsFixed(2);
      otherChargeGstBasicAmnt3Controller.text =
          otherChargeGstBasicAmnt3.toStringAsFixed(2);
      otherChargeGstBasicAmnt4Controller.text =
          otherChargeGstBasicAmnt4.toStringAsFixed(2);
      otherChargeGstBasicAmnt5Controller.text =
          otherChargeGstBasicAmnt5.toStringAsFixed(2);

      otherChargeGstAmnt1Controller.text =
          otherChargeGstAmnt1.toStringAsFixed(2);
      otherChargeGstAmnt2Controller.text =
          otherChargeGstAmnt2.toStringAsFixed(2);
      otherChargeGstAmnt3Controller.text =
          otherChargeGstAmnt3.toStringAsFixed(2);
      otherChargeGstAmnt4Controller.text =
          otherChargeGstAmnt4.toStringAsFixed(2);
      otherChargeGstAmnt5Controller.text =
          otherChargeGstAmnt5.toStringAsFixed(2);

      _totalGstController.text = totalGstController.toStringAsFixed(2);
      _netAmountController.text = netAmountController.toStringAsFixed(2);
      _roundOFController.text = roundOFController.toStringAsFixed(2);
    }
  }

  Widget OtherChargeDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      //  margin: EdgeInsets.only(top: 3, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList1,
                context1: context,
                controller: _otherChargeNameController1,
                controllerID: _otherChargeIDController1,
                controller1: _otherChargeGSTPerController1,
                controller2: _otherChargeTaxTypeController1,
                controller3: _otherChargeBeForeGSTController1,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    // height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                // contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget OtherChargeDropDown2(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      //margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList2,
                context1: context,
                controller: _otherChargeNameController2,
                controllerID: _otherChargeIDController2,
                controller1: _otherChargeGSTPerController2,
                controller2: _otherChargeTaxTypeController2,
                controller3: _otherChargeBeForeGSTController2,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    //height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                //contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget OtherChargeDropDown3(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      //margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList3,
                context1: context,
                controller: _otherChargeNameController3,
                controllerID: _otherChargeIDController3,
                controller1: _otherChargeGSTPerController3,
                controller2: _otherChargeTaxTypeController3,
                controller3: _otherChargeBeForeGSTController3,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    // height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                //contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget OtherChargeDropDown4(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      // margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList4,
                context1: context,
                controller: _otherChargeNameController4,
                controllerID: _otherChargeIDController4,
                controller1: _otherChargeGSTPerController4,
                controller2: _otherChargeTaxTypeController4,
                controller3: _otherChargeBeForeGSTController4,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    //height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                //contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget OtherChargeDropDown5(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      // margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOtherCharges(
                values: arr_ALL_Name_ID_For_ProjectList5,
                context1: context,
                controller: _otherChargeNameController5,
                controllerID: _otherChargeIDController5,
                controller1: _otherChargeGSTPerController5,
                controller2: _otherChargeTaxTypeController5,
                controller3: _otherChargeBeForeGSTController5,
                lable: "Select Other Charge"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    // height: CardViewHeight,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                //contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                              ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget OtherAmount1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            // height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Focus(
              child: TextFormField(
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter this field";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _otherAmount1,
                  onTap: () => {
                        _otherAmount1.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _otherAmount1.text.length,
                        )
                      },
                  decoration: InputDecoration(
                    //  contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: "0.00",
                    labelStyle: TextStyle(
                      color: Color(0xFF000000),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              /*onFocusChange: (hasFocus){
                  if(hasFocus)
                    {
                      TotalCalculation();
                    }
                },*/
            ),
            /*  onFocusChange: (hasFocus) {
                if(hasFocus) {
                  // do stuff



                }
              },
            ),*/
          ),
        )
      ],
    );
  }

  Widget OtherAmount2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            //  height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Focus(
              child: TextFormField(
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter this field";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _otherAmount2,
                  onTap: () => {
                        _otherAmount2.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _otherAmount2.text.length,
                        )
                      },
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: "0.00",
                    labelStyle: TextStyle(
                      color: Color(0xFF000000),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              /* onFocusChange: (hasFocus){
                if(hasFocus){
                  TotalCalculation2();
                }
              },*/
            ),
          ),
        )
      ],
    );
  }

  Widget OtherAmount3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            //  height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Focus(
              child: TextFormField(
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter this field";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _otherAmount3,
                  onTap: () => {
                        _otherAmount3.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _otherAmount3.text.length,
                        )
                      },
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: "0.00",
                    labelStyle: TextStyle(
                      color: Color(0xFF000000),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              /* onFocusChange: (hasFocus)
              {
                if(hasFocus)
                  {
                    TotalCalculation3();
                  }
              },*/
            ),
          ),
        )
      ],
    );
  }

  Widget OtherAmount4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            // height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Focus(
              child: TextFormField(
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter this field";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _otherAmount4,
                  onTap: () => {
                        _otherAmount4.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _otherAmount4.text.length,
                        )
                      },
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.only(bottom: 10),
                    hintText: "0.00",
                    labelStyle: TextStyle(
                      color: Color(0xFF000000),
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF000000),
                  ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              onFocusChange: (hasFocus) {
                if (hasFocus) {}
              },
            ),
          ),
        )
      ],
    );
  }

  Widget OtherAmount5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            //height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            alignment: Alignment.center,
            child: TextFormField(
                validator: (value) {
                  if (value.toString().trim().isEmpty) {
                    return "Please enter this field";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _otherAmount5,
                onTap: () => {
                      _otherAmount5.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _otherAmount5.text.length,
                      )
                    },
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.only(bottom: 10),
                  hintText: "0.00",
                  labelStyle: TextStyle(
                    color: Color(0xFF000000),
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF000000),
                ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
        )
      ],
    );
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void _onOtherChargeListResponse(QuotationOtherChargeListResponseState state) {
    if (state.quotationOtherChargesListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_ProjectList1.clear();
      arr_ALL_Name_ID_For_ProjectList2.clear();
      arr_ALL_Name_ID_For_ProjectList3.clear();
      arr_ALL_Name_ID_For_ProjectList4.clear();
      arr_ALL_Name_ID_For_ProjectList5.clear();
      arrGenericOtheCharge.clear();
      for (var i = 0;
          i < state.quotationOtherChargesListResponse.details.length;
          i++) {
        arrGenericOtheCharge
            .add(state.quotationOtherChargesListResponse.details[i]);

        print("InquiryStatus : " +
            state.quotationOtherChargesListResponse.details[i].chargeName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.quotationOtherChargesListResponse.details[i].chargeName;
        all_name_id.pkID =
            state.quotationOtherChargesListResponse.details[i].pkId;
        all_name_id.Taxtype = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        all_name_id.TaxRate = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        all_name_id.isChecked =
            state.quotationOtherChargesListResponse.details[i].beforeGST;
        arr_ALL_Name_ID_For_ProjectList1.add(all_name_id);
        arr_ALL_Name_ID_For_ProjectList2.add(all_name_id);
        arr_ALL_Name_ID_For_ProjectList3.add(all_name_id);
        arr_ALL_Name_ID_For_ProjectList4.add(all_name_id);
        arr_ALL_Name_ID_For_ProjectList5.add(all_name_id);

        if (_otherChargeIDController1.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController1.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController1.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController1.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController1.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController1.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        }

        if (_otherChargeIDController2.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController2.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController2.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController2.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController2.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController2.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        } else if (_otherChargeIDController3.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController3.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController3.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController3.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController3.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController3.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        } else if (_otherChargeIDController4.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController4.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController4.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController4.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController4.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController4.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        } else if (_otherChargeIDController5.text ==
            state.quotationOtherChargesListResponse.details[i].pkId
                .toString()) {
          _otherChargeIDController5.text = state
              .quotationOtherChargesListResponse.details[i].pkId
              .toString();

          _otherChargeNameController5.text =
              state.quotationOtherChargesListResponse.details[i].chargeName;

          _otherChargeTaxTypeController5.text = state
              .quotationOtherChargesListResponse.details[i].taxType
              .toString();
          _otherChargeGSTPerController5.text = state
              .quotationOtherChargesListResponse.details[i].gSTPer
              .toString();
          _otherChargeBeForeGSTController5.text = state
              .quotationOtherChargesListResponse.details[i].beforeGST
              .toString();
        }
      }

      /*  if(arr_ALL_Name_ID_For_ProjectList1.length!=0)
        {
          for(int i=0;i<arr_ALL_Name_ID_For_ProjectList1.length;i++)
            {
              if(_otherChargeIDController1.text==arr_ALL_Name_ID_For_ProjectList1[i].pkID.toString())
              {
                _otherChargeIDController1.text        = arr_ALL_Name_ID_For_ProjectList1[i].pkID.toString();
                _otherChargeNameController1.text      = arr_ALL_Name_ID_For_ProjectList1[i].Name;
                _otherChargeTaxTypeController1.text   = arr_ALL_Name_ID_For_ProjectList1[i].Taxtype;
                _otherChargeGSTPerController1.text    = arr_ALL_Name_ID_For_ProjectList1[i].TaxRate;
                _otherChargeBeForeGSTController1.text = arr_ALL_Name_ID_For_ProjectList1[i].isChecked.toString();


              }

            }
        }
      else if(arr_ALL_Name_ID_For_ProjectList2.length!=0)
      {
        for(int i=0;i<arr_ALL_Name_ID_For_ProjectList2.length;i++)
        {
          if(_otherChargeIDController2.text==arr_ALL_Name_ID_For_ProjectList2[i].pkID.toString())
          {
            _otherChargeIDController2.text = arr_ALL_Name_ID_For_ProjectList2[i].pkID.toString();

            _otherChargeNameController2.text  = arr_ALL_Name_ID_For_ProjectList2[i].Name;

            _otherChargeTaxTypeController2.text = arr_ALL_Name_ID_For_ProjectList2[i].Taxtype;
            _otherChargeGSTPerController2.text =arr_ALL_Name_ID_For_ProjectList2[i].TaxRate;
            _otherChargeBeForeGSTController2.text = arr_ALL_Name_ID_For_ProjectList2[i].isChecked.toString();


          }

        }
      }
      else if(arr_ALL_Name_ID_For_ProjectList3.length!=0)
      {
        for(int i=0;i<arr_ALL_Name_ID_For_ProjectList3.length;i++)
        {

          print("gfry"+ _otherChargeIDController3.text  + "ArrayChrgeID : " + arr_ALL_Name_ID_For_ProjectList3[i].pkID.toString());
          if(_otherChargeIDController3.text==arr_ALL_Name_ID_For_ProjectList3[i].pkID.toString())
          {
            _otherChargeIDController3.text = arr_ALL_Name_ID_For_ProjectList3[i].pkID.toString();

            _otherChargeNameController3.text  = arr_ALL_Name_ID_For_ProjectList3[i].Name;


            _otherChargeTaxTypeController3.text = arr_ALL_Name_ID_For_ProjectList3[i].Taxtype;

            print("sdfjdfj"+ "ChargeTaxtype" +  _otherChargeTaxTypeController3.text);

            _otherChargeGSTPerController3.text =arr_ALL_Name_ID_For_ProjectList3[i].TaxRate;
            _otherChargeBeForeGSTController3.text = arr_ALL_Name_ID_For_ProjectList3[i].isChecked.toString();


          }

        }
      }
      else if(arr_ALL_Name_ID_For_ProjectList4.length!=0)
      {
        for(int i=0;i<arr_ALL_Name_ID_For_ProjectList4.length;i++)
        {
          if(_otherChargeIDController4.text==arr_ALL_Name_ID_For_ProjectList4[i].pkID.toString())
          {
            _otherChargeIDController4.text = arr_ALL_Name_ID_For_ProjectList4[i].pkID.toString();

            _otherChargeNameController4.text  = arr_ALL_Name_ID_For_ProjectList4[i].Name;

            _otherChargeTaxTypeController4.text = arr_ALL_Name_ID_For_ProjectList4[i].Taxtype;
            _otherChargeGSTPerController4.text =arr_ALL_Name_ID_For_ProjectList4[i].TaxRate;
            _otherChargeBeForeGSTController4.text = arr_ALL_Name_ID_For_ProjectList4[i].isChecked.toString();


          }

        }
      }
      else if(arr_ALL_Name_ID_For_ProjectList5.length!=0)
      {
        for(int i=0;i<arr_ALL_Name_ID_For_ProjectList5.length;i++)
        {
          if(_otherChargeIDController5.text==arr_ALL_Name_ID_For_ProjectList5[i].pkID.toString())
          {
            _otherChargeIDController5.text = arr_ALL_Name_ID_For_ProjectList5[i].pkID.toString();

            _otherChargeNameController5.text  = arr_ALL_Name_ID_For_ProjectList5[i].Name;

            _otherChargeTaxTypeController5.text = arr_ALL_Name_ID_For_ProjectList5[i].Taxtype;
            _otherChargeGSTPerController5.text =arr_ALL_Name_ID_For_ProjectList5[i].TaxRate;
            _otherChargeBeForeGSTController5.text = arr_ALL_Name_ID_For_ProjectList5[i].isChecked.toString();


          }

        }


      }

*/
    }
  }

  void _OnProductSucessResponse(InsertProductSucessResponseState state) {
    print("Productjfdj" + state.response.toString());
  }

  void _OnProductDeleteSucessResponse(
      DeleteALLQuotationProductTableState state) {
    print("Productjfdjdfd" + state.response.toString());
  }

  void _OnChargID1Response(QuotationOtherCharge1ListResponseState state) {
    arrGenericOtheCharge.clear();
    for (int i = 0;
        i < state.quotationOtherChargesListResponse.details.length;
        i++) {
      arrGenericOtheCharge
          .add(state.quotationOtherChargesListResponse.details[i]);
    }
  }

  void _OngetAdditionalCharges(GetGenericAddditionalChargesState state) {
    if (state.quotationOtherChargesListResponse != null) {
      _otherChargeNameController1.text = "";
      _otherChargeNameController2.text = "";
      _otherChargeNameController3.text = "";
      _otherChargeNameController4.text = "";
      _otherChargeNameController5.text = "";

      print("jjfjdjf121" + _addditionalCharges.BasicAmt.toString());

      if (state.quotationOtherChargesListResponse.ChargeID1.toString() != "0" ||
          state.quotationOtherChargesListResponse.ChargeID1.toString() != "") {
        _otherAmount1.text =
            state.quotationOtherChargesListResponse.ChargeAmt1.toString();
        _otherChargeIDController1.text =
            state.quotationOtherChargesListResponse.ChargeID1.toString();
        _otherChargeNameController1.text =
            state.quotationOtherChargesListResponse.ChargeName1.toString();
      }

      if (state.quotationOtherChargesListResponse.ChargeID2.toString() != "0" ||
          state.quotationOtherChargesListResponse.ChargeID2.toString() != "") {
        _otherAmount2.text =
            state.quotationOtherChargesListResponse.ChargeAmt2.toString();
        _otherChargeIDController2.text =
            state.quotationOtherChargesListResponse.ChargeID2.toString();
        _otherChargeNameController2.text =
            state.quotationOtherChargesListResponse.ChargeName2.toString();
      }

      if (state.quotationOtherChargesListResponse.ChargeID3.toString() != "0" ||
          state.quotationOtherChargesListResponse.ChargeID3.toString() != "") {
        _otherAmount3.text =
            state.quotationOtherChargesListResponse.ChargeAmt3.toString();
        _otherChargeIDController3.text =
            state.quotationOtherChargesListResponse.ChargeID3.toString();
        _otherChargeNameController3.text =
            state.quotationOtherChargesListResponse.ChargeName3.toString();
      }

      if (state.quotationOtherChargesListResponse.ChargeID4.toString() != "0" ||
          state.quotationOtherChargesListResponse.ChargeID4.toString() != "") {
        _otherAmount4.text =
            state.quotationOtherChargesListResponse.ChargeAmt4.toString();
        _otherChargeIDController4.text =
            state.quotationOtherChargesListResponse.ChargeID4.toString();
        _otherChargeNameController4.text =
            state.quotationOtherChargesListResponse.ChargeName4.toString();
      }

      if (state.quotationOtherChargesListResponse.ChargeID5.toString() != "0" ||
          state.quotationOtherChargesListResponse.ChargeID5.toString() != "") {
        _otherAmount5.text =
            state.quotationOtherChargesListResponse.ChargeAmt5.toString();
        _otherChargeIDController5.text =
            state.quotationOtherChargesListResponse.ChargeID5.toString();
        _otherChargeNameController5.text =
            state.quotationOtherChargesListResponse.ChargeName5.toString();
      }
    }
  }

  void _OnGenericIsertCallSucess(AddGenericAddditionalChargesState state) {
    print("_OnGenericIsertCallSucess" + state.response);
  }

  void _onDeleteAllGenericAddtionalAmount(
      DeleteAllGenericAddditionalChargesState state) {
    print("DeleteAllGenericAddditionalChargesState" + state.response);
  }
}
