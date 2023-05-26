import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/dealer/dealer_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/purchase_bill/list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/purchase_bill/other_charges/add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/purchase_bill/product_details/purchase_details_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class DPurchaseAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/DPurchaseAddEditScreen';

  @override
  BaseState<DPurchaseAddEditScreen> createState() =>
      _DPurchaseAddEditScreenState();
}

class _DPurchaseAddEditScreenState extends BaseState<DPurchaseAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  DealerBloc _dealerBloc;
  final TextEditingController edt_ComplanitDate = TextEditingController();
  final TextEditingController edt_ReverseComplanitDate =
      TextEditingController();
  final TextEditingController edt_Dealer_Name = TextEditingController();

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  double CardViewHieght = 45;

  final TextEditingController edt_TermConditionHeader = TextEditingController();
  final TextEditingController edt_TermConditionHeaderID =
      TextEditingController();

  final TextEditingController edt_TermConditionFooter = TextEditingController();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TermConditionList = [];

  final TextEditingController edt_StateCode = TextEditingController();
  final TextEditingController edt_HeaderDisc = TextEditingController();
  QuotationDetails _editModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _dealerBloc = DealerBloc(baseBloc);
    edt_StateCode.text = _offlineLoggedInData.details[0].stateCode.toString();
    edt_HeaderDisc.text = "0.00";
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    edt_ComplanitDate.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();
    edt_ReverseComplanitDate.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    edt_Dealer_Name.text = "Test customer";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dealerBloc,
      child: BlocConsumer<DealerBloc, DealerStates>(
        builder: (BuildContext context, DealerStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, DealerStates state) {
          if (state is QuotationTermsCondtionResponseState) {
            _OnTermConditionListResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is QuotationTermsCondtionResponseState) {
            return true;
          }

          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Purchase Bill Details'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  top: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFollowupDate(),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    CustomerName(),
                    TermsConditionList("Select Term & Condition",
                        enable1: false,
                        title: "Select Term & Condition",
                        hintTextvalue: "Tap to Select Term & Condition",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_TermConditionHeader,
                        controllerpkID: edt_TermConditionHeaderID,
                        Custom_values1: arr_ALL_Name_ID_For_TermConditionList),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Term & Condition",
                          style: TextStyle(
                              fontSize: 12,
                              color: colorPrimary,
                              fontWeight: FontWeight
                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                          ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7, right: 7, top: 10),
                      child: TextFormField(
                        controller: edt_TermConditionFooter,
                        minLines: 2,
                        maxLines: 15,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Enter Notes',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () {
                        //  _onTapOfDeleteALLContact();
                        //  navigateTo(context, InquiryProductListScreen.routeName);

                        if (edt_Dealer_Name.text == "") {
                          // print("INWWWE" + InquiryNo.toString());
                          navigateTo(
                              context, DPurchaseProductListScreen.routeName,
                              arguments: AddDPurchaseProductListScreenArgument(
                                  "",
                                  _offlineLoggedInData.details[0].stateCode
                                      .toString(),
                                  "0.00"));
                        } else {
                          showCommonDialogWithSingleOption(context,
                              "Customer name is required To view Product !",
                              positiveButtonTitle: "OK");
                        }
                      }, "Add Product + ",
                          width: 600,
                          backGroundColor: Color(0xff4d62dc),
                          radius: 15),
                    ),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () {
                        // getContactarray();
                        // _onTapOfSaveCustomerAPICall();
                        // navigateTo(context, ContactsListScreen.routeName);
                        navigateTo(
                                context, DPurchaseOtherCharge_screen.routeName,
                                arguments: DPurchaseOtherCharge_screenArguments(
                                    int.parse(edt_StateCode.text == null
                                        ? 0
                                        : edt_StateCode.text),
                                    _editModel,
                                    edt_HeaderDisc.text))
                            .then((value) {
                          if (value == null) {
                            print("HeaderDiscount From QTOtherCharges 0.00");
                          } else {
                            print("HeaderDiscount From QTOtherCharges $value");
                            edt_HeaderDisc.text = value;
                          }
                        });
                        //DPurchaseOtherCharge_screen
                      }, "Other Charges",
                          backGroundColor: Color(0xff4d62dc),
                          width: 600,
                          radius: 15),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () {
                        // getContactarray();
                        // _onTapOfSaveCustomerAPICall();
                        // navigateTo(context, ContactsListScreen.routeName);
                      }, "Save", width: 600, radius: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, DPurchaseListScreen.routeName, clearAllStack: true);
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _selectDate(context, edt_ComplanitDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Voucher Date *",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: CardViewHieght,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_ComplanitDate.text == null ||
                              edt_ComplanitDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_ComplanitDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_ComplanitDate.text == null ||
                                  edt_ComplanitDate.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget CustomerName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Dealer Name *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHieght,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      enabled: false,
                      controller: edt_Dealer_Name,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.all(10),
                        hintText: "Tap to enter Name",
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
                  Icons.person,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget TermsConditionList(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap:
                () => /*showcustomdialogWithID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controllerID: controllerpkID,
                lable: "Select $Category")*/

                    _dealerBloc.add(QuotationTermsConditionCallEvent(
                        QuotationTermsConditionRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          color: colorPrimary,
                          fontWeight: FontWeight
                              .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: CardViewHieght,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_ComplanitDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseComplanitDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  void _OnTermConditionListResponse(QuotationTermsCondtionResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_TermConditionList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].tNCHeader);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].tNCHeader;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].tNCContent;

        arr_ALL_Name_ID_For_TermConditionList.add(all_name_id);
      }
      showcustomdialogWithMultipleID(
          values: arr_ALL_Name_ID_For_TermConditionList,
          context1: context,
          controller: edt_TermConditionHeader,
          controllerID: edt_TermConditionHeaderID,
          controller2: edt_TermConditionFooter,
          lable: "Select Term & Condition ");
    }
  }
}
