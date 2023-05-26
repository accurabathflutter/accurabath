import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/firstscreen/first_screen_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/company_details/company_details_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_source_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/designation_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/authentication/first_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SerialKeyScreen extends BaseStatefulWidget {
  static const routeName = '/SerialKeyScreen';

  _SerialKeyScreenState createState() => _SerialKeyScreenState();
}

class _SerialKeyScreenState extends BaseState<SerialKeyScreen>
    with BasicScreen, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  FirstScreenBloc _firstScreenBloc;
  final double _minValue = 8.0;

/*  final TextEditingController edt_User_Name = TextEditingController();

   final TextEditingController edt_User_Password = TextEditingController();*/
  int count = 0;

  TextEditingController _userNameController = TextEditingController();

  TextEditingController _IPCotroller = TextEditingController();
  TextEditingController EmailTO = TextEditingController();

  //EmailTO

  TextEditingController _passwordController = TextEditingController();
  CompanyDetailsResponse _offlineLoggedInData;
  CustomerSourceResponse _offlineCustomerSourceData;
  DesignationApiResponse _offlineCustomerDesignationData;
  LoginUserDetialsResponse _offlineLoggedInDetailsData;
  String InvalidUserMessage = "";
  bool _isObscure = true;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ModeOfTransfer = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SerialKeyDropDown = [];
  bool value = false;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    getIPDropDown();
    _firstScreenBloc = FirstScreenBloc(baseBloc);
    _initPackageInfo();

    /*  FirebaseMessaging.instance.getToken().then((token) async {
      //final tokenStr = token.toString();
      // do whatever you want with the token here
      print("fcm_TOken" + token);
    });*/

    /*  _firstScreenBloc
      ..add(CompanyDetailsCallEvent(
          CompanyDetailsApiRequest(serialKey: "ABCD-EFGH-IJKL-MNOW")));*/
  }

  ///listener to multiple states of bloc to handles api responses
  ///use only BlocListener if only need to listen to events
