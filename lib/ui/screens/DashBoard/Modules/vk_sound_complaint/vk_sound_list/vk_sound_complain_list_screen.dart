import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/vk_sound_complaint/vk_sound_complaint_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_complain_pkid_to_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_sound_complain_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/vk_sound_complaint/vk_sound_complain_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/complaint/complaint_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/menu_rights_response.dart';
import 'package:for_practice_the_app/models/api_responses/vk_sound_complaint/vk_sound_complain_list_response.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/vk_sound_complaint/vk_sound_add_edit/vk_sound_complain_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/vk_sound_complaint/vk_sound_list/vk_complaint_history_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/make_call.dart';
import 'package:for_practice_the_app/utils/broadcast_msg/share_msg.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class VkSoundComplaintPaginationListScreen extends BaseStatefulWidget {
  static const routeName = '/VkSoundComplaintPaginationListScreen';

  @override
  _VkSoundComplaintPaginationListScreenState createState() =>
      _VkSoundComplaintPaginationListScreenState();
}

class _VkSoundComplaintPaginationListScreenState
    extends BaseState<VkSoundComplaintPaginationListScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  VkComplaintScreenBloc _complaintScreenBloc;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  int _pageNo = 0;
  VkComplaintListResponse _inquiryListResponse;
  ComplaintSearchDetails _searchDetails;
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  bool expanded = true;
  bool isDeleteVisible = true;
  MenuRightsResponse _menuRightsResponse;
  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;
  final TextEditingController edt_Search_CustomerName = TextEditingController();

  VkComplainPkIDtoDetailsResponseState vkComplainPkIDtoDetailsResponseState;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    _menuRightsResponse = SharedPrefHelper.instance.getMenuRights();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _complaintScreenBloc = VkComplaintScreenBloc(baseBloc);
    edt_Search_CustomerName.text = "";
    _complaintScreenBloc.add(VkComplaintListRequestEvent(
        1,
        VkComplaintListRequest(
          pkID: "0",
          SearchKey: "",
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString(),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _complaintScreenBloc
        ..add(VkComplaintListRequestEvent(
            1,
            VkComplaintListRequest(
              pkID: "0",
              SearchKey: "",
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString(),
            ))),
      child: BlocConsumer<VkComplaintScreenBloc, VkComplaintScreenStates>(
        builder: (BuildContext context, VkComplaintScreenStates state) {
          if (state is VkComplaintListResponseState) {
            VkComplaintListAPIResponse(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is VkComplaintListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, VkComplaintScreenStates state) {
          if (state is VkComplaintDeleteResponseState) {
            _onDeleteAPIResponse(state);
          }
          if (state is SearchCustomerListByNumberCallResponseState) {
            _ONOnlyCustomerDetails(state);
          }

          if (state is VkComplainPkIDtoDetailsResponseState) {
            _onpkIDtoDetailsAPIResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is VkComplaintDeleteResponseState ||
              currentState is SearchCustomerListByNumberCallResponseState ||
              currentState is VkComplainPkIDtoDetailsResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

//http://localhost:1900/ComplaintQuick.aspx?MobilePdf=yes&userid=admin&password=123&pkID=60167
  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text('Technical Site Visit'),
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
                    _complaintScreenBloc.add(VkComplaintListRequestEvent(
                        1,
                        VkComplaintListRequest(
                          pkID: "0",
                          SearchKey: "",
                          LoginUserID: LoginUserID,
                          CompanyId: CompanyID.toString(),
                        )));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      children: [
                        BasicCustomerSearch(),
                        Expanded(child: _buildInquiryList()),
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
                  navigateTo(context, VkComplaintAddEditScreen.routeName);
                },
                child: const Icon(Icons.add),
                backgroundColor: colorPrimary,
              )
            : Container(),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  Widget BasicCustomerSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Customer Name * ",
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
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_Search_CustomerName,
                      onChanged: (value) {
                        if (value.toString().length > 2) {
                          _complaintScreenBloc.add(VkComplaintListRequestEvent(
                              1,
                              VkComplaintListRequest(
                                pkID: "0",
                                SearchKey: value.toString(),
                                LoginUserID: LoginUserID,
                                CompanyId: CompanyID.toString(),
                              )));
                        } else {
                          _complaintScreenBloc.add(VkComplaintListRequestEvent(
                              1,
                              VkComplaintListRequest(
                                pkID: "0",
                                SearchKey: "",
                                LoginUserID: LoginUserID,
                                CompanyId: CompanyID.toString(),
                              )));
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Search Customer",
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
                  Icons.search,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void VkComplaintListAPIResponse(VkComplaintListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        // _searchDetails = null;
        _inquiryListResponse = state.vkComplaintListResponse;
      } else {
        _inquiryListResponse.details
            .addAll(state.vkComplaintListResponse.details);
      }
      _pageNo = state.newPage;
    }
  }

  _buildInquiryList() {
    if (_inquiryListResponse == null) {
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
      child: ListView.builder(
        key: Key('selected'),
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _inquiryListResponse.details.length,
      ),
    );
  }

  void _onInquiryListPagination() {
    _complaintScreenBloc.add(VkComplaintListRequestEvent(
        _pageNo + 1,
        VkComplaintListRequest(
          pkID: "0",
          SearchKey: "",
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString(),
        )));
  }

  _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    VkComplaintListResponseDetails model = _inquiryListResponse.details[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key: Key(index.toString()),
          initiallyExpanded: false, //attention
          initialElevation: 5.0,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          elevation: 1,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: colorTileBG,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xff0066b3),
                          size: 24,
                        ),
                      ),
                      Text("Customer",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Color(0xff0066b3),
                            fontSize: 7,
                          ))
                    ],
                  ),
                  Flexible(
                    child: Card(
                      color: model.complaintStatus == "Open"
                          ? Colors.green
                          : Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          model.complaintStatus,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xff0066b3),
                      size: 24,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        model.customerName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: true,
                    child: GestureDetector(
                      onTap: () async {
                        MoveTofollowupHistoryPage(model.CustomerID.toString());
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
                                  Icons.history,
                                  size: 24,
                                  color: colorPrimary,
                                ),
                              ),
                            ),
                          ),
                          Text("History",
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
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      FetchCustomerDetails(model.CustomerID.toString());
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
                              Icons.account_box,
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
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: Container(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                              Text("Comp.No",
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
                                                model
                                                    .complaintNo, //put your own long text here.
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
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                child: Icon(
                                                  Icons.calendar_today_outlined,
                                                  color: colorCardBG,
                                                ),
                                              ),
                                              Text("Comp.Date",
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
                                                model.complaintDate == ""
                                                    ? "N/A"
                                                    : model.complaintDate
                                                            .getFormattedDate(
                                                                fromFormat:
                                                                    "yyyy-MM-ddTHH:mm:ss",
                                                                toFormat:
                                                                    "dd-MM-yyyy") ??
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
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 3,
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
                                        Icons.sticky_note_2,
                                        color: colorCardBG,
                                      ),
                                      Text("Notes",
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
                                        model
                                            .complaintNotes, //put your own long text here.
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
                          SizedBox(
                            height: 3,
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
                                        Icons.online_prediction,
                                        color: colorCardBG,
                                      ),
                                      Text("Type",
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
                                        model.complaintType == ""
                                            ? "N/A"
                                            : model
                                                .complaintType, //put your own long text here.
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
                          SizedBox(
                            height: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: colorCardBG,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 300,
                height: 50,
                child: ButtonBar(
                    // alignment: MainAxisAlignment.spaceAround,
                    alignment: MainAxisAlignment.center,
                    buttonHeight: 40.0,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      IsEditRights == true
                          ? GestureDetector(
                              onTap: () {
                                _complaintScreenBloc.add(
                                    VkComplaintpkIDtoDetailsRequestEvent(
                                        model.pkID,
                                        VkComplaintpkIDtoDetailsRequest(
                                            pkID: model.pkID.toString(),
                                            CompanyId: CompanyID.toString())));
                              },
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    CUSTOM_UPDATE,
                                    height: 24,
                                    width: 24,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
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
                            )
                          : Container(),
                      isDeleteVisible == true
                          ? GestureDetector(
                              onTap: () {
                                showCommonDialogWithTwoOptions(context,
                                    "Are you sure you want to Delete This Details ?",
                                    negativeButtonTitle: "No",
                                    positiveButtonTitle: "Yes",
                                    onTapOfPositiveButton: () {
                                  Navigator.of(context).pop();

                                  _inquiryListResponse.details.removeAt(index);

                                  _complaintScreenBloc.add(
                                      VkComplaintDeleteRequestEvent(
                                          model.pkID,
                                          VkComplaintDeleteRequest(
                                              pkID: model.pkID.toString(),
                                              CompanyId:
                                                  CompanyID.toString())));
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    CUSTOM_DELETE,
                                    height: 24,
                                    width: 24,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                  ),
                                  Text(
                                    'delete',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: colorWhite),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ]),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));

    /*return Container(
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
            model.customerName,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: GestureDetector(
            child: Text(
              model.complaintNo,
              style: TextStyle(
                color: Color(0xFF504F4F),
                fontSize: _fontSize_Title,
              ),
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
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Complaint Notes ",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintNotes == ""
                                                ? "N/A"
                                                : model.complaintNotes,
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
                                        Text("Status",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color(label_color),
                                                fontSize: _fontSize_Label,
                                                letterSpacing: .3)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                            model.complaintStatus == null
                                                ? "N/A"
                                                : model.complaintStatus,
                                            style: TextStyle(
                                                color: model.complaintStatus ==
                                                        "Open"
                                                    ? colorGreenDark
                                                    : colorRedDark,
                                                fontSize: _fontSize_Title,
                                                letterSpacing: .3)),
                                      ],
                                    )),
                              ]),
                          SizedBox(
                            height: sizeboxsize,
                          ),
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
                            //_onTapOfEditCustomer(model);
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
                            // _onTapOfDeleteInquiry(model.pkID);
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
        ));*/
  }

  void _onDeleteAPIResponse(VkComplaintDeleteResponseState state) {
    _complaintScreenBloc.add(VkComplaintListRequestEvent(
        _pageNo,
        VkComplaintListRequest(
          pkID: "0",
          SearchKey: "",
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString(),
        )));
  }

  Future<void> MoveTofollowupHistoryPage(String CustomerID) {
    navigateTo(context, VKComplaintHistoryScreen.routeName,
            arguments: VKComplaintHistoryScreenArguments(CustomerID))
        .then((value) {});
  }

  void FetchCustomerDetails(String customerID) {
    _complaintScreenBloc.add(SearchCustomerListByNumberCallEvent(
        CustomerSearchByIdRequest(
            companyId: CompanyID,
            loginUserID: LoginUserID,
            CustomerID: customerID.toString())));
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

    CustomerDetails customerDetails = CustomerDetails();
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

  void _onpkIDtoDetailsAPIResponse(VkComplainPkIDtoDetailsResponseState state) {
    vkComplainPkIDtoDetailsResponseState = state;

    navigateTo(context, VkComplaintAddEditScreen.routeName,
            arguments: VkAddUpdateComplaintScreenArguments(
                vkComplainPkIDtoDetailsResponseState))
        .then((value) {
      _complaintScreenBloc.add(VkComplaintListRequestEvent(
          _pageNo,
          VkComplaintListRequest(
            pkID: "0",
            SearchKey: "",
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString(),
          )));
    });
  }
}
