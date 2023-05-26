import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/salesbill/salesbill_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/assembly/sb_assembly_table.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';

class SBAssemblyScreenArgument {
  String quotation_No;
  String finishProductID;

  SBAssemblyScreenArgument(this.quotation_No, this.finishProductID);
}

class SBAssemblyScreen extends BaseStatefulWidget {
  static const routeName = '/SBAssemblyScreen';
  final SBAssemblyScreenArgument arguments;
  SBAssemblyScreen(this.arguments);
  @override
  _SBAssemblyScreenState createState() => _SBAssemblyScreenState();
}

class _SBAssemblyScreenState extends BaseState<SBAssemblyScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<SBAssemblyTable> _productList = [];

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  String QuotationNo = "";
  SBAssemblyTable qtModel;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  String LoginUserID;
  String CompanyID;

  SalesBillBloc _inquiryBloc;
  List<ProductSearchDetails> GeneralProductdetails = [];
  ProductSearchDetails _searchDetails;
  List _tempListOfCities;
  //1
  final _scaffoldKey = GlobalKey();
  final TextEditingController textController = new TextEditingController();
  final TextEditingController _productNameController =
      new TextEditingController();
  final TextEditingController _productIDController =
      new TextEditingController();
  final TextEditingController edt_QTY = TextEditingController();
  final TextEditingController edt_Unit = TextEditingController();

  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _inquiryBloc = SalesBillBloc(baseBloc);

    if (widget.arguments != null) {
      print("GetINQNOFRomList" + widget.arguments.quotation_No);
      QuotationNo = widget.arguments.quotation_No;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc
        ..add(SBAssemblyTableListEvent(widget.arguments.finishProductID)),
      child: BlocConsumer<SalesBillBloc, SalesBillStates>(
        builder: (BuildContext context, SalesBillStates state) {
          if (state is SBAssemblyTableListState) {
            _OnAsseblyListResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is SBAssemblyTableListState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, SalesBillStates state) {
          if (state is SBAssemblyTableOneItemDeleteState) {
            _OnDeleteOneItemResponse(state);
          }

          if (state is SBAssemblyTableInsertState) {
            SOAssemblyTableInsertResponse(state);
          }
          if (state is SBAssemblyTableUpdateState) {
            SOAssemblyTableUpdateResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SBAssemblyTableOneItemDeleteState ||
              currentState is SBAssemblyTableInsertState ||
              currentState is SBAssemblyTableUpdateState) {
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
      body: Column(
        children: [
          getCommonAppBar(context, baseTheme, "SO_Assembly List",
              showBack: true),
          Container(
              margin: EdgeInsets.all(10), child: _buildContactsListView()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: colorPrimary,
            onPressed: () {
              _productNameController.text = "";
              _productIDController.text = "";
              edt_QTY.text = "";
              edt_Unit.text = "";
              _showAddAssemblyScreen(context, "Add");
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

  Future<void> _onTapOfEditContact(
      BuildContext context, int index, SBAssemblyTable model123) async {
    _productIDController.text = model123.ProductID;
    _productNameController.text = model123.ProductName;
    edt_QTY.text = model123.Quantity;
    edt_Unit.text = model123.Unit;

    _showEditAssemblyScreen(context, "Edit", model123);
  }

  _onTapOfDeleteContact(int id, int ItemIndex) {
    if (ItemIndex != null) {
      _productList.removeAt(ItemIndex);
    }
    _inquiryBloc.add(SBAssemblyTableOneItemDeleteEvent(id));
    // QuotationOneProductDeleteEvent
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    SBAssemblyTable model = _productList[index];

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
                  InkWell(
                    onTap: () {
                      //_onTapOfEditContact(index, model);
                      _onTapOfEditContact(context, index, model);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: colorPrimary,
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
                      ],
                    ),
                  ),
                ]),
          ],
        ));
  }

  void _OnAsseblyListResponse(SBAssemblyTableListState state) {
    _productList.clear();
    for (int i = 0; i < state.response.length; i++) {
      _productList.add(state.response[i]);
    }
  }

  void _OnDeleteOneItemResponse(SBAssemblyTableOneItemDeleteState state) {
    print("AsseblyDeleteEvent" + " Delete API " + state.response);
    _inquiryBloc
        .add(SBAssemblyTableListEvent(widget.arguments.finishProductID));
  }

  void _showAddAssemblyScreen(context, String fromPage) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context1) {
          //3
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    margin: EdgeInsets.all(10),
                    child: ListView(children: [
                      ListTile(
                          title:
                              _buildGeneralProductSearchView(context1, "Add")),
                      SizedBox(
                        width: 20,
                        height: 5,
                      ),
                      ListTile(title: QTY()),
                      SizedBox(
                        width: 20,
                        height: 5,
                      ),
                      ListTile(title: Unit()),
                      SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: getCommonButton(baseTheme, () {
                                if (_productNameController.text != "") {
                                  if (edt_QTY.text != "") {
                                    if (edt_Unit.text != "") {
                                      Navigator.of(context1).pop();

                                      _inquiryBloc.add(
                                          SBAssemblyTableInsertEvent(
                                              context,
                                              SBAssemblyTable(
                                                  widget.arguments
                                                      .finishProductID,
                                                  _productIDController.text,
                                                  _productNameController.text,
                                                  edt_QTY.text,
                                                  edt_Unit.text,
                                                  "")));
                                    } else {
                                      showCommonDialogWithSingleOption(
                                          context, "Unit Is Required!",
                                          positiveButtonTitle: "OK",
                                          onTapOfPositiveButton: () {
                                        Navigator.of(context1).pop();
                                      });
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Quantity Is Required!",
                                        positiveButtonTitle: "OK",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context1).pop();
                                    });
                                  }
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Product Name Is Required!",
                                      positiveButtonTitle: "OK",
                                      onTapOfPositiveButton: () {
                                    Navigator.of(context1).pop();
                                  });
                                }
                              }, "Add",
                                  backGroundColor: colorPrimary, radius: 30),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: getCommonButton(baseTheme, () {
                                Navigator.of(context1).pop();
                              }, "Close",
                                  backGroundColor: colorPrimary, radius: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        height: 40,
                      ),
                    ]),
                  );
                });
          });
        });
  }

  void _showEditAssemblyScreen(
      context, String fromPage, SBAssemblyTable qtAssemblyTable) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context1) {
          //3
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    margin: EdgeInsets.all(10),
                    child: ListView(children: [
                      ListTile(
                          title:
                              _buildGeneralProductSearchView(context1, "Edit")),
                      SizedBox(
                        width: 20,
                        height: 5,
                      ),
                      ListTile(title: QTY()),
                      SizedBox(
                        width: 20,
                        height: 5,
                      ),
                      ListTile(title: Unit()),
                      SizedBox(
                        width: 20,
                        height: 20,
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: getCommonButton(baseTheme, () {
                                if (_productNameController.text != "") {
                                  if (edt_QTY.text != "") {
                                    if (edt_Unit.text != "") {
                                      Navigator.of(context1).pop();

                                      _inquiryBloc.add(
                                          SBAssemblyTableUpdateEvent(
                                              context,
                                              SBAssemblyTable(
                                                  widget.arguments
                                                      .finishProductID,
                                                  _productIDController.text,
                                                  _productNameController.text,
                                                  edt_QTY.text,
                                                  edt_Unit.text,
                                                  "",
                                                  id: qtAssemblyTable.id)));
                                    } else {
                                      showCommonDialogWithSingleOption(
                                          context, "Unit Is Required!",
                                          positiveButtonTitle: "OK",
                                          onTapOfPositiveButton: () {
                                        Navigator.of(context1).pop();
                                      });
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Quantity Is Required!",
                                        positiveButtonTitle: "OK",
                                        onTapOfPositiveButton: () {
                                      Navigator.of(context1).pop();
                                    });
                                  }
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Product Name Is Required!",
                                      positiveButtonTitle: "OK",
                                      onTapOfPositiveButton: () {
                                    Navigator.of(context1).pop();
                                  });
                                }
                              }, "Update",
                                  backGroundColor: colorPrimary, radius: 30),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: getCommonButton(baseTheme, () {
                                Navigator.of(context1).pop();
                              }, "Close",
                                  backGroundColor: colorPrimary, radius: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                        height: 15,
                      ),
                    ]),
                  );
                });
          });
        });
  }

  Widget _buildGeneralProductSearchView(
      BuildContext context123, String IsEnable) {
    return InkWell(
      onTap: () {
        IsEnable == "Edit"
            ? Container()
            : _onTapOfSearchView(); //_showSearchModal(context123);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Product * ",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
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
              height: 40,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return "Please enter this field";
                          }
                          return null;
                        },
                        onTap: () {
                          IsEnable == "Edit"
                              ? Container()
                              : _onTapOfSearchView(); //_showSearchModal(context);
                        },
                        readOnly: true,
                        controller: _productNameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 5),
                          hintText: "Tap to search Product",
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
      ),
    );
  }

  QTY() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Quantity *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.only(left: 7, right: 7, top: 4),
            child: Container(
              height: 40,
              child: TextFormField(
                controller: edt_QTY,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onTap: () => {
                  edt_QTY.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: edt_QTY.text.length,
                  )
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, bottom: 5),

                  //  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Enter Details',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,

                  /*border: OutlineInputBorder(
                      borderSide: new BorderSide(color: colorPrimary),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )*/
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Unit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Unit *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.only(left: 7, right: 7, top: 4),
            child: Container(
              height: 40,
              child: TextFormField(
                controller: edt_Unit,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onTap: () => {
                  edt_Unit.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: edt_Unit.text.length,
                  )
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, bottom: 5),

                  //  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Enter Details',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,

                  /*border: OutlineInputBorder(
                      borderSide: new BorderSide(color: colorPrimary),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )*/
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void SOAssemblyTableInsertResponse(SBAssemblyTableInsertState state) {
    print("mdf" + state.response.toString());
    _inquiryBloc
        .add(SBAssemblyTableListEvent(widget.arguments.finishProductID));
  }

  void SOAssemblyTableUpdateResponse(SBAssemblyTableUpdateState state) {
    print("mdf" + state.response.toString());
    _inquiryBloc
        .add(SBAssemblyTableListEvent(widget.arguments.finishProductID));
  }

  Future<void> _onTapOfSearchView() async {
    /* navigateTo(context, SearchInquiryProductScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _inquiryBloc.add(InquiryProductSearchNameCallEvent(InquiryProductSearchRequest(pkID: "",CompanyId: "10032",ListMode: "L",SearchKey: value)));
       print("ProductDetailss345"+_searchDetails.productName +"Alias"+ _searchDetails.productAlias);
      }
    });*/
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _searchDetails = ProductSearchDetails();
        _searchDetails = value;
        setState(() {
          // edt_Specification.text = "";
          _productNameController.text = _searchDetails.productName.toString();
          _productIDController.text = _searchDetails.pkID.toString();
        });
      }
    });
  }
}
