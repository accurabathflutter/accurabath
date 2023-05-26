import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/expense/expense_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/assembly/qt_assembly_table.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/qt_assembly/qt_assembly_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/General_Constants.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/image_full_screen.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class QTAssemblyAddEditScreenArguments {
  QTAssemblyTable editModel;
  String finishedProductID;
  String FromAddEdit;

  QTAssemblyAddEditScreenArguments(
      this.editModel, this.finishedProductID, this.FromAddEdit);
}

class QTAssemblyAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/QTAssemblyAddEditScreen';

  final QTAssemblyAddEditScreenArguments arguments;

  QTAssemblyAddEditScreen(this.arguments);

  @override
  _QTAssemblyAddEditScreenState createState() =>
      _QTAssemblyAddEditScreenState();
}

class _QTAssemblyAddEditScreenState extends BaseState<QTAssemblyAddEditScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController edt_ExpenseDateController =
      TextEditingController();
  final TextEditingController edt_ReverseExpenseDateController =
      TextEditingController();

  final TextEditingController edt_ExpenseNotes = TextEditingController();

  final TextEditingController edt_ExpenseType = TextEditingController();
  final TextEditingController edt_ExpenseTypepkID = TextEditingController();
  final TextEditingController edt_ExpenseAmount = TextEditingController();
  final TextEditingController edt_FromLocation = TextEditingController();
  final TextEditingController edt_ToLocation = TextEditingController();

  final TextEditingController edt_OrderNo = TextEditingController();
  final TextEditingController edt_QTY = TextEditingController();
  FocusNode edt_QTYFocusNode;

  final TextEditingController edt_Unit = TextEditingController();
  final TextEditingController edt_Specification = TextEditingController();
  final TextEditingController edt_MatirialSpecification =
      TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeaveType = [];

  DateTime selectedDate = DateTime.now();
  QuotationBloc _expenseBloc;
  int savepkID = 0;
  bool _isForUpdate;
  int ExpensepkID = 0;

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  //ExpenseTypeResponse _offlineExpenseType;

  int CompanyID = 0;
  String LoginUserID = "";

  DateTime FromDate = DateTime.now();
  DateTime ToDate = DateTime.now();
  bool is_visibleLocation;
  List<File> multiple_selectedImageFile = [];
  File _selectedImageFile;
  List<ALL_Name_ID> arr_ImageList = [];

  String fileName = "";

  String SiteURL = "";
  String ImageURLFromListing = "";
  String GetImageNamefromEditMode = "";
  FocusNode AmountFocusNode, FromLocationFocusNode;

  int tablepkID = 0;

  String QuotationNo = "";
  String ProductID = "";

  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productIDController = TextEditingController();
  ProductSearchDetails _searchDetails;

  @override
  void initState() {
    super.initState();
    _expenseBloc = QuotationBloc(baseBloc);
    AmountFocusNode = FocusNode();
    edt_QTYFocusNode = FocusNode();
    FromLocationFocusNode = FocusNode();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    //_offlineExpenseType = SharedPrefHelper.instance.getExpenseType();

    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    SiteURL = _offlineCompanyData.details[0].siteURL;
    //_onLeaveRequestTypeSuccessResponse(_offlineExpenseType);
    edt_ExpenseDateController.text = selectedDate.day.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.year.toString();

    edt_ReverseExpenseDateController.text = selectedDate.year.toString() +
        "-" +
        selectedDate.month.toString() +
        "-" +
        selectedDate.day.toString();

    _isForUpdate = widget.arguments.editModel != null;
    edt_ExpenseType.addListener(() {
      if (edt_ExpenseType.text == "Petrol") {
        FromLocationFocusNode.requestFocus();
      } else {
        AmountFocusNode.requestFocus();
      }
    });

    if (_isForUpdate) {
      _productNameController.text = widget.arguments.editModel.ProductName;
      _productIDController.text = widget.arguments.editModel.ProductID;
      edt_QTY.text = widget.arguments.editModel.Quantity;
      edt_Unit.text = widget.arguments.editModel.Unit;
      /*edt_OrderNo.text = widget.arguments.editModel.OrderNo;
      edt_GroupDiscription.text = widget.arguments.editModel.Group_Description;
      edt_Head.text = widget.arguments.editModel.Head;
      edt_Specification.text = widget.arguments.editModel.Specification;
      edt_MatirialSpecification.text =
          widget.arguments.editModel.Material_Remarks.toString();
      tablepkID = widget.arguments.editModel.id;

      QuotationNo = widget.arguments.editModel.QuotationNo;

      ProductID = widget.arguments.editModel.ProductID;*/
    }

    is_visibleLocation = false;
    edt_ExpenseType.addListener(() {
      if (edt_ExpenseType.text == "Petrol") {
        is_visibleLocation = true;
      } else {
        is_visibleLocation = false;
      }
      setState(() {});
    });

    /*   List lst123 = "Expense Added Successfully !10047".split("!");
    String RetrunPkID = lst123[1].toString();
    print("SaveReturnPKID : " + RetrunPkID);
*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _expenseBloc,
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, QuotationStates state) {
          if (state is QTAssemblyTableInsertState) {
            QTAssemblyTableInsertResponse(state);
          }
          if (state is QTAssemblyTableUpdateState) {
            QTAssemblyTableUpdateResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is QTAssemblyTableInsertState ||
              currentState is QTAssemblyTableUpdateState) {
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
        /* appBar: NewGradientAppBar(
          title: Text('Assembly Details'),
          gradient:
              LinearGradient(colors: [
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
        ),*/
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(Constant.CONTAINERMARGIN),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchView(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        QTY(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Unit(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Visibility(
                          visible: widget.arguments.FromAddEdit == "Add"
                              ? true
                              : false,
                          child: getCommonButton(baseTheme, () {
                            showCommonDialogWithTwoOptions(context,
                                "Are you sure you want to Add Assembly Details ?",
                                negativeButtonTitle: "No",
                                positiveButtonTitle: "Yes",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();

                              _expenseBloc.add(QTAssemblyTableInsertEvent(
                                  context,
                                  QTAssemblyTable(
                                      widget.arguments.finishedProductID,
                                      _productIDController.text,
                                      _productNameController.text,
                                      edt_QTY.text,
                                      edt_Unit.text,
                                      "")));
                            });
                          }, "Add", backGroundColor: colorPrimary),
                        ),
                        Visibility(
                          visible: widget.arguments.FromAddEdit == "Edit"
                              ? true
                              : false,
                          child: getCommonButton(baseTheme, () {
                            showCommonDialogWithTwoOptions(context,
                                "Are you sure you want to Update Assembly Details ?",
                                negativeButtonTitle: "No",
                                positiveButtonTitle: "Yes",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();

                              _expenseBloc.add(QTAssemblyTableUpdateEvent(
                                  context,
                                  QTAssemblyTable(
                                      widget.arguments.finishedProductID,
                                      _productIDController.text,
                                      _productNameController.text,
                                      edt_QTY.text,
                                      edt_Unit.text,
                                      "",
                                      id: widget.arguments.editModel.id)));
                            });
                          }, "Update", backGroundColor: colorPrimary),
                        ),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                      ]))),
        ),
      ),
    );
  }

  void checkPhotoPermissionStatus() async {
    bool granted = await Permission.storage.isGranted;
    bool Denied = await Permission.storage.isDenied;
    bool PermanentlyDenied = await Permission.storage.isPermanentlyDenied;

    print("PermissionStatus" +
        "Granted : " +
        granted.toString() +
        " Denied : " +
        Denied.toString() +
        " PermanentlyDenied : " +
        PermanentlyDenied.toString());

    if (Denied == true) {
      // openAppSettings();

      await Permission.storage.request();

/*      showCommonDialogWithSingleOption(
          context, "Location permission is required , You have to click on OK button to Allow the location access !",
          positiveButtonTitle: "OK",
      onTapOfPositiveButton: () async {
         await openAppSettings();
         Navigator.of(context).pop();

      }

      );*/

      // await Permission.location.request();
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
      openAppSettings();
    }
    if (PermanentlyDenied == true) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    }

    if (granted == true) {
      // The OS restricts access, for example because of parental controls.

      /*if (serviceLocation == true) {
        // Use location.
        _serviceEnabled=false;

         location.requestService();


      }
      else{
        _serviceEnabled=true;
        _getCurrentLocation();



      }*/
    }
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop("allOtherCharges");

    // navigateTo(context, ExpenseListScreen.routeName, clearAllStack: true);
  }

  /*Future<int> deleteFile(File file123) async {
    try {
      final file = await file123.path;

      await file123.delete();
    } catch (e) {
      return 0;
    }
  }*/

  Widget OrderNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Order.#",
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
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_OrderNo,
                      decoration: InputDecoration(
                        hintText: "Tap to enter Order No.",
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
              ],
            ),
          ),
        )
      ],
    );
  }

  /*Widget Head() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Head",
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
            padding: EdgeInsets.only(left: 10, top: 10),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      controller: edt_Head,
                      decoration: InputDecoration(
                        hintText: "Tap to enter Head",
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
              ],
            ),
          ),
        )
      ],
    );
  }*/

  Widget FromLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("From Location",
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
                      focusNode: FromLocationFocusNode,
                      textInputAction: TextInputAction.next,
                      controller: edt_FromLocation,
                      decoration: InputDecoration(
                        hintText: "Tap to enter location",
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
                  Icons.location_on,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget ToLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("To Location",
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
                      textInputAction: TextInputAction.next,
                      controller: edt_ToLocation,
                      decoration: InputDecoration(
                        hintText: "Tap to enter location",
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
                  Icons.location_on,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget CustomDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialog(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF000000),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: hintTextvalue,
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
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fillData(ExpenseDetails expenseDetails) async {
    print("LeaveDateee" + expenseDetails.expenseDate);

    edt_ExpenseDateController.text = expenseDetails.expenseDate
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseExpenseDateController.text = expenseDetails.expenseDate
        .getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    print("LeaveFromDate" + FromDate.toString());

    /* try {
      var imageId = await ImageDownloader.downloadImage(SiteURL+"otherimages/"+expenseDetails.expenseImage);
      if (imageId == null) {
        return;
      }
      var path = await ImageDownloader.findPath(imageId);
      print("ImageFilePathfromAPI123" + path.toString());
      _selectedImageFile = File(path);

    } on PlatformException catch (error) {
      print(error);
    }*/

    edt_ExpenseNotes.text = expenseDetails.expenseNotes;
    edt_ExpenseType.text =
        expenseDetails.expenseTypeName == "--Not Available--" ||
                expenseDetails.expenseTypeName == "N/A"
            ? ""
            : expenseDetails.expenseTypeName;
    edt_ExpenseTypepkID.text = expenseDetails.expenseTypeId.toString();
    ExpensepkID = expenseDetails.pkID;
    edt_ExpenseAmount.text = expenseDetails.amount.toString();
    edt_FromLocation.text = expenseDetails.fromLocation;
    edt_ToLocation.text = expenseDetails.toLocation;
    if (expenseDetails.expenseImage.isNotEmpty) {
      ImageURLFromListing =
          SiteURL + "otherimages/" + expenseDetails.expenseImage;
      GetImageNamefromEditMode = expenseDetails.expenseImage;
    } else {
      ImageURLFromListing = "";
    }
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _selectDate(context, edt_ExpenseDateController);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Expense Date *",
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
                    child: Text(
                      edt_ExpenseDateController.text == null ||
                              edt_ExpenseDateController.text == ""
                          ? "DD-MM-YYYY"
                          : edt_ExpenseDateController.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_ExpenseDateController.text == null ||
                                  edt_ExpenseDateController.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_ExpenseDateController.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseExpenseDateController.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  openFullScreenImage(File multiple_selectedImageFile123) {
    /* return FullScreenWidget(
       child: Hero(
         tag: "customTag",
         child: ClipRRect(
           borderRadius: BorderRadius.circular(16),
           child: Image.file(
             multiple_selectedImageFile123,
             fit: BoxFit.cover,
           ),
         ),
       ),
     );
*/
    return ImageFullScreenWrapperWidget(
      child: Image.file(multiple_selectedImageFile123),
      dark: true,
    );
  }

  Widget fullScreenImage() => FullScreenWidget(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            IMG_HEADER_LOGO,
            fit: BoxFit.cover,
          ),
        ),
      );

  Future<File> _fileFromImageUrl(String url, String ImageName) async {
    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(p.join(documentDirectory.path, ImageName));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
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
            child: TextFormField(
              controller: edt_QTY,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.number,
              onTap: () => {
                edt_QTY.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: edt_QTY.text.length,
                )
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
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
            child: TextFormField(
              controller: edt_Unit,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
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
      ],
    );
  }

  void QTAssemblyTableInsertResponse(QTAssemblyTableInsertState state) {
    print("mdf" + state.response.toString());

    Navigator.of(state.context).pop(state.response.toString());
    // navigateTo(context, QTAssemblyScreen.routeName, clearAllStack: true);
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        print("VlaueForISForUpdate" + _isForUpdate.toString());
        if (_isForUpdate == false) {
          _onTapOfSearchView();
        }
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
                          if (_isForUpdate == false) {
                            _onTapOfSearchView();
                          }
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

  Future<void> _onTapOfSearchView() async {
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _searchDetails = ProductSearchDetails();
        _searchDetails = value;
        setState(() {
          _productNameController.text = "";
          _productIDController.text = "";
          edt_Unit.text = "";
          edt_QTY.text = "0.00";
          _productNameController.text = _searchDetails.productName;
          _productIDController.text = _searchDetails.pkID.toString();
          edt_Unit.text = _searchDetails.unit;
        });
      }
    });
  }

  void QTAssemblyTableUpdateResponse(QTAssemblyTableUpdateState state) {
    print("mdf" + state.response.toString());
    navigateTo(context, QTAssemblyScreen.routeName);

    //Navigator.of(state.context).pop(state.response.toString());
  }
}
