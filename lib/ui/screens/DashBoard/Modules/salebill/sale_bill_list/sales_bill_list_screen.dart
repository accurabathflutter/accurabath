import 'dart:collection';
import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:for_practice_the_app/blocs/base/base_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/salesbill/salesbill_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sales_bill_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/headerToDetailsRequest.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sales_bill_generate_pdf_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sales_bill_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_delete_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/search_quotation_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/sales_bill_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/search_sales_bill_search_response.dart';
import 'package:for_practice_the_app/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salebill/sale_bill_list/search_sales_bill_sceen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/sale_bill_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class SalesBillListScreen extends BaseStatefulWidget {
  static const routeName = '/SalesBillListScreen';

  @override
  _SalesBillListScreenState createState() => _SalesBillListScreenState();
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

class _SalesBillListScreenState extends BaseState<SalesBillListScreen>
    with BasicScreen, WidgetsBindingObserver {
  SalesBillBloc _QuotationBloc;
  int _pageNo = 0;
  SalesBillListResponse _quotationListResponse;
  bool expanded = true;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;
  SearchDetails _searchDetails;
  SearchSalesBillListResponseSearchDetails _salesBillListResponseSearchDetails;
  int CompanyID = 0;
  String LoginUserID = "";
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  String SiteURL = "";
  String QTGEN = "";
  bool isLoading = true;
  String Password = "";

  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

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
  bool onWebLoadingStop = true;

  ContextMenu contextMenu;
  URLRequest urlRequest;

  String url = "";
  double progress = 0;
  int prgresss = 0;
  final urlController = TextEditingController();
  CustomerDetails customerDetails = CustomerDetails();

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
    _QuotationBloc = SalesBillBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();

    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    Password = _offlineLoggedInData.details[0].userPassword;

    getUserRights(_menuRightsResponse);

    _QuotationBloc.add(DeleteGenericAddditionalChargesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _QuotationBloc
        ..add(SalesBillListCallEvent(
            _pageNo + 1,
            SalesBillListRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID))),
      child: BlocConsumer<SalesBillBloc, SalesBillStates>(
        builder: (BuildContext context, SalesBillStates state) {
          if (state is SalesBillListCallResponseState) {
            _onInquiryListCallSuccess(state);
          }
          if (state is SalesBillSearchByIDResponseState) {
            _onSearchSalesBillResponse(state);
          }
          /*if (state is SearchQuotationListByNumberCallResponseState) {
            _onInquiryListByNumberCallSuccess(state);
          }*/

          if (state is UserMenuRightsResponseState) {
            _OnMenuRightsSucess(state);
          }

          if (state is DeleteAllGenericAddditionalChargesState) {
            _OnDeleteAllGenericCharges(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is SalesBillListCallResponseState ||
              currentState is SalesBillSearchByIDResponseState ||
              currentState is UserMenuRightsResponseState ||
              currentState is DeleteAllGenericAddditionalChargesState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, SalesBillStates state) {
          if (state is SalesBillPDFGenerateResponseState) {
            _onGenerateSalesBillPDFCallSuccess(state);
          }

          if (state is SearchCustomerListByNumberCallResponseState) {
            _ONOnlyCustomerDetails(state);
          }

          if (state is SBDeleteResponseState) {
            _OnDeleteSBHeaderFromAPI(state);
          }

          if (state is HeaderToDetailsResponseState) {
            _onHeaderpkIDtoDetails(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesBillPDFGenerateResponseState ||
              currentState is SearchCustomerListByNumberCallResponseState ||
              currentState is SBDeleteResponseState ||
              currentState is HeaderToDetailsResponseState) {
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
          title: Text('Sales Bill List'),
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
                    _QuotationBloc
                      ..add(SalesBillListCallEvent(
                          1,
                          SalesBillListRequest(
                              CompanyId: CompanyID.toString(),
                              LoginUserID: LoginUserID)));

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
                        _buildSearchView(),
                        Expanded(child: _buildInquiryList())
                      ],
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

                  navigateTo(context, SalesBillAddEditScreen.routeName,
                      clearAllStack: true);
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
          Text("Search Sales Bill",
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
                      _salesBillListResponseSearchDetails == null
                          ? "Tap to search quotation"
                          : _salesBillListResponseSearchDetails.custoemerName,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _salesBillListResponseSearchDetails == null
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
              ? OneTimeGenerateSO(
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
  void _onInquiryListCallSuccess(SalesBillListCallResponseState state) {
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
    if (_quotationListResponse.details.length <
        _quotationListResponse.totalCount) {
      _QuotationBloc
        ..add(SalesBillListCallEvent(
            _pageNo + 1,
            SalesBillListRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    }
  }

  ExpantionCustomer(BuildContext context, int index) {
    SaleBillDetails model = _quotationListResponse.details[index];

    return Container(
      padding: EdgeInsets.all(15),
      child: ExpansionTileCard(
        initialElevation: 5.0,
        elevation: 5.0,
        elevationCurve: Curves.easeInOut,
        shadowColor: Color(0xFF504F4F),
        baseColor: Color(0xFFFCFCFC),
        expandedColor: Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
        leading: CircleAvatar(
            backgroundColor: Color(0xFF504F4F),
            child: /*Image.asset(IC_USERNAME,height: 25,width: 25,)*/
                Image.network(
              "http://demo.sharvayainfotech.in/images/profile.png",
              height: 35,
              fit: BoxFit.fill,
              width: 35,
            )),
        /* title: Text("Customer",style:TextStyle(fontSize: 12,color: Color(0xFF504F4F),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),
      ),*/
        /* title:  Row(
            children:<Widget>[
              Expanded(
                child: Text(model.customerName,style: TextStyle(
                    color: Colors.black
                ),),
              ),
              Expanded(child:  Text(model.quotationNo,style: TextStyle(
                  color: Colors.black
              ),),)
            ]
        ),*/
        title: Text(
          model.customerName,
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          model.invoiceNo,
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
                    Container(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                //await _makePhoneCall(model.contactNo1);

                                MakeCall.callto(model.createdEmployeeMobile);
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
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () async {
                                ShareMsg.msg(
                                    context, model.createdEmployeeMobile);
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
                              width: 15,
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

                                await _showMyDialog(model);
                              },
                              child: Container(
                                child: Image.asset(
                                  PDF_ICON,
                                  width: 30,
                                  height: 30,
                                ),
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
                                      "SalesBill.aspx?MobilePdf=yes&userid=" +
                                      LoginUserID +
                                      "&password=" +
                                      Password +
                                      "&pQuotID=" +
                                      model.pkID.toString() +
                                      "&CustomerID=" +
                                      model.customerID.toString();

                                  print("sdsds34" + sendemailreq);

                                  if (model.EmailAddress.toString() != "") {
                                    //_showEmailPIMyDialog(model);

                                    _showEmailMyDialog(model);
                                  } else {
                                    showCommonDialogWithSingleOption(context,
                                        "Customer's Email Not Found\nKindly Update Email From Customer Master !",
                                        positiveButtonTitle: "OK",
                                        onTapOfPositiveButton: () {
                                      Navigator.pop(context);
                                    });
                                  }
                                  /*
                                  EmailTO.text = model.emailAddress;
                                  showcustomdialogSendEmail(
                                      context1: context,
                                      Email: model.emailAddress)*/
                                },
                                child: Container(
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
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTitleWithValueView(
                                "Invoice Date",
                                model.invoiceDate.getFormattedDate(
                                        fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                        toFormat: "dd-MM-yyyy") ??
                                    "-"),
                          ),
                          Expanded(
                            child: _buildTitleWithValueView(
                                "Invoice #", model.invoiceNo ?? "-"),
                          ),
                        ]),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          model.inquiryNo != ""
                              ? Expanded(
                                  child: _buildTitleWithValueView(
                                      "Lead #", model.inquiryNo ?? "-"),
                                )
                              : Container(),
                          model.quotationNo != ""
                              ? Expanded(
                                  child: _buildTitleWithValueView(
                                      "Quot.#", model.quotationNo ?? "-"),
                                )
                              : Container(),
                          model.orderNo != ""
                              ? Expanded(
                                  child: _buildTitleWithValueView(
                                      "SO.#", model.orderNo ?? "-"),
                                )
                              : Container(),
                        ]),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(children: [
                      model.supplierRef != ""
                          ? Expanded(
                              child: _buildTitleWithValueView(
                                  "Supplier Ref	", model.supplierRef ?? "-"),
                            )
                          : Container(),
                      model.gSTNO != ""
                          ? Expanded(
                              child: _buildTitleWithValueView(
                                  "GST #", model.gSTNO ?? "-"),
                            )
                          : Container(),
                    ]),
                    model.supplierRef == "" && model.gSTNO == ""
                        ? Container()
                        : SizedBox(
                            height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                          ),
                    Row(children: [
                      Expanded(
                        child: _buildTitleWithValueView(
                            "BasicAmt.", model.basicAmt.toString() ?? "-"),
                      ),
                      Expanded(
                        child: _buildTitleWithValueView("DiscountAmt.",
                            model.discountAmt.toString() ?? "-"),
                      ),
                    ]),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(children: [
                      Expanded(
                        child: _buildTitleWithValueView(
                            "TaxAmt.", model.taxAmt.toString() ?? "-"),
                      ),
                      Expanded(
                        child: _buildTitleWithValueView(
                            "ROffAmt.", model.rOffAmt.toString() ?? "-"),
                      ),
                    ]),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                    Row(children: [
                      Expanded(
                        child: _buildTitleWithValueView(
                            "NetAmt.", model.netAmt.toString() ?? "-"),
                      ),
                      Expanded(
                        child: _buildTitleWithValueView(
                            "Created by.", model.createdBy.toString() ?? "-"),
                      ),
                    ]),
                    SizedBox(
                      height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonHeight: 52.0,
              buttonMinWidth: 90.0,
              children: <Widget>[
                IsEditRights == true
                    ? GestureDetector(
                        onTap: () {
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
                          // SBDeleteRequestEvent
                          //new ExpansionTileCardState().collapse();

                          showCommonDialogWithTwoOptions(context,
                              "Are you sure you want to delete this SalesBill ?",
                              negativeButtonTitle: "No",
                              positiveButtonTitle: "Yes",
                              onTapOfPositiveButton: () {
                            Navigator.of(context).pop();
                            //_collapse();
                            _QuotationBloc.add(SBDeleteRequestEvent(
                                model.pkID.toString(),
                                SBDeleteRequest(
                                    CompanyID: CompanyID.toString())));
                          });
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
              ]),
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

  Future<void> _showEmailMyDialog(SaleBillDetails model) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Send Email'),
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

  GenerateQTSendEmail(SaleBillDetails model, BuildContext context123) {
    return Center(
      child: Container(
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
                          "SalesBill.aspx?MobilePdf=yes&userid=" +
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

                    showCommonDialogWithSingleOption(
                        context, "Invoice Sent Email Successfully ",
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

  void _onTaptoEditQuotation(SaleBillDetails model) {
    _QuotationBloc.add(HeaderToDetailsRequestEvent(
        model.pkID, HeaderToDetailsRequest(CompanyId: CompanyID.toString())));
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  ///navigates to search list screen
  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchSalesBillScreen.routeName).then((value) {
      if (value != null) {
        _salesBillListResponseSearchDetails = value;
        _QuotationBloc.add(SalesBillSearchByIdRequestCallEvent(
            _salesBillListResponseSearchDetails.value,
            SalesBillSearchByIdRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
      }
    });
  }

  ///updates data of inquiry list
  /* void _onInquiryListByNumberCallSuccess(
      SearchQuotationListByNumberCallResponseState state) {
    _quotationListResponse = state.response;
  }*/

  Future<void> _showMyDialog(SaleBillDetails model) async {
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

  GenerateQT(SaleBillDetails model, BuildContext context123) {
    print("DFrrt" +
        SiteURL +
        "/salesbill.aspx?MobilePdf=yes&userid=" +
        LoginUserID +
        "&password=" +
        Password +
        "&pQuotID=" +
        model.pkID.toString());
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
                        "/salesbill.aspx?MobilePdf=yes&userid=" +
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
                      context, "SO Generated Successfully ",
                      onTapOfPositiveButton: () {
                    Navigator.of(context).pop();
                    Navigator.of(context123).pop();
                    _QuotationBloc.add(SalesBillPDFGenerateCallEvent(
                        SalesBillPDFGenerateRequest(
                            CompanyId: CompanyID.toString(),
                            InvoiceNo: model.invoiceNo)));
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

  Future<void> _showMyDialog1(SaleBillDetails model) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context123) {
        return AlertDialog(
          title: Text('Do You want to Generate SaleBill ? '),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: true,
                  child: GenerateQT1(model, context123),
                )
                //GetCircular123(),
              ],
            ),
          ),
          actions: <Widget>[
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
                child: Text('NO')),
            /* prgresss!=100 ? CircularProgressIndicator() :*/ ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(90, 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                  ),
                ),
                onPressed: () => {
                      Navigator.of(context).pop(),
                      _QuotationBloc.add(SalesBillPDFGenerateCallEvent(
                          SalesBillPDFGenerateRequest(
                              CompanyId: CompanyID.toString(),
                              InvoiceNo: model.invoiceNo)))
                    }, //  We can return any object from here
                child: Text('YES'))
          ],
        );
      },
    );
  }

  GenerateQT1(SaleBillDetails model, BuildContext context123) {
    print("DFrrt" +
        SiteURL +
        "/salesbill.aspx?MobilePdf=yes&userid=" +
        LoginUserID +
        "&password=" +
        Password +
        "&pQuotID=" +
        model.pkID.toString());
    return Container(
      height: 200,
      child: Visibility(
        visible: true,
        child: InAppWebView(
          //                        webView.loadUrl(SiteURL+"/Quotation.aspx?MobilePdf=yes&userid="+userName123+"&password="+UserPassword+"&pQuotID="+contactListFiltered.get(position).getPkID() + "");
          // initialUrlRequest:urlRequest == null ? URLRequest(url: Uri.parse("http://122.169.111.101:3346/Default.aspx")) :urlRequest ,
          initialUrlRequest: URLRequest(
              url: Uri.parse(SiteURL +
                  "/salesbill.aspx?MobilePdf=yes&userid=" +
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
          androidOnPermissionRequest: (controller, origin, resources) async {
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
    );
  }

  void _onGenerateSalesBillPDFCallSuccess(
      SalesBillPDFGenerateResponseState state) {
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

  void _onSearchSalesBillResponse(SalesBillSearchByIDResponseState state) {
    _quotationListResponse = state.response;
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLSalesBillProduct();
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

  void getUserRights(MenuRightsResponse menuRightsResponse) {
    for (int i = 0; i < menuRightsResponse.details.length; i++) {
      print("ldsj" + "MaenudNAme : " + menuRightsResponse.details[i].menuName);

      if (menuRightsResponse.details[i].menuName == "pgSalesBill") {
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

  OneTimeGenerateSO(
      SaleBillDetails model, BuildContext context123, String GenerateMode) {
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
                          "/salesbill.aspx?MobilePdf=yes&userid=" +
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
          ],
        ),
      ),
    );
  }

  void _OnDeleteSBHeaderFromAPI(SBDeleteResponseState state) {
    showCommonDialogWithSingleOption(context, state.response.details[0].column1,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);

      _QuotationBloc.add(SalesBillListCallEvent(
          1,
          SalesBillListRequest(
              CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    });
  }

  void _OnDeleteAllGenericCharges(
      DeleteAllGenericAddditionalChargesState state) {
    print("_OnDeleteAllGenericCharges" +
        " DeleteAllGenericFromDBSB : " +
        state.response);
  }

  void _onHeaderpkIDtoDetails(HeaderToDetailsResponseState state) {
    //  HeaderToDetailsResponseDetails
    navigateTo(context, SalesBillAddEditScreen.routeName,
            arguments:
                AddUpdateSaleBillScreenArguments(state.response.details[0]))
        .then((value) {
      _QuotationBloc
        ..add(SalesBillListCallEvent(
            1,
            SalesBillListRequest(
                CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));
    });
  }
}
