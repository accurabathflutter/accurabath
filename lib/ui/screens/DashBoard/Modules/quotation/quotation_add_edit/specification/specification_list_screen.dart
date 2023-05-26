import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/specification/quotation/quotation_specification.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/specification/specification_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';

class SpecificationListArgument {
  String inquiry_No;
  String ProductID;

  SpecificationListArgument(this.inquiry_No, this.ProductID);
}

class SpecificationListScreen extends BaseStatefulWidget {
  static const routeName = '/SpecificationListScreen';
  final SpecificationListArgument arguments;

  SpecificationListScreen(this.arguments);
  @override
  _SpecificationListScreenState createState() =>
      _SpecificationListScreenState();
}

class _SpecificationListScreenState extends BaseState<SpecificationListScreen>
    with BasicScreen, WidgetsBindingObserver {
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  String LoginUserID;
  String CompanyID;

  List<QuotationSpecificationTable> _productList = [];
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;

  QuotationBloc _quotationBloc;
  String _productID = "";

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _quotationBloc = QuotationBloc(baseBloc);

    screenStatusBarColor = colorWhite;
    if (widget.arguments != null) {
      print("GetINQNOFRomList" + widget.arguments.inquiry_No);

      _productID = widget.arguments.ProductID;
    }
    //getContacts();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _quotationBloc,
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          /* if (state is GetQuotationProductListState) {
            _OnGetQuotationProductList(state);
          }*/
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          /*if (currentState is GetQuotationProductListState) {
            return true;
          }*/

          return false;
        },
        listener: (BuildContext context, QuotationStates state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      color: colorWhite,
      child: Column(
        children: [
          getCommonAppBar(context, baseTheme, "Specification List",
              showBack: true),
          Expanded(
            child: Stack(
              children: [
                _buildContactsListView(),
              ],
            ),
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
    _productList.addAll(await OfflineDbHelper.getInstance()
        .getQuotationSpecificationWithProductID(_productID));

    setState(() {});
  }

  Future<void> _onTapOfEditContact(QuotationSpecificationTable model) async {
    /* await navigateTo(context, AddInquiryProductScreen.routeName,
        arguments: AddInquiryProductScreenArguments(_productList[index]));
*/

    navigateTo(context, QuotationSpecificationAddEditScreen.routeName,
            arguments: AddUpdateQuotationSpecificationScreenArguments(model))
        .then((value) {
      print("ljfdjg" + value.toString());

      getProduct();
    });

    // getProduct(); //right now calling again get contacts, later it can be optimized
  }

  Future<void> _onTapOfDeleteContact(int index) async {
    await OfflineDbHelper.getInstance()
        .deleteInquiryProduct(_productList[index].id);
    setState(() {
      _productList.removeAt(index);
    });
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    QuotationSpecificationTable model = _productList[index];

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
            model.Group_Description,
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
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("Order.#",
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
                                                    model.OrderNo == ""
                                                        ? "N/A"
                                                        : model.OrderNo,
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
                                                Text("Head",
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
                                                    model.Head == ""
                                                        ? "N/A"
                                                        : model.Head,
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
                                                Text("Group Description.",
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
                                                    model.Group_Description ==
                                                            ""
                                                        ? "N/A"
                                                        : model
                                                            .Group_Description,
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
                                                    model.Specification == ""
                                                        ? "N/A"
                                                        : model.Specification,
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
                                                Text("Material Remarks",
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
                                                    model.Material_Remarks == ""
                                                        ? "N/A"
                                                        : model
                                                            .Material_Remarks,
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
                                  SizedBox(
                                    height: sizeboxsize,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))),
              ),
            ),
            ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonHeight: 52.0,
                buttonMinWidth: 90.0,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _onTapOfEditContact(model);
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
                  SizedBox(
                    width: 10,
                  ),
                  /* GestureDetector(
                    onTap: () {
                      _onTapOfDeleteContact(index);
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
                  ),*/
                ]),
          ],
        ));
  }
}
