import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/Clients/BlueTone/Inquiry/Product/product_price_list_screen.dart';
import 'package:for_practice_the_app/Clients/BlueTone/Inquiry/Product/size_list_chek_box_dialog.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/SizedList/size_list_request.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/bluetone_inquiry_product.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/price_model.dart';
import 'package:for_practice_the_app/Clients/BlueTone/bluetone_model/product_with_sized_list_model.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_product_search_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';

class AddBluetoneProductListArgument {
  String quotation_No;
  String finishProductID;

  AddBluetoneProductListArgument(this.quotation_No, this.finishProductID);
}

class BlueToneInquiryProductListScreen extends BaseStatefulWidget {
  static const routeName = '/BlueToneInquiryProductListScreen';
  final AddBluetoneProductListArgument arguments;
  BlueToneInquiryProductListScreen(this.arguments);
  @override
  _BlueToneInquiryProductListScreenState createState() =>
      _BlueToneInquiryProductListScreenState();
}

class _BlueToneInquiryProductListScreenState
    extends BaseState<BlueToneInquiryProductListScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<ProductWithSizedList> _productList = [];
  List<PriceModel> arrSizeList = [];
  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  String QuotationNo = "";
  BlueToneProductModel qtModel;
  List<ALL_Name_ID> arr_ProductDropDownList = [];

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  String LoginUserID;
  String CompanyID;

  InquiryBloc _inquiryBloc;
  //1
  final _scaffoldKey = GlobalKey();
  final TextEditingController textController = new TextEditingController();
  final TextEditingController _productNameController =
      new TextEditingController();
  final TextEditingController _productSizedController =
      new TextEditingController();
  final TextEditingController _productIDController =
      new TextEditingController();

  List<String> _sizedLisStringdata = [];

  final TextEditingController edt_QTY = TextEditingController();
  final TextEditingController edt_Unit = TextEditingController();
  final TextEditingController edt_SizedListController = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_INQ_QT_SO_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Payment_Schedual_List = [];

  List<String> sizedModelListView = [];

  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();
    _inquiryBloc = InquiryBloc(baseBloc);

    getProductPriceList();

    if (widget.arguments != null) {
      print("GetINQNOFRomList" + widget.arguments.quotation_No);
      QuotationNo = widget.arguments.quotation_No;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          _inquiryBloc..add(BlueToneProductModelListEvent()),
      child: BlocConsumer<InquiryBloc, InquiryStates>(
        builder: (BuildContext context, InquiryStates state) {
          if (state is BlueToneProductModelListState) {
            _OnAsseblyListResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is BlueToneProductModelListState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InquiryStates state) {
          if (state is BlueToneProductModelOneItemDeleteState) {
            _OnDeleteOneItemResponse(state);
          }

          if (state is BlueToneProductModelInsertState) {
            QTAssemblyTableInsertResponse(state);
          }
          if (state is BlueToneProductModelInsertState) {
            QTAssemblyTableUpdateResponse(state);
          }
          if (state is SizeListResponseState) {
            SizedListFromProductID(state);
          }

          if (state is InquiryProductSearchResponseState) {
            getProductDropDownList(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is BlueToneProductModelOneItemDeleteState ||
              currentState is InquiryProductSearchResponseState ||
              currentState is BlueToneProductModelInsertState ||
              currentState is BlueToneProductModelInsertState ||
              currentState is SizeListResponseState) {
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
          //getCommonAppBar(context, baseTheme, "Product List", showBack: true),
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

              edt_SizedListController.text = "";
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
      BuildContext context, int index, ProductWithSizedList model123) async {
    _productIDController.text = model123.ProductID;
    _productNameController.text = model123.ProductName;
    edt_Unit.text = model123.UnitPrice;
    List<PriceModel> arrinquiryShareModel = [];

    arrinquiryShareModel = await OfflineDbHelper.getInstance()
        .getProductPriceList(_productIDController.text);
    List<String> sizedModelList = [];
    for (int i = 0; i < arrinquiryShareModel.length; i++) {
      if (arrinquiryShareModel[i].isChecked == "true") {
        sizedModelList.add(arrinquiryShareModel[i].SizeName);
      }
    }

    var stringwe = sizedModelList.join('\n');
    edt_SizedListController.text = stringwe.toString();
    _showEditAssemblyScreen(context, "Edit", model123);
  }

  _onTapOfDeleteContact(int id, int ItemIndex) {
    if (ItemIndex != null) {
      _productList.removeAt(ItemIndex);
    }
    _inquiryBloc.add(BlueToneProductModelOneItemDeleteEvent(id));
    // QuotationOneProductDeleteEvent
  }

  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ExpantionCustomer(BuildContext context, int index) {
    ProductWithSizedList model = _productList[index];

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
                                                          model.UnitPrice == ""
                                                              ? "N/A"
                                                              : model.UnitPrice
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
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index2) {
                                      return model.ProductID ==
                                              model.SizedList[index2].ProductID
                                          ? Text(
                                              model.SizedList[index2].SizeName)
                                          : Container();
                                    },
                                    itemCount: model.SizedList.length,
                                  )
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

  void _OnAsseblyListResponse(BlueToneProductModelListState state) {
    _productList.clear();

    for (int i = 0; i < state.response.length; i++) {
      _productList.add(state.response[i]);
      //getSizedddList(state.response[i].ProductID);
      //insertProductPrice(state.response[i].ProductID);
    }
  }

  void _OnDeleteOneItemResponse(BlueToneProductModelOneItemDeleteState state) {
    print("AsseblyDeleteEvent" + " Delete API " + state.response);
    _inquiryBloc.add(BlueToneProductModelListEvent());
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
                      ListTile(title: Unit()),
                      SizedBox(
                        width: 20,
                        height: 10,
                      ),
                      ListTile(
                        title: InkWell(
                            onTap: () async {
                              if (_productIDController.text != "") {
                                List<PriceModel> arrinquiryShareModel = [];

                                arrinquiryShareModel =
                                    await OfflineDbHelper.getInstance()
                                        .getProductPriceList(
                                            _productIDController.text);

                                if (arrinquiryShareModel.isNotEmpty) {
                                  List<String> sizedModelList =
                                      await showDialog<List<String>>(
                                    //<--------|
                                    context: context,
                                    builder: (context) => Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: CheckboxListViewDialog(
                                          arrinquiryShareModel),
                                    ),
                                  );
                                  edt_SizedListController.text = "";
                                  var stringwe = sizedModelList.join(' | \n');
                                  edt_SizedListController.text =
                                      stringwe.toString();
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "ProductSize is not available !",
                                      positiveButtonTitle: "OK",
                                      onTapOfPositiveButton: () {
                                    Navigator.of(context1).pop();
                                  });
                                }
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "ProductName Is Required!",
                                    positiveButtonTitle: "OK",
                                    onTapOfPositiveButton: () {
                                  Navigator.of(context1).pop();
                                });
                              }
                            },
                            child: SizedListControllerview()),
                      ),
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
                                  if (edt_Unit.text != "") {
                                    Navigator.of(context1).pop();

                                    /*insertProductPrice(
                                        _productIDController.text);*/

                                    _inquiryBloc
                                        .add(BlueToneProductModelInsertEvent(
                                            context,
                                            BlueToneProductModel(
                                              "",
                                              LoginUserID,
                                              CompanyID,
                                              _productNameController.text,
                                              _productIDController.text,
                                              edt_Unit.text,
                                            )));
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
      context, String fromPage, ProductWithSizedList qtAssemblyTable) async {
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
                      Visibility(visible: false, child: ListTile(title: QTY())),
                      SizedBox(
                        width: 20,
                        height: 5,
                      ),
                      ListTile(title: Unit()),
                      SizedBox(
                        width: 20,
                        height: 10,
                      ),
                      ListTile(
                        title: InkWell(
                            onTap: () async {
                              List<PriceModel> arrinquiryShareModel = [];

                              arrinquiryShareModel =
                                  await OfflineDbHelper.getInstance()
                                      .getProductPriceList(
                                          _productIDController.text);

                              if (arrinquiryShareModel.isNotEmpty) {
                                List<String> sizedModelList =
                                    await showDialog<List<String>>(
                                  //<--------|
                                  context: context,
                                  builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: CheckboxListViewDialog(
                                        arrinquiryShareModel),
                                  ),
                                );

                                var stringwe = sizedModelList.join('\n');
                                edt_SizedListController.text =
                                    stringwe.toString();
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "ProductSize is not available !",
                                    positiveButtonTitle: "OK",
                                    onTapOfPositiveButton: () {
                                  Navigator.of(context1).pop();
                                });
                              }
                            },
                            child: SizedListControllerview()),
                      ),
                      /* ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                  arrinquiryShareModel123[index].SizeName));
                        },
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: arrinquiryShareModel123.length,
                      ),*/
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
                                  if (edt_Unit.text != "") {
                                    Navigator.of(context1).pop();

                                    _inquiryBloc.add(
                                        BlueToneProductModelUpdateEvent(
                                            context,
                                            BlueToneProductModel(
                                                "",
                                                LoginUserID,
                                                CompanyID,
                                                _productNameController.text,
                                                _productIDController.text,
                                                edt_Unit.text,
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
          Container(
            margin: EdgeInsets.only(left: 10, right: 20),
            child: Text("Select Product * ",
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
              padding: EdgeInsets.only(left: 10, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                        /*validator: (value) {
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
                        ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),*/

                        enabled: false,
                        controller: _productNameController,
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, bottom: 5),

                          //  contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Select Product',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                        )),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
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

  Widget _sizedChekboxDropdown(BuildContext context123) {
    return InkWell(
      onTap: () {
        navigateTo(context, ProductPriceListScreen.routeName,
                arguments: AddProductPriceListScreenArguments(
                    /*arr_ALL_Name_ID_For_INQ_QT_SO_List,*/
                    _productIDController.text))
            .then((value) async {
          setState(() {
            _sizedLisStringdata.clear();
            List<PriceModel> temparray = value;

            for (int i = 0; i < temparray.length; i++) {
              print("ArrayItems" +
                  " Name : " +
                  temparray[i].SizeName +
                  " IsCheck : " +
                  temparray[i].isChecked);

              _sizedLisStringdata.add(temparray[i].SizeName);

              updateDetails(temparray[i]);
            }
            var stringwe = _sizedLisStringdata.join(' | \n');
            // _productSizedController.text = stringwe.toString();
          });
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Size",
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
                        readOnly: true,
                        controller: _productSizedController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 5),
                          hintText: "Tap to select Size",
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
                    Icons.arrow_drop_down_outlined,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          ),
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
          child: Text("Unit Price *",
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
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Container(
              child: TextFormField(
                controller: edt_Unit,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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

  SizedListControllerview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("SizedList",
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
              padding: EdgeInsets.only(left: 10, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: edt_SizedListController,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, bottom: 5),

                        //  contentPadding: EdgeInsets.all(10.0),
                        hintText: 'Select Sized',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(fontSize: 12),
                        border: InputBorder.none,

                        /*border: OutlineInputBorder(
                            borderSide: new BorderSide(color: colorPrimary),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )*/
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void QTAssemblyTableInsertResponse(BlueToneProductModelInsertState state) {
    print("mdf" + state.response.toString());
    _inquiryBloc.add(BlueToneProductModelListEvent());
  }

  void QTAssemblyTableUpdateResponse(BlueToneProductModelInsertState state) {
    print("mdf" + state.response.toString());
    _inquiryBloc.add(BlueToneProductModelListEvent());
  }

  Future<void> _onTapOfSearchView() async {
    _inquiryBloc.add(InquiryProductSearchNameCallEvent(
        InquiryProductSearchRequest(
            pkID: "",
            CompanyId: CompanyID.toString(),
            ListMode: "L",
            SearchKey: "")));

    /*  navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) async {
      if (value != null) {
        _searchDetails = ProductSearchDetails();
        _searchDetails = value;
        setState(() {
          // edt_Specification.text = "";
          _productNameController.text = _searchDetails.productName.toString();
          _productIDController.text = _searchDetails.pkID.toString();
          _inquiryBloc.add(SizeListRequestEvent(SizeListRequest(
            ProductID: _productIDController.text,
            LoginUserID: LoginUserID,
            CompanyId: CompanyID.toString(),
          )));
        });
      }
    });*/
  }

  void getProductPriceList() {
    arr_ALL_Name_ID_For_INQ_QT_SO_List.clear();
    for (var i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "100 X 100 MM";
        all_name_id.isChecked = false;
      } else if (i == 1) {
        all_name_id.Name = "250 X 330 MM";
        all_name_id.isChecked = false;
      } else if (i == 2) {
        all_name_id.Name = "500 X 500 MM";
        all_name_id.isChecked = false;
      } else if (i == 3) {
        all_name_id.Name = "1000 X 1000 MM";
        all_name_id.isChecked = false;
      }
      arr_ALL_Name_ID_For_INQ_QT_SO_List.add(all_name_id);
    }
  }

  /*  void insertProductPrice(String productID) async {
    for (var i = 0; i < 4; i++) {
      if (i == 0) {
        await OfflineDbHelper.getInstance().insertProductPriceList(
            PriceModel("100 X 100 MM", "false", productID));
      } else if (i == 1) {
        await OfflineDbHelper.getInstance().insertProductPriceList(
            PriceModel("250 X 330 MM", "false", productID));
      } else if (i == 2) {
        await OfflineDbHelper.getInstance().insertProductPriceList(
            PriceModel("500 X 500 MM", "false", productID));
      } else if (i == 3) {
        await OfflineDbHelper.getInstance().insertProductPriceList(
            PriceModel("1000 X 1000 MM", "false", productID));
      }
    }
  }

  void updatePriceList(List<PriceModel> temparray) async {
    for (int i = 0; i < temparray.length; i++) {
      print("ddfhfdjf" +
          temparray[i].priceName +
          " Checked " +
          temparray[i].isChecked +
          " productID : " +
          temparray[i].productID +
          " id : " +
          temparray[i].id.toString());

      await OfflineDbHelper.getInstance().updateProductPriceItem(PriceModel(
          temparray[i].priceName,
          temparray[i].isChecked,
          temparray[i].productID,
          id: temparray[i].id));
    }
    setState(() {});
  }

  void updateDetails(PriceModel temparray) async {
    await OfflineDbHelper.getInstance().updateProductPriceItem(PriceModel(
      temparray.priceName,
      temparray.isChecked,
      temparray.productID,
      id: temparray.id,
    ));
  }*/

  void SizedListFromProductID(SizeListResponseState state) {
    if (state.arrSizeList.isNotEmpty) {
      List<String> sizedModelList = [];
      for (int i = 0; i < state.arrSizeList.length; i++) {
        print("sdjdsfj" + state.arrSizeList[i].SizeName);
        arrSizeList.add(state.arrSizeList[i]);
        sizedModelList.add(state.arrSizeList[i].SizeName);
      }

      var stringwe = sizedModelList.join(' | \n');
      edt_SizedListController.text = stringwe.toString();
    }
  }

  void updateDetails(PriceModel temparray) async {
    await OfflineDbHelper.getInstance().updateProductPriceItem(PriceModel(
      temparray.ProductID.toString(),
      temparray.ProductName.toString(),
      temparray.SizeID.toString(),
      temparray.SizeName.toString(),
      temparray.isChecked,
      id: temparray.id,
    ));
  }

  void getSizedddList(String productID) async {
    arrSizeList.clear();
    arrSizeList =
        await OfflineDbHelper.getInstance().getProductPriceList(productID);
  }

  void getProductDropDownList(InquiryProductSearchResponseState state) {
    arr_ProductDropDownList.clear();
    for (int i = 0;
        i < state.inquiryProductSearchResponse.details.length;
        i++) {
      ALL_Name_ID all_name_id1 = ALL_Name_ID();
      all_name_id1.Name =
          state.inquiryProductSearchResponse.details[i].productName;
      all_name_id1.Name1 =
          state.inquiryProductSearchResponse.details[i].pkID.toString();
      arr_ProductDropDownList.add(all_name_id1);
    }

    showProductDropDownCustomDialog(
        values: arr_ProductDropDownList,
        context1: context,
        controller: _productNameController,
        controller1: _productIDController,
        lable: "Select Product");
  }

  showProductDropDownCustomDialog(
      {List<ALL_Name_ID> values,
      BuildContext context1,
      TextEditingController controller,
      TextEditingController controller1,
      String lable}) async {
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
                    lable,
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context1).pop();
                                  controller.text = values[index].Name;
                                  controller1.text = values[index].Name1;
                                  _inquiryBloc
                                      .add(SizeListRequestEvent(SizeListRequest(
                                    ProductID: controller1.text,
                                    LoginUserID: LoginUserID,
                                    CompanyId: CompanyID.toString(),
                                  )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorPrimary), //Change color
                                        width: 10.0,
                                        height: 10.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1.5),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          values[index].Name,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: colorPrimary,
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: values.length,
                          ),
                        ])),
                  ],
                )),
          ],
        );
      },
    );
  }
}
