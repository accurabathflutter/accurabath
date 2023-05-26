import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_pdf_generate_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/search_quotation_list_by_number_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/search_quotation_list_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/quotation_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/search_quotation_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home_screen.dart';

class QuotationListScreen extends BaseStatefulWidget {
  static const routeName = '/QuotationListScreen';

  @override
  _QuotationListScreenState createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends BaseState<QuotationListScreen>
    with BasicScreen, WidgetsBindingObserver {
  QuotationBloc _QuotationBloc;
  int _pageNo = 0;
  QuotationListResponse _quotationListResponse;
  bool expanded = true;
  var isRedirect = true;

  double sizeboxsize = 12;
  double _fontSize_Label = 8;
  double _fontSize_Title = 10;
  int label_color = 0xff0066b3; //0x66666666;
  int title_color = 0xff0066b3;
  SearchDetails _searchDetails;
  int CompanyID = 0;
  String LoginUserID = "";
  String Password = "";
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;

  InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController pullToRefreshController;
  ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  int prgresss = 0;
  final urlController = TextEditingController();

  String SiteURL = "";
  String QTGEN = "";
  bool isLoading = true;
  bool onWebLoadingStop = true;
  URLRequest urlRequest;
  CustomerDetails customerDetails = CustomerDetails();

  //EmailTO

  TextEditingController EmailTO = TextEditingController();

  TextEditingController EmailBCC = TextEditingController();

  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  @override
  void initState() {
    super.initState();
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    screenStatusBarColor = colorPrimary;
    _QuotationBloc = QuotationBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password =
        _offlineLoggedInData.details[0].userPassword.replaceAll("#", "%23");

    getUserRights(_menuRightsResponse);

    baseBloc.emit(ShowProgressIndicatorState(true));

    _QuotationBloc.add(DeleteGenericAddditionalChargesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _QuotationBloc
        ..add(QuotationListCallEvent(
            _pageNo + 1,
            QuotationListApiRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID,
                pkId: ""))),
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          if (state is QuotationListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is SearchQuotationListByNumberCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }

          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }

          if (state is DeleteAllGenericAddditionalChargesState) {
            _OnDeleteAllGenericCharges(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is QuotationListCallResponseState ||
              currentState is SearchQuotationListByNumberCallResponseState ||
              currentState is UserMenuRightsResponseState ||
              currentState is DeleteAllGenericAddditionalChargesState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, QuotationStates state) {
          if (state is QuotationPDFGenerateResponseState) {
            _onGenerateQuotationPDFCallSuccess(state);
          }

          if (state is QuotationDeleteCallResponseState) {
            _OnDeleteQuotationSucessResponse(state);
          }

          if (state is SearchCustomerListByNumberCallResponseState) {
            _ONOnlyCustomerDetails(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is QuotationPDFGenerateResponseState ||
              currentState is QuotationDeleteCallResponseState ||
              currentState is SearchCustomerListByNumberCallResponseState) {
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
        backgroundColor: colorVeryLightCardBG,
        appBar: NewGradientAppBar(
          title: Text('Quotation List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                _onTapOfSearchView(); //_onTaptoSearchInquiryView();
              },
              child: Image.asset(
                CUSTOM_SEARCH,
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(
              width: 10,
            ),
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
                    _QuotationBloc.add(QuotationListCallEvent(
                        1,
                        QuotationListApiRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID,
                            pkId: "")));

                    getUserRights(_menuRightsResponse);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 10,
                    ),
                    child: Column(
                      children: [Expanded(child: _buildInquiryList())],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: IsAddRights == true
            ? FloatingActionButton(
                onPressed: () async {
                  // Add your onPressed code here!
                  await _onTapOfDeleteALLProduct();

                  navigateTo(context, QuotationAddEditScreen.routeName);
                },
                child: const Icon(Icons.add),
                backgroundColor: colorPrimary,
              )
            : Container(),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );

    return Column(
      children: [
        getCommonAppBar(context, baseTheme, localizations.inquiry),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              top: 25,
            ),
            child: Column(
              children: [
                _buildSearchView(),
                Expanded(child: _buildInquiryList())
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Quotation",
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

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
              height: 60,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _searchDetails == null
                          ? "Tap to search quotation"
                          : _searchDetails.custoemerName,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _searchDetails == null
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.search,
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

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_quotationListResponse == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
              scrollInfo,
            ) &&
            _searchDetails == null) {
          _onInquiryListPagination();
          return true;
        } else {
          return false;
        }
      },
      child: Column(
        children: [
          _quotationListResponse.details.length != 0
              ? _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                          "DHSI-09RY-BATH-ACCU" ||
                      _offlineLoggedInData.details[0].serialKey.toUpperCase() ==
                          "TEST-0000-ACBF-0214"
                  ? OneTimeGenerateQTWithDiscount(
                      _quotationListResponse.details[0], context, "new")
                  : OneTimeGenerateQT(
                      _quotationListResponse.details[0], context, "new")
              : Container(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildInquiryListItem(index);
              },
              shrinkWrap: true,
              itemCount: _quotationListResponse.details.length,
            ),
          ),
        ],
      ),
    );
  }

  ///builds row item view of inquiry list
  Widget _buildInquiryListItem(int index) {
    return Column(
      children: [ExpantionCustomer(context, index)],
    );
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
                fontWeight: FontWeight
                    .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
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
  void _onInquiryListCallSuccess(QuotationListCallResponseState state) async {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _searchDetails = null;
        _quotationListResponse = state.response;
      } else {
        _quotationListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onInquiryListPagination() {
    print("jdsj" + _pageNo.toString());
    _QuotationBloc.add(QuotationListCallEvent(
        _pageNo + 1,
        QuotationListApiRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID,
            pkId: "")));
    /*if (_quotationListResponse.details.length <
        _quotationListResponse.totalCount) {
      _QuotationBloc.add(QuotationListCallEvent(
          _pageNo + 1,
          QuotationListApiRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              pkId: "")));
    }*/
  }

  ExpantionCustomer(BuildContext context, int index) {
    QuotationDetails model = _quotationListResponse.details[index];

    return Container(
      margin: EdgeInsets.all(10),
      child: ExpansionTileCard(
        initialElevation: 5.0,
        elevation: 5.0,
        elevationCurve: Curves.easeInOut,
        shadowColor: Color(0xFF504F4F),
        baseColor: Color(0xFFFCFCFC),
        expandedColor: colorTileBG,
        //Colors.deepOrange[50],ADD8E6

        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.assignment_ind,
                    color: Color(0xff108dcf),
                    size: 24,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Color(0xff108dcf),
                size: 24,
              ),
            ),
            SizedBox(
              width: 3,
            ),
            Flexible(
              child: Text(
                model.customerName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(
                Icons.confirmation_num,
                color: Color(0xff108dcf),
                size: 12,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                model.quotationNo,
                style: TextStyle(
                  color: Color(0xFF504F4F),
                  fontSize: 9,
                ),
              ),
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
            child: Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Visibility(
                            visible: true,
                            child: GestureDetector(
                              onTap: () async {
                                MakeCall.callto(model.contactNo1);
                              },
                              child: Column(
                                children: [
                                  Card(
                                    color: colorBackGroundGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      child: Center(
                                        child: Icon(
                                          Icons.phone,
                                          size: 24,
                                          color: colorPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text("Call",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: colorPrimary,
                                          fontSize: 7,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () async {
                              ShareMsg.msg(context, model.contactNo1);
                            },
                            child: Column(
                              children: [
                                Card(
                                  color: colorBackGroundGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    child: Center(
                                        child: Icon(
                                      Icons.message,
                                      size: 24,
                                      color: colorPrimary,
                                    )),
                                  ),
                                ),
                                Text("WhatsApp",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: colorPrimary,
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () async {
                              FetchCustomerDetails(model.customerID);
                            },
                            child: Column(
                              children: [
                                Card(
                                  color: colorBackGroundGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    /*decoration: const BoxDecoration(
                                    color: colorPrimary,
                                    shape: BoxShape.circle),*/
                                    child: Center(
                                        child: Icon(
                                      Icons.perm_identity_outlined,
                                      size: 24,
                                      color: colorPrimary,
                                    )),
                                  ),
                                ),
                                Text("Info.",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: colorPrimary,
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          /* GestureDetector(
                            onTap: () async {
                              FetchCustomerDetails(model.customerID);
                            },
                            child: Column(
                              children: [
                                Card(
                                  color: colorBackGroundGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    */ /*decoration: const BoxDecoration(
                                    color: colorPrimary,
                                    shape: BoxShape.circle),*/ /*
                                    child: Center(
                                        child: Icon(
                                      Icons.perm_identity_outlined,
                                      size: 24,
                                      color: colorPrimary,
                                    )),
                                  ),
                                ),
                                Text("Info.",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: colorPrimary,
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),*/
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () async {
                              print("Acurabath_non_dis" +
                                  "  PDF : " +
                                  SiteURL +
                                  "/Quotation.aspx?QuotationType=nondis&PrintHeader=yes&MobilePdf=yes&userid=" +
                                  LoginUserID +
                                  "&password=" +
                                  Password +
                                  "&pQuotID=" +
                                  model.pkID.toString());

                              await _showMyDialog(model, "new");
                            },
                            child: Column(
                              children: [
                                Card(
                                  color: colorBackGroundGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    child: Center(
                                        child: Icon(
                                      Icons.picture_as_pdf_rounded,
                                      size: 24,
                                      color: colorPrimary,
                                    )),
                                  ),
                                ),
                                Text("pdf",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: colorPrimary,
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          _offlineLoggedInData.details[0].serialKey
                                          .toUpperCase() ==
                                      "DHSI-09RY-BATH-ACCU" ||
                                  _offlineLoggedInData.details[0].serialKey
                                          .toUpperCase() ==
                                      "TEST-0000-ACBF-0214"
                              ? GestureDetector(
                                  onTap: () async {
                                    print("Acurabath_dis" +
                                        " PDF : " +
                                        SiteURL +
                                        "/Quotation.aspx?QuotationType=dis&PrintHeader=yes&MobilePdf=yes&userid=" +
                                        LoginUserID +
                                        "&password=" +
                                        Password +
                                        "&pQuotID=" +
                                        model.pkID.toString());

                                    await _showMyDialogAccurabathWithDiscount(
                                        model, "new");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Column(
                                      children: [
                                        Card(
                                          color: colorBackGroundGray,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            child: Center(
                                                child: Icon(
                                              Icons.picture_as_pdf_rounded,
                                              size: 24,
                                              color: colorPrimary,
                                            )),
                                          ),
                                        ),
                                        Text("pdf %",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: colorPrimary,
                                                fontSize: 7,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () async {
                              String sendemailreq = SiteURL +
                                  "Quotation.aspx?MobilePdf=yes&userid=" +
                                  LoginUserID +
                                  "&password=" +
                                  Password +
                                  "&pQuotID=" +
                                  model.pkID.toString() +
                                  "&CustomerID=" +
                                  model.customerID.toString();

                              print("webreqj" + sendemailreq);

                              print("customermail" +
                                  model.emailAddress.toString());

                              if (model.emailAddress.toString() != "") {
                                _showEmailMyDialog(model);
                              } else {
                                showCommonDialogWithSingleOption(context,
                                    "Customer's Email Not Found\nKindly Update Email From Customer Master !",
                                    positiveButtonTitle: "OK",
                                    onTapOfPositiveButton: () {
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Column(
                              children: [
                                Card(
                                  color: colorBackGroundGray,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    /*decoration: const BoxDecoration(
                                    color: colorPrimary,
                                    shape: BoxShape.circle),*/
                                    child: Center(
                                        child: Icon(
                                      Icons.email,
                                      size: 24,
                                      color: colorPrimary,
                                    )),
                                  ),
                                ),
                                Text("Email",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: colorPrimary,
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                  ),
                  Card(
                    color: colorBackGroundGray,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 10, top: 5, bottom: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.confirmation_num,
                                        color: colorCardBG,
                                      ),
                                      Text("Quotation",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorCardBG,
                                            fontSize: 7,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Flexible(
                                    child: Text(
                                        model
                                            .quotationNo, //put your own long text here.
                                        maxLines: 3,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize_Title)),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: colorCardBG,
                                      ),
                                      Text("QT.Date",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorCardBG,
                                            fontSize: 7,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                        model.quotationDate.getFormattedDate(
                                                fromFormat:
                                                    "yyyy-MM-ddTHH:mm:ss",
                                                toFormat: "dd-MM-yyyy") ??
                                            "-",
                                        maxLines: 3,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize_Title)),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                  Card(
                    color: colorBackGroundGray,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.confirmation_num,
                                        color: colorCardBG,
                                      ),
                                      Text("Lead#",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorCardBG,
                                            fontSize: 7,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                        model.inquiryNo.toString() == ""
                                            ? "Not Available"
                                            : model.inquiryNo
                                                .toString(), //put your own long text here.
                                        maxLines: 3,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize_Title)),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.category,
                                        color: colorCardBG,
                                      ),
                                      Text("Status",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorCardBG,
                                            fontSize: 7,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(
                                        model.inquiryStatus == ""
                                            ? "Not Available"
                                            : model.inquiryStatus.toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize_Title)),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                  Card(
                    color: colorBackGroundGray,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 10, top: 5, bottom: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.currency_rupee,
                                        color: colorCardBG,
                                      ),
                                      Text("BasicAmt.",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorCardBG,
                                            fontSize: 7,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Flexible(
                                    child: Text(
                                        model.basicAmt.toString() ??
                                            "-", //put your own long text here.
                                        maxLines: 3,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize_Title)),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.currency_rupee,
                                        color: colorCardBG,
                                      ),
                                      Text("NetAmt.",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: colorCardBG,
                                            fontSize: 7,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Text(model.netAmt.toString() ?? "-",
                                        maxLines: 3,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            color: Color(title_color),
                                            fontWeight: FontWeight.bold,
                                            fontSize: _fontSize_Title)),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                  Card(
                    color: colorBackGroundGray,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: colorCardBG,
                              ),
                              Text("Create",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: colorCardBG,
                                      fontSize: 7,
                                      letterSpacing: .3))
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                                model.createdDate.getFormattedDate(
                                    fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                    toFormat:
                                        "dd-MM-yyyy"), //put your own long text here.
                                maxLines: 3,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Color(title_color),
                                    fontWeight: FontWeight.bold,
                                    fontSize: _fontSize_Title)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: colorBackGroundGray,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              Icon(
                                Icons.perm_contact_cal_rounded,
                                color: colorCardBG,
                              ),
                              Text("By",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: colorCardBG,
                                      fontSize: 7,
                                      letterSpacing: .3))
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                                model.createdBy, //put your own long text here.
                                maxLines: 3,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Color(title_color),
                                    fontWeight: FontWeight.bold,
                                    fontSize: _fontSize_Title)),
                          )
                        ],
                      ),
                    ),
                  ),
                  /* _buildTitleWithValueView(
                      "Sales Executive", model.createdBy),
                  SizedBox(
                    height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                  ),*/
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          SizedBox(
            height: 10,
          ),
          IsEditRights == false && IsDeleteRights == false
              ? Container()
              : Card(
                  color: colorCardBG,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    width: 300,
                    height: 50,
                    child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        buttonHeight: 52.0,
                        buttonMinWidth: 90.0,
                        children: <Widget>[
                          IsEditRights == true
                              ? Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // _onTapOfEditCustomer(model);

                                          _onTaptoEditQuotation(model);
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              CUSTOM_UPDATE,
                                              height: 24,
                                              width: 24,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                            ),
                                            Text(
                                              'Update',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: colorWhite),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          IsDeleteRights == true
                              ? GestureDetector(
                                  onTap: () {
                                    _OnDeleteQuotationRequest(model);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Image.asset(
                                        CUSTOM_DELETE,
                                        height: 29,
                                        width: 29,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                      ),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: colorWhite),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: 10,
                          ),
                        ]),
                  ),
                ),
          SizedBox(
            height: 10,
          )
          /*ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonHeight: 52.0,
              buttonMinWidth: 90.0,
              children: <Widget>[
                IsEditRights == true
                    ? GestureDetector(
                        onTap: () async {

                          _onTaptoEditQuotation(model);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(color: Colors.black),
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
                          //  cardA.currentState?.collapse();
                          //new ExpansionTileCardState().collapse();

                          _OnDeleteQuotationRequest(model);
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ]),*/
        ],
      ),
    );
  }

  void FetchCustomerDetails(int customerID321) {
    _QuotationBloc.add(SearchCustomerListByNumberCallEvent(
        CustomerSearchByIdRequest(
            companyId: CompanyID,
            loginUserID: LoginUserID,
            CustomerID: customerID321.toString())));
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchQuotationScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _QuotationBloc.add(SearchQuotationListByNumberCallEvent(
            _searchDetails.value,
            SearchQuotationListByNumberRequest(
                CompanyId: CompanyID.toString(),
                QuotationNo: _searchDetails.quotationNo)));
      }
    });
  }

  ///updates data of inquiry list
  void _onInquiryListByNumberCallSuccess(
      SearchQuotationListByNumberCallResponseState state) {
    _quotationListResponse = state.response;
  }

  _launchURL(String pdfURL) async {
    var url123 = pdfURL;
    if (await canLaunch(url123)) {
      await launch(url123);
    } else {
      throw 'Could not launch $url123';
    }
  }

  void _onGenerateQuotationPDFCallSuccess(
      QuotationPDFGenerateResponseState state) {
    String a = state.response.details[0].column1.toString();
    var b = state.response.details[0].column1.toString().split("QT");

    var c = [];

    if (b[1].toString().contains("/")) {
      c = b[1].toString().split("/");

      String FinalURL =
          b[0].toString() + "QT" + c[0].toString() + "-" + c[1].toString();
      print("Revisesds" +
          " URL :" +
          a.toString() +
          " QTNO : " +
          b[0].toString() +
          "\n" +
          b[1].toString() +
          "\n" +
          c[0].toString() +
          "\n" +
          c[1].toString() +
          "\n" +
          FinalURL.toString());
      _launchURL(FinalURL);
    } else {
      _launchURL(state.response.details[0].column1.toString());
    }

    // _launchURL(state.response.details[0].column1.toString());
  }

  Future<void> _showMyDialog(
      QuotationDetails model, String GenerateMode) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Please wait..! '),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: _offlineLoggedInData.details[0].serialKey
                                  .toUpperCase() ==
                              "DHSI-09RY-BATH-ACCU" ||
                          _offlineLoggedInData.details[0].serialKey
                                  .toUpperCase() ==
                              "TEST-0000-ACBF-0214"
                      ? ACCURABATHGenerateQTWithoutDiscount(
                          model, context123, GenerateMode)
                      : GenerateQT(model, context123, GenerateMode),
                )
                //GetCircular123(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialogAccurabathWithDiscount(
      QuotationDetails model, String GenerateMode) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Please wait..! '),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: ACCURABATHGenerateQTWithDiscount(
                      model, context123, GenerateMode),
                )
                //GetCircular123(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEmailMyDialog(QuotationDetails model) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Sending Email ...!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQTSendEmail(model, context123),
                )
                //GetCircular123(),
              ],
            ),
          ),
        );
      },
    );
  }

  void getStatusCodeOfSendEmail(String URLOFQTSendEmail) async {
    /*

    while (isRedirect) {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(url))
          ..followRedirects = false
          ..headers['cookie'] = 'security=true';
    print(request.headers);
    final response = await client.send(request);

    if (response.statusCode == HttpStatus.movedTemporarily) {
      isRedirect = response.isRedirect;
      url = response.headers['location'];
      // final receivedCookies = response.headers['set-cookie'];
    } else if (response.statusCode == HttpStatus.ok) {
      print(await response.stream.join(''));
    }
  }
    */

    while (isRedirect) {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(URLOFQTSendEmail))
        ..followRedirects = false
        ..headers['cookie'] = 'security=true';
      print(request.headers);
      final response = await client.send(request);

      if (response.statusCode == HttpStatus.movedTemporarily) {
        isRedirect = response.isRedirect;

        if (response.statusCode == 200) {
          // isRedirect = response.isRedirect;
          print("akjshds" + 'exists');
          break;
        } else {
          print("akjshds" + 'not exists');
        }
        // url = response.headers['location'];
        // final receivedCookies = response.headers['set-cookie'];
      } else if (response.statusCode == HttpStatus.ok) {
        print(await response.stream.join(''));
      }
    }

    /*final client = http.Client();
    final request = http.Request('GET', Uri.parse(URLOFQTSendEmail))
      ..followRedirects = false;
    print(request.headers);
    final response = await client.send(request);

    if (response.statusCode == 200) {
      // isRedirect = response.isRedirect;
      print("akjshds" + 'exists');
    } else {
      print("akjshds" + 'not exists');
    }*/
  }

  GenerateQT(
      QuotationDetails model, BuildContext context123, String GenerateMode1) {
    return Center(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  //SiteURL +
                  //                           "/Quotation.aspx?MobilePdf=yes&userid=" +
                  //                           LoginUserID +
                  //                           "&password=" +
                  //                           Password +
                  //                           "&pQuotID=" +
                  //                           model.pkID.toString()
                  //                        webView.loadUrl(SiteURL+"/Quotation.aspx?MobilePdf=yes&userid="+userName123+"&password="+UserPassword+"&pQuotID="+contactListFiltered.get(position).getPkID() + "");
                  // initialUrlRequest:urlRequest == null ? URLRequest(url: Uri.parse("http://122.169.111.101:3346/Default.aspx")) :urlRequest ,
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "/Quotation.aspx?MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&pQuotID=" +
                          model.pkID.toString())),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );

                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      isLoading = false;
                    });
                    print("OnLoad" +
                        "On Loading Complted" +
                        onWebLoadingStop.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    //Navigator.pop(context123);

                    String pageTitle = "";

                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;

                        print("sdf567" + pageTitle);

                        if (pageTitle != "E-Office-Desk") {
                          Navigator.pop(context123);
                          showCommonDialogWithSingleOption(
                              context, "Quotation Generated Successfully ",
                              onTapOfPositiveButton: () {
                            Navigator.of(context).pop();
                            _QuotationBloc.add(QuotationPDFGenerateCallEvent(
                                QuotationPDFGenerateRequest(
                                    CompanyId: CompanyID.toString(),
                                    QuotationNo: model.quotationNo)));
                            //Navigator.pop(context);
                          });
                        } else {
                          Navigator.pop(context123);
                          showCommonDialogWithSingleOption(
                              context, "Please Try Again !");
                        }
                      });
                    });

                    /*showCommonDialogWithSingleOption(
                                context, "Email Sent Successfully ",
                                onTapOfPositiveButton: () {
                              //Navigator.pop(context);
                              navigateTo(context, HomeScreen.routeName,
                                  clearAllStack: true);
                            });*/
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;
                      // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                    }

                    //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )
          ],
        ),
      ),
    );
  }

  ACCURABATHGenerateQTWithoutDiscount(
      QuotationDetails model, BuildContext context123, String GenerateMode1) {
    return Center(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  //                        webView.loadUrl(SiteURL+"/Quotation.aspx?MobilePdf=yes&userid="+userName123+"&password="+UserPassword+"&pQuotID="+contactListFiltered.get(position).getPkID() + "");
                  // initialUrlRequest:urlRequest == null ? URLRequest(url: Uri.parse("http://122.169.111.101:3346/Default.aspx")) :urlRequest ,
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "/Quotation.aspx?QuotationType=nondis&PrintHeader=yes&MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&pQuotID=" +
                          model.pkID.toString())),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );

                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      isLoading = false;
                    });
                    print("OnLoad" +
                        "On Loading Complted" +
                        onWebLoadingStop.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    //Navigator.pop(context123);

                    String pageTitle = "";

                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;

                        print("sdf567" + pageTitle);

                        if (pageTitle != "E-Office-Desk") {
                          Navigator.pop(context123);
                          showCommonDialogWithSingleOption(
                              context, "Quotation Generated Successfully ",
                              onTapOfPositiveButton: () {
                            Navigator.of(context).pop();
                            _QuotationBloc.add(QuotationPDFGenerateCallEvent(
                                QuotationPDFGenerateRequest(
                                    CompanyId: CompanyID.toString(),
                                    QuotationNo: model.quotationNo)));
                            //Navigator.pop(context);
                          });
                        } else {
                          Navigator.pop(context123);
                          showCommonDialogWithSingleOption(
                              context, "Please Try Again !");
                        }
                      });
                    });

                    /*showCommonDialogWithSingleOption(
                                context, "Email Sent Successfully ",
                                onTapOfPositiveButton: () {
                              //Navigator.pop(context);
                              navigateTo(context, HomeScreen.routeName,
                                  clearAllStack: true);
                            });*/
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;
                      // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                    }

                    //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )
          ],
        ),
      ),
    );
  }

  ACCURABATHGenerateQTWithDiscount(
      QuotationDetails model, BuildContext context123, String GenerateMode1) {
    return Center(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  //                        webView.loadUrl(SiteURL+"/Quotation.aspx?MobilePdf=yes&userid="+userName123+"&password="+UserPassword+"&pQuotID="+contactListFiltered.get(position).getPkID() + "");
                  // initialUrlRequest:urlRequest == null ? URLRequest(url: Uri.parse("http://122.169.111.101:3346/Default.aspx")) :urlRequest ,
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "/Quotation.aspx?QuotationType=dis&PrintHeader=yes&MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&pQuotID=" +
                          model.pkID.toString())),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );

                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      isLoading = false;
                    });
                    print("OnLoad" +
                        "On Loading Complted" +
                        onWebLoadingStop.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    //Navigator.pop(context123);

                    String pageTitle = "";

                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;

                        print("sdf567" + pageTitle);

                        if (pageTitle != "E-Office-Desk") {
                          Navigator.pop(context123);
                          showCommonDialogWithSingleOption(
                              context, "Quotation Generated Successfully ",
                              onTapOfPositiveButton: () {
                            Navigator.of(context).pop();
                            _QuotationBloc.add(QuotationPDFGenerateCallEvent(
                                QuotationPDFGenerateRequest(
                                    CompanyId: CompanyID.toString(),
                                    QuotationNo: model.quotationNo)));
                            //Navigator.pop(context);
                          });
                        } else {
                          Navigator.pop(context123);
                          showCommonDialogWithSingleOption(
                              context, "Please Try Again !");
                        }
                      });
                    });

                    /*showCommonDialogWithSingleOption(
                                context, "Email Sent Successfully ",
                                onTapOfPositiveButton: () {
                              //Navigator.pop(context);
                              navigateTo(context, HomeScreen.routeName,
                                  clearAllStack: true);
                            });*/
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;
                      // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                    }

                    //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )
          ],
        ),
      ),
    );
  }

  OneTimeGenerateQT(
      QuotationDetails model, BuildContext context123, String GenerateMode) {
    return Center(
      child: Container(
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            Container(
              height: 5,
              width: 5,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  //                        webView.loadUrl(SiteURL+"/Quotation.aspx?MobilePdf=yes&userid="+userName123+"&password="+UserPassword+"&pQuotID="+contactListFiltered.get(position).getPkID() + "");
                  // initialUrlRequest:urlRequest == null ? URLRequest(url: Uri.parse("http://122.169.111.101:3346/Default.aspx")) :urlRequest ,
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "/Quotation.aspx?MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&pQuotID=" +
                          model.pkID.toString())),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    baseBloc.emit(ShowProgressIndicatorState(true));

                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );

                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      isLoading = false;
                    });
                    print("OnLoad" +
                        "On Loading Complted" +
                        onWebLoadingStop.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    //Navigator.pop(context123);

                    String pageTitle = "";

                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;

                        print("sdf567" + pageTitle);
                      });
                    });
                    baseBloc.emit(ShowProgressIndicatorState(false));

                    /*showCommonDialogWithSingleOption(
                                context, "Email Sent Successfully ",
                                onTapOfPositiveButton: () {
                              //Navigator.pop(context);
                              navigateTo(context, HomeScreen.routeName,
                                  clearAllStack: true);
                            });*/
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;
                      // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                    }

                    //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
            ),
            /*Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )*/
          ],
        ),
      ),
    );
  }

  OneTimeGenerateQTWithDiscount(
      QuotationDetails model, BuildContext context123, String GenerateMode) {
    return Center(
      child: Container(
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            Container(
              height: 5,
              width: 5,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  //                        webView.loadUrl(SiteURL+"/Quotation.aspx?MobilePdf=yes&userid="+userName123+"&password="+UserPassword+"&pQuotID="+contactListFiltered.get(position).getPkID() + "");
                  // initialUrlRequest:urlRequest == null ? URLRequest(url: Uri.parse("http://122.169.111.101:3346/Default.aspx")) :urlRequest ,
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "/Quotation.aspx?QuotationType=dis&PrintHeader=yes&MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&pQuotID=" +
                          model.pkID.toString())),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    baseBloc.emit(ShowProgressIndicatorState(true));

                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );

                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    setState(() {
                      onWebLoadingStop = true;
                      isLoading = false;
                    });
                    print("OnLoad" +
                        "On Loading Complted" +
                        onWebLoadingStop.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    //Navigator.pop(context123);

                    String pageTitle = "";

                    controller.getTitle().then((value) {
                      setState(() {
                        pageTitle = value;

                        print("sdf567" + pageTitle);
                      });
                    });
                    baseBloc.emit(ShowProgressIndicatorState(false));

                    /*showCommonDialogWithSingleOption(
                                context, "Email Sent Successfully ",
                                onTapOfPositiveButton: () {
                              //Navigator.pop(context);
                              navigateTo(context, HomeScreen.routeName,
                                  clearAllStack: true);
                            });*/
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;
                      // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                    }

                    //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },
                  onPageCommitVisible: (controller, url) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
            ),
            /*Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )*/
          ],
        ),
      ),
    );
  }

  GenerateQTSendEmail(QuotationDetails model, BuildContext context123) {
    return Center(
      child: Container(
        child: Stack(
          children: [
            Container(
              height: 20,
              width: 20,
              child: Visibility(
                visible: true,
                child: InAppWebView(
                  /*
                    Uri.parse(SiteURL +
                        "/Quotation.aspx?MobilePdf=yes&userid=" +
                        LoginUserID +
                        "&password=" +
                        Password +
                        "&pQuotID=" +
                        model.pkID.toString()))*/
                  //SendEmail Web Method : https://eofficedesk.sharvayainfotech.in/Quotation.aspx?MobilePdf=yes&userid=admin&password=sioffice#000&pQuotID=241040&CustomerID=20944
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(SiteURL +
                          "Quotation.aspx?MobilePdf=yes&userid=" +
                          LoginUserID +
                          "&password=" +
                          Password +
                          "&pQuotID=" +
                          model.pkID.toString() +
                          "&CustomerID=" +
                          model.customerID.toString())),

                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,

                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },

                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunch(url)) {
                        // Launch the App
                        await launch(
                          url,
                        );

                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();

                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                    Navigator.of(context).pop();
                    showCommonDialogWithSingleOption(
                        context, "Send Email Successfully ",
                        onTapOfPositiveButton: () {
                      Navigator.of(context).pop();
                      // openEmailApp(context);
                      //Navigator.pop(context);
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                    isLoading = false;
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                      this.prgresss = progress;
                      // _QuotationBloc.add(QuotationPDFGenerateCallEvent(QuotationPDFGenerateRequest(CompanyId: CompanyID.toString(),QuotationNo: model.quotationNo)));
                    }

                    //  EasyLoading.showProgress(progress / 100, status: 'Loading...');

                    setState(() {
                      this.progress = progress / 100;
                      this.prgresss = progress;

                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print("LoadWeb" + consoleMessage.message.toString());
                  },
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: Lottie.asset('assets/lang/sample_kishan_two.json',
                  width: 100, height: 100),
            )
          ],
        ),
      ),
    );
  }

  void openEmailApp(BuildContext context325146) async {
    var result = await OpenMailApp.openMailApp();

    // If no mail apps found, show error
    if (!result.didOpen && !result.canOpen) {
      showCommonDialogWithSingleOption(
          context, "No Any Email App Found in your Phone ",
          onTapOfPositiveButton: () {
        Navigator.of(context325146).pop();
      });
      // iOS: if multiple mail apps found, show dialog to select.
      // There is no native intent/default app system in iOS so
      // you have to do it yourself.
    } else if (!result.didOpen && result.canOpen) {
      showDialog(
        context: context,
        builder: (_) {
          return MailAppPickerDialog(
            mailApps: result.options,
          );
        },
      );
    }
  }

  GetCircular123() {
    /*  if(webViewController!=null)
      {
        webViewController.getProgress().whenComplete(() async =>  {
          valuee1 = await webViewController.getProgress(),
          print("PAgeLoaded" + valuee1.toString())
        });
      }*/

    print("DFDFDF" + "sdfsdssdsffs");
  }

  void _onTaptoEditQuotation(QuotationDetails model) async {
    await _onTapOfDeleteALLProduct();

    navigateTo(context, QuotationAddEditScreen.routeName,
            arguments: AddUpdateQuotationScreenArguments(model))
        .then((value) {
      _QuotationBloc.add(QuotationListCallEvent(
          1,
          QuotationListApiRequest(
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID,
              pkId: "")));
    });
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLQuotationProduct();
    await OfflineDbHelper.getInstance().deleteALLOldQuotationProduct();
    await OfflineDbHelper.getInstance().deleteALLQuotationOtherCharge();
  }

  void _OnDeleteQuotationRequest(QuotationDetails model) {
    showCommonDialogWithTwoOptions(
        context, "Are you sure you want to delete this Quotation ?",
        negativeButtonTitle: "No",
        positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
      Navigator.of(context).pop();
      //_collapse();
      _QuotationBloc.add(QuotationDeleteRequestCallEvent(context, model.pkID,
          QuotationDeleteRequest(CompanyID: CompanyID.toString())));
    });
  }

  void _OnDeleteQuotationSucessResponse(
      QuotationDeleteCallResponseState state) {
    navigateTo(state.context, QuotationListScreen.routeName,
        clearAllStack: true);
  }

  void _ONOnlyCustomerDetails(
      SearchCustomerListByNumberCallResponseState state) {
    for (int i = 0; i < state.response.details.length; i++) {
      print("CustomerDetailsw" +
          "CustomerName : " +
          state.response.details[i].customerName +
          " Customer ID : " +
          state.response.details[i].customerID.toString());
    }

    customerDetails = CustomerDetails();
    customerDetails.customerName = state.response.details[0].customerName;
    customerDetails.customerType = state.response.details[0].customerType;
    customerDetails.customerSourceName =
        state.response.details[0].customerSourceName;
    customerDetails.contactNo1 = state.response.details[0].contactNo1;
    customerDetails.emailAddress = state.response.details[0].emailAddress;
    customerDetails.address = state.response.details[0].address;
    customerDetails.area = state.response.details[0].area;
    customerDetails.pinCode = state.response.details[0].pinCode;
    customerDetails.countryName = state.response.details[0].countryName;
    customerDetails.stateName = state.response.details[0].stateName;
    customerDetails.cityName = state.response.details[0].cityName;
    customerDetails.cityName = state.response.details[0].cityName;

    showcustomdialog(
      context1: context,
      customerDetails123: customerDetails,
    );
  }

  showcustomdialog({
    BuildContext context1,
    CustomerDetails customerDetails123,
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
                    "Customer Details",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              customerDetails123.customerName,
                              style: TextStyle(color: colorBlack),
                            ),
                          )
                        ],
                      ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Category  ",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                        .customerType
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Source",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .customerSourceName ==
                                                            "--Not Available--"
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .customerSourceName,
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("Contact No1.",
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Color(
                                                              label_color),
                                                          fontSize:
                                                              _fontSize_Label,
                                                          letterSpacing: .3)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      customerDetails123
                                                                  .contactNo1 ==
                                                              ""
                                                          ? "N/A"
                                                          : customerDetails123
                                                              .contactNo1,
                                                      style: TextStyle(
                                                          color: Color(
                                                              title_color),
                                                          fontSize:
                                                              _fontSize_Title,
                                                          letterSpacing: .3))
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () async {
                                                          MakeCall.callto(
                                                              customerDetails123
                                                                  .contactNo1);
                                                        },
                                                        child: Container(
                                                          child: Image.asset(
                                                            PHONE_CALL_IMAGE,
                                                            width: 32,
                                                            height: 32,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          ShareMsg.msg(
                                                              context,
                                                              customerDetails123
                                                                  .contactNo1);
                                                        },
                                                        child: Container(
                                                          child: Image.asset(
                                                            WHATSAPP_IMAGE,
                                                            width: 32,
                                                            height: 32,
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: sizeboxsize,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Email",
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Color(label_color),
                                                    fontSize: _fontSize_Label,
                                                    letterSpacing: .3)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                customerDetails123
                                                            .emailAddress ==
                                                        ""
                                                    ? "N/A"
                                                    : customerDetails123
                                                        .emailAddress,
                                                style: TextStyle(
                                                    color: Color(title_color),
                                                    fontSize: _fontSize_Title,
                                                    letterSpacing: .3)),
                                          ],
                                        )
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Address",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .address ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .address,
                                                    style:
                                                        TextStyle(
                                                            color: Color(
                                                                title_color),
                                                            fontSize:
                                                                _fontSize_Title,
                                                            letterSpacing: .3)),
                                              ],
                                            ))
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Area",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123.area ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .area,
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Pin-Code",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .pinCode ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .pinCode,
                                                    style:
                                                        TextStyle(
                                                            color: Color(
                                                                title_color),
                                                            fontSize:
                                                                _fontSize_Title,
                                                            letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Country",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .countryName
                                                                .toString() ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .countryName
                                                            .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("State",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123.stateName
                                                                .toString() ==
                                                            ""
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .stateName
                                                            .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("City",
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color:
                                                            Color(label_color),
                                                        fontSize:
                                                            _fontSize_Label,
                                                        letterSpacing: .3)),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    customerDetails123
                                                                .cityName ==
                                                            null
                                                        ? "N/A"
                                                        : customerDetails123
                                                            .cityName,
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            )),
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context1);
                                      },
                                      child: Center(
                                          child: Text(
                                        "Close",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: colorPrimary,
                                            fontWeight: FontWeight.bold),
                                      )))
                                ],
                              ),
                            ),
                          ],
                        ))),
                  ],
                )),
          ],
        );
      },
    );
  }

  showcustomdialogSendEmail({
    BuildContext context1,
    String Email,
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
                    "Send Email",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Email To.",
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
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller: EmailTO,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter email To",
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
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Email BCC",
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
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller: EmailBCC,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter email BCC",
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
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () {
                              if (EmailTO.text != "") {
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Email TO is Required!",
                                    positiveButtonTitle: "OK");
                              }
                            },
                            "YES",
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () {
                              Navigator.pop(context);
                            },
                            "NO",
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgQuotation") {
        _QuotationBloc.add(UserMenuRightsRequestEvent(
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

  void _OnDeleteAllGenericCharges(
      DeleteAllGenericAddditionalChargesState state) {
    print("_OnDeleteAllGenericCharges" +
        " DeleteAllGenericFromDB : " +
        state.response);
  }
}
