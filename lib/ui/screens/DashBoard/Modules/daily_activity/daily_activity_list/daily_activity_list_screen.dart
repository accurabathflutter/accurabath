import 'package:device_apps/device_apps.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/dailyactivity/dailyactivity_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/daily_activity/daily_activity_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/daily_activity/daily_activity_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/daily_activity/daily_activity_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/follower_employee_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/contact_model.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/daily_activity/daily_activity_add_edit/daily_activity_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:mailto/mailto.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../home_screen.dart';

class AddUpdateDailyActivityListScreenArguments {
  String ListDate;

  AddUpdateDailyActivityListScreenArguments(this.ListDate);
}

class DailyActivityListScreen extends BaseStatefulWidget {
  static const routeName = '/DailyActivityListScreen';
  final AddUpdateDailyActivityListScreenArguments arguments;

  DailyActivityListScreen(this.arguments);

  @override
  _DailyActivityListScreenState createState() =>
      _DailyActivityListScreenState();
}

class _DailyActivityListScreenState extends BaseState<DailyActivityListScreen>
    with BasicScreen, WidgetsBindingObserver {
  DailyActivityScreenBloc _dailyActivityScreenBloc;
  int _pageNo = 0;
  DailyActivityListResponse _dailyActivityDetails;
  bool expanded = true;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _key;
  String foos = 'One';
  int selected = 0; //attention
  bool isExpand = false;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;

  int CompanyID = 0;
  String LoginUserID = "";
  List<ContactModel> _contactsList = [];

  bool _hasCallSupport = false;
  Future<void> _launched;
  String _phone = '';
  var _url = "https://api.whatsapp.com/send?phone=91";
  bool isDeleteVisible = true;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();
  final TextEditingController edt_FollowupEmployeeUserID =
      TextEditingController();
  final TextEditingController edt_FollowupStatus = TextEditingController();
  final TextEditingController edt_FollowupStatusReverse =
      TextEditingController();

  DateTime selectedDate = DateTime.now();

  String TotalCount = "";
  double totduration = 0.00;
  final TextEditingController TASKTOTALDURATION = TextEditingController();
  bool _isForUpdate;

  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorDarkYellow;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getFollowerEmployeeList();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    edt_FollowupEmployeeList.text =
        _offlineLoggedInData.details[0].employeeName;
    edt_FollowupEmployeeUserID.text =
        _offlineLoggedInData.details[0].employeeID.toString();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _dailyActivityScreenBloc = DailyActivityScreenBloc(baseBloc);
    isExpand = false;

    edt_FollowupStatus.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();

    edt_FollowupStatusReverse.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      edt_FollowupStatus.text = widget.arguments.ListDate
          .getFormattedDate(fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy");
      _dailyActivityScreenBloc
        ..add(DailyActivityListCallEvent(
            1,
            DailyActivityListRequest(
                CompanyId: CompanyID,
                LoginUserID: LoginUserID,
                EmployeeID: edt_FollowupEmployeeUserID.text,
                ActivityDate: widget.arguments.ListDate)));
    } else {
      _dailyActivityScreenBloc
        ..add(DailyActivityListCallEvent(
            1,
            DailyActivityListRequest(
                CompanyId: CompanyID,
                LoginUserID: LoginUserID,
                EmployeeID: edt_FollowupEmployeeUserID.text,
                ActivityDate: edt_FollowupStatusReverse.text)));
    }

    canLaunch('tel:123').then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);

    edt_FollowupStatus.addListener(followerEmployeeList);
    edt_FollowupStatusReverse.addListener(followerEmployeeList);
    edt_FollowupEmployeeList.addListener(followerEmployeeList);
    edt_FollowupEmployeeUserID.addListener(followerEmployeeList);

    getUserRights(_menuRightsResponse);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _makeSms(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'smsto',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dailyActivityScreenBloc,
      child: BlocConsumer<DailyActivityScreenBloc, DailyActivityScreenStates>(
        builder: (BuildContext context, DailyActivityScreenStates state) {
          if (state is DailyActivityCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          /* if (state is SearchCustomerListByNumberCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }*/
          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is DailyActivityCallResponseState ||
              currentState is UserMenuRightsResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, DailyActivityScreenStates state) {
          if (state is DailyActivityDeleteCallResponseState) {
            _onCustomerDeleteCallSucess(state, context);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is DailyActivityDeleteCallResponseState) {
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
          title: Text('Daily Activities List'),
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
                }),
            /*  _offlineLoggedInData.details[0].companyID == 4132
                ?*/
            IconButton(
                icon: Icon(
                  Icons.email,
                  color: colorWhite,
                ),
                onPressed: () async {
                  bool isInstalled =
                      await DeviceApps.isAppInstalled('ru.yandex.mail');

                  if (isInstalled == true) {
                    if (_dailyActivityDetails.details.isNotEmpty) {
                      sendEmail(_dailyActivityDetails.details);
                    } else {
                      showCommonDialogWithSingleOption(context,
                          "You Can't Send Mail Because Your Daily WorkLog is Empty",
                          positiveButtonTitle: "OK");
                    }
                  } else {
                    showCommonDialogWithTwoOptions(context,
                        "Kindly Install Yandex Mail App For Sending Mail !",
                        positiveButtonTitle: "Download",
                        onTapOfPositiveButton: () async {
                          //https://play.google.com/store/apps/details?id=ru.yandex.mail&hl=en&gl=US

                          String uri =
                              'https://play.google.com/store/apps/details?id=ru.yandex.mail&hl=en&gl=US';
                          if (await canLaunch(uri)) {
                            await launch(uri);
                          } else {
                            print("No App found");
                          }
                        },
                        negativeButtonTitle: "Close",
                        onTapOfNegativeButton: () {
                          Navigator.pop(context);
                        });
                  }

                  /*final smtpServer = SmtpServer('smtp.yandex.com',
                      // port: 587,
                      //ssl: true,
                      username: 'noreply@sharvayainfotech.com',
                      password: "sharvaya");


                  final message = Message()
                    ..from =
                        Address("rathod.kishan7up@gmail.com", 'Kishan Rathod')
                    ..recipients.add('Ashish.rathod@sharvayainfotech.com')

                    ..subject =
                        'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
                    ..text =
                        'This is the plain text.\nThis is line 2 of the text part.'
                    ..html =
                        "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

                  try {
                    final sendReport = await send(message, smtpServer);
                    print('Message sent: ' + sendReport.toString());
                  } on MailerException catch (e) {
                    print('Message not sent.');
                    for (var p in e.problems) {
                      print('Problem: ${p.code}: ${p.msg}');
                    }
                  }*/
                })
            /*: Container()*/
          ],
        ),
        /* AppBar(
          backgroundColor: colorPrimary,
          title: Text("Customer List"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.water_damage_sharp,color: colorWhite,),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),*/
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    baseBloc.refreshScreen();

                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      children: [
                        // _buildSearchView(),
                        Row(children: [
                          Expanded(
                            flex: 2,
                            child: _buildEmplyeeListView(),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildSearchView(),
                          ),
                        ]),
                        Expanded(child: _buildInquiryList())
                      ],
                    ),
                  ),
                ),
              ),
              _buildCount()
            ],
          ),
        ),
        floatingActionButton: IsAddRights == true
            ? FloatingActionButton(
                onPressed: () async {
                  // Add your onPressed code here!
                  // navigateTo(context, DailyActivityAddEditScreen.routeName);
                  navigateTo(context, DailyActivityAddEditScreen.routeName,
                          arguments:
                              AddUpdateDailyActivityRequestScreenArguments(
                                  null, edt_FollowupStatusReverse.text))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: const Icon(Icons.add),
                backgroundColor: colorPrimary,
              )
            : Container(),
        bottomSheet: Padding(padding: EdgeInsets.only(bottom: 80)),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  ///builds header and title view

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_dailyActivityDetails == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
          scrollInfo,
        )) {
          _onInquiryListPagination();
          return true;
        } else {
          return false;
        }
      },
      child: ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _dailyActivityDetails.details.length,
      ),
    );
  }

  ///builds row item view of inquiry list
  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ///updates data of inquiry list
  void _onInquiryListCallSuccess(DailyActivityCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _dailyActivityDetails = state.dailyActivityListResponse;
      } else {
        _dailyActivityDetails.details
            .addAll(state.dailyActivityListResponse.details);
      }
      _pageNo = state.newPage;
    }

    if (state.dailyActivityListResponse.details.length != 0) {
      totduration = 0.00;
      for (int i = 0; i < state.dailyActivityListResponse.details.length; i++) {
        totduration += state.dailyActivityListResponse.details[i].taskDuration;
      }

      //double taskdurationTwoDecimal = totduration.toStringAsFixed(2);

      List<String> SpliteMinute = totduration.toStringAsFixed(2).split(".");

      print("lsdjjfj55" +
          SpliteMinute[0].toString() +
          SpliteMinute[1].toString());

      int Hour = int.parse(SpliteMinute[0].toString());
      int Minute = int.parse(SpliteMinute[1].toString());
      int TotalMinute = 0;

      if (Minute > 60) {
        TotalMinute = Minute - 60;
        Hour = Hour + 1;
      } else {
        TotalMinute = Minute;
        // Hour = Hour;
      }

      print("lsdjjfj5566551" +
          " HOURS " +
          Hour.toString() +
          " Minute " +
          TotalMinute.toString());

      TASKTOTALDURATION.text =
          Hour.toString() + " Hrs. " + TotalMinute.toString() + " Min. ";
    }
    // TotalCount = state.dailyActivityListResponse.totalCount.toString();
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onInquiryListPagination() {
    _dailyActivityScreenBloc.add(DailyActivityListCallEvent(
        _pageNo + 1,
        DailyActivityListRequest(
            CompanyId: CompanyID,
            LoginUserID: LoginUserID,
            EmployeeID: "",
            ActivityDate: "")));

    /*if (_inquiryListResponse.details.length < _inquiryListResponse.totalCount) {


    }*/
  }

  ExpantionCustomer(BuildContext context, int index) {
    DailyActivityDetails model = _dailyActivityDetails.details[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: Color(0xFFC1E0FA),
          leading: CircleAvatar(
              backgroundColor: Color(0xFF504F4F),
              child: Image.network(
                "http://demo.sharvayainfotech.in/images/profile.png",
                height: 35,
                fit: BoxFit.fill,
                width: 35,
              )),
          title: Text(
            model.createdEmployeeName,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            model.taskCategoryName +
                " [ " +
                (model.taskDuration == 0
                    ? "0.00"
                    : model.taskDuration.toString()) +
                " Hrs ]",
            style: TextStyle(
              color: Color(0xFF504F4F),
              fontSize: _fontSize_Title,
            ),
          ),

          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: Container(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Work Category  ",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Color(label_color),
                                            fontSize: _fontSize_Label,
                                            letterSpacing: .3)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        model.taskCategoryName == ""
                                            ? "N/A"
                                            : model.taskCategoryName,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontSize: _fontSize_Title,
                                            letterSpacing: .3)),
                                  ],
                                )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Work Notes",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.taskDescription == ""
                                                ? "N/A"
                                                : model.taskDescription,
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    ))
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Work Hrs.",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.taskDuration == 0
                                                ? "N/A"
                                                : model.taskDuration.toString(),
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("CreatedDate",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.createdDate == ""
                                                ? "N/A"
                                                : model.createdDate
                                                        .getFormattedDate(
                                                            fromFormat:
                                                                "yyyy-MM-ddTHH:mm:ss",
                                                            toFormat:
                                                                "dd-MM-yyyy") ??
                                                    "-",
                                            style: TextStyle(
                                                color: Color(title_color),
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
            ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonHeight: 52.0,
                buttonMinWidth: 90.0,
                children: <Widget>[
                  IsEditRights == true
                      ? GestureDetector(
                          onTap: () {
                            _onTapOfEditCustomer(model);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.edit,
                                color: colorPrimary,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(color: colorPrimary),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 10,
                  ),
                  IsDeleteRights == true
                      ? GestureDetector(
                          onTap: () {
                            _onTapOfDeleteInquiry(model.pkID);
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: colorPrimary,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(color: colorPrimary),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ]),
          ],
        ));
  }

  void _onTapOfDeleteInquiry(int id) {
    print("CUSTID" + id.toString());
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Customer?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      //_collapse();
      _dailyActivityScreenBloc.add(DailyActivityDeleteByNameCallEvent(
          id, DailyActivityDeleteRequest(CompanyID: CompanyID.toString())));
      // _CustomerBloc..add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: CompanyID,loginUserID: LoginUserID,CustomerID: "",ListMode: "L")));
    });
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {}

  ///updates data of inquiry list

  void _onCustomerDeleteCallSucess(
      DailyActivityDeleteCallResponseState state, BuildContext context) {
    /* _inquiryListResponse.details
        .removeWhere((element) => element.customerID == state.id);*/

    /* print("CustomerDeleted" +
        state.dailyActivityDeleteResponse.details[0].column1.toString() +
        "");
    //baseBloc.refreshScreen();
    navigateTo(context, DailyActivityListScreen.routeName, clearAllStack: true);*/

    _dailyActivityScreenBloc.add(DailyActivityListCallEvent(
        1,
        DailyActivityListRequest(
            CompanyId: CompanyID,
            LoginUserID: LoginUserID,
            EmployeeID: edt_FollowupEmployeeUserID.text,
            ActivityDate: edt_FollowupStatusReverse.text)));
  }

  void _onTapOfEditCustomer(DailyActivityDetails model) {
    navigateTo(context, DailyActivityAddEditScreen.routeName,
            arguments: AddUpdateDailyActivityRequestScreenArguments(
                model, model.createdDate))
        .then((value) {
      _dailyActivityScreenBloc.add(DailyActivityListCallEvent(
          1,
          DailyActivityListRequest(
              CompanyId: CompanyID,
              LoginUserID: LoginUserID,
              EmployeeID: edt_FollowupEmployeeUserID.text,
              ActivityDate: edt_FollowupStatusReverse.text)));
    });
  }

  followerEmployeeList() {
    print(
        "CurrentEMP Text is ${edt_FollowupStatusReverse.text + " USERID : " + edt_FollowupEmployeeUserID.text}");
    _dailyActivityScreenBloc
      ..add(DailyActivityListCallEvent(
          1,
          DailyActivityListRequest(
              CompanyId: CompanyID,
              LoginUserID: LoginUserID,
              EmployeeID: edt_FollowupEmployeeUserID.text,
              ActivityDate: edt_FollowupStatusReverse.text)));
    setState(() {});
  }

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);

        showcustomdialogWithTWOName(
            values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
            context1: context,
            controller: edt_FollowupEmployeeList,
            controller1: edt_FollowupEmployeeUserID,
            lable: "Select Employee");
      },
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                          color: Colors.black, // <-- Change this
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
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
          )
        ],
      ),
    );
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        /* showcustomdialog(
            values: arr_ALL_Name_ID_For_Folowup_Status,
            context1: context,
            controller: edt_FollowupStatus,
            lable: "Select Status");*/
        // _expenseBloc.add(ExpenseTypeByNameCallEvent(ExpenseTypeAPIRequest(CompanyId: CompanyID.toString())));
        _selectDate(context, edt_FollowupStatus, edt_FollowupStatusReverse);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Select Date",
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
                      style: TextStyle(
                          color: Colors.black, // <-- Change this
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
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

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController edt_followupStatusReverse) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_FollowupStatus.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_FollowupStatusReverse.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      FollowerEmployeeListResponse state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    if (state.details != null) {
      if (_offlineLoggedInData.details[0].roleCode.toLowerCase().trim() ==
          "admin") {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = "ALL";
        all_name_id.Name1 = "";
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }

      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.Name1 = state.details[i].pkID.toString();
        arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
      }
    }
  }

  Widget _buildCount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: colorPrimary,
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, top: 3),
                child: Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 7),
                child: Text(
                  "Total Task Duration\t:",
                  style: TextStyle(
                    fontFamily: "Poppins_Regular",
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  // totduration.toStringAsFixed(2),
                  TASKTOTALDURATION.text,
                  style: TextStyle(
                    fontFamily: "Poppins_Regular",
                    fontSize: 15,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgDailyActivity") {
        _dailyActivityScreenBloc.add(UserMenuRightsRequestEvent(
            menuRightsResponse.details[i].menuId.toString(),
            UserMenuRightsRequest(
                MenuID: menuRightsResponse.details[i].menuId.toString(),
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID)));
        break;
      }
    }
  }

  void _OnMenuRightsSucess(UserMenuRightsResponseState state) {
    for (int i = 0; i < state.userMenuRightsResponse.details.length; i++) {
      print("DSFsdfkk" +
          " MenuName :" +
          state.userMenuRightsResponse.details[i].addFlag1.toString());

      IsAddRights = state.userMenuRightsResponse.details[i].addFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
      IsEditRights = state.userMenuRightsResponse.details[i].editFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
      IsDeleteRights = state.userMenuRightsResponse.details[i].delFlag1
                  .toLowerCase()
                  .toString() ==
              "true"
          ? true
          : false;
    }
  }

  void sendEmail(List<DailyActivityDetails> details) async {
    List<String> dailydata = [];
    for (int i = 0; i < details.length; i++) {
      dailydata.add(" => " +
          "Category : " +
          details[i].taskCategoryName +
          "\nWork Notes : " +
          details[i].taskDescription +
          "\n" +
          " ( " +
          (details[i].taskDuration == 0
              ? "0.00"
              : details[i].taskDuration.toString()) +
          " Hrs )\n\n");
    }

    String ReportToEmail = "";

    String ReportToCC = "";
    String ReportToCC1 = "";
    String ReportToCC2 = "";

    ReportToEmail = "ashish.rathod@sharvayainfotech.com";
    ReportToCC = "jalpa.shah@sharvayainfotech.com";

    if (_offlineLoggedInData.details[0].employeeID == 67) {
      //Dhara
      ReportToEmail = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeID == 62) {
      //Bhavini
      ReportToEmail = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeID == 63) {
      //Nisha
      ReportToEmail = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeID == 95) {
      //Dev
      ReportToEmail = "payal.vaghasiya@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC2 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeID == 101) {
      //Payal
      ReportToEmail = "hekanksh.gohel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }

    if (_offlineLoggedInData.details[0].employeeID == 100) {
      //Yash
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }

    if (_offlineLoggedInData.details[0].employeeID == 94) {
      //Shivam
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeID == 99) {
      //Trilok
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeID == 93) {
      //Krish
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }
    if (_offlineLoggedInData.details[0].employeeID == 102) {
      //Vedant
      ReportToEmail = "akshar.patel@sharvayainfotech.com";
      ReportToCC = "ashish.rathod@sharvayainfotech.com";
      ReportToCC1 = "jalpa.shah@sharvayainfotech.com";
    }

    /* final Uri params = Uri(
      host: 'smtp.yandex.com',
      port: 587,
      scheme: 'mailto',
      path: 'Kishan.rathod@sharvayainfotech.com',
      query: 'subject=Hello&body=World!',
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/
    /* final Email email = Email(
      body: 'Email body',
      subject: 'From Flutter App',
      recipients: ['mayank.panchal@sharvayainfotech.com'],
      cc: ['kishan.rathod@sharvayainfotech.com'],
      // bcc: ['bcc@example.com'],
      // attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);*/

    final mailtoLink = Mailto(
      to: [ReportToEmail],
      cc: [ReportToCC, ReportToCC1, ReportToCC2],
      subject: 'Daily Report  ' + edt_FollowupStatus.text,
      body: 'Respected Sir,\n'
              'Daily Report Points\n\n' +
          dailydata
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '\nTotal Hours : ' + TASKTOTALDURATION.text),
    );
    await launch('$mailtoLink');
    /*final String subject = "Subject:";
    final String stringText = "Same Message:";
    String uri =
        'mailto:kishan.rathod@sharvayainfotech.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print("No email client found");
    }
  }*/
  }
}
