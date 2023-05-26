import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/quotationtable.dart';
import 'package:for_practice_the_app/models/common/specification/quotation/quotation_specification.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/products/old_quotation_product_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/calculation/header_discount_calculation.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';

class OldAddQuotationProductListArgument {
  String quotation_No;
  String stateCode;
  String HeaderDiscAmnt;

  OldAddQuotationProductListArgument(
      this.quotation_No, this.stateCode, this.HeaderDiscAmnt);
}

class OldQuotationProductListScreen extends BaseStatefulWidget {
  static const routeName = '/OldQuotationProductListScreen';
  final OldAddQuotationProductListArgument arguments;
  OldQuotationProductListScreen(this.arguments);
  @override
  _OldQuotationProductListScreenState createState() =>
      _OldQuotationProductListScreenState();
}

class _OldQuotationProductListScreenState
    extends BaseState<OldQuotationProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<QuotationTable> _productList = [];

  List<QuotationSpecificationTable> _quotationProductSpecification = [];

  List<QuotationTable> _TempinquiryProductList = [];

  List<QuotationTable> AfterDiscountProductList = [];

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

  QuotationBloc _inquiryBloc;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _inquiryBloc = QuotationBloc(baseBloc);

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
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
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
        listener: (BuildContext context, QuotationStates state) {
          if (state is SpecificationListResponseState) {
            _onGetQuotationSpecificationFromAPI(state);
          }

          if (state is QuotationOneProductDeleteState) {
            _onQuotationOneProductDeleteResponse(state);
          }
          if (state is DeleteQuotationSpecificationByFinishProductIDState) {
            _onDeleteQuotationSpecificationByFinishProductIDSucess(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SpecificationListResponseState ||
              currentState is QuotationOneProductDeleteState ||
              currentState
                  is DeleteQuotationSpecificationByFinishProductIDState) {
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
      appBar: /*PreferredSizeWidget(getCommonAppBar(context, baseTheme, "Quotation Product List", showBack: true)),*/
          AppBar(
        backgroundColor: colorPrimary,
        title: Text("Quotation Product List"),
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
              await navigateTo(context, OldAddQuotationProductScreen.routeName,
                      arguments: OldAddQuotationProductScreenArguments(
                          qtModel, _StateCode, _HeaderDiscAmnt, QuotationNo))
                  .then((value) {
                List<QuotationTable> temp_productList = value;

                for (int i = 0; i < temp_productList.length; i++) {
                  print("tableID" + " ID " + temp_productList[i].id.toString());
                }

                _inquiryBloc.add(GetQuotationProductListEvent());
              });
              //getProduct();
              //UpdateAfterHeaderDiscountToDB();
//right now calling again get contacts, later it can be optimized
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

          /* return Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID:${_productList[index].id}"),
                          Text("InquiryNo: ${_productList[index].InquiryNo}"),
                          Text("ProductID:${_productList[index].ProductID}"),
                          Text("ProductName: ${_productList[index].ProductName}"),
                          Text("Quantity: ${_productList[index].Quantity}"),
                          Text("UnitPrice: ${_productList[index].UnitPrice}"),

                        ],
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _onTapOfEditContact(index);
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  _onTapOfDeleteContact(index);
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      )
                    ],
                  )),
            );*/
        },
        shrinkWrap: true,
        itemCount: _productList.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED
            /*height: 200,
              width: 200*/
            ),
      );
    }
  }

  Future<void> getProduct() async {
    _productList.clear();
    _productList
        .addAll(await OfflineDbHelper.getInstance().getQuotationProduct());

    double hiderdiscount = double.parse(
        _HeaderDiscAmnt.toString() == null || _HeaderDiscAmnt.toString() == ""
            ? 0.00
            : _HeaderDiscAmnt.toString());
    String CompanyStateCode =
        _offlineLoggedInData.details[0].stateCode.toString();
    String CustomerStateID = _productList[0].StateCode.toString();

    List<QuotationTable> TempproductList1 =
        HeaderDiscountCalculation.txtHeadDiscount_WithZero(
            _productList, hiderdiscount, CompanyStateCode, CustomerStateID);

    List<QuotationTable> TempproductList =
        HeaderDiscountCalculation.txtHeadDiscount_TextChanged(
            TempproductList1, hiderdiscount, CompanyStateCode, CustomerStateID);

    // await OfflineDbHelper.getInstance().deleteALLQuotationProduct();
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

    navigateTo(context, OldAddQuotationProductScreen.routeName,
            arguments: OldAddQuotationProductScreenArguments(
                _productList[index], _StateCode, _HeaderDiscAmnt, QuotationNo))
        .then((value) {
      _inquiryBloc.add(GetQuotationProductListEvent());
    });

    //getProduct();
    //setState(() {});
    //UpdateAfterHeaderDiscountToDB();
//right now calling again get contacts, later it can be optimized
  }

  _onTapOfDeleteContact(int id, int ItemIndex) {
    /*await OfflineDbHelper.getInstance().deleteQuotationProduct(id);
    setState(() {
      // _productList.removeAt(ItemIndex);
      _inquiryBloc.add(GetQuotationProductListEvent());
    });*/
    if (ItemIndex != null) {
      _productList.removeAt(ItemIndex);
    }
    _inquiryBloc.add(QuotationOneProductDeleteEvent(id));
    // QuotationOneProductDeleteEvent
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    QuotationTable model = _productList[index];

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
                                                              : removeAllHtmlTags(
                                                                  model
                                                                          .ProductSpecification
                                                                      .toString()),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  title_color),
                                                              fontSize:
                                                                  _fontSize_Title,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                  /* ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(90, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(24.0),
                        ),
                      ),
                    ),*/
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
                      _inquiryBloc.add(
                          DeleteQuotationSpecificationByFinishProductIDEvent(
                              model.ProductID));

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

      List<QuotationTable> TempproductList1 =
          HeaderDiscountCalculation.txtHeadDiscount_WithZero(
              _productList, HeaderDisAmnt, CompanyStateCode, CustomerStateID);

      List<QuotationTable> TempproductList =
          HeaderDiscountCalculation.txtHeadDiscount_TextChanged(
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

  void _onQuotationOneProductDeleteResponse(
      QuotationOneProductDeleteState state) {
    print("lkjdsjf" + state.response);
    _inquiryBloc.add(GetQuotationProductListEvent());
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    String removedHTML = htmlText.replaceAll(exp, '');
    return removedHTML;
  }

  void _onDeleteQuotationSpecificationByFinishProductIDSucess(
      DeleteQuotationSpecificationByFinishProductIDState state) {
    print("specDeleteFinishProductID" + state.response);
  }
}
