import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/dealer/dealer_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/dealer/sales_bill/productl_db_table.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Dealer/sales_bill/product_details/add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';

class AddDSaleBillProductListScreenArgument {
  String quotation_No;
  String stateCode;
  String HeaderDiscAmnt;

  AddDSaleBillProductListScreenArgument(
      this.quotation_No, this.stateCode, this.HeaderDiscAmnt);
}

class DSaleBillProductListScreen extends BaseStatefulWidget {
  static const routeName = '/DSaleBillProductListScreen';
  final AddDSaleBillProductListScreenArgument arguments;
  DSaleBillProductListScreen(this.arguments);
  @override
  BaseState<DSaleBillProductListScreen> createState() =>
      _DSaleBillProductListScreenState();
}

class _DSaleBillProductListScreenState
    extends BaseState<DSaleBillProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  DealerBloc _dealerBloc;
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _StateCode = 0;
  String QuotationNo = "";
  DealerSaleBillProductDBTable qtModel;

  List<DealerSaleBillProductDBTable> _productList = [];

  String _HeaderDiscAmnt = "0.00";

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  String LoginUserID;
  String CompanyID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dealerBloc = DealerBloc(baseBloc);
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    if (widget.arguments != null) {
      print("GetINQNOFRomList" + widget.arguments.quotation_No);
      QuotationNo = widget.arguments.quotation_No;
      _StateCode = int.parse(widget.arguments.stateCode);
      _HeaderDiscAmnt = widget.arguments.HeaderDiscAmnt;
    }
    _dealerBloc.add(GetDealerSaleBillProduct());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _dealerBloc,
      child: BlocConsumer<DealerBloc, DealerStates>(
        builder: (BuildContext context, DealerStates state) {
          if (state is GetDealerSaleBillProductState) {
            getProductFromDB(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetDealerSaleBillProductState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, DealerStates state) {
          if (state is DeleteByIdDealerSaleBillProductState) {
            deleteByIdResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is DeleteByIdDealerSaleBillProductState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text("Product List"),
      ),
      body: _buildContactsListView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: colorPrimary,
            onPressed: () async {
              /* await navigateTo(
                          context,
                          AddQuotationProductScreen.routeName,
                        );*/
              await navigateTo(context, DSaleBillProductAddEditScreen.routeName,
                  arguments: AddDSalesBillProductAddEdit_screenArguments(
                      qtModel, _StateCode, _HeaderDiscAmnt));
              _dealerBloc.add(GetDealerSaleBillProduct());
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsListView() {
    if (_productList.length != 0) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _productList.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED),
      );
    }
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    DealerSaleBillProductDBTable model = _productList[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,

          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: Color(0xFFC1E0FA), //Colors.deepOrange[50],ADD8E6
          leading: CircleAvatar(
              backgroundColor: Color(0xFF504F4F),
              child: Image.asset(
                PRODUCT_ICON,
                height: 48,
                width: 48,
              )), //Image.network("https://cdn-icons.flaticon.com/png/512/4785/premium/4785452.png?token=exp=1639741267~hmac=4fc9726eef0cf39128308a40039ea5ca", height: 35, fit: BoxFit.fill,width: 35,)),
          title: Text(
            model.ProductName,
            style: TextStyle(color: Colors.black),
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
                    margin: EdgeInsets.all(20),
                    child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Unit",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color(
                                                                  label_color),
                                                              fontSize:
                                                                  _fontSize_Label,
                                                              letterSpacing:
                                                                  .3)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          model.Unit == ""
                                                              ? "N/A"
                                                              : model.Unit
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                      Expanded(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Quantity.  ",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color(
                                                                  label_color),
                                                              fontSize:
                                                                  _fontSize_Label,
                                                              letterSpacing:
                                                                  .3)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          model.Quantity
                                                                      .toString() ==
                                                                  ""
                                                              ? "N/A"
                                                              : model
                                                                      .Quantity
                                                                  .toString(),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Unit Rate.  ",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color(
                                                                  label_color),
                                                              fontSize:
                                                                  _fontSize_Label,
                                                              letterSpacing:
                                                                  .3)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          model.UnitRate
                                                                      .toString() ==
                                                                  ""
                                                              ? "N/A"
                                                              : model
                                                                      .UnitRate
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                      Expanded(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Dis.%",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color(
                                                                  label_color),
                                                              fontSize:
                                                                  _fontSize_Label,
                                                              letterSpacing:
                                                                  .3)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          model.DiscountPercent
                                                                      .toString() ==
                                                                  ""
                                                              ? "N/A"
                                                              : model.DiscountPercent
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Net Rate.  ",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color(
                                                                  label_color),
                                                              fontSize:
                                                                  _fontSize_Label,
                                                              letterSpacing:
                                                                  .3)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          model.NetRate
                                                                      .toString() ==
                                                                  ""
                                                              ? "N/A"
                                                              : model.NetRate
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                      Expanded(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Amount",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color(
                                                                  label_color),
                                                              fontSize:
                                                                  _fontSize_Label,
                                                              letterSpacing:
                                                                  .3)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          model.Amount.toString() ==
                                                                  ""
                                                              ? "N/A"
                                                              : model.Amount
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Tax.%  ",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color(
                                                                  label_color),
                                                              fontSize:
                                                                  _fontSize_Label,
                                                              letterSpacing:
                                                                  .3)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          model.TaxRate
                                                                      .toString() ==
                                                                  ""
                                                              ? "N/A"
                                                              : model.TaxRate
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                      Expanded(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text("Tax Amount",
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color: Color(
                                                                  label_color),
                                                              fontSize:
                                                                  _fontSize_Label,
                                                              letterSpacing:
                                                                  .3)),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                          model.TaxAmount
                                                                      .toString() ==
                                                                  ""
                                                              ? "N/A"
                                                              : model.TaxAmount
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
                                                    ],
                                                  )),
                                            ]),
                                      ),
                                    ],
                                  ),
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
                                                Text("Net Amount",
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
                                                    model.NetAmount
                                                                .toString() ==
                                                            ""
                                                        ? "N/A"
                                                        : model
                                                                .NetAmount
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                Text("Specification",
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
                                                    model.NetAmount
                                                                .toString() ==
                                                            ""
                                                        ? "N/A"
                                                        : model.ProductSpecification
                                                            .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: .3)),
                                              ],
                                            ))
                                      ]),
                                ],
                              ),
                            ),
                          ],
                        ))),
              ),
            ),
            ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                buttonHeight: 52.0,
                buttonMinWidth: 90.0,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      _onTapOfEditContact(index);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: colorPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Text(
                          'Edit',
                          style: TextStyle(color: colorPrimary),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _onTapOfDeleteContact(model.id);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: colorPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(color: colorPrimary),
                        ),
                      ],
                    ),
                  ),
                ]),
          ],
        ));
  }

  Future<void> _onTapOfEditContact(int index) async {
    print("fjdj" + _HeaderDiscAmnt);

    await navigateTo(context, DSaleBillProductAddEditScreen.routeName,
        arguments: AddDSalesBillProductAddEdit_screenArguments(
            _productList[index], _StateCode, _HeaderDiscAmnt));
    _dealerBloc.add(GetDealerSaleBillProduct());
  }

  Future<void> _onTapOfDeleteContact(int pkid) async {
    _dealerBloc.add(DeleteByIdDealerSaleBillProduct(pkid));
  }

  void getProductFromDB(GetDealerSaleBillProductState state) {
    _productList.clear();
    for (int i = 0; i < state.dealerSaleBillProductDBTable.length; i++) {
      _productList.add(state.dealerSaleBillProductDBTable[i]);
    }
  }

  void deleteByIdResponse(DeleteByIdDealerSaleBillProductState state) {
    _dealerBloc.add(GetDealerSaleBillProduct());

    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK");
  }
}