/*
  @override
  Widget build(BuildContext context) {
    return BlocListener<FirstScreenBloc, FirstScreenStates>(
      bloc: _authenticationBloc,
      listener: (BuildContext context, FirstScreenStates state) {
        if (state is FirstScreenResponseState) {
          _onFirstScreenCallSuccess(state.response);
        }
      },
      child: super.build(context),
    );
  }
*/

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _firstScreenBloc,
      child: BlocConsumer<FirstScreenBloc, FirstScreenStates>(
        builder: (BuildContext context, FirstScreenStates state) {
          //handle states

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called

          return false;
        },
        listener: (BuildContext context, FirstScreenStates state) {
          //handle states
          if (state is MasterBaseURLResponseState) {
            _onMasterBaseURLAPIResponse(state);
          }
          if (state is ComapnyDetailsEventResponseState) {
            _onCompanyDetailsCallSucess(state.companyDetailsResponse);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          if (currentState is ComapnyDetailsEventResponseState ||
              currentState is MasterBaseURLResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    /*edt_User_Name.text = "admin";
    edt_User_Password.text = "admin!@#";*/

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
            right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN,
            top: 50,
            bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopView(),
            SizedBox(height: 50),
            _buildLoginForm(),

            /*Positioned(
              child: new Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: ,
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  _onCompanyDetailsCallSucess(CompanyDetailsResponse response) {
    // SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_LOGGED_IN_USER_DATA, true);

    if (response.details.length != 0) {
      SharedPrefHelper.instance.setCompanyData(response);
      _offlineLoggedInData = SharedPrefHelper.instance.getCompanyData();
      SharedPrefHelper.instance.putBool(SharedPrefHelper.IS_REGISTERED, true);

      navigateTo(context, FirstScreen.routeName, clearAllStack: true);

      print("Company Details : " +
          response.details[0].companyName.toString() +
          "");
    } else {
      showCommonDialogWithSingleOption(context, "Invalid SerialKey",
          positiveButtonTitle: "OK");
    }
  }

  Widget _buildTopView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          IMG_HEADER_LOGO,
          width: MediaQuery.of(context).size.width / 1.8,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          "Registration",
          style: TextStyle(
            color: colorPrimary,
            fontSize: 48,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Register your account",
          style: TextStyle(
            color: Color(0xff019ee9),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SerialKeyTextField(),
          SizedBox(
            height: 25,
          ),
          Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
            ),
            child: getCommonButton(baseTheme, () {
              print("MobileAppVersion" +
                  " BuildNumber : " +
                  _packageInfo.buildNumber.toString() +
                  " Version : " +
                  _packageInfo.version.toString());
              _onTapOfLogin();
            }, "Register"),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final url =
                      'https://docs.google.com/document/d/1Vaw_raFxfDK8Rj7nWsteafX8k47h0N3Ye0irNAV8oK4/edit?usp=sharing';

                  if (await canLaunch(url)) {
                    await launch(
                      url,
                      forceSafariVC: false,
                    );
                  }
                },
                child: Text(
                  "Terms of Use ",
                  style: TextStyle(
                    fontSize: 10,
                    color: colorPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                "  |  ",
                style: TextStyle(
                  fontSize: 10,
                  color: colorPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              InkWell(
                onTap: () async {
                  final url =
                      'https://docs.google.com/document/d/13HliC_idDq4G-06Ii8z0gyzsXYZgSbvfzYThxTmQRpc/edit?usp=sharing';

                  if (await canLaunch(url)) {
                    await launch(
                      url,
                      forceSafariVC: false,
                    );
                  }
                },
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontSize: 10,
                    color: colorPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _onTapOfLogin() async {
    if (_userNameController.text != "") {
      print("SERRRR" + _userNameController.text.toString().toUpperCase());
      _firstScreenBloc.add(MasterBaseURLCallEvent(CompanyDetailsApiRequest(
          serialKey: _userNameController.text.toString())));
    } else {
      showCommonDialogWithSingleOption(context, "Serial Key field is blank !",
          positiveButtonTitle: "OK");
    }
    //TODO
  }

  Widget SerialKeyTextField() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Text("Serial Key",
                style: TextStyle(
                    fontSize: 15,
                    color:
                        colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: Color(0xffE0E0E0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          maxLength: 19,
                          controller: _userNameController,
                          cursorColor: Color(0xFFF1E6FF),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                            ),
                            hintText: "xxxx-xxxx-xxxx-xxxx",
                            border: InputBorder.none,
                            counterStyle: TextStyle(height: double.minPositive),
                            counterText: "",
                          ),
                          onChanged: (String value) async {
                            setState(() {
                              if (count <= _userNameController.text.length &&
                                  (_userNameController.text.length == 4 ||
                                      _userNameController.text.length == 9 ||
                                      _userNameController.text.length == 14)) {
                                _userNameController.text =
                                    _userNameController.text + "-";
                                int pos = _userNameController.text.length;
                                _userNameController.selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: pos));
                              } else if (count >=
                                      _userNameController.text.length &&
                                  (_userNameController.text.length == 4 ||
                                      _userNameController.text.length == 9 ||
                                      _userNameController.text.length == 14)) {
                                _userNameController.text =
                                    _userNameController.text.substring(
                                        0, _userNameController.text.length - 1);
                                int pos = _userNameController.text.length;
                                _userNameController.selection =
                                    TextSelection.fromPosition(
                                        TextPosition(offset: pos));
                              }
                              count = _userNameController.text.length;
                            });
                          })),
                ],
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Text("IP",
                      style: TextStyle(
                          fontSize: 15,
                          color:
                              colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                Card(
                  elevation: 5,
                  color: Color(0xffE0E0E0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          maxLength: 19,
                          controller: _IPCotroller,
                          cursorColor: Color(0xFFF1E6FF),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.vpn_key,
                            ),
                            hintText: "xxxx-xxxx-xxxx-xxxx",
                            border: InputBorder.none,
                            counterStyle: TextStyle(height: double.minPositive),
                            counterText: "",
                          ),
                        )),
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

  void getIPDropDown() {
    arr_ALL_Name_ID_For_ModeOfTransfer.clear();
    for (var i = 0; i < 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "http://122.169.111.101:108/";
      } else if (i == 1) {
        all_name_id.Name = "http://208.109.14.134:83/";
      }
      arr_ALL_Name_ID_For_ModeOfTransfer.add(all_name_id);
    }
  }

  void _onMasterBaseURLAPIResponse(MasterBaseURLResponseState state) {
    SharedPrefHelper.instance
        .setBaseURL(state.masterBaseURLResponse.details[0].baseURL + "/");

    if (SharedPrefHelper.instance.getBaseURL() != "") {
      _firstScreenBloc.add(CompanyDetailsCallEvent(CompanyDetailsApiRequest(
          serialKey: _userNameController.text.toString())));
    } else {
      showCommonDialogWithSingleOption(context, "Something Went Wrong !",
          positiveButtonTitle: "OK");
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }
}
