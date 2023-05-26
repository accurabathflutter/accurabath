import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/salesorder/salesorder_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/SO_Export/so_export_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sales_order_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sales_order_generate_pdf_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/salesorder_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/search_salesorder_list_by_number_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/shipment/so_shipment_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/salesorder_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/search_salesorder_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/shipment/so_shipment_list_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/sales_order_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salesorder/search_salesorder_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../home_screen.dart';

class SalesOrderListScreen extends BaseStatefulWidget {
  static const routeName = '/SalesOrderListScreen';

  @override
  _SalesOrderListScreenState createState() => _SalesOrderListScreenState();
}

enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}

class _SalesOrderListScreenState extends BaseState<SalesOrderListScreen>
    with BasicScreen, WidgetsBindingObserver {
  SalesOrderBloc _SalesOrderBloc;
  int _pageNo = 0;
  SalesOrderListResponse _SalesOrderListResponse;
  bool expanded = true;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 10;
  int label_color = 0xff0066b3; //0x66666666;
  int title_color = 0xff0066b3;
  SearchDetails _searchDetails;
  int CompanyID = 0;
  String LoginUserID = "";
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  MenuRightsResponse _menuRightsResponse;

  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  String SiteURL = "";
  String Password = "";
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
  final urlController = TextEditingController();
  String url = "";
  bool isLoading = true;
  int prgresss = 0;
  double progress = 0;
  CustomerDetails customerDetails = CustomerDetails();
  bool onWebLoadingStop = true;

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
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;

    Password =
        _offlineLoggedInData.details[0].userPassword.replaceAll("#", "%23");
    print("PWDf" + Password.toString());
    _SalesOrderBloc = SalesOrderBloc(baseBloc);

    _SalesOrderBloc.add(PaymentScheduleDeleteAllItemEvent());
    getUserRights(_menuRightsResponse);

    baseBloc.emit(ShowProgressIndicatorState(true));
    _SalesOrderBloc.add(DeleteGenericAddditionalChargesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _SalesOrderBloc
        ..add(SalesOrderListCallEvent(
            _pageNo + 1,
            SalesOrderListApiRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID))),
      child: BlocConsumer<SalesOrderBloc, SalesOrderStates>(
        builder: (BuildContext context, SalesOrderStates state) {
          if (state is SalesOrderListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is SearchSalesOrderListByNumberCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }
          if (state is PaymentScheduleDeleteAllResponseState) {
            _OnDeleteAllPaymentScheduleTable(state);
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
          if (currentState is SalesOrderListCallResponseState ||
              currentState is SearchSalesOrderListByNumberCallResponseState ||
              currentState is PaymentScheduleDeleteAllResponseState ||
              currentState is UserMenuRightsResponseState ||
              currentState is DeleteAllGenericAddditionalChargesState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, SalesOrderStates state) {
          if (state is SalesOrderPDFGenerateResponseState) {
            _onGenerateQuotationPDFCallSuccess(state);
          }
          if (state is SearchCustomerListByNumberCallResponseState) {
            _ONOnlyCustomerDetails(state);
          }

          if (state is SalesOrderDeleteResponseState) {
            _onDeleteSalesOrderResponse(state);
          }

          if (state is SOShipmentlistResponseState) {
            _onGetShipmentDetails(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesOrderPDFGenerateResponseState ||
              currentState is SearchCustomerListByNumberCallResponseState ||
              currentState is SalesOrderDeleteResponseState ||
              currentState is SOShipmentlistResponseState) {
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
          title: Text('SalesOrder List'),
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
                    _SalesOrderBloc.add(SalesOrderListCallEvent(
                        1,
                        SalesOrderListApiRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID)));
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
                onPressed: () {
                  // Add your onPressed code here!

                  navigateTo(context, SaleOrderNewAddEditScreen.routeName);
                },
                child: const Icon(Icons.add),
                backgroundColor: colorPrimary,
              )
            : Container(),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: LoginUserID),
      ),
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_SalesOrderListResponse == null) {
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
          _SalesOrderListResponse.details.length != 0
              ? OneTimeGenerateSO(
                  _SalesOrderListResponse.details[0], context, "new")
              : Container(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _buildInquiryListItem(index);
              },
              shrinkWrap: true,
              itemCount: _SalesOrderListResponse.details.length,
            ),
          ),
        ],
      ),
    );
  }

  ///builds row item view of inquiry list
  Widget _buildInquiryListItem(int index) {
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
  void _onInquiryListCallSuccess(SalesOrderListCallResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _searchDetails = null;
        _SalesOrderListResponse = state.response;
      } else {
        _SalesOrderListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
    _SalesOrderBloc.add(PaymentScheduleDeleteAllItemEvent());
  }

  ///checks if already all records are arrive or not
  ///calls api with new page
  void _onInquiryListPagination() {
    _SalesOrderBloc.add(SalesOrderListCallEvent(
        _pageNo + 1,
        SalesOrderListApiRequest(
            CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
  }

  ExpantionCustomer(BuildContext context, int index) {
    SalesOrderDetails model = _SalesOrderListResponse.details[index];

    return Container(
      padding: EdgeInsets.all(15),
      child: ExpansionTileCard(
        initialElevation: 5.0,
        elevation: 5.0,
        elevationCurve: Curves.easeInOut,
        shadowColor: Color(0xFF504F4F),
        baseColor: Color(0xFFFCFCFC),
        expandedColor: colorTileBG,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
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
                model.orderNo,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                          ]),
                    ),
                    Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                print("jdlfdjf" +
                                    SiteURL +
                                    "/Quotation.aspx?MobilePdf=yes&userid=" +
                                    LoginUserID +
                                    "&password=" +
                                    Password +
                                    "&pQuotID=" +
                                    model.pkID.toString());

                                String URLPDFF = SiteURL +
                                    "/Quotation.aspx?MobilePdf=yes&userid=" +
                                    LoginUserID +
                                    "&password=" +
                                    Password +
                                    "&pQuotID=" +
                                    model.pkID.toString();
                                await _showMyDialog(model);
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
                                        Icons.picture_as_pdf_rounded,
                                        size: 24,
                                        color: colorPrimary,
                                      )),
                                    ),
                                  ),
                                  Text("SO",
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
                                print("jdlfdjf" +
                                    SiteURL +
                                    "/Quotation.aspx?MobilePdf=yes&userid=" +
                                    LoginUserID +
                                    "&password=" +
                                    Password +
                                    "&pQuotID=" +
                                    model.pkID.toString());

                                String URLPDFF = SiteURL +
                                    "/Quotation.aspx?MobilePdf=yes&userid=" +
                                    LoginUserID +
                                    "&password=" +
                                    Password +
                                    "&pQuotID=" +
                                    model.pkID.toString();
                                await _showMyDialogForPI(model);
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
                                      /*decoration: const BoxDecoration(
                                    color: colorPrimary,
                                    shape: BoxShape.circle),*/
                                      child: Center(
                                          child: Icon(
                                        Icons.picture_as_pdf_rounded,
                                        size: 24,
                                        color: colorPrimary,
                                      )),
                                    ),
                                  ),
                                  Text("PI",
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
                            Visibility(
                              visible: true,
                              child: GestureDetector(
                                onTap: () async {
                                  String sendemailreq = SiteURL +
                                      "SalesOrder.aspx?MobilePdf=yes&userid=" +
                                      LoginUserID +
                                      "&password=" +
                                      Password +
                                      "&pQuotID=" +
                                      model.pkID.toString() +
                                      "&CustomerID=" +
                                      model.customerID.toString() +
                                      "&pageType=so";

                                  print("SO_Email" + sendemailreq);

                                  print("customermail" +
                                      model.emailAddress.toString());

                                  if (model.emailAddress.toString() != "") {
                                    _showEmailSOMyDialog(model);
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        child: Center(
                                          child: Icon(
                                            Icons.email,
                                            size: 24,
                                            color: colorPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text("SO",
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
                                String sendemailreq = SiteURL +
                                    "SalesOrder.aspx?MobilePdf=yes&userid=" +
                                    LoginUserID +
                                    "&password=" +
                                    Password +
                                    "&pQuotID=" +
                                    model.pkID.toString() +
                                    "&CustomerID=" +
                                    model.customerID.toString() +
                                    "&pageType=pro";

                                print("PI_Email" + sendemailreq);
                                // _showEmailPIMyDialog(model);

                                if (model.emailAddress.toString() != "") {
                                  _showEmailPIMyDialog(model);
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
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      child: Center(
                                          child: Icon(
                                        Icons.email,
                                        size: 24,
                                        color: colorPrimary,
                                      )),
                                    ),
                                  ),
                                  Text("PI",
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
                    Visibility(
                      visible: false,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      //await _makePhoneCall(model.contactNo1);
                                      MakeCall.callto(model.contactNo1);
                                    },
                                    child: Container(
                                      child: Image.asset(
                                        PHONE_CALL_IMAGE,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      ShareMsg.msg(context, model.contactNo1);
                                    },
                                    child: Container(
                                      child: Image.asset(
                                        WHATSAPP_IMAGE,
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      FetchCustomerDetails(model.customerID);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                          color: colorPrimary,
                                          shape: BoxShape.circle),
                                      child: Center(
                                          child: Icon(
                                        Icons.account_box,
                                        size: 24,
                                        color: colorWhite,
                                      )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                          ),
                          Container(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    print("jdlfdjf" +
                                        SiteURL +
                                        "/Quotation.aspx?MobilePdf=yes&userid=" +
                                        LoginUserID +
                                        "&password=" +
                                        Password +
                                        "&pQuotID=" +
                                        model.pkID.toString());

                                    String URLPDFF = SiteURL +
                                        "/Quotation.aspx?MobilePdf=yes&userid=" +
                                        LoginUserID +
                                        "&password=" +
                                        Password +
                                        "&pQuotID=" +
                                        model.pkID.toString();

                                    await _showMyDialog(model);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          PDF_ICON,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "SO",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    print("jdlfdjf" +
                                        SiteURL +
                                        "/Quotation.aspx?MobilePdf=yes&userid=" +
                                        LoginUserID +
                                        "&password=" +
                                        Password +
                                        "&pQuotID=" +
                                        model.pkID.toString());

                                    String URLPDFF = SiteURL +
                                        "/Quotation.aspx?MobilePdf=yes&userid=" +
                                        LoginUserID +
                                        "&password=" +
                                        Password +
                                        "&pQuotID=" +
                                        model.pkID.toString();

                                    await _showMyDialogForPI(model);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          PDF_ICON,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "PI",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Visibility(
                                  visible: true,
                                  child: GestureDetector(
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
                                      _showEmailSOMyDialog(model);
                                      /*
                                  EmailTO.text = model.emailAddress;
                                  showcustomdialogSendEmail(
                                      context1: context,
                                      Email: model.emailAddress)*/
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                              color: colorPrimary,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            Icons.email,
                                            size: 24,
                                            color: colorWhite,
                                          )),
                                        ),
                                        Container(
                                          child: Text(
                                            "SO",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Visibility(
                                  visible: true,
                                  child: GestureDetector(
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
                                      _showEmailPIMyDialog(model);
                                      /*
                                  EmailTO.text = model.emailAddress;
                                  showcustomdialogSendEmail(
                                      context1: context,
                                      Email: model.emailAddress)*/
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                              color: colorPrimary,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            Icons.email,
                                            size: 24,
                                            color: colorWhite,
                                          )),
                                        ),
                                        Container(
                                          child: Text(
                                            "PI",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                                        Text("OrderNo",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: colorCardBG,
                                              fontSize: 7,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                          model.orderNo.toString() == ""
                                              ? "Not Available"
                                              : model.orderNo
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.calendar_today_outlined,
                                          color: colorCardBG,
                                        ),
                                        Text("Order",
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
                                          model.orderDate.getFormattedDate(
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
                            left: 12, right: 10, top: 5, bottom: 5),
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
                                        Text("Qt.No",
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
                                          model.quotationNo.toString() == ""
                                              ? "Not Available"
                                              : model.quotationNo
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.dns_rounded,
                                          color: colorCardBG,
                                        ),
                                        Text("status",
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
                                          model.approvalStatus.toString() == ""
                                              ? "Not Available"
                                              : model.approvalStatus.toString(),
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
                            left: 12, right: 10, top: 5, bottom: 5),
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
                                        Text("Amount",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: colorCardBG,
                                              fontSize: 7,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                          model.basicAmt.toString() == ""
                                              ? "Not Available"
                                              : model.basicAmt
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
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
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
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Card(
                      color: colorBackGroundGray,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 12, right: 10, top: 5, bottom: 5),
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
                                          Icons.perm_identity_outlined,
                                          color: colorCardBG,
                                        ),
                                        Text("By",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: colorCardBG,
                                              fontSize: 7,
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Flexible(
                                      child: Text(
                                          model
                                              .createdBy, //put your own long text here.
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
                            ]),
                      ),
                    ),
                  ],
                ),
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

                                          _SalesOrderBloc.add(
                                              SOShipmentListRequestEvent(
                                            SOShipmentListRequest(
                                                OrderNo: model.orderNo,
                                                LoginUserID: LoginUserID,
                                                CompanyId:
                                                    CompanyID.toString()),
                                            model,
                                            SOExportListRequest(
                                                OrderNo: model.orderNo,
                                                LoginUserID: LoginUserID,
                                                CompanyId:
                                                    CompanyID.toString()),
                                          ));

                                          /*navigateTo(
                                                    context,
                                                    SaleOrderNewAddEditScreen
                                                        .routeName,
                                                    arguments:
                                                        AddUpdateSalesOrderNewScreenArguments(
                                                            model))
                                                .then((value) {
                                              _SalesOrderBloc.add(
                                                  SalesOrderListCallEvent(
                                                      1,
                                                      SalesOrderListApiRequest(
                                                          CompanyId: CompanyID
                                                              .toString(),
                                                          LoginUserID:
                                                              LoginUserID)));
                                            });*/
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
                                    showCommonDialogWithTwoOptions(context,
                                        "Are you sure you want to delete this SalesOrder ?",
                                        negativeButtonTitle: "No",
                                        positiveButtonTitle: "Yes",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context).pop();
                                      //_collapse();
                                      _SalesOrderBloc.add(
                                          SalesOrderDeleteRequestEvent(
                                              model.pkID.toString(),
                                              SalesOrderDeleteRequest(
                                                  CompanyID:
                                                      CompanyID.toString())));
                                    });
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
        ],
      ),
    );
  }

  void FetchCustomerDetails(int customerID321) {
    _SalesOrderBloc.add(SearchCustomerListByNumberCallEvent(
        "fromDialog",
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
    navigateTo(context, SearchSalesOrderScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;

        print("sjdsfj" + _searchDetails.salesOrderNo.toString());
        _SalesOrderBloc.add(SearchSalesOrderListByNumberCallEvent(
            _searchDetails.value,
            SearchSalesOrderListByNumberRequest(
                CompanyId: CompanyID.toString(),
                OrderNo: _searchDetails.salesOrderNo,
                pkID: "",
                LoginUserID: LoginUserID)));
      }
    });
  }

  ///updates data of inquiry list
  void _onInquiryListByNumberCallSuccess(
      SearchSalesOrderListByNumberCallResponseState state) {
    _SalesOrderListResponse = state.response;
  }

  Future<void> _showMyDialog(SalesOrderDetails model) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Please wait..!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQT(model, context123),
                )
                //GetCircular123(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialogForPI(SalesOrderDetails model) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Please wait..!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GeneratePI(model, context123),
                )
                //GetCircular123(),
              ],
            ),
          ),
        );
      },
    );
  }

  GeneratePI(SalesOrderDetails model, BuildContext context123) {
    print("PerformaLink" +
        SiteURL +
        "/SalesOrder.aspx?MobilePdf=yes&userid=" +
        LoginUserID +
        "&password=" +
        Password +
        "&pQuotID=" +
        model.pkID.toString() +
        "&pageType=pro");
    return Center(
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
                        "/SalesOrder.aspx?MobilePdf=yes&userid=" +
                        LoginUserID +
                        "&password=" +
                        Password +
                        "&pQuotID=" +
                        model.pkID.toString() +
                        "&pageType=pro")),

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
                shouldOverrideUrlLoading: (controller, navigationAction) async {
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

                  String pageTitle = "";

                  controller.getTitle().then((value) {
                    setState(() {
                      pageTitle = value;

                      print("sdf567" + pageTitle);
                    });
                  });

                  showCommonDialogWithSingleOption(
                      context, "Perfoma Invoice Generated Successfully ",
                      onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                    Navigator.of(context123).pop();
                    _SalesOrderBloc.add(SalesOrderPDFGenerateCallEvent(
                        SalesOrderPDFGenerateRequest(
                            CompanyId: CompanyID.toString(),
                            OrderNo: model.orderNo)));
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Lottie.asset('assets/lang/sample_kishan_two.json',
                width: 100, height: 100),
          )
        ],
      ),
    );
  }

  GenerateQT(SalesOrderDetails model, BuildContext context123) {
    print("Servrg" +
        SiteURL +
        "SalesOrder.aspx?MobilePdf=yes&userid=" +
        LoginUserID +
        "&password=" +
        Password +
        "&pQuotID=" +
        model.pkID.toString() +
        "&pageType=so");
    return Center(
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
                        "/SalesOrder.aspx?MobilePdf=yes&userid=" +
                        LoginUserID +
                        "&password=" +
                        Password +
                        "&pQuotID=" +
                        model.pkID.toString() +
                        "&pageType=so")),
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
                shouldOverrideUrlLoading: (controller, navigationAction) async {
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

                  String pageTitle = "";

                  controller.getTitle().then((value) {
                    setState(() {
                      pageTitle = value;

                      print("sdf567" + pageTitle);
                    });
                  });

                  showCommonDialogWithSingleOption(
                      context, "Invoice Generated Successfully ",
                      onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                    Navigator.of(context123).pop();
                    _SalesOrderBloc.add(SalesOrderPDFGenerateCallEvent(
                        SalesOrderPDFGenerateRequest(
                            CompanyId: CompanyID.toString(),
                            OrderNo: model.orderNo)));
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Lottie.asset('assets/lang/sample_kishan_two.json',
                width: 100, height: 100),
          )
        ],
      ),
    );
  }

  void _onGenerateQuotationPDFCallSuccess(
      SalesOrderPDFGenerateResponseState state) {
    _launchURL(state.response.details[0].column1.toString());
  }

  _launchURL(String pdfURL) async {
    var url123 = pdfURL;
    if (await canLaunch(url123)) {
      await launch(url123);
    } else {
      throw 'Could not launch $url123';
    }
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

    if (state.IsFromDialog == "fromDialog") {
      showcustomdialog(
        context1: context,
        customerDetails123: customerDetails,
      );
    }
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

  Future<void> _showEmailSOMyDialog(SalesOrderDetails model) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('SO Send Email '),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQTSendEmailSO(model, context123),
                )
                //GetCircular123(),
              ],
            ),
          ),
          /* actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(90, 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context)
                    .pop(), //  We can return any object from here
                child: Text('Close')),
          ],*/
        );
      },
    );
  }

  GenerateQTSendEmailSO(SalesOrderDetails model, BuildContext context123) {
    return Container(
      height: 50,
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
                        "SalesOrder.aspx?MobilePdf=yes&userid=" +
                        LoginUserID +
                        "&password=" +
                        Password +
                        "&pQuotID=" +
                        model.pkID.toString() +
                        "&CustomerID=" +
                        model.customerID.toString() +
                        "&pageType=so")),

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
                shouldOverrideUrlLoading: (controller, navigationAction) async {
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

                  showCommonDialogWithSingleOption(
                      context, "Sales Order Sent Email Successfully ",
                      onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                    Navigator.of(context123).pop();
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Lottie.asset('assets/lang/sample_kishan_two.json',
                width: 100, height: 100),
          )
        ],
      ),
    );
  }

  Future<void> _showEmailPIMyDialog(SalesOrderDetails model) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('PI Send Email '),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQTSendEmailPI(model, context123),
                )
                //GetCircular123(),
              ],
            ),
          ),
          /* actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(90, 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context)
                    .pop(), //  We can return any object from here
                child: Text('Close')),
          ],*/
        );
      },
    );
  }

  GenerateQTSendEmailPI(SalesOrderDetails model, BuildContext context123) {
    return Container(
      height: 50,
      child: Stack(
        children: [
          Container(
            height: 20,
            width: 20,
            child: Visibility(
              visible: true,
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse(SiteURL +
                        "SalesOrder.aspx?MobilePdf=yes&userid=" +
                        LoginUserID +
                        "&password=" +
                        Password +
                        "&pQuotID=" +
                        model.pkID.toString() +
                        "&CustomerID=" +
                        model.customerID.toString() +
                        "&pageType=pro")),

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
                shouldOverrideUrlLoading: (controller, navigationAction) async {
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

                  showCommonDialogWithSingleOption(
                      context, "Performa Invoice Sent Email Successfully ",
                      onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                    Navigator.of(context123).pop();
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.white,
            child: Lottie.asset('assets/lang/sample_kishan_two.json',
                width: 100, height: 100),
          )
        ],
      ),
    );
  }

  void _OnDeleteAllPaymentScheduleTable(
      PaymentScheduleDeleteAllResponseState state) {
    print("deleteallpayment" + state.response);
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

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgSalesOrder") {
        _SalesOrderBloc.add(UserMenuRightsRequestEvent(
            menuRightsResponse.details[i].menuId.toString(),
            UserMenuRightsRequest(
                MenuID: menuRightsResponse.details[i].menuId.toString(),
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID)));
        break;
      }
    }
  }

  void _onDeleteSalesOrderResponse(SalesOrderDeleteResponseState state) {
    print(
        "SODeleteResponse" + state.salesOrderDeleteResponse.details[0].column1);

    showCommonDialogWithSingleOption(
        context, state.salesOrderDeleteResponse.details[0].column1,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);

      _SalesOrderBloc.add(SalesOrderListCallEvent(
          1,
          SalesOrderListApiRequest(
              CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    });
  }

  OneTimeGenerateSO(
      SalesOrderDetails model, BuildContext context123, String GenerateMode) {
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
                          "/SalesOrder.aspx?MobilePdf=yes&userid=" +
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

  void _OnDeleteAllGenericCharges(
      DeleteAllGenericAddditionalChargesState state) {
    print("_OnDeleteAllGenericCharges" +
        " DeleteAllGenericFromDBSO : " +
        state.response);
  }

  void _onGetShipmentDetails(SOShipmentlistResponseState state) {
    if (state.response.details.isNotEmpty) {
      navigateTo(context, SaleOrderNewAddEditScreen.routeName,
              arguments: AddUpdateSalesOrderNewScreenArguments(
                  state.salesOrderDetails,
                  state.response.details[0],
                  state.soExportListResponse))
          .then((value) {
        _SalesOrderBloc.add(SalesOrderListCallEvent(
            1,
            SalesOrderListApiRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
      });
    } else {
      SOShipmentlistResponseDetails soShipmentlistResponseDetails =
          new SOShipmentlistResponseDetails();
      soShipmentlistResponseDetails.rowNum = 0;
      soShipmentlistResponseDetails.pkID = 0;

      soShipmentlistResponseDetails.orderNo = "";
      soShipmentlistResponseDetails.sCompanyName = "";
      soShipmentlistResponseDetails.sGSTNo = "";
      soShipmentlistResponseDetails.sContactNo = "";
      soShipmentlistResponseDetails.sContactPersonName = "";
      soShipmentlistResponseDetails.sAddress = "";
      soShipmentlistResponseDetails.sArea = "";
      soShipmentlistResponseDetails.sCountryCode = "IND";
      soShipmentlistResponseDetails.countryName = "India";
      soShipmentlistResponseDetails.sCityCode =
          _offlineLoggedInData.details[0].CityCode;
      soShipmentlistResponseDetails.cityName =
          _offlineLoggedInData.details[0].CityName;
      soShipmentlistResponseDetails.sStateCode =
          _offlineLoggedInData.details[0].stateCode;
      soShipmentlistResponseDetails.stateName =
          _offlineLoggedInData.details[0].StateName;
      soShipmentlistResponseDetails.sPincode = "";
      soShipmentlistResponseDetails.updatedBy = "";
      soShipmentlistResponseDetails.updatedDate = "";
      soShipmentlistResponseDetails.customerID = 0;
      soShipmentlistResponseDetails.customerName = "";
      soShipmentlistResponseDetails.employeeID = 0;
      soShipmentlistResponseDetails.employeeName = "";
      soShipmentlistResponseDetails.createdBy = "";
      soShipmentlistResponseDetails.createdDate = "";
      soShipmentlistResponseDetails.createdEmployeeName = "";
      soShipmentlistResponseDetails.companyID = CompanyID;

      navigateTo(context, SaleOrderNewAddEditScreen.routeName,
              arguments: AddUpdateSalesOrderNewScreenArguments(
                  state.salesOrderDetails,
                  soShipmentlistResponseDetails,
                  state.soExportListResponse))
          .then((value) {
        _SalesOrderBloc.add(SalesOrderListCallEvent(
            1,
            SalesOrderListApiRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
      });
    }
  }
}
