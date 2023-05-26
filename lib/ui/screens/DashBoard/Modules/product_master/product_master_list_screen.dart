import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/product_master/product_master_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/product/product_master_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/product_master/product_master_list_response.dart';
import 'package:for_practice_the_app/models/common/quotationtable.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class ProductMasterListScreen extends BaseStatefulWidget {
  static const routeName = '/ProductMasterListScreen';

  @override
  _ProductMasterListScreenState createState() =>
      _ProductMasterListScreenState();
}

class _ProductMasterListScreenState extends BaseState<ProductMasterListScreen>
    with BasicScreen, WidgetsBindingObserver {
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _StateCode = 0;
  String QuotationNo = "";
  QuotationTable qtModel;
  String _HeaderDiscAmnt = "0.00";

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  String LoginUserID;
  String CompanyID;

  ManagePurchaseBloc _inquiryBloc;
  int _pageNo = 0;
  ProductMasterResponseDetails _searchDetails;
  ProductMasterResponse _inquiryListResponse;
  int selected = 0; //attention
  final TextEditingController edt_SearchProduct = TextEditingController();

  @override
  void initState() {
    super.initState();
    edt_SearchProduct.text = "";
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _inquiryBloc = ManagePurchaseBloc(baseBloc);

    _inquiryBloc.add(ProductMasterListEvent(
        1,
        ProductMasterListRequest(
            ProductID: "0",
            ListMode: "L",
            SearchKey: "",
            PageNo: 1.toString(),
            PageSize: "10",
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
    //getContacts();
    /// getProduct();

    //UpdateAfterHeaderDiscountToDB();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc
        ..add(ProductMasterListEvent(
            _pageNo + 1,
            ProductMasterListRequest(
                ProductID: "0",
                ListMode: "L",
                SearchKey: "",
                PageNo: (_pageNo + 1).toString(),
                PageSize: "10",
                LoginUserID: LoginUserID,
                CompanyId: CompanyID.toString()))),
      child: BlocConsumer<ManagePurchaseBloc, ProductMasterState>(
        builder: (BuildContext context, ProductMasterState state) {
          if (state is ProductMasterResponseState) {
            _OnProductListResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ProductMasterResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, ProductMasterState state) {},
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
          title: Text('Product List'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          actions: [
            GestureDetector(
              onTap: () {
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
                          ListTile(
                            // leading: Icon(Icons.share),
                            title: _buildEmplyeeListView(),
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

                                    _inquiryBloc
                                      ..add(ProductMasterListEvent(
                                          1,
                                          ProductMasterListRequest(
                                              ProductID: "0",
                                              ListMode: "L",
                                              SearchKey: edt_SearchProduct.text,
                                              PageNo: 1.toString(),
                                              PageSize: "10000",
                                              LoginUserID: LoginUserID,
                                              CompanyId:
                                                  CompanyID.toString())));
                                    edt_SearchProduct.text = "";
                                  }, "Submit", radius: 15),
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
                  size: 30,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _inquiryBloc
                      ..add(ProductMasterListEvent(
                          1,
                          ProductMasterListRequest(
                              ProductID: "0",
                              ListMode: "L",
                              SearchKey: "",
                              PageNo: 1.toString(),
                              PageSize: "10",
                              LoginUserID: LoginUserID,
                              CompanyId: CompanyID.toString())));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        // _buildSearchView(),
                        Expanded(child: _buildInquiryList())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void _OnProductListResponse(ProductMasterResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      //checking if new data is arrived
      if (state.newPage == 1) {
        //resetting search
        _searchDetails = null;
        _inquiryListResponse = state.response;
      } else {
        _inquiryListResponse.details.addAll(state.response.details);
      }
      _pageNo = state.newPage;
    }
  }

  Widget _buildInquiryList() {
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
      child: _inquiryListResponse.details.isNotEmpty
          ? ListView.builder(
              key: Key('selected $selected'),
              itemBuilder: (context, index) {
                return _buildInquiryListItem(index);
              },
              shrinkWrap: true,
              itemCount: _inquiryListResponse.details.length,
            )
          : Center(
              child: Container(
              alignment: Alignment.center,
              child: Lottie.asset(NO_DATA_ANIMATED
                  /*height: 200,
              width: 200*/
                  ),
            )),
    );
  }

  void _onInquiryListPagination() {
    _inquiryBloc.add(ProductMasterListEvent(
        _pageNo + 1,
        ProductMasterListRequest(
            ProductID: "0",
            ListMode: "L",
            SearchKey: "",
            PageNo: (_pageNo + 1).toString(),
            PageSize: "10",
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString())));
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    ProductMasterResponseDetails model = _inquiryListResponse.details[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          elevation: 1,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: colorTileBG,
          /* leading: Image.network(
            "http://demo.sharvayainfotech.in/images/profile.png",
            height: 35,
            width: 35,
          ),*/
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
                      Icons.ballot_rounded,
                      color: Color(0xff108dcf),
                      size: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text(
                  model.productName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Card(
                  color: colorBackGroundGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.short_text,
                              color: Color(0xff108dcf),
                              size: 24,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              model.productAlias,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colorPrimary,
                                fontSize: _fontSize_Title,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /* Flexible(
                child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          "Closing",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        Text(
                          model.closingSTK.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),*/
            ],
          ),
          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            model.productImage != ""
                ? Container(
                    child: Card(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.network(
                            _offlineCompanyData.details[0].siteURL +
                                model.productImage),
                      ),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          "Opening Stock",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        Text(
                          model.openingSTK.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                )),
                Flexible(
                    child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          "Closing Stock",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        Text(
                          model.closingSTK.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                )),
                Flexible(
                    child: Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          "Sales Price",
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),
                        Text(
                          model.unitPrice.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 30, right: 30),
              height: 1,
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
                                                Icons.currency_rupee,
                                                color: colorCardBG,
                                              ),
                                              Text("UnitPrice",
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
                                                model.unitPrice.toString() == ""
                                                    ? "N/A"
                                                    : model.unitPrice
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
                                                Icons.percent,
                                                color: colorCardBG,
                                              ),
                                              Text("Rate",
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
                                                model.taxRate.toString() == ""
                                                    ? "N/A"
                                                    : model.taxRate
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
                                                Icons.group_work,
                                                color: colorCardBG,
                                              ),
                                              Text("Group",
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
                                                model.productGroupName
                                                            .toString() ==
                                                        ""
                                                    ? "N/A"
                                                    : model.productGroupName
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
                                                Icons.branding_watermark,
                                                color: colorCardBG,
                                              ),
                                              Text("Brand",
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
                                                model.brandName.toString() == ""
                                                    ? "N/A"
                                                    : model.brandName
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
                                  ]),
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
            Visibility(
              visible: false,
              child: Card(
                color: colorCardBG,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: 300,
                  height: 50,
                  child: ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      buttonHeight: 52.0,
                      buttonMinWidth: 90.0,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // _onTapOfEditCustomer(model);
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
                                    const EdgeInsets.symmetric(horizontal: 2.0),
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
                        GestureDetector(
                          onTap: () {
                            // _onTapOfDeleteInquiry(model.customerID);
                          },
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                CUSTOM_DELETE,
                                height: 29,
                                width: 29,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
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
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ]),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }

  Widget _buildEmplyeeListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            child: Text("Search Product",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
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
                    controller: edt_SearchProduct,
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
                        hintText: "Search Product"),
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
    );
  }
}
