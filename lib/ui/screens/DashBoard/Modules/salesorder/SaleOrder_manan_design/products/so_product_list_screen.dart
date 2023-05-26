import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/salesorder/salesorder_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/quotationtable.dart';
import 'package:for_practice_the_app/models/common/sales_order_table.dart';
import 'package:for_practice_the_app/models/common/specification/quotation/quotation_specification.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/products/so_product_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/calculation/sales_order_calculation/sales_order_header_discount_calculation.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';

class SOProductListArgument {
  String quotation_No;
  String stateCode;
  String HeaderDiscAmnt;

  SOProductListArgument(this.quotation_No, this.stateCode, this.HeaderDiscAmnt);
}

class SOProductListScreen extends BaseStatefulWidget {
  static const routeName = '/SOProductListScreen';
  final SOProductListArgument arguments;
  SOProductListScreen(this.arguments);
  @override
  _SOProductListScreenState createState() => _SOProductListScreenState();
}

class _SOProductListScreenState extends BaseState<SOProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<SalesOrderTable> _productList = [];

  List<QuotationSpecificationTable> _quotationProductSpecification = [];

  List<SalesOrderTable> _TempinquiryProductList = [];

  List<SalesOrderTable> AfterDiscountProductList = [];

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _StateCode = 0;
  String QuotationNo = "";
  SalesOrderTable qtModel;
  String _HeaderDiscAmnt = "0.00";

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  String LoginUserID;
  String CompanyID;

  SalesOrderBloc _inquiryBloc;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _inquiryBloc = SalesOrderBloc(baseBloc);

    if (widget.arguments != null) {
      print("GetINQNOFRomList" + widget.arguments.quotation_No);
      QuotationNo = widget.arguments.quotation_No;
      _StateCode = int.parse(widget.arguments.stateCode);
      _HeaderDiscAmnt = widget.arguments.HeaderDiscAmnt;

      _inquiryBloc.add(GetQuotationProductListEvent());

      _inquiryBloc.add(GetQuotationSpecificationTableEvent());
    }

    //getContacts();
    /// getProduct();

    //UpdateAfterHeaderDiscountToDB();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          _inquiryBloc..add(GetQuotationProductListEvent()),
      child: BlocConsumer<SalesOrderBloc, SalesOrderStates>(
        builder: (BuildContext context, SalesOrderStates state) {
          if (state is GetQuotationProductListState) {
            _OnGetQuotationProductList(state);
          }

          if (state is GetQuotationSpecificationTableState) {
            _OnGetQuotationSpecification(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetQuotationProductListState ||
              currentState is GetQuotationSpecificationTableState) {
            return true;
          }

          return false;
        },
        listener: (BuildContext context, SalesOrderStates state) {
          if (state is SpecificationListResponseState) {
            _onGetQuotationSpecificationFromAPI(state);
          }

          if (state is SOProductOneDeleteState) {
            _onOneProductDeleteResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SpecificationListResponseState ||
              currentState is SOProductOneDeleteState) {
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
        title: Text("SalesOrder Product List"),
      ),
      body: _buildContactsListView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /* FloatingActionButton(
            backgroundColor: colorPrimary,
            onPressed: () async {
              */ /* await navigateTo(
                          context,
                          AddQuotationProductScreen.routeName,
                        );*/ /*
              await navigateTo(context, QuotationOtherChargeScreen.routeName,
                  arguments: QuotationOtherChargesScreenArguments(qtModel,_StateCode));
              getProduct();
            },
            child: Icon(Icons.filter_alt_rounded),
          ),
          SizedBox(height: 10,),*/
          FloatingActionButton(
            backgroundColor: colorPrimary,
            onPressed: () async {
              /* await navigateTo(
                          context,
                          AddQuotationProductScreen.routeName,
                        );*/
              await navigateTo(context, SOAddEditScreen.routeName,
                      arguments: SOAddEditScreenArguments(
                          qtModel, _StateCode, _HeaderDiscAmnt, QuotationNo))
                  .then((value) {
                List<SalesOrderTable> temp_productList = value;

                for (int i = 0; i < temp_productList.length; i++) {
                  print("tableID" + " ID " + temp_productList[i].id.toString());
                }

                _inquiryBloc.add(GetQuotationProductListEvent());
              });
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

  Future<void> getProduct() async {
    _productList.clear();
    _productList
        .addAll(await OfflineDbHelper.getInstance().getSalesOrderProduct());

    double hiderdiscount = double.parse(
        _HeaderDiscAmnt.toString() == null || _HeaderDiscAmnt.toString() == ""
            ? 0.00
            : _HeaderDiscAmnt.toString());
    String CompanyStateCode =
        _offlineLoggedInData.details[0].stateCode.toString();
    String CustomerStateID = _productList[0].StateCode.toString();

    List<SalesOrderTable> TempproductList1 =
        SalesOrderHeaderDiscountCalculation.txtHeadDiscount_WithZero(
            _productList, hiderdiscount, CompanyStateCode, CustomerStateID);

    List<SalesOrderTable> TempproductList =
        SalesOrderHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
            TempproductList1, hiderdiscount, CompanyStateCode, CustomerStateID);

    _productList.clear();
    _productList.addAll(TempproductList);

    setState(() {});
  }

  Future<void> _onTapOfEditContact(int index) async {
    print("fjdj" + QuotationNo);

    for (int i = 0; i < _quotationProductSpecification.length; i++) {
      print("ProductWiseSpecification" +
          " GroupDescription : " +
          _quotationProductSpecification[i].Group_Description +
          " ProductID : " +
          _productList[index].ProductID.toString() +
          " SpecProductID : " +
          _quotationProductSpecification[i].ProductID.toString());
      if (_productList[index].ProductID.toString() ==
          _quotationProductSpecification[i].ProductID) {
        print("ProductWiseSpecification123" +
            " GroupDescription : " +
            _quotationProductSpecification[i].Group_Description);
      }
    }

    navigateTo(context, SOAddEditScreen.routeName,
            arguments: SOAddEditScreenArguments(
                _productList[index], _StateCode, _HeaderDiscAmnt, QuotationNo))
        .then((value) {
      _inquiryBloc.add(GetQuotationProductListEvent());
    });
  }

  _onTapOfDeleteContact(int id, int ItemIndex) {
    /*await OfflineDbHelper.getInstance().deleteSalesOrderProduct(id);
    setState(() {
      if (ItemIndex != null) {
        _productList.removeAt(ItemIndex);
      }
      _inquiryBloc.add(GetQuotationProductListEvent());
    });*/
    if (ItemIndex != null) {
      _productList.removeAt(ItemIndex);
    }
    _inquiryBloc.add(SOProductOneDeleteEvent(id));
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    SalesOrderTable model = _productList[index];

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
              child: Image.asset(
                PRODUCT_ICON,
                height: 48,
                width: 48,
              )),
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
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Delivery Date",
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
                                                    model.DeliveryDate == ""
                                                        ? "N/A"
                                                        : model.DeliveryDate
                                                            .getFormattedDate(
                                                                fromFormat:
                                                                    "yyyy-MM-dd",
                                                                toFormat:
                                                                    "dd-MM-yyyy"),
                                                    style: TextStyle(
                                                        color:
                                                            Color(title_color),
                                                        fontSize:
                                                            _fontSize_Title,
                                                        letterSpacing: .3)),
                                              ],
                                            ))
                                      ]),
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                  removeAllHtmlTags(model.ProductSpecification
                                              .toString()) ==
                                          ""
                                      ? Container()
                                      : Row(
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
                                                      Text("Specification",
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
                                                          model.ProductSpecification
                                                                      .toString() ==
                                                                  ""
                                                              ? "N/A"
                                                              : removeAllHtmlTags(model
                                                                      .ProductSpecification
                                                                  .toString()),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              letterSpacing:
                                                                  .3)),
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
                      _onTapOfDeleteContact(model.id, index);
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

  void _ontaptoSpecificationADDEdit(QuotationTable model) {}

  void _OnGetQuotationProductList(GetQuotationProductListState state) {
    if (state.response.length != 0) {
      String CustomerStateID = state.response[0].StateCode.toString();
      _productList.clear();
      for (int i = 0; i < state.response.length; i++) {
        _productList.add(state.response[i]);
      }

      //_headerDiscountController.text = "100.00";
      double HeaderDisAmnt =
          _HeaderDiscAmnt.isNotEmpty ? double.parse(_HeaderDiscAmnt) : 0.00;
      // HeaderDisAmnt = 100;
      String CompanyStateCode =
          _offlineLoggedInData.details[0].stateCode.toString();

      List<SalesOrderTable> TempproductList1 =
          SalesOrderHeaderDiscountCalculation.txtHeadDiscount_WithZero(
              _productList, HeaderDisAmnt, CompanyStateCode, CustomerStateID);

      List<SalesOrderTable> TempproductList =
          SalesOrderHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
              TempproductList1,
              HeaderDisAmnt,
              CompanyStateCode,
              CustomerStateID);

      for (int i = 0; i < _productList.length; i++) {
        print("productList" +
            " AmountFromProductList : " +
            _productList[i].DiscountPercent.toString() +
            " NetAmountFromProductList : " +
            _productList[i].DiscountAmt.toString() +
            " NetRate : " +
            _productList[i].NetRate.toString() +
            " BasicAmount : " +
            _productList[i].Amount.toString() +
            " NetAmnount : " +
            _productList[i].NetAmount.toString());
      }

      for (int i = 0; i < TempproductList1.length; i++) {
        print("TempproductList1" +
            " AmountCalculation : " +
            TempproductList1[i].DiscountPercent.toString() +
            " NetAmountCalculation : " +
            TempproductList1[i].DiscountAmt.toString() +
            " NetRate : " +
            TempproductList1[i].NetRate.toString() +
            " BasicAmount : " +
            TempproductList1[i].Amount.toString() +
            " NetAmount : " +
            TempproductList1[i].NetAmount.toString());
      }

      for (int i = 0; i < TempproductList.length; i++) {
        print("TempproductList" +
            " AmountCalculation : " +
            TempproductList[i].DiscountPercent.toString() +
            " NetAmountCalculation : " +
            TempproductList[i].DiscountAmt.toString() +
            " NetRate : " +
            TempproductList[i].NetRate.toString() +
            " BasicAmount : " +
            TempproductList[i].Amount.toString() +
            " NetAmount : " +
            TempproductList[i].NetAmount.toString());
      }

      _productList.clear();
      for (int i = 0; i < TempproductList.length; i++) {
        _productList.add(TempproductList[i]);
      }

      // UpdateHeaderDiscountCalculation(TempproductList);
    }
  }

  void _onGetQuotationSpecificationFromAPI(
      SpecificationListResponseState state) {}

  void _OnGetQuotationSpecification(GetQuotationSpecificationTableState state) {
    _quotationProductSpecification.clear();
    for (int i = 0; i < state.response.length; i++) {
      print("SpecificationResponse" + " " + state.response[i].ProductID);
      _quotationProductSpecification.add(state.response[i]);
    }
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    String removedHTML = htmlText.replaceAll(exp, '');
    return removedHTML;
  }

  void _onOneProductDeleteResponse(SOProductOneDeleteState state) {
    print("ljdsfj889ui" + state.response);
    _inquiryBloc.add(GetQuotationProductListEvent());
  }
}
