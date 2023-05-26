import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/dealer/dealer_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/bank_voucher/list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import '../../../../res/dimen_resources.dart';

class DBankVoucherAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/DBankVoucherAddEditScreen';

  @override
  BaseState<DBankVoucherAddEditScreen> createState() =>
      _DBankVoucherAddEditScreenState();
}

class _DBankVoucherAddEditScreenState
    extends BaseState<DBankVoucherAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  DealerBloc _dealerBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  final TextEditingController edt_ComplanitDate = TextEditingController();
  final TextEditingController edt_ReverseComplanitDate =
      TextEditingController();
  final TextEditingController edt_Priority = TextEditingController();
  final TextEditingController edt_Dealer_Name = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_Voucher_Amount = TextEditingController();
  final TextEditingController edt_Address = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  double CardViewHieght = 45;
  SearchDetails _searchDetails;
  bool _isForUpdate = false;
  bool is_Receivable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    selectedDate = DateTime.now();
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
    FetchFollowupPriorityDetails();

    _dealerBloc = DealerBloc(baseBloc);
    edt_Priority.text = "Receivable";
    edt_Priority.addListener(() {
      setState(() {
        if (edt_Priority.text == "Receivable") {
          is_Receivable = true;
          edt_CustomerName.text = "";
        } else {
          is_Receivable = false;
          edt_CustomerName.text = "INTERGLOBLE MANUFACTURING COMPANY";
        }
      });
    });
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
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
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
          title: Text('BankVoucher Details'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                  top: 25,
                ),
                child: Column(
                  children: [
                    _buildFollowupDate(),
                    CustomDropDown1("Rec./Pay.",
                        enable1: false,
                        title: "Rec./Pay.",
                        hintTextvalue: "Tap to Select Rec./Pay.",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_Priority,
                        Custom_values1: arr_ALL_Name_ID_For_Folowup_Priority),
                    is_Receivable == true ? CustomerName() : Container(),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    _buildSearchView(),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    VoucherAmount(),
                    SizedBox(
                      height: Constant.SIZEBOXNEWHEIGHT,
                    ),
                    TransactionNotes(),
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
    navigateTo(context, DBankVoucherListScreen.routeName, clearAllStack: true);
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

  Widget CustomDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category"),
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

  FetchFollowupPriorityDetails() {
    arr_ALL_Name_ID_For_Folowup_Priority.clear();
    for (var i = 0; i <= 1; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Receivable";
      } else if (i == 1) {
        all_name_id.Name = "Payable";
      }
      arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
    }
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

  Widget VoucherAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Voucher Amount *",
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
                      controller: edt_Voucher_Amount,
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      //onSubmitted: (_) => FocusScope.of(context).requestFocus(myFocusNode),
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.all(10),
                        hintText: "Tap to enter Amount",
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
                  Icons.attach_money,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        is_Receivable == true ? _onTapOfSearchView() : Container();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text(
                is_Receivable == true ? "Customer A/c *" : "Company Name *",
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
                        controller: edt_CustomerName,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(right: 15),
                          hintText: "Search customer",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          overflow: TextOverflow.ellipsis,
                          color: Color(0xFF000000),
                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                        ),
                  ),
                  Icon(
                    is_Receivable == true ? Icons.search : Icons.home,
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

  Future<void> _onTapOfSearchView() async {
    if (_isForUpdate == false) {
      navigateTo(context, SearchFollowupCustomerScreen.routeName).then((value) {
        if (value != null) {
          _searchDetails = value;
          edt_CustomerpkID.text = _searchDetails.value.toString();
          edt_CustomerName.text = _searchDetails.label.toString();
        }
        print("CustomerInfo : " +
            edt_CustomerName.text.toString() +
            " CustomerID : " +
            edt_CustomerpkID.text.toString());
      });
    }
  }

  Widget TransactionNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Transaction Notes *",
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
            height: 100,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      minLines: 3,
                      maxLines: null,
                      controller: edt_Address,
                      decoration: InputDecoration(
                        hintText: "Tap to enter notes",
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
}
