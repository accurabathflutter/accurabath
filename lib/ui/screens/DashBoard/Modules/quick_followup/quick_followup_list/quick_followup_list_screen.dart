// ignore_for_file: non_constant_identifier_names

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_filter_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/quick_followup_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/followup/quick_followup_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/globals.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/followup/followup_history_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quick_followup/quick_followup_add_edit/quick_followup_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
//import 'package:whatsapp_share/whatsapp_share.dart';

class QuickFollowupListScreen extends BaseStatefulWidget {
  static const routeName = '/QuickFollowupListScreen';

  @override
  _QuickFollowupListScreenState createState() =>
      _QuickFollowupListScreenState();
}

class _QuickFollowupListScreenState extends BaseState<QuickFollowupListScreen>
    with BasicScreen, WidgetsBindingObserver {
  FollowupBloc _FollowupBloc;
  int _pageNo = 0;
  QuickFollowupListResponse _FollowupListResponse;

  // FollowerEmployeeListResponse _FollowerEmployeeListResponse;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  bool expanded = true;
  bool isListExist = false;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;
  ALL_Name_ID SelectedStatus;
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Status = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  int selected = 0; //attention
  bool isExpand = false;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  var _url = "https://api.whatsapp.com/send?phone=91";
  bool isDeleteVisible = true;
  int TotalCount = 0;
  final TextEditingController PuchInTime = TextEditingController();
  final TextEditingController PuchOutTime = TextEditingController();
  double CardViewHeight = 45.00;
  final TextEditingController edt_Application = TextEditingController();
  final TextEditingController edt_SerialNo = TextEditingController();
  final TextEditingController edt_FollowUpDate = TextEditingController();
  final TextEditingController edt_ReverseFollowUpDate = TextEditingController();
  final TextEditingController edt_Status = TextEditingController();
  final TextEditingController edt_employeeName = TextEditingController();
  final TextEditingController edt_employeeID = TextEditingController();

  //
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_EmployeeList = [];

  @override
  void initState() {
    super.initState();

    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    edt_employeeName.text = _offlineLoggedInData.details[0].employeeName;
    edt_employeeID.text = _offlineLoggedInData.details[0].employeeID.toString();

    FetchFollowupPriorityDetails();

    _FollowupBloc = FollowupBloc(baseBloc);

    edt_Status.text = "active";

    FetchFollowupStatusDetails();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text = _offlineLoggedInData.details[0].userID;

    isExpand = false;

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);

    edt_FollowUpDate.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();
    edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    /*  edt_Status.addListener(() {
      _FollowupBloc.add(QuickFollowupListRequestEvent(QuickFollowupListRequest(
          FollowupStatus: edt_Status.text,
          */ /*FollowupDate:edt_ReverseFollowUpDate.text*/ /* CompanyId:
              CompanyID.toString())));
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc
        ..add(QuickFollowupListRequestEvent(QuickFollowupListRequest(
          FollowupStatus: edt_Status.text,
          /*FollowupDate:edt_ReverseFollowUpDate.text*/ CompanyId:
              CompanyID.toString(),
          EmployeeID: edt_employeeID.text,
        ))),

      // _FollowupBloc..add(FollowupFilterListCallEvent("todays",FollowupFilterListRequest(CompanyId: CompanyID.toString(),LoginUserID: LoginUserID,PageNo: 1,PageSize: 10))),
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          if (state is QuickFollowupListResponseState) {
            _onFollowupListCallSuccess(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is QuickFollowupListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FollowupStates state) {
          if (state is FollowupDeleteCallResponseState) {
            _onFollowupDeleteCallSucess(state, context);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is FollowupDeleteCallResponseState) {
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
          title: Text('QuickFollowup List'),
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
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _FollowupBloc.add(QuickFollowupListRequestEvent(
                        QuickFollowupListRequest(
                            FollowupStatus: edt_Status.text,
                            /*FollowupDate:edt_ReverseFollowUpDate.text*/ CompanyId:
                                CompanyID.toString(),
                            EmployeeID: edt_employeeID.text)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      children: [
                        /* _buildEmplyeeListView(),
                        CustomDropDown1("Status",
                            enable1: false,
                            title: "Status",
                            hintTextvalue: "Tap to Select Status",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_Status,
                            Custom_values1:
                                arr_ALL_Name_ID_For_Folowup_Priority),*/
                        Expanded(child: _buildFollowupList())
                      ],
                    ),
                  ),
                ),
              ),

              /*  Padding(
                padding: const EdgeInsets.all(18.0),
                child: _buildSearchView(),//searchUI(Custom_values1),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: _buildFollowupList(),
              ),*/
            ],
          ),
        ),
        floatingActionButton: /*FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            navigateTo(context, QuickFollowUpAddEditScreen.routeName);
          },
          child: const Icon(Icons.add),
          backgroundColor: colorPrimary,
        )*/

            Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                /* edt_FollowupEmployeeList.text = "";
                _onTapOfSearchView();*/
                return showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Wrap(
                        children: [
                          ListTile(
                            // leading: Icon(Icons.share),
                            title: Center(
                              child: Text(
                                "~~~Filter~~~",
                                style: TextStyle(color: colorPrimary),
                              ),
                            ),
                          ),
                          Container(
                            height: 2,
                            color: colorLightGray,
                          ),
                          Container(
                            height: 5,
                          ),
                          ListTile(title: _buildEmplyeeListView()),
                          ListTile(
                            title: CustomDropDown1("Status",
                                enable1: false,
                                title: "Status",
                                hintTextvalue: "Tap to Select Status",
                                icon: Icon(Icons.arrow_drop_down),
                                controllerForLeft: edt_Status,
                                Custom_values1:
                                    arr_ALL_Name_ID_For_Folowup_Priority),
                          ),
                          Container(
                            height: 10,
                          ),
                          ListTile(
                            //leading: Icon(Icons.edit),
                            title: Center(
                                child: Row(
                              children: [
                                Flexible(
                                  child: getCommonButton(baseTheme, () {
                                    Navigator.pop(context);

                                    _FollowupBloc.add(
                                        QuickFollowupListRequestEvent(
                                            QuickFollowupListRequest(
                                      FollowupStatus: edt_Status.text,
                                      /*FollowupDate:edt_ReverseFollowUpDate.text*/ CompanyId:
                                          CompanyID.toString(),
                                      EmployeeID: edt_employeeID.text,
                                    )));
                                  }, "Submit", radius: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: getCommonButton(baseTheme, () {
                                    Navigator.pop(context);

                                    _FollowupBloc.add(QuickFollowupListRequestEvent(
                                        QuickFollowupListRequest(
                                            FollowupStatus: edt_Status.text,
                                            /*FollowupDate:edt_ReverseFollowUpDate.text*/ CompanyId:
                                                CompanyID.toString(),
                                            EmployeeID: edt_employeeID.text)));
                                  }, "Close", radius: 15),
                                ),
                              ],
                            )),
                          ),
                          Container(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Image.asset(
                CUSTOM_SETTING,
                width: 32,
                height: 32,
              ),
              backgroundColor: colorPrimary,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () async {
                // Add your onPressed code here!
                navigateTo(context, QuickFollowUpAddEditScreen.routeName);
                // navigateTo(context, TeleCallerAddEditScreen.routeName);
              },
              child: const Icon(Icons.add),
              backgroundColor: colorPrimary,
            ),
          ],
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
      ),
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_Folowup_Status,
            context1: context,
            controller: edt_FollowupStatus,
            lable: "Select Status");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Status",
                    style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
                Icon(
                  Icons.filter_list_alt,
                  color: colorGrayDark,
                ),]),*/
          /*  SizedBox(
            height: 5,
          ),
*/
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: /* Text(
                        SelectedStatus =="" ?
                        "Tap to select Status" : SelectedStatus.Name,
                        style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),*/

                        TextField(
                      controller: edt_FollowupStatus,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Select",
                        /* hintStyle: TextStyle(
                    color: Colors.grey, // <-- Change this
                    fontSize: 12,

                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey, // <-- Change this
                    fontSize: 12,

                  ),*/
                      ),
                    ),
                    // dropdown()
                  ),
                  /*Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmplyeeListView123() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              showcustomdialog(
                  values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
                  context1: context,
                  controller: edt_FollowupEmployeeList,
                  controller2: edt_FollowupEmployeeUserID,
                  lable: "Select Employee");
            },
            child: Card(
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: /* Text(
                          SelectedStatus =="" ?
                          "Tap to select Status" : SelectedStatus.Name,
                          style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),*/

                          TextField(
                        controller: edt_FollowupEmployeeList,
                        enabled: false,
                        /*  onChanged: (value) => {
                      print("StatusValue " + value.toString() )
                  },*/
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Select"),
                      ),
                      // dropdown()
                    ),
                    /*  Icon(
                      Icons.arrow_drop_down,
                      color: colorGrayDark,
                    )*/
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///builds inquiry list
  Widget _buildFollowupList() {
    if (isListExist) {
      return ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildFollowupListItem(index);
        },
        shrinkWrap: true,
        itemCount: _FollowupListResponse.details.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_SEARCH_RESULT_FOUND, height: 200, width: 200),
      );
    }
  }

  ///builds row item view of inquiry list
  Widget _buildFollowupListItem(int index) {
    //FilterDetails model = _FollowupListResponse.details[index];

    return ExpantionCustomer(context, index);
  }

  ///builds inquiry row items title and value's common view
  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                /*fontWeight: FontWeight.bold,*/
                fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        Text(value,
            style: TextStyle(
                fontSize: _fontSize_Title,
                color:
                    colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            )
      ],
    );
  }

  Widget _buildLabelWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 12,
                color: Color(
                    0xff030303)) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 5,
        ),
        Text(
          value,
          style: baseTheme.textTheme.headline3,
        )
      ],
    );
  }

  ///updates data of inquiry list
  void _onFollowupListCallSuccess(QuickFollowupListResponseState state) {
    //print("Response326584"+state.quickFollowupListResponse.details[0].customerName.toString());

    if (state.quickFollowupListResponse.details.length != 0) {
      //_FollowupListResponse = state.quickFollowupListResponse;

      for (int i = 0; i < state.quickFollowupListResponse.details.length; i++) {
        /* QuickFollowupListResponseDetails quickFollowupListResponseDetails = QuickFollowupListResponseDetails();
            quickFollowupListResponseDetails.customerName*/

        _FollowupListResponse = state.quickFollowupListResponse;
      }

      if (_FollowupListResponse != null) {
        isListExist = true;
        TotalCount = state.quickFollowupListResponse.totalCount;
      } else {
        isListExist = false;
        TotalCount = 0;
      }
    } else {
      isListExist = false;
    }

    /* for(int i=0;i<_FollowupListResponse.details.length;i++)
      {
        if(_FollowupListResponse.details)
      }*/
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onFollowupListPagination() {
    _FollowupBloc.add(FollowupFilterListCallEvent(
        edt_FollowupStatus.text,
        FollowupFilterListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID,
            PageNo: _pageNo + 1,
            PageSize: 10000)));

    /* if (_FollowupListResponse.details.length < _FollowupListResponse.totalCount) {

    }*/
  }

  ExpantionCustomer(BuildContext context, int index) {
    QuickFollowupListResponseDetails model =
        _FollowupListResponse.details[index];

    String CreatedEmployeeNAme = "";
    for (int i = 0; i < arr_EmployeeList.length; i++) {
      if (model.createdBy == arr_EmployeeList[i].MenuName) {
        CreatedEmployeeNAme = arr_EmployeeList[i].Name;
        break;
      }
    }

    //Totcount= _FollowupListResponse.totalCount;
    //  if(_FollowupListResponse.details[index].employeeName == edt_FollowupEmployeeList.text) {
    return Container(
      padding: EdgeInsets.all(15),
      child: ExpansionTileCard(
        initialElevation: 5.0,
        elevation: 5.0,
        elevationCurve: Curves.easeInOut,
        // initiallyExpanded: index == selected,
        shadowColor: Color(0xFF504F4F),
        baseColor: Color(0xFFFCFCFC),
        expandedColor: Color(0xFFC1E0FA),
        //Colors.deepOrange[50],ADD8E6
        /* leading: CircleAvatar(
            backgroundColor: Color(0xFF504F4F),
            child: Image.network(
              "http://demo.sharvayainfotech.in/images/profile.png",
              height: 35,
              fit: BoxFit.fill,
              width: 35,
            )),*/
        title: Column(
          children: [
            model.customerName.toString() == ""
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.home_work,
                              color: Color(0xff0066b3),
                              size: 22,
                            ),
                          ),
                          Text("Company",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xff0066b3),
                                fontSize: 7,
                              ))
                        ],
                      ),
                      Container(
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Color(0xff0066b3),
                          size: 24,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          model.customerName,
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
            model.customerName.toString() == ""
                ? Container()
                : Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: 1,
                  ),
            model.createdBy.toString() == ""
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.emoji_people_sharp,
                              color: Color(0xff0066b3),
                              size: 22,
                            ),
                            Text("SALES REP",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xff0066b3),
                                  fontSize: 7,
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Color(0xff0066b3),
                          size: 24,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          CreatedEmployeeNAme,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                model.timeIn != "" || model.timeOut != ""
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: [
                              Text("In-Time : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10)),
                              Text(
                                getTime(model.timeIn),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: colorPrimary),
                              ),
                            ],
                          ),
                          model.timeOut != ""
                              ? Row(
                                  children: [
                                    Text("Out-Time : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10)),
                                    Text(
                                      getTime(model.timeOut),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: colorPrimary),
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                )
              ],
            )
          ],
        ),
        /*title: Text(
          model.customerName,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),*/
        subtitle: Visibility(
          visible: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              /* Text(
                model.inquiryStatus,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),*/
              model.timeIn != "" || model.timeOut != ""
                  ? Divider(
                      thickness: 1,
                    )
                  : Container(),
              model.timeIn != "" || model.timeOut != ""
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          children: [
                            Text("In-Time : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 10)),
                            Text(
                              getTime(model.timeIn),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: colorPrimary),
                            ),
                          ],
                        ),
                        model.timeOut != ""
                            ? Row(
                                children: [
                                  Text("Out-Time : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10)),
                                  Text(
                                    getTime(model.timeOut),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: colorPrimary),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),

        children: <Widget>[
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    MakeCall.callto(model.contactNo1);
                                  },
                                  child: Container(
                                      child: Column(
                                    children: [
                                      Text(
                                        "Call",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Image.asset(
                                        PHONE_CALL_IMAGE,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ],
                                  )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    ShareMsg.msg(context, model.contactNo1);
                                  },
                                  child: Container(
                                    child: /*Image.asset(
                                                    WHATSAPP_IMAGE,
                                                    width: 30,
                                                    height: 30,
                                                  ),*/
                                        Column(
                                      children: [
                                        Text(
                                          "Share",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Image.asset(
                                          WHATSAPP_IMAGE,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                model.latitudeIN != "" ||
                                        model.longitude_IN != ""
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (model.latitudeIN != "" ||
                                              model.longitude_IN != "") {
                                            print("jdjfds45" +
                                                double.parse(model.latitudeIN)
                                                    .toString() +
                                                " Longitude : " +
                                                double.parse(model.longitude_IN)
                                                    .toString());
                                            MapsLauncher.launchCoordinates(
                                                double.parse(model.latitudeIN),
                                                double.parse(
                                                    model.longitude_IN),
                                                'Location In');
                                          } else {
                                            showCommonDialogWithSingleOption(
                                                context,
                                                "Location In Not Valid !",
                                                positiveButtonTitle: "OK",
                                                onTapOfPositiveButton: () {
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        },
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Text(
                                              "In",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Image.asset(
                                              LOCATION_ICON,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ],
                                        )),
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 20,
                                ),
                                model.latitudeOUT != "" ||
                                        model.longitude_OUT != ""
                                    ? GestureDetector(
                                        onTap: () async {
                                          if (model.timeOut != "" &&
                                              model.timeOut != "00:00:00") {
                                            if (model.latitudeOUT != "" ||
                                                model.longitude_OUT != "") {
                                              MapsLauncher.launchCoordinates(
                                                  double.parse(
                                                      model.latitudeOUT),
                                                  double.parse(
                                                      model.longitude_OUT),
                                                  'Location Out');
                                            } else {
                                              showCommonDialogWithSingleOption(
                                                  context,
                                                  "Location Out Not Valid !",
                                                  positiveButtonTitle: "OK",
                                                  onTapOfPositiveButton: () {
                                                Navigator.of(context).pop();
                                              });
                                            }
                                          }
                                        },
                                        child: model.timeOut != "" &&
                                                model.timeOut != "00:00:00"
                                            ? Container(
                                                child: Column(
                                                children: [
                                                  Text(
                                                    "Out",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Colors.deepOrange,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Image.asset(
                                                    LOCATION_ICON,
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ],
                                              ))
                                            : Container(),
                                      )
                                    : Container(),
                              ]),
                        ),
                        SizedBox(
                          height: sizeboxsize,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Contact No1.",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(label_color),
                                      fontSize: _fontSize_Label,
                                      letterSpacing: .3)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  model.contactNo1 == ""
                                      ? "N/A"
                                      : model.contactNo1,
                                  style: TextStyle(
                                      color: Color(title_color),
                                      fontSize: _fontSize_Title,
                                      letterSpacing: .3))
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTitleWithValueView(
                                "Followup Date",
                                model.followupDate.getFormattedDate(
                                        fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                        toFormat: "dd-MM-yyyy") ??
                                    "-"),
                          ),
                          Expanded(
                            child: _buildTitleWithValueView(
                                "Followup Type", model.inquiryStatus ?? "-"),
                          ),
                        ]),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTitleWithValueView(
                                "Next Followup Date",
                                model.nextFollowupDate.getFormattedDate(
                                        fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                        toFormat: "dd-MM-yyyy") ??
                                    "-"),
                          ),
                          Expanded(
                            child: _buildTitleWithValueView(
                              "CreatedBy : ",
                              model.createdBy,
                            ),
                          )
                        ]),
                  ],
                ),
              ),
            ),
          ),
          edt_Status.text == "completestatus" || edt_Status.text == "future"
              ? Container()
              : ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                      model.timeIn.toString() == ""
                          ? GestureDetector(
                              onTap: () {
                                navigateTo(context,
                                        QuickFollowUpAddEditScreen.routeName,
                                        arguments:
                                            QuickAddUpdateFollowupScreenArguments(
                                                _FollowupListResponse
                                                    .details[index],
                                                false,
                                                "PunchIn"))
                                    .then((value) {
                                  _FollowupBloc.add(QuickFollowupListRequestEvent(
                                      QuickFollowupListRequest(
                                          /*FollowupDate:edt_ReverseFollowUpDate.text,*/ CompanyId:
                                              CompanyID.toString(),
                                          EmployeeID: edt_employeeID.text)));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.login,
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'PunchIn',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      model.timeIn.toString() != ""
                          ? GestureDetector(
                              onTap: () {
                                navigateTo(context,
                                        QuickFollowUpAddEditScreen.routeName,
                                        arguments:
                                            QuickAddUpdateFollowupScreenArguments(
                                                _FollowupListResponse
                                                    .details[index],
                                                false,
                                                "PunchOut"))
                                    .then((value) {
                                  _FollowupBloc.add(QuickFollowupListRequestEvent(
                                      QuickFollowupListRequest(
                                          /*FollowupDate:edt_ReverseFollowUpDate.text,*/ CompanyId:
                                              CompanyID.toString(),
                                          FollowupStatus: edt_Status.text,
                                          EmployeeID: edt_employeeID.text)));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.logout,
                                    color: Colors.black,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                  ),
                                  Text(
                                    'PunchOut',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ]),
          edt_Status.text == "future"
              ? ButtonBar(
                  alignment: MainAxisAlignment.center,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          navigateTo(
                                  context, QuickFollowUpAddEditScreen.routeName,
                                  arguments:
                                      QuickAddUpdateFollowupScreenArguments(
                                          _FollowupListResponse.details[index],
                                          true,
                                          "PunchIn"))
                              .then((value) {
                            _FollowupBloc.add(QuickFollowupListRequestEvent(
                                QuickFollowupListRequest(
                                    /*FollowupDate:edt_ReverseFollowUpDate.text,*/ CompanyId:
                                        CompanyID.toString(),
                                    EmployeeID: edt_employeeID.text)));
                          });
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.login,
                              color: Colors.black,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              'PunchIn',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      )
                    ])
              : Container(),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  FetchFollowupStatusDetails() {
    arr_ALL_Name_ID_For_Folowup_Status.clear();
    for (var i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Todays";
      } else if (i == 1) {
        all_name_id.Name = "Missed";
      } else if (i == 2) {
        all_name_id.Name = "Future";
      } else if (i == 3) {
        all_name_id.Name = "completestatus";
      }
      arr_ALL_Name_ID_For_Folowup_Status.add(all_name_id);
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess123(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].userID;
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  void _onTapOfDeleteCustomer(int id) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Visit ?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      //_collapse();
      _FollowupBloc.add(QuickFollowupDeleteByNameCallEvent(
          id, FollowupDeleteRequest(CompanyId: CompanyID.toString())));
    });
  }

  void _onFollowupDeleteCallSucess(FollowupDeleteCallResponseState state,
      BuildContext buildContext123) async {
    /* _FollowupListResponse.details
        .removeWhere((element) => element.pkID == state.id);*/
    print("CustomerDeleted" +
        state.followupDeleteResponse.details[0].column1.toString() +
        "");
    // baseBloc.refreshScreen();
    String Msg = "Visit Delete SucessFully";
    await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      //navigateTo(context, FollowupListScreen.routeName, clearAllStack: true);
      navigateTo(context, QuickFollowupListScreen.routeName,
          clearAllStack: true);
    });

    /* navigateTo(buildContext123, QuickFollowupListScreen.routeName,
        clearAllStack: true);*/
  }

  Future<void> MoveTofollowupHistoryPage(String inquiryNo, String CustomerID) {
    navigateTo(context, FollowupHistoryScreen.routeName,
            arguments: FollowupHistoryScreenArguments(inquiryNo, CustomerID))
        .then((value) {});
  }

  showcustomdialogPunchIn({
    BuildContext context1,
    TextEditingController followupDate,
    TextEditingController reversefollowupDate,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorPrimary, //                   <--- border color
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        15.0) //                 <--- border radius here
                    ),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Add Details",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    /* TextField(
                        controller: edt_Application,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Tap to enter Application",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF000000),
                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                    ),*/
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              // _selectDate(context1, followupDate);

                              DateTime selectedDate = DateTime.now();

                              final DateTime picked = await showDatePicker(
                                  context: context1,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: DateTime(2101));
                              if (picked != null && picked != selectedDate)
                                setState(() {
                                  selectedDate = picked;
                                  edt_FollowUpDate.text =
                                      selectedDate.day.toString() +
                                          "-" +
                                          selectedDate.month.toString() +
                                          "-" +
                                          selectedDate.year.toString();

                                  print("Dateee" + edt_FollowUpDate.text);
                                  /* edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();*/
                                });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Text("FollowUp Date *",
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
                                    height: 60,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            edt_FollowUpDate.text == null ||
                                                    edt_FollowUpDate.text == ""
                                                ? "DD-MM-YYYY"
                                                : edt_FollowUpDate.text,
                                            style: baseTheme.textTheme.headline3
                                                .copyWith(
                                                    color:
                                                        edt_FollowUpDate.text ==
                                                                    null ||
                                                                edt_FollowUpDate
                                                                        .text ==
                                                                    ""
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
                              height: CardViewHeight,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                        enabled: true,
                                        controller: edt_Application,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: "Tap to enter Application",
                                          labelStyle: TextStyle(
                                            color: Color(0xFF000000),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF000000),
                                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                        ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Text("Serial No",
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
                              height: CardViewHeight,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: double.maxFinite,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                        enabled: true,
                                        controller: edt_SerialNo,
                                        decoration: InputDecoration(
                                          hintText: "Tap to enter SerialNo",
                                          labelStyle: TextStyle(
                                            color: Color(0xFF000000),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF000000),
                                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                        ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(90, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(24.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {});
                          // _productList[index1].SerialNo = edt_Application.text;
                          Navigator.pop(context123);
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(color: colorWhite),
                        ))
                  ],
                )),
          ],
        );
      },
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
        F_datecontroller.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        /* edt_ReverseFollowUpDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();*/
      });
  }

  FetchFollowupPriorityDetails() {
    arr_ALL_Name_ID_For_Folowup_Priority.clear();
    for (var i = 0; i <= 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "active";
      } else if (i == 1) {
        all_name_id.Name = "todays";
      } else if (i == 2) {
        all_name_id.Name = "missed";
      } else if (i == 3) {
        all_name_id.Name = "future";
      } else if (i == 4) {
        all_name_id.Name = "completestatus";
      }
      arr_ALL_Name_ID_For_Folowup_Priority.add(all_name_id);
    }
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
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Select Status",
                        style: TextStyle(
                            fontSize: 12,
                            color: colorPrimary,
                            fontWeight: FontWeight
                                .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                        ),
                    Icon(
                      Icons.filter_list_alt,
                      color: colorPrimary,
                    ),
                  ]),
                  SizedBox(
                    height: 5,
                  ),
                  Card(
                    elevation: 5,
                    color: colorLightGray,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      // padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: edt_Status,
                              enabled: false,
                              style: TextStyle(fontSize: 15),
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Select",
                              ),
                            ),
                            // dropdown()
                          ),
                          /*  Icon(
                      Icons.arrow_drop_down,
                      color: colorGrayDark,
                    )*/
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);

        showcustomdialogWithTWOName(
            values: arr_EmployeeList,
            context1: context,
            controller: edt_employeeName,
            controller1: edt_employeeID,
            lable: "Select Employee");
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Select Employee",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
              Icon(
                Icons.filter_list_alt,
                color: colorPrimary,
              ),
            ]),
            SizedBox(
              height: 5,
            ),
            Card(
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                // padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: edt_employeeName,
                        enabled: false,
                        style: TextStyle(fontSize: 15),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Select",
                        ),
                      ),
                      // dropdown()
                    ),
                    /*  Icon(
                      Icons.arrow_drop_down,
                      color: colorGrayDark,
                    )*/
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_EmployeeList.clear();

    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id1 = ALL_Name_ID();
        all_name_id1.Name = state.details[i].employeeName;
        all_name_id1.Name1 = state.details[i].pkID.toString();
        all_name_id1.MenuName = state.details[i].userID;
        arr_EmployeeList.add(all_name_id1);
      }
    }
  }
}
