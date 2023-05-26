import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/quotationtable.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';

class SampleScreenArgument {
  String quotation_No;
  String finishProductID;

  SampleScreenArgument(this.quotation_No, this.finishProductID);
}

class SampleScreen extends BaseStatefulWidget {
  static const routeName = '/QTAssemblyScreen';
  final SampleScreenArgument arguments;
  SampleScreen(this.arguments);
  @override
  _SampleScreenState createState() => _SampleScreenState();
}

class _SampleScreenState extends BaseState<SampleScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<QuotationTable> _productList = [];

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
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
          FloatingActionButton(
            backgroundColor: colorPrimary,
            onPressed: () async {
              /* await navigateTo(context, OldAddQuotationProductScreen.routeName,
                  arguments: OldAddQuotationProductScreenArguments(
                      qtModel, _StateCode, _HeaderDiscAmnt, QuotationNo))
                  .then((value) {


                _inquiryBloc.add(GetQuotationProductListEvent());
              });*/
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
        child: Lottie.asset(NO_DATA_ANIMATED
            /*height: 200,
              width: 200*/
            ),
      );
    }
  }

  Future<void> _onTapOfEditContact(int index) async {
    /* navigateTo(context, OldAddQuotationProductScreen.routeName,
        arguments: OldAddQuotationProductScreenArguments(
            _productList[index], _StateCode, _HeaderDiscAmnt, QuotationNo))
        .then((value) {
      List<QuotationTable> temp_productList = value;

      for (int i = 0; i < temp_productList.length; i++) {
        print("tableID" + " ID " + temp_productList[i].id.toString());
      }

      _inquiryBloc.add(GetQuotationProductListEvent());
    });*/
  }

  _onTapOfDeleteContact(int id, int ItemIndex) {
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
}
