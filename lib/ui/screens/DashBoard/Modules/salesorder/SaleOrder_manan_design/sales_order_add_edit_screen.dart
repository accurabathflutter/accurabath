import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/salesorder/salesorder_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesOrder/bank_details_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesOrder/multi_no_to_product_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_search_by_id_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/save_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/SO_Export/so_export_save_api.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sale_order_header_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sale_order_product_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/sales_order_all_product_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/shipment/so_shipment_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/all_employee_List_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/country_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/salesorder_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/shipment/so_shipment_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleOrder/so_export/so_export_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:for_practice_the_app/models/common/sales_order_table.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_country_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/customer_search/customer_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/module_no_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/addtional_charges/sales_order_summary_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/products/so_product_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salesorder/salesorder_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/calculation/additional_charges_calculation.dart';
import 'package:for_practice_the_app/utils/calculation/model/additonalChargeDetails.dart';
import 'package:for_practice_the_app/utils/calculation/sales_order_calculation/sales_order_header_discount_calculation.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/sales_order_payment_schedule.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class AddUpdateSalesOrderNewScreenArguments {
  SalesOrderDetails editModel;
  SOShipmentlistResponseDetails soShipmentlistResponseDetails;
  SOExportListResponse soExportListResponse;
  AddUpdateSalesOrderNewScreenArguments(this.editModel,
      this.soShipmentlistResponseDetails, this.soExportListResponse);
}

class SaleOrderNewAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/SaleOrderNewAddEditScreen';

  final AddUpdateSalesOrderNewScreenArguments arguments;

  SaleOrderNewAddEditScreen(this.arguments);

  @override
  _SaleOrderNewAddEditScreenState createState() =>
      _SaleOrderNewAddEditScreenState();
}

class _SaleOrderNewAddEditScreenState
    extends BaseState<SaleOrderNewAddEditScreen>
    with BasicScreen, WidgetsBindingObserver, TickerProviderStateMixin {
  SalesOrderBloc _salesOrderBloc;

  SearchDetails searchCustomerDetails;
  SearchCountryDetails _searchDetails;
  SearchStateDetails _searchStateDetails;
  SearchCityDetails _searchCityDetails;
  bool _isForUpdate;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDatePI = DateTime.now();
  DateTime selectedDateRefrence = DateTime.now();
  DateTime selectedDateDelivery = DateTime.now();
  DateTime selectedDateWorkOrder = DateTime.now();

  double dateFontSize = 13;

  static const List<Tab> SalesOrderTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  PickedFile imageFile = null;
  File _image;
  bool img_visible = false;
  String fileName;
  double _rating;

  String imageDialogchoose = '';
  List imageDialog = [
    'Gallery',
    'Camera',
  ];

  TextEditingController _controller_order_no = TextEditingController();
  TextEditingController _controller_customer_name = TextEditingController();
  TextEditingController _controller_customer_pkID = TextEditingController();

  TextEditingController _controller_order_date = TextEditingController();
  TextEditingController _controller_rev_order_date = TextEditingController();
  TextEditingController _controller_PINO = TextEditingController();
  TextEditingController _controller_PI_date = TextEditingController();
  TextEditingController _controller_rev_PI_date = TextEditingController();
  TextEditingController _controller_bank_name = TextEditingController();
  TextEditingController _controller_bank_ID = TextEditingController();

  TextEditingController _controller_select_inquiry = TextEditingController();
  TextEditingController _controller_sales_executive = TextEditingController();
  TextEditingController _controller_sales_executiveID = TextEditingController();

  TextEditingController _controller_reference_no = TextEditingController();
  TextEditingController _controller_reference_date = TextEditingController();
  TextEditingController _controller_work_order_date = TextEditingController();
  TextEditingController _controller_rev_work_order_date =
      TextEditingController();
  TextEditingController _controller_delivery_date = TextEditingController();
  TextEditingController _controller_rev_delivery_date = TextEditingController();
  TextEditingController _controller_rev_reference_date =
      TextEditingController();
  TextEditingController _controller_currency = TextEditingController();
  TextEditingController _controller_currency_Symbol = TextEditingController();

  TextEditingController _controller_exchange_rate = TextEditingController();
  TextEditingController _controller_credit_days = TextEditingController();
  TextEditingController _controller_work_order_no = TextEditingController();
  TextEditingController _contrller_terms_and_condition =
      TextEditingController();
  TextEditingController _contrller_select_terms_and_condition =
      TextEditingController();
  TextEditingController _contrller_select_terms_and_conditionID =
      TextEditingController();
  TextEditingController _contrller_delivery_terms = TextEditingController();
  TextEditingController _contrller_payment_terms = TextEditingController();
  TextEditingController _controller_select_email_subject =
      TextEditingController();
  TextEditingController _controller_select_email_subject_ID =
      TextEditingController();

  TextEditingController _contrller_email_subject = TextEditingController();
  TextEditingController _controller_amount = TextEditingController();
  TextEditingController _controller_due_date = TextEditingController();
  TextEditingController _controller_rev_due_date = TextEditingController();

  //shipment
  TextEditingController _controller_transport_name = TextEditingController();
  TextEditingController _controller_place_of_rec = TextEditingController();
  TextEditingController _controller_flight_no = TextEditingController();
  TextEditingController _controller_port_of_loading = TextEditingController();
  TextEditingController _controller_port_of_dispatch = TextEditingController();
  TextEditingController _controller_port_of_destination =
      TextEditingController();
  TextEditingController _controller_container_no = TextEditingController();
  TextEditingController _controller_packages = TextEditingController();
  TextEditingController _controller_type_of_package = TextEditingController();
  TextEditingController _controller_net_weight = TextEditingController();
  TextEditingController _controller_gross_weight = TextEditingController();
  TextEditingController _controller_FOB = TextEditingController();

  //Image Picker
  TextEditingController _controller_image = TextEditingController();

  //Shipment Address
  TextEditingController _controller_company_name = TextEditingController();
  TextEditingController _controller_GSTNO = TextEditingController();
  TextEditingController _controller_contact_no = TextEditingController();
  TextEditingController _controller_contact_person_name =
      TextEditingController();
  TextEditingController _controller_address = TextEditingController();
  TextEditingController _controller_area = TextEditingController();
  TextEditingController edt_QualifiedCountry = TextEditingController();
  TextEditingController edt_QualifiedCountryCode = TextEditingController();

  TextEditingController edt_QualifiedState = TextEditingController();
  TextEditingController edt_QualifiedStateCode = TextEditingController();
  TextEditingController edt_QualifiedCity = TextEditingController();
  TextEditingController edt_QualifiedCityCode = TextEditingController();
  TextEditingController edt_QualifiedPinCode = TextEditingController();

  TextEditingController _controller_state = TextEditingController();
  TextEditingController _controller_city = TextEditingController();
  TextEditingController _controller_Module_NO = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Bank_Name = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Sales_Executive = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Currency = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Terms_And_Condition = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Email_Subject = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_INQ_QT_SO_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Payment_Schedual_List = [];

  TextEditingController _controller_projectName = TextEditingController();
  TextEditingController _controller_projectID = TextEditingController();

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  ALL_EmployeeList_Response _offlineFollowerEmployeeListData;

  int pkID = 0;
  int CompanyID = 0;
  String LoginUserID = "";
  bool isAllEditable = false;
  SalesOrderDetails _editModel;

  SOShipmentlistResponseDetails _soShipmentlistResponseDetails;

  SOExportListResponse _soExportListResponse;

  String SalesOrderNo = "";
  final TextEditingController edt_HeaderDisc = TextEditingController();
  List<SalesOrderTable> _inquiryProductList = [];

  List<SalesOrderProductRequest> arrSOProductList = [];
  final TextEditingController edt_StateCode = TextEditingController();

  List<SoPaymentScheduleTable> arr_PaymentScheduleList = [];

  TextEditingController _controllerAmountDialog = TextEditingController();
  TextEditingController _controllerDueDateDialog = TextEditingController();
  TextEditingController _controllerRevDueDateDialog = TextEditingController();
  TextEditingController _contrller_Email_Add_Subject = TextEditingController();
  TextEditingController _contrller_Email_Add_Content = TextEditingController();
  TextEditingController _eventHour = TextEditingController();
  TextEditingController _eventMinute = TextEditingController();

  AddditionalCharges addditionalCharges = AddditionalCharges();
  bool isUpdateCalculation = false;

  double Tot_otherChargeWithTax = 0.00;
  double Tot_otherChargeExcludeTax = 0.00;

  double HeaderDisAmnt = 0.00; //double.parse(edt_HeaderDisc.toString());
  List<OtherChargeDetails> arrGenericOtheCharge = [];

  TextEditingController _controller_reapeat = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _salesOrderBloc = SalesOrderBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();
    arr_ALL_Name_ID_For_Payment_Schedual_List.clear();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    getSelectOptionList();
    _eventHour.text = "00";
    _eventMinute.text = "00";
    _controller_reapeat.text = "0";
    _salesOrderBloc.add(SaleOrderBankDetailsListRequestEvent(
        SaleOrderBankDetailsListRequest(
            CompanyId: CompanyID.toString(),
            pkID: "",
            LoginUserID: LoginUserID)));
    _salesOrderBloc.add(QuotationProjectListCallEvent(
        QuotationProjectListRequest(
            CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));

    _salesOrderBloc.add(PaymentScheduleListEvent());

    _salesOrderBloc.add(GenericOtherChargeCallEvent(
        CompanyID.toString(), QuotationOtherChargesListRequest(pkID: "")));

    _salesOrderBloc.add(SOAssemblyTableALLDeleteEvent());

    _isForUpdate = widget.arguments != null;
    _controller_select_inquiry.addListener(() {
      setState(() {
        if (_controller_customer_pkID.text != null ||
            _controller_customer_pkID.text != "") {
          if (_controller_select_inquiry.text == "Inquiry") {
            _salesOrderBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                SaleBill_INQ_QT_SO_NO_ListRequest(
                    CompanyId: CompanyID.toString(),
                    CustomerID: _controller_customer_pkID.text.toString(),
                    ModuleType: "Inquiry")));
          } else if (_controller_select_inquiry.text == "Quotation") {
            _salesOrderBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                SaleBill_INQ_QT_SO_NO_ListRequest(
                    CompanyId: CompanyID.toString(),
                    CustomerID: _controller_customer_pkID.text.toString(),
                    ModuleType: "Quotation")));
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Customer name is required To view Option !",
              positiveButtonTitle: "OK");
        }
      });
    });
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      print("dljsf" + _offlineLoggedInData.details[0].CityCode.toString());
      _searchStateDetails = SearchStateDetails();
      edt_QualifiedCountry.text = "India";
      edt_QualifiedCountryCode.text = "IND";
      _searchStateDetails.value = _offlineLoggedInData.details[0].stateCode;
      edt_QualifiedState.text = _offlineLoggedInData.details[0].StateName;
      edt_QualifiedStateCode.text =
          _offlineLoggedInData.details[0].stateCode.toString();

      edt_QualifiedCity.text = _offlineLoggedInData.details[0].CityName;
      edt_QualifiedCityCode.text =
          _offlineLoggedInData.details[0].CityCode.toString();
      edt_StateCode.text = _offlineLoggedInData.details[0].stateCode.toString();

      _controller_order_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      _controller_rev_order_date.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      _controller_PI_date.text = selectedDatePI.day.toString() +
          "-" +
          selectedDatePI.month.toString() +
          "-" +
          selectedDatePI.year.toString();
      _controller_rev_PI_date.text = selectedDatePI.year.toString() +
          "-" +
          selectedDatePI.month.toString() +
          "-" +
          selectedDatePI.day.toString();
      _controller_reference_date.text = selectedDateRefrence.day.toString() +
          "-" +
          selectedDateRefrence.month.toString() +
          "-" +
          selectedDateRefrence.year.toString();
      _controller_rev_reference_date.text =
          selectedDateRefrence.year.toString() +
              "-" +
              selectedDateRefrence.month.toString() +
              "-" +
              selectedDateRefrence.day.toString();
      _controller_delivery_date.text = selectedDateDelivery.day.toString() +
          "-" +
          selectedDateDelivery.month.toString() +
          "-" +
          selectedDateDelivery.year.toString();
      _controller_rev_delivery_date.text =
          selectedDateDelivery.year.toString() +
              "-" +
              selectedDateDelivery.month.toString() +
              "-" +
              selectedDateDelivery.day.toString();
      _controller_work_order_date.text = selectedDateWorkOrder.day.toString() +
          "-" +
          selectedDateWorkOrder.month.toString() +
          "-" +
          selectedDateWorkOrder.year.toString();
      _controller_rev_work_order_date.text =
          selectedDateWorkOrder.year.toString() +
              "-" +
              selectedDateWorkOrder.month.toString() +
              "-" +
              selectedDateWorkOrder.day.toString();

      edt_StateCode.text = "";
      _salesOrderBloc.add(DeleteGenericAddditionalChargesEvent());

      _salesOrderBloc.add(AddGenericAddditionalChargesEvent(
          GenericAddditionalCharges("0.00", "0", "0.00", "0", "0.00", "0",
              "0.00", "0", "0.00", "0", "0.00", "", "", "", "", "")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _salesOrderBloc,
      child: BlocConsumer<SalesOrderBloc, SalesOrderStates>(
        builder: (BuildContext context, SalesOrderStates state) {
          //handle states

          if (state is QuotationProjectListResponseState) {
            _OnProjectList(state);
          }

          if (state is BankDetailsListResponseState) {
            _onBankDetailsList(state);
          }

          if (state is PaymentScheduleListResponseState) {
            _OnPaymentScheduleSucessList(state);
          }

          if (state is AddGenericAddditionalChargesState) {
            _OnGenericIsertCallSucess(state);
          }

          if (state is DeleteAllGenericAddditionalChargesState) {
            _onDeleteAllGenericAddtionalAmount(state);
          }

          if (state is SearchCustomerListByNumberCallResponseState) {
            _ONOnlyCustomerDetails(state);
          }

          if (state is GenericOtherCharge1ListResponseState) {
            _OnGenricOtherChargeResponse(state);
          }
          if (state is SOAssemblyTableDeleteALLState) {
            _onDeleteAllQTAssemblyResponse(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          if (currentState is BankDetailsListResponseState ||
              currentState is QuotationProjectListResponseState ||
              currentState is PaymentScheduleListResponseState ||
              currentState is AddGenericAddditionalChargesState ||
              currentState is DeleteAllGenericAddditionalChargesState ||
              currentState is SearchCustomerListByNumberCallResponseState ||
              currentState is GenericOtherCharge1ListResponseState ||
              currentState is SOAssemblyTableDeleteALLState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, SalesOrderStates state) {
          if (state is SalesBill_INQ_QT_SO_NO_ListResponseState) {
            _OnINQ_QT_SO_NO_Response(state);
          }
          if (state is MultiNoToProductDetailsResponseState) {
            _On_No_To_ProductDetails(state);
          }
          if (state is PaymentScheduleResponseState) {
            _onInsertPaymentScheduleSucess(state);
          }
          if (state is PaymentScheduleDeleteResponseState) {
            _ondeletePaymentSchedule(state);
          }

          if (state is PaymentScheduleEditResponseState) {
            OnUpdatePaymentSchedule(state);
          }

          if (state is SaleOrderHeaderSaveResponseState) {
            _OnSalesOrderHeaderSaveSucessResponse(state);
          }

          if (state is SaleOrderProductSaveResponseState) {
            _OnSaleOrderProductSaveResponse(state);
          }

          if (state is SOCurrencyListResponseState) {
            _ONCurrencyResponse(state);
          }

          if (state is SaveEmailContentResponseState) {
            _OnSaveEmailContentResponse(state);
          }

          if (state is SaleBillEmailContentResponseState) {
            _OnEmailContentResponse(state);
          }

          if (state is QuotationTermsCondtionResponseState) {
            _OnTermsAndConditionResponse(state);
          }

          return super.build(context);
          //handle states
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called

          if (currentState is SalesBill_INQ_QT_SO_NO_ListResponseState ||
              currentState is MultiNoToProductDetailsResponseState ||
              currentState is PaymentScheduleResponseState ||
              currentState is PaymentScheduleDeleteResponseState ||
              currentState is PaymentScheduleEditResponseState ||
              currentState is SaleOrderHeaderSaveResponseState ||
              currentState is SaleOrderProductSaveResponseState ||
              currentState is SOCurrencyListResponseState ||
              currentState is SaveEmailContentResponseState ||
              currentState is SaleBillEmailContentResponseState ||
              currentState is QuotationTermsCondtionResponseState) {
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
      child: DefaultTabController(
        length: 7,
        child: Scaffold(
            appBar: NewGradientAppBar(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple, Colors.red]),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 19,
                ),
                onPressed: () async {
                  await _onTapOfDeleteALLProduct();
                  navigateTo(context, SalesOrderListScreen.routeName,
                      clearAllStack: true);
                },
              ),
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
              title: Text("Manage Sales Order"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mandetoryDetails(),
                        space(10),
                        ProductAndAddtionalCharges(),
                        space(5),
                        basicInformation(),
                        space(5),
                        termsAndCondition(),
                        space(5),
                        emailContent(),
                        //space(5),
                        // paymentSchedule(),
                        //space(5),
                        shipmentDetail(),
                        //space(5),
                        //attachment(),
                        space(5),
                        shipmentAddress(),
                        space(20),
                        save(),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  } // Widget build(BuildContext context)

  Future<bool> _onBackPressed() async {
    // await _onTapOfDeleteALLProduct();
    await _onTapOfDeleteALLProduct();
    navigateTo(context, SalesOrderListScreen.routeName, clearAllStack: true);
  }

  Widget ProductDetails() {
    return Container(
      child: Text("Welcome To Tesla Bikes Collections"),
    );
  }

  Widget _buildOrderDate() {
    return InkWell(
      onTap: () {
        _selectOrderDate(
            context, _controller_order_date, _controller_rev_order_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 5,
          // ),
          Card(
            elevation: 3,
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
                    child: Text(
                      _controller_order_date.text == null ||
                              _controller_order_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_order_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_order_date.text == null ||
                                  _controller_order_date.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: dateFontSize),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                    size: 17,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPIDate() {
    return InkWell(
      onTap: () {
        _selectPIDate(context, _controller_PI_date, _controller_rev_PI_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  SizedBox(
            height: 5,
          ),*/
          Card(
            elevation: 3,
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
                    child: Text(
                      _controller_PI_date.text == null ||
                              _controller_PI_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_PI_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_PI_date.text == null ||
                                  _controller_PI_date.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: dateFontSize),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                    size: 17,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReferenceDate() {
    return InkWell(
      onTap: () {
        _selectRefrenceDate(context, _controller_reference_date,
            _controller_rev_reference_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  SizedBox(
            height: 5,
          ),*/
          Card(
            elevation: 3,
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
                    child: Text(
                      _controller_reference_date.text == null ||
                              _controller_reference_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_reference_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_reference_date.text == null ||
                                  _controller_reference_date.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: dateFontSize),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
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

  Widget _buildDeliveryDate() {
    return InkWell(
      onTap: () {
        _selectDeliveryDate(
            context, _controller_delivery_date, _controller_rev_delivery_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  SizedBox(
            height: 5,
          ),*/
          Card(
            elevation: 3,
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
                    child: Text(
                      _controller_delivery_date.text == null ||
                              _controller_delivery_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_delivery_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_delivery_date.text == null ||
                                  _controller_delivery_date.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: dateFontSize),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                    size: 17,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWorkOrdereDate() {
    return InkWell(
      onTap: () {
        _selectWorkOrderDate(context, _controller_work_order_date,
            _controller_rev_work_order_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  SizedBox(
            height: 5,
          ),*/
          Card(
            elevation: 3,
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
                    child: Text(
                      _controller_work_order_date.text == null ||
                              _controller_work_order_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_work_order_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_work_order_date.text == null ||
                                  _controller_work_order_date.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: dateFontSize),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                    size: 17,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDueDate() {
    return InkWell(
      onTap: () {
        _selectOrderDate(
            context, _controller_due_date, _controller_rev_due_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  SizedBox(
            height: 5,
          ),*/
          Card(
            elevation: 3,
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
                    child: Text(
                      _controller_due_date.text == null ||
                              _controller_due_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_due_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_due_date.text == null ||
                                  _controller_due_date.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: dateFontSize),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                    size: 17,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectOrderDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        F_datecontroller.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        Rev_dateController.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Future<void> _selectPIDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDatePI,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDatePI = picked;
        F_datecontroller.text = selectedDatePI.day.toString() +
            "-" +
            selectedDatePI.month.toString() +
            "-" +
            selectedDatePI.year.toString();
        Rev_dateController.text = selectedDatePI.year.toString() +
            "-" +
            selectedDatePI.month.toString() +
            "-" +
            selectedDatePI.day.toString();
      });
  }

  Future<void> _selectRefrenceDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateRefrence,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateRefrence = picked;
        F_datecontroller.text = selectedDateRefrence.day.toString() +
            "-" +
            selectedDateRefrence.month.toString() +
            "-" +
            selectedDateRefrence.year.toString();
        Rev_dateController.text = selectedDateRefrence.year.toString() +
            "-" +
            selectedDateRefrence.month.toString() +
            "-" +
            selectedDateRefrence.day.toString();
      });
  }

  Future<void> _selectDeliveryDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateDelivery,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateDelivery = picked;
        F_datecontroller.text = selectedDateDelivery.day.toString() +
            "-" +
            selectedDateDelivery.month.toString() +
            "-" +
            selectedDateDelivery.year.toString();
        Rev_dateController.text = selectedDateDelivery.year.toString() +
            "-" +
            selectedDateDelivery.month.toString() +
            "-" +
            selectedDateDelivery.day.toString();
      });
  }

  Future<void> _selectWorkOrderDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateWorkOrder,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateWorkOrder = picked;
        F_datecontroller.text = selectedDateWorkOrder.day.toString() +
            "-" +
            selectedDateWorkOrder.month.toString() +
            "-" +
            selectedDateWorkOrder.year.toString();
        Rev_dateController.text = selectedDateWorkOrder.year.toString() +
            "-" +
            selectedDateWorkOrder.month.toString() +
            "-" +
            selectedDateWorkOrder.day.toString();
      });
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createTextLabel("Search Customer *", 10.0, 0.0),
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
                    child: TextField(
                        controller: _controller_customer_name,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search customer",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 13,
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
            onTap: () {
              if (Category == "Currency") {
                _salesOrderBloc.add(SOCurrencyListRequestEvent(
                    SOCurrencyListRequest(
                        LoginUserID: LoginUserID,
                        CurrencyName: "",
                        CompanyID: CompanyID.toString())));
              } else {
                if (_controller_customer_name.text != "") {
                  arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List != [] ??
                      arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.clear();
                  _controller_Module_NO.text = "";

                  showcustomdialogWithOnlyName(
                      values: Custom_values1,
                      context1: context,
                      controller: controllerForLeft,
                      lable: "Select $Category");
                } else {
                  showCommonDialogWithSingleOption(
                      context, "CustomerName is required !",
                      positiveButtonTitle: "OK");
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*SizedBox(
                  height: 5,
                ),*/
                Card(
                  elevation: 3,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controllerForLeft,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 7),
                              hintText: hintTextvalue,
                              hintStyle:
                                  TextStyle(fontSize: 13, color: colorGrayDark),
                              labelStyle: TextStyle(
                                color: Color(0xFF000000),
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF000000),
                            )
                            // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                            ,
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

  Widget CustomDropDownWithID1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controllerForID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controllerID: controllerForID,
                lable: title),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*SizedBox(
                  height: 5,
                ),*/
                Card(
                  elevation: 3,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controllerForLeft,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 7),
                              hintText: hintTextvalue,
                              hintStyle:
                                  TextStyle(fontSize: 13, color: colorGrayDark),
                              labelStyle: TextStyle(
                                color: Color(0xFF000000),
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF000000),
                            )
                            // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                            ,
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

  Widget CustomDropDownWithMultiID1(
    String Category, {
    bool enable1,
    Icon icon,
    String title,
    String hintTextvalue,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _salesOrderBloc.add(QuotationTermsConditionCallEvent(
                  QuotationTermsConditionRequest(
                      CompanyId: CompanyID.toString(),
                      LoginUserID: LoginUserID)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*SizedBox(
                  height: 5,
                ),*/
                Card(
                  elevation: 3,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _contrller_select_terms_and_condition,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 7),
                              hintText: hintTextvalue,
                              hintStyle:
                                  TextStyle(fontSize: 13, color: colorGrayDark),
                              labelStyle: TextStyle(
                                color: Color(0xFF000000),
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF000000),
                            )
                            // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                            ,
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

  showcustomdialogWithOnlyName(
      {List<ALL_Name_ID> values,
      BuildContext context1,
      TextEditingController controller,
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
                  color: colorBlack, //                   <--- border color
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
                        color: colorBlack, fontWeight: FontWeight.bold),
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
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorBlack), //Change color
                                        width: 10.0,
                                        height: 10.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1.5),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        values[index].Name,
                                        style: TextStyle(color: colorBlack),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              /* return SimpleDialogOption(
                              onPressed: () => {
                                controller.text = values[index].Name,
                                controller2.text = values[index].Name1,
                              Navigator.of(context1).pop(),
                            },
                              child: Text(values[index].Name),
                            );*/
                            },
                            itemCount: values.length,
                          ),
                        ])),
                  ],
                )),
            /*Center(
            child: Container(
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: Color(0xFFF27442),
                  borderRadius: BorderRadius.all(Radius.circular(
                      5.0) //                 <--- border radius here
                  ),
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Color(0xFFF27442))),
              //color: Color(0xFFF27442),
              child: GestureDetector(
                child: Text(
                  "Close",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ),*/
          ],
        );
      },
    );
  }

  Widget createTextFormField(
      TextEditingController _controller, String _hintText,
      {int minLines = 1,
      int maxLines = 1,
      double height = 40,
      double left = 5,
      double right = 5,
      double top = 8,
      double bottom = 10,
      bool isEnable = true,
      double AllPadding = 0,
      TextInputType keyboardInput = TextInputType.number}) {
    return Card(
      color: colorLightGray,
      margin:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: height,
        padding: EdgeInsets.all(AllPadding),
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          minLines: minLines,
          maxLines: maxLines,
          enabled: isEnable,
          style: TextStyle(fontSize: 13),
          controller: _controller,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardInput,
          decoration: InputDecoration(
              hintText: _hintText,
              hintStyle: TextStyle(fontSize: 13, color: colorGrayDark),
              fillColor: colorLightGray,
              contentPadding: EdgeInsets.symmetric(horizontal: 14),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              )),
        ),
      ),
    );
  }

  Widget createTextLabel(String labelName, double leftPad, double rightPad) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: leftPad, right: rightPad),
        child: Row(
          children: [
            Text(labelName,
                style: TextStyle(
                    fontSize: 10,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _imageDialog(int index) {
    return Container(
      // height: 30,
      width: 10,
      // padding: EdgeInsets.only(left: 10),
      alignment: Alignment.center,
      child: Align(
        alignment: Alignment.center,
        child: ListTile(
          minVerticalPadding: 0,
          horizontalTitleGap: 0,
          visualDensity: VisualDensity(vertical: -3),
          // to compact
          // leading: Container(
          //   width: 0,
          //   margin: EdgeInsets.only(top: 5),
          // child: Icon(
          //   Icons.circle,
          //   color: Colors.indigo[900],
          //   size: 15,
          // ),
          // ),
          title: Container(
            // width: 5,
            padding: const EdgeInsets.all(0.0),

            // margin: EdgeInsets.only(right: 25),
            child: Container(
              padding: EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    // child: Icon(
                    //   Icons.circle,
                    //   color: Colors.indigo[900],
                    //   size: 10,
                    // ),
                  ),
                  Text(
                    imageDialog[index],
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.indigo[900],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            setState(() {
              imageDialogchoose = imageDialog[index].toString();
              _controller_image.text = imageDialogchoose;
              if (imageDialogchoose == 'Gallery') {
                _openGallery(context);
              } else if (imageDialogchoose == 'Camera') {
                _openCamera(context);
              }
              Navigator.of(context).pop();
            });
          },
        ),
      ),
    );
  }

//Customer/{pageNo}-{PageSize}
  Future _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile;
      _image = File(imageFile.path);
      fileName = imageFile.path.split('/').last;
      if (imageFile != null) {
        img_visible = true;
      }
    });

    // Navigator.pop(context);
  }

  Future _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile;
      _image = File(imageFile.path);
      fileName = imageFile.path.split('/').last;
      if (imageFile != null) {
        img_visible = true;
      }
    });

    // Navigator.pop(context);
  }

  Future<void> _onTapOfSearchView() async {
    await _onTapOfDeleteALLProduct();

    if (_isForUpdate == false) {
      navigateTo(context, SearchInquiryCustomerScreen.routeName).then((value) {
        if (value != null) {
          searchCustomerDetails = value;
          _controller_customer_name.text = searchCustomerDetails.label;
          _controller_customer_pkID.text =
              searchCustomerDetails.value.toString();

          arr_ALL_Name_ID_For_INQ_QT_SO_List.clear();
          arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.clear();
          _controller_Module_NO.text = "";
          _controller_select_inquiry.text = "";

          edt_StateCode.text = searchCustomerDetails.stateCode.toString();
        }
      });
    }
  }

  mandetoryDetails() {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 1),
      margin: EdgeInsets.symmetric(vertical: 10),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(child: createTextLabel("Order No.", 10.0, 0.0)),
                  Flexible(
                    flex: 2,
                    child: createTextLabel("Order Date", 10.0, 0.0),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: createTextFormField(
                        _controller_order_no, "Order No.",
                        isEnable: false),
                  ),
                  Flexible(flex: 2, child: _buildOrderDate())
                ],
              ),
              SizedBox(
                width: 20,
                height: 15,
              ),
              _buildSearchView(),
              SizedBox(
                height: 10,
              ),
              createTextLabel("Bank Name *", 10.0, 0.0),
              CustomDropDownWithID1("BankName",
                  enable1: false,
                  title: "Select Bank",
                  hintTextvalue: "Tap to Select Bank",
                  icon: Icon(Icons.arrow_drop_down),
                  controllerForLeft: _controller_bank_name,
                  controllerForID: _controller_bank_ID,
                  Custom_values1: arr_ALL_Name_ID_For_Sales_Order_Bank_Name),
              SizedBox(
                height: 10,
              ),
              _isForUpdate != true
                  ? Column(
                      children: [
                        createTextLabel("Select Option", 10.0, 0.0),
                        CustomDropDown1("Option",
                            enable1: false,
                            title: "Select Option",
                            hintTextvalue: "Tap to select",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: _controller_select_inquiry,
                            Custom_values1:
                                arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry),
                        // createTextLabel("Inq/QT/SO No.", 10.0, 0.0),
                        SizedBox(
                          height: 15,
                        ),
                        _ModuleDropDown(context)
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      // height: 60,
    );
  }

  productDetails() {
    return Container(
        margin: EdgeInsets.all(10),
        child: getCommonButton(baseTheme, () {
          if (_controller_customer_name.text != "") {
            // print("INWWWE" + InquiryNo.toString());

            navigateTo(context, SOProductListScreen.routeName,
                arguments: SOProductListArgument(
                    SalesOrderNo, edt_StateCode.text, edt_HeaderDisc.text));
          } else {
            showCommonDialogWithSingleOption(
                context, "Customer name is required To view Product !",
                positiveButtonTitle: "OK");
          }
        }, "Products",
            width: 600,
            textColor: colorPrimary,
            backGroundColor: colorGreenLight,
            radius: 25.0));
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<SalesOrderTable> temp =
        await OfflineDbHelper.getInstance().getSalesOrderProduct();
    print("Prodiuucy" + temp.length.toString());
    _inquiryProductList.addAll(temp);
    setState(() {});
  }

  basicInformation() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff362d8b), borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Basic Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      BASIC_INFORMATION,
                      width: 27,
                    ),
                  ),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        /* Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Select Option", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Inq/QT/SO No.", 10.0, 0.0),
                            ),
                          ],
                        ),*/

                        SizedBox(
                          height: 10,
                        ),
                        createTextLabel("Sales Executive", 10.0, 0.0),
                        SizedBox(
                          height: 3,
                        ),
                        _buildEmplyeeListView(),
                        SizedBox(
                          height: 10,
                        ),
                        /*createTextLabel("Projects", 10.0, 0.0),
                        SizedBox(
                          height: 3,
                        ),
                        CustomDropDownWithID1("Project",
                            enable1: false,
                            title: "Select Project",
                            hintTextvalue: "Tap to Select Projects",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: _controller_projectName,
                            controllerForID: _controller_projectID,
                            Custom_values1: arr_ALL_Name_ID_For_ProjectList),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: createTextLabel("PI No.", 10.0, 0.0),
                            ),
                            Flexible(
                              flex: 1,
                              child: createTextLabel("PI Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: createTextFormField(
                                  _controller_PINO, "PI No."),
                            ),
                            Flexible(flex: 1, child: _buildPIDate())
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Reference No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Reference Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_reference_no, "Reference No."),
                            ),
                            Flexible(child: _buildReferenceDate())
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Select Currency", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Delivery Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: CustomDropDown1("Currency",
                                  enable1: false,
                                  title: "Select Currency",
                                  hintTextvalue: "Tap to Select Currency",
                                  icon: Icon(Icons.arrow_drop_down),
                                  controllerForLeft: _controller_currency,
                                  Custom_values1:
                                      arr_ALL_Name_ID_For_Sales_Order_Select_Currency),
                            ),
                            Flexible(child: _buildDeliveryDate())
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Work Order No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Work Order Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: createTextFormField(
                                    _controller_work_order_no,
                                    "Work Order No")),
                            Flexible(child: _buildWorkOrdereDate())
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Exchange Rate", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel("Credit Days", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: createTextFormField(
                                    _controller_exchange_rate,
                                    "Exchange Rate")),
                            Flexible(
                                child: createTextFormField(
                                    _controller_credit_days, "Credit Days"))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                    */
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  termsAndCondition() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff362d8b), borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Terms & Condition",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      CREDIT_INFORMATION,
                      width: 27,
                    ),
                  ),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        createTextLabel("Select Terms & Condition", 10.0, 0.0),
                        SizedBox(
                          height: 3,
                        ),
                        CustomDropDownWithMultiID1(
                          "Terms & Conditions",
                          enable1: false,
                          title: "Terms & Conditions",
                          hintTextvalue: "Tap to Select Terms & Conditions",
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        createTextLabel("Terms & Condition", 10.0, 0.0),
                        createTextFormField(
                            _contrller_terms_and_condition, "Terms & Condition",
                            minLines: 2,
                            maxLines: 8,
                            height: 120,
                            AllPadding: 10,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        /* createTextLabel("Delivery Terms", 10.0, 0.0),
                        createTextFormField(
                            _contrller_delivery_terms, "Delivery Terms",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        createTextLabel("Payment Terms", 10.0, 0.0),
                        createTextFormField(
                            _contrller_payment_terms, "Payment terms",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            bottom: 5,
                            keyboardInput: TextInputType.text),*/
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  emailContent() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff362d8b), borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Email Content",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      EMAIL,
                      width: 27,
                      color: Colors.white,
                    ),
                  ),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        createTextLabel("Select Email Content", 10.0, 0.0),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: EmailSubjectWithMultiID1("Email Subject",
                                  enable1: false,
                                  title: "Email Subject",
                                  hintTextvalue: "Tap to Select Email Content",
                                  icon: Icon(Icons.arrow_drop_down),
                                  Custom_values1:
                                      arr_ALL_Name_ID_For_Email_Subject),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 42,
                                alignment: Alignment.topRight,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    // Add your onPressed code here!
                                    //await _onTapOfDeleteALLProduct();
                                    showcustomdialogEmailContent(
                                        context1: context, Email: "sdfj");
                                    // navigateTo(context, QuotationAddEditScreen.routeName);
                                  },
                                  child: const Icon(Icons.add),
                                  backgroundColor: Colors.pinkAccent,
                                ),
                              ),
                            )
                          ],
                        ),
                        /*CustomDropDown1("Email Subject",
                            enable1: false,
                            title: "Email Subject",
                            hintTextvalue: "Tap to Select Subject",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: _controller_select_email_subject,
                            Custom_values1: arr_ALL_Name_ID_For_Email_Subject),*/
                        SizedBox(
                          height: 10,
                        ),
                        createTextLabel("Subject", 10.0, 0.0),
                        createTextFormField(
                            _controller_select_email_subject, "Email Subject",
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        createTextLabel("Email Introduction", 10.0, 0.0),
                        createTextFormField(
                            _contrller_email_subject, "Email Introduction",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            bottom: 5,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  paymentSchedule() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff362d8b),
              borderRadius: BorderRadius.circular(20)),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Payment Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(child: Icon(Icons.attach_money)),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        arr_PaymentScheduleList.length != 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: arr_PaymentScheduleList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //return _buildSearchInquiryListItem(index);
                                  return Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        child: Column(children: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: ListTile(
                                                    title: Text(
                                                      'Amount',
                                                      style: TextStyle(
                                                          color: colorPrimary),
                                                    ),
                                                    subtitle: Text(
                                                      '${arr_PaymentScheduleList[index].amount.toString()}',
                                                      style: TextStyle(
                                                          color: colorBlack,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Container(
                                                    child: ListTile(
                                                      title: Text(
                                                        'Date',
                                                        style: TextStyle(
                                                            color:
                                                                colorPrimary),
                                                      ),
                                                      subtitle: Text(
                                                        '${arr_PaymentScheduleList[index].dueDate.toString()}',
                                                        style: TextStyle(
                                                            color: colorBlack,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            thickness: 1,
                                            color: colorPrimary,
                                          ),
                                          ButtonBar(
                                              alignment:
                                                  MainAxisAlignment.spaceAround,
                                              buttonMinWidth: 90.0,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    _controllerAmountDialog
                                                            .text =
                                                        arr_PaymentScheduleList[
                                                                index]
                                                            .amount
                                                            .toStringAsFixed(2);
                                                    _controllerDueDateDialog
                                                            .text =
                                                        arr_PaymentScheduleList[
                                                                index]
                                                            .dueDate
                                                            .toString();
                                                    _controllerRevDueDateDialog
                                                            .text =
                                                        arr_PaymentScheduleList[
                                                                index]
                                                            .revdueDate
                                                            .toString();

                                                    showcustomdialogSendEmail(
                                                        context1: context,
                                                        updatedID:
                                                            arr_PaymentScheduleList[
                                                                    index]
                                                                .id);
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: colorPrimary,
                                                    size: 24,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _salesOrderBloc.add(
                                                        PaymentScheduleDeleteEvent(
                                                            arr_PaymentScheduleList[
                                                                    index]
                                                                .id));
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: colorPrimary,
                                                    size: 24,
                                                  ),
                                                ),
                                              ]),
                                        ]),
                                      ));
                                  /*return Row(
                                    children: [
                                      Text(arr_PaymentScheduleList[index]
                                          .dueDate
                                          .toString()),
                                      Flexible(
                                          child: getCommonButton(baseTheme, () {
                                        print("deleteID" +
                                            arr_PaymentScheduleList[index]
                                                .id
                                                .toString());
                                        _salesOrderBloc.add(
                                            PaymentScheduleDeleteEvent(
                                                arr_PaymentScheduleList[index]
                                                    .id));

                                      }, "del"))
                                    ],
                                  );*/
                                },
                              )
                            : Container(),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: createTextLabel("Amount", 10.0, 0.0),
                            ),
                            Expanded(
                              flex: 2,
                              child: createTextLabel("Due Date", 10.0, 0.0),
                            ),
                            Expanded(
                              child: createTextLabel("", 10.0, 0.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: createTextFormField(
                                    _controller_amount, "Amount")),
                            Expanded(
                              flex: 2,
                              child: _buildDueDate(),
                            ),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(left: 5),
                              child: getCommonButton(baseTheme, () {
                                //  ALL_Name_ID all_name_id = ALL_Name_ID();

                                /* all_name_id.Name = _controller_amount.text;
                              all_name_id.PresentDate =
                                    _controller_rev_due_date.text;

                              arr_ALL_Name_ID_For_Payment_Schedual_List
                                    .add(all_name_id);
                              _controllers.add(new TextEditingController());
                              _controllers1.add(new TextEditingController());
                              _controllers2.add(new TextEditingController());*/
                                //  SoPaymentScheduleTable()

                                if (_controller_amount.text != "") {
                                  if (_controller_due_date.text != "") {
                                    setState(() {
                                      _salesOrderBloc.add(PaymentScheduleEvent(
                                          SoPaymentScheduleTable(
                                              double.parse(
                                                  _controller_amount.text),
                                              _controller_due_date.text,
                                              _controller_rev_due_date.text)));

                                      _controller_amount.text = "";
                                      _controller_due_date.text = "";
                                      _controller_rev_due_date.text = "";
                                    });
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Date is Required !",
                                        positiveButtonTitle: "OK");
                                  }
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Amount is Required !",
                                      positiveButtonTitle: "OK");
                                }
                              }, "+", width: 42, height: 42, radius: 15),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  shipmentDetail() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff362d8b), borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Shipment Detail",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(child: Icon(Icons.local_shipping_outlined)),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        createTextLabel(
                            "Pre Carriage By (Transporter Name)", 10.0, 0.0),
                        createTextFormField(
                            _controller_transport_name, "Enter Transport Name",
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        createTextLabel(
                            "Place Of Rec.By Pre Carrier", 10.0, 0.0),
                        createTextFormField(
                            _controller_place_of_rec, "Enter Place",
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextLabel(
                                  "Vessel/Flight No", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Port Of Loading", 10.0, 0.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_flight_no, "Enter Flight No.",
                                  keyboardInput: TextInputType.text),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_port_of_loading,
                                  "Enter Port Of Loading",
                                  keyboardInput: TextInputType.text),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextLabel(
                                  "Port Of Dispatch", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel(
                                  "Port Of Destination", 10.0, 0.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_port_of_dispatch,
                                  "Enter Port Of Dispatch",
                                  keyboardInput: TextInputType.text),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_port_of_destination,
                                  "Enter Port Of Destination",
                                  keyboardInput: TextInputType.text),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Container No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel("Packages", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_container_no,
                                  "Enter Container No.",
                                  keyboardInput: TextInputType.text),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_packages, "Enter Packages",
                                  keyboardInput: TextInputType.text),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Packages Types", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Net Weight(KGs)", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_type_of_package,
                                  "Enter packages type",
                                  keyboardInput: TextInputType.text),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_net_weight, "Enter Net Weight",
                                  keyboardInput:
                                      TextInputType.numberWithOptions(
                                          decimal: true)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextLabel(
                                  "Gross Weight(KGs)", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel(
                                  "FOB (Free Of Board)", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_gross_weight,
                                  "Enter Gross Weight",
                                  keyboardInput:
                                      TextInputType.numberWithOptions(
                                          decimal: true)),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_FOB, "Enter FOB",
                                  keyboardInput: TextInputType.text),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  attachment() {
    return Container();
  }

  shipmentAddress() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xff362d8b), borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Shipment Address",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(child: Icon(Icons.location_on)),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        createTextLabel("Company Name", 10.0, 0.0),
                        createTextFormField(
                            _controller_company_name, "Company Name",
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                        createTextLabel("Contact Person Name", 10.0, 0.0),
                        createTextFormField(_controller_contact_person_name,
                            "Contact Person Name",
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel("Contact No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel("GST No.", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 2,
                                child: createTextFormField(
                                    _controller_contact_no,
                                    "Enter Contact No.")),
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    _controller_GSTNO, "Enter GSTNo.",
                                    keyboardInput: TextInputType.text)),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        createTextLabel("Address", 10.0, 0.0),
                        createTextFormField(
                            _controller_address, "Enter Address",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel("Area", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 2,
                                child: createTextFormField(
                                    _controller_area, "Enter Area",
                                    keyboardInput: TextInputType.text)),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: QualifiedCountry()),
                            Expanded(flex: 1, child: QualifiedState()),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: QualifiedCity()),
                            Expanded(flex: 1, child: QualifiedPinCode()),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  save() {
    return // Save
        Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            child: getCommonButton(
              baseTheme,
              () async {
                print("fjsfjjjsdffkjsdfj" +
                    _controller_currency_Symbol.text +
                    " Name : " +
                    _controller_currency.text);
                if (_controller_order_date.text != "") {
                  if (_controller_customer_name.text != "") {
                    if (_controller_bank_name.text != "") {
                      List<SalesOrderTable> temp =
                          await OfflineDbHelper.getInstance()
                              .getSalesOrderProduct();

                      if (temp.length != 0) {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to Save this SalesOrder ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () async {
                          Navigator.of(context).pop();

                          if (SalesOrderNo != '') {
                            _salesOrderBloc.add(
                                SalesOrderProductDeleteRequestEvent(
                                    pkID,
                                    SalesOrderAllProductDeleteRequest(
                                        CompanyId: CompanyID.toString())));
                          } else {}

                          HeaderDisAmnt = edt_HeaderDisc.text.isNotEmpty
                              ? double.parse(edt_HeaderDisc.text)
                              : 0.00;

                          List<SalesOrderTable> TempproductList1 =
                              SalesOrderHeaderDiscountCalculation
                                  .txtHeadDiscount_WithZero(
                                      temp,
                                      HeaderDisAmnt,
                                      _offlineLoggedInData.details[0].stateCode
                                          .toString(),
                                      edt_StateCode.text.toString());

                          List<SalesOrderTable> TempproductList =
                              SalesOrderHeaderDiscountCalculation
                                  .txtHeadDiscount_TextChanged(
                                      TempproductList1,
                                      HeaderDisAmnt,
                                      _offlineLoggedInData.details[0].stateCode
                                          .toString(),
                                      edt_StateCode.text.toString());

                          for (int i = 0; i < temp.length; i++) {
                            print("productList" +
                                " AmountFromProductList : " +
                                temp[i].DiscountPercent.toString() +
                                " NetAmountFromProductList : " +
                                temp[i].DiscountAmt.toString() +
                                " NetRate : " +
                                temp[i].NetRate.toString() +
                                " BasicAmount : " +
                                temp[i].Amount.toString() +
                                " NetAmnount : " +
                                temp[i].NetAmount.toString());
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

                          List<GenericAddditionalCharges>
                              quotationOtherChargesListResponse =
                              await OfflineDbHelper.getInstance()
                                  .getGenericAddditionalCharges();

                          List<double> finalPrice =
                              UpdateHeaderDiscountCalculation(TempproductList,
                                  quotationOtherChargesListResponse);

                          for (int i = 0; i < finalPrice.length; i++) {
                            print("finalCalfk" + finalPrice[i].toString());
                          }

                          _salesOrderBloc.add(SaleOrderHeaderSaveRequestEvent(
                            context,
                            pkID,
                            SaleOrderHeaderSaveRequest(
                              CompanyId: CompanyID.toString(),
                              OrderNo: _controller_order_no.text,
                              OrderDate: _controller_rev_order_date.text,
                              LoginUserID: LoginUserID,
                              CustomerId: _controller_customer_pkID.text,
                              QuotationNo: "",
                              DeliveryDate: _controller_rev_delivery_date.text,
                              TermsCondition:
                                  _contrller_terms_and_condition.text,
                              Latitude: SharedPrefHelper.instance.getLatitude(),
                              Longitude:
                                  SharedPrefHelper.instance.getLongitude(),
                              DiscountAmt: edt_HeaderDisc.text.toString(),
                              SGSTAmt: finalPrice[4].toStringAsFixed(2),
                              CGSTAmt: finalPrice[3].toStringAsFixed(2),
                              IGSTAmt: finalPrice[5].toStringAsFixed(2),
                              ChargeID1: quotationOtherChargesListResponse[0]
                                  .ChargeID1,
                              ChargeAmt1: quotationOtherChargesListResponse[0]
                                  .ChargeAmt1,
                              ChargeBasicAmt1: finalPrice[6].toStringAsFixed(2),
                              ChargeGSTAmt1: finalPrice[11].toStringAsFixed(2),
                              ChargeID2: quotationOtherChargesListResponse[0]
                                  .ChargeID2,
                              ChargeAmt2: quotationOtherChargesListResponse[0]
                                  .ChargeAmt2,
                              ChargeBasicAmt2: finalPrice[7].toStringAsFixed(2),
                              ChargeGSTAmt2: finalPrice[12].toStringAsFixed(2),
                              ChargeID3: quotationOtherChargesListResponse[0]
                                  .ChargeID3,
                              ChargeAmt3: quotationOtherChargesListResponse[0]
                                  .ChargeAmt3,
                              ChargeBasicAmt3: finalPrice[8].toStringAsFixed(2),
                              ChargeGSTAmt3: finalPrice[13].toStringAsFixed(2),
                              ChargeID4: quotationOtherChargesListResponse[0]
                                  .ChargeID4,
                              ChargeAmt4: quotationOtherChargesListResponse[0]
                                  .ChargeAmt4,
                              ChargeBasicAmt4: finalPrice[9].toStringAsFixed(2),
                              ChargeGSTAmt4: finalPrice[14].toStringAsFixed(2),
                              ChargeID5: quotationOtherChargesListResponse[0]
                                  .ChargeID5,
                              ChargeAmt5: quotationOtherChargesListResponse[0]
                                  .ChargeAmt5,
                              ChargeBasicAmt5:
                                  finalPrice[10].toStringAsFixed(2),
                              ChargeGSTAmt5: finalPrice[15].toStringAsFixed(2),
                              NetAmt: finalPrice[17].toStringAsFixed(2),
                              BasicAmt: finalPrice[0].toStringAsFixed(2),
                              ROffAmt: finalPrice[18].toStringAsFixed(2),
                              ApprovalStatus: "",
                              ChargePer1: "0.00",
                              ChargePer2: "0.00",
                              ChargePer3: "0.00",
                              ChargePer4: "0.00",
                              ChargePer5: "0.00",
                              AdvancePer: "0.00",
                              AdvanceAmt: "0.00",
                              CurrencyName:
                                  _controller_currency.text.toString() ??
                                      _controller_currency.text,
                              CurrencySymbol:
                                  _controller_currency_Symbol.text.toString() ??
                                      _controller_currency_Symbol.text,
                              ExchangeRate: _controller_exchange_rate.text,
                              RefType: "",
                              EmailHeader: _contrller_email_subject.text,
                              EmailContent:
                                  _controller_select_email_subject.text,
                            ),
                            SOShipmentSaveRequest(
                              OrderNo: "",
                              SCompanyName: _controller_company_name.text,
                              SGSTNo: _controller_GSTNO.text,
                              SContactNo: _controller_contact_no.text,
                              SContactPersonName:
                                  _controller_contact_person_name.text,
                              SAddress: _controller_address.text,
                              SArea: _controller_area.text,
                              SCountryCode: edt_QualifiedCountryCode.text,
                              SCityCode: edt_QualifiedCityCode.text,
                              SStateCode: edt_QualifiedStateCode.text,
                              SPincode: edt_QualifiedPinCode.text,
                              LoginUserID: LoginUserID,
                              CompanyId: CompanyID.toString(),
                            ),
                            SOExportSaveRequest(
                              OrderNo: "",
                              PreCarrBy:
                                  _controller_transport_name.text.toString(),
                              PreCarrRecPlace:
                                  _controller_place_of_rec.text.toString(),
                              FlightNo: _controller_flight_no.text.toString(),
                              PortOfLoading:
                                  _controller_port_of_loading.text.toString(),
                              PortOfDispatch:
                                  _controller_port_of_dispatch.text.toString(),
                              PortOfDestination: _controller_port_of_destination
                                  .text
                                  .toString(),
                              MarksNo: _controller_container_no.text.toString(),
                              Packages: _controller_packages.text.toString(),
                              NetWeight: _controller_net_weight.text.toString(),
                              GrossWeight:
                                  _controller_gross_weight.text.toString(),
                              PackageType:
                                  _controller_type_of_package.text.toString(),
                              FreeOnBoard: _controller_FOB.text.toString(),
                              LoginUserID: LoginUserID.toString(),
                              CompanyId: CompanyID.toString(),
                            ),
                          ));
                        });
                      } else {
                        showCommonDialogWithSingleOption(
                            context, "ProductDetails is required !",
                            positiveButtonTitle: "OK",
                            onTapOfPositiveButton: () {
                          Navigator.pop(context);
                        });
                      }
                    } else {
                      showCommonDialogWithSingleOption(
                          context, "Bank Name is required !",
                          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    showCommonDialogWithSingleOption(
                        context, "CustomerName is required !",
                        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                      Navigator.pop(context);
                    });
                  }
                } else {
                  showCommonDialogWithSingleOption(
                      context, "SaleOrder date is required !",
                      positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                    Navigator.pop(context);
                  });
                }
              },
              "Save",
              backGroundColor: Color(0xff362d8b),
              radius: 18,
            ));
  }

  List<double> UpdateHeaderDiscountCalculation(
      List<SalesOrderTable> tempproductList,
      List<GenericAddditionalCharges> quotationOtherChargesListResponse1) {
    if (tempproductList != null) {
      ///From OtherCharge DropDown API
      String _otherChargeTaxTypeController1 = "";
      String _otherChargeTaxTypeController2 = "";
      String _otherChargeTaxTypeController3 = "";
      String _otherChargeTaxTypeController4 = "";
      String _otherChargeTaxTypeController5 = "";

      String _otherChargeBeForeGSTController1 = "";
      String _otherChargeBeForeGSTController2 = "";
      String _otherChargeBeForeGSTController3 = "";
      String _otherChargeBeForeGSTController4 = "";
      String _otherChargeBeForeGSTController5 = "";

      String _otherChargeGSTPerController1 = "";
      String _otherChargeGSTPerController2 = "";
      String _otherChargeGSTPerController3 = "";
      String _otherChargeGSTPerController4 = "";
      String _otherChargeGSTPerController5 = "";

      /// From GenericAddtionalCharge DB Table
      String _otherChargeIDController1 = "";
      String _otherChargeIDController2 = "";
      String _otherChargeIDController3 = "";
      String _otherChargeIDController4 = "";
      String _otherChargeIDController5 = "";

      String _otherChargeNameController1 = "";
      String _otherChargeNameController2 = "";
      String _otherChargeNameController3 = "";
      String _otherChargeNameController4 = "";
      String _otherChargeNameController5 = "";

      String _otherAmount1 = "";
      String _otherAmount2 = "";
      String _otherAmount3 = "";
      String _otherAmount4 = "";
      String _otherAmount5 = "";

      double Tot_BasicAmount = 0.00;
      double Tot_GSTAmt = 0.00;
      double Tot_CGSTAmt = 0.00;
      double Tot_SGSTAmt = 0.00;
      double Tot_IGSTAmt = 0.00;

      double Tot_NetAmt = 0.00;
      Tot_otherChargeWithTax = 0.0;
      Tot_otherChargeExcludeTax = 0.0;
      List<GenericAddditionalCharges> quotationOtherChargesListResponse =
          quotationOtherChargesListResponse1;

      _otherChargeIDController1 =
          quotationOtherChargesListResponse[0].ChargeID1;
      _otherChargeIDController2 =
          quotationOtherChargesListResponse[0].ChargeID2;
      _otherChargeIDController3 =
          quotationOtherChargesListResponse[0].ChargeID3;
      _otherChargeIDController4 =
          quotationOtherChargesListResponse[0].ChargeID4;
      _otherChargeIDController5 =
          quotationOtherChargesListResponse[0].ChargeID5;

      _otherChargeNameController1 =
          quotationOtherChargesListResponse[0].ChargeName1;
      _otherChargeNameController2 =
          quotationOtherChargesListResponse[0].ChargeName2;
      _otherChargeNameController3 =
          quotationOtherChargesListResponse[0].ChargeName3;
      _otherChargeNameController4 =
          quotationOtherChargesListResponse[0].ChargeName4;
      _otherChargeNameController5 =
          quotationOtherChargesListResponse[0].ChargeName5;

      _otherAmount1 = quotationOtherChargesListResponse[0].ChargeAmt1;
      _otherAmount2 = quotationOtherChargesListResponse[0].ChargeAmt2;
      _otherAmount3 = quotationOtherChargesListResponse[0].ChargeAmt3;
      _otherAmount4 = quotationOtherChargesListResponse[0].ChargeAmt4;
      _otherAmount5 = quotationOtherChargesListResponse[0].ChargeAmt5;

      // productList.clear();

      for (int i = 0; i < tempproductList.length; i++) {
        print("Amount" +
            tempproductList[i].Amount.toString() +
            "NetAmount : " +
            tempproductList[i].Amount.toString());
        // productList.add(tempproductList[i]);
        Tot_BasicAmount += tempproductList[i].Amount;
        Tot_otherChargeWithTax = 0.00;

        ///Before Gst
        Tot_GSTAmt += tempproductList[i].TaxAmount;
        Tot_CGSTAmt += tempproductList[i].CGSTAmt;
        Tot_SGSTAmt += tempproductList[i].SGSTAmt;
        Tot_IGSTAmt += tempproductList[i].IGSTAmt;

        Tot_otherChargeExcludeTax = 0.00;

        ///AFTER gst
        Tot_NetAmt += tempproductList[i].NetAmount;
      }

      print("FinalAmount" +
          " BasicAmount : " +
          Tot_BasicAmount.toString() +
          " TotalGST Amnt : " +
          Tot_GSTAmt.toString() +
          " Tot_NetAmt : " +
          Tot_NetAmt.toString());

      HeaderDisAmnt = edt_HeaderDisc.text.isNotEmpty
          ? double.parse(edt_HeaderDisc.text)
          : 0.00;

      List<double> hdnOthChrgGST1hdnOthChrgBasic1 = [],
          hdnOthChrgGST1hdnOthChrgBasic2 = [],
          hdnOthChrgGST1hdnOthChrgBasic3 = [],
          hdnOthChrgGST1hdnOthChrgBasic4 = [],
          hdnOthChrgGST1hdnOthChrgBasic5 = [];

      Tot_otherChargeWithTax = 0.00;

      for (int i = 0; i < arrGenericOtheCharge.length; i++) {
        print("TAXXXXX" + arrGenericOtheCharge[i].chargeName);
        if (_otherChargeIDController1 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController1 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController1 =
              arrGenericOtheCharge[i].beforeGST.toString();

          _otherChargeGSTPerController1 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }

        if (_otherChargeIDController2 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController2 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController2 =
              arrGenericOtheCharge[i].beforeGST.toString();
          _otherChargeGSTPerController2 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }
        if (_otherChargeIDController3 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController3 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController3 =
              arrGenericOtheCharge[i].beforeGST.toString();
          _otherChargeGSTPerController3 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }
        if (_otherChargeIDController4 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController4 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController4 =
              arrGenericOtheCharge[i].beforeGST.toString();
          _otherChargeGSTPerController4 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }
        if (_otherChargeIDController5 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController5 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController5 =
              arrGenericOtheCharge[i].beforeGST.toString();
          _otherChargeGSTPerController5 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }
      }

      if (_otherChargeNameController1.isNotEmpty) {
        if (_otherChargeNameController1.toString() != "null") {
          print("AA1" + _otherChargeBeForeGSTController1.toString());

          hdnOthChrgGST1hdnOthChrgBasic1 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController1.isNotEmpty
                      ? int.parse(_otherChargeIDController1)
                      : 0,
                  _otherAmount1.isNotEmpty ? double.parse(_otherAmount1) : 0.00,
                  _otherChargeGSTPerController1.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController1)
                      : 0.00,
                  _otherChargeTaxTypeController1.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController1.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController1.toString())
                      : 0,
                  _otherChargeBeForeGSTController1.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController1 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic1[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic1[1];
          }
        } else {
          _otherChargeNameController1 = "";
        }
      }
      if (_otherChargeNameController2.isNotEmpty) {
        if (_otherChargeNameController2.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic2 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController2.isNotEmpty
                      ? int.parse(_otherChargeIDController2)
                      : 0,
                  _otherAmount2.isNotEmpty ? double.parse(_otherAmount2) : 0.00,
                  _otherChargeGSTPerController2.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController2)
                      : 0.00,
                  _otherChargeTaxTypeController2.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController2.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController2.toString())
                      : 0,
                  _otherChargeBeForeGSTController2.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController2 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic2[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic2[1];
          }
        } else {
          _otherChargeNameController2 = "";
        }
      }

      print("ds9980" + _otherChargeNameController3.toString());
      if (_otherChargeNameController3.isNotEmpty) {
        if (_otherChargeNameController3.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic3 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController3.isNotEmpty
                      ? int.parse(_otherChargeIDController3)
                      : 0,
                  _otherAmount3.isNotEmpty ? double.parse(_otherAmount3) : 0.00,
                  _otherChargeGSTPerController3.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController3)
                      : 0.00,
                  _otherChargeTaxTypeController3.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController3.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController3.toString())
                      : 0,
                  _otherChargeBeForeGSTController3.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController3 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic3[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic3[1];
          }
        } else {
          _otherChargeNameController3 = "";
        }
      }

      if (_otherChargeNameController4.isNotEmpty) {
        if (_otherChargeNameController4.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic4 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController4.isNotEmpty
                      ? int.parse(_otherChargeIDController4)
                      : 0,
                  _otherAmount4.isNotEmpty ? double.parse(_otherAmount4) : 0.00,
                  _otherChargeGSTPerController4.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController4)
                      : 0.00,
                  _otherChargeTaxTypeController4.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController4.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController4.toString())
                      : 0,
                  _otherChargeBeForeGSTController4.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController4 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          }
        } else {
          _otherChargeNameController4 = "";
        }
      }

      if (_otherChargeNameController5.isNotEmpty) {
        if (_otherChargeNameController5.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic5 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController5.isNotEmpty
                      ? int.parse(_otherChargeIDController5)
                      : 0,
                  _otherAmount5.isNotEmpty ? double.parse(_otherAmount5) : 0.00,
                  _otherChargeGSTPerController5.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController5)
                      : 0.00,
                  _otherChargeTaxTypeController5.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController5.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController5.toString())
                      : 0,
                  _otherChargeBeForeGSTController5.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController5 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          }
        } else {
          _otherChargeNameController5 = "";
        }
      }

      /*if (_otherChargeNameController4.isNotEmpty) {
        if (_otherChargeNameController4.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic4 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  int.parse(_otherChargeIDController4),
                  double.parse(_otherAmount4),
                  double.parse(_otherChargeGSTPerController4),
                  int.parse(_otherChargeTaxTypeController4.toString() == "0.00"
                      ? "0"
                      : _otherChargeTaxTypeController4.toString()),
                  _otherChargeBeForeGSTController4.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController4 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          }
        } else {
          _otherChargeNameController4 = "";
        }
      }
      if (_otherChargeNameController5.isNotEmpty) {
        if (_otherChargeNameController5.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic5 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  int.parse(_otherChargeIDController5),
                  double.parse(_otherAmount5),
                  double.parse(_otherChargeGSTPerController5),
                  int.parse(_otherChargeTaxTypeController5.toString() == "0.00"
                      ? "0"
                      : _otherChargeTaxTypeController5.toString()),
                  _otherChargeBeForeGSTController5.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController5 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          }
        } else {
          _otherChargeNameController5 = "";
        }
      }*/

      /* print("llll" +
          "hdnOthChrgGST1" +
          hdnOthChrgGST1hdnOthChrgBasic1[0].toString() +
          " hdnOthChrgBasic1 : " +
          hdnOthChrgGST1hdnOthChrgBasic1[1].toString());*/

      double otherChargeGstAmnt1 = hdnOthChrgGST1hdnOthChrgBasic1.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic1[0]
          : 0.00;
      double otherChargeGstBasicAmnt1 =
          hdnOthChrgGST1hdnOthChrgBasic1.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic1[1]
              : 0.00;
      double otherChargeGstAmnt2 = hdnOthChrgGST1hdnOthChrgBasic2.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic2[0]
          : 0.00;
      double otherChargeGstBasicAmnt2 =
          hdnOthChrgGST1hdnOthChrgBasic2.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic2[1]
              : 0.00;
      double otherChargeGstAmnt3 = hdnOthChrgGST1hdnOthChrgBasic3.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic3[0]
          : 0.00;
      double otherChargeGstBasicAmnt3 =
          hdnOthChrgGST1hdnOthChrgBasic3.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic3[1]
              : 0.00;
      double otherChargeGstAmnt4 = hdnOthChrgGST1hdnOthChrgBasic4.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic4[0]
          : 0.00;
      double otherChargeGstBasicAmnt4 =
          hdnOthChrgGST1hdnOthChrgBasic4.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic4[1]
              : 0.00;

      double otherChargeGstAmnt5 = hdnOthChrgGST1hdnOthChrgBasic5.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic5[0]
          : 0.00;
      double otherChargeGstBasicAmnt5 =
          hdnOthChrgGST1hdnOthChrgBasic5.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic5[1]
              : 0.00;

      List<double> TempproductList =
          SalesOrderHeaderDiscountCalculation.funCalculateTotal(
              otherChargeGstAmnt1,
              otherChargeGstAmnt2,
              otherChargeGstAmnt3,
              otherChargeGstAmnt4,
              otherChargeGstAmnt5,
              otherChargeGstBasicAmnt1,
              otherChargeGstBasicAmnt2,
              otherChargeGstBasicAmnt3,
              otherChargeGstBasicAmnt4,
              otherChargeGstBasicAmnt5,
              Tot_CGSTAmt,
              Tot_SGSTAmt,
              Tot_IGSTAmt,
              Tot_BasicAmount,
              Tot_NetAmt,
              HeaderDisAmnt,
              Tot_otherChargeWithTax,
              Tot_otherChargeExcludeTax);

      double totalGstController = 0.00,
          netAmountController = 0.00,
          roundOFController = 0.00;
      totalGstController = TempproductList[2];
      netAmountController = TempproductList[4];
      roundOFController = TempproductList[5];

      List<double> finalcalculation = [
        /*0*/ Tot_BasicAmount,
        /*1*/ Tot_otherChargeWithTax,
        /*2*/ Tot_otherChargeExcludeTax,
        /*3*/ Tot_CGSTAmt,
        /*4*/ Tot_SGSTAmt,
        /*5*/ Tot_IGSTAmt,
        /*6*/ otherChargeGstBasicAmnt1,
        /*7*/ otherChargeGstBasicAmnt2,
        /*8*/ otherChargeGstBasicAmnt3,
        /*9*/ otherChargeGstBasicAmnt4,
        /*10*/ otherChargeGstBasicAmnt5,
        /*11*/ otherChargeGstAmnt1,
        /*12*/ otherChargeGstAmnt2,
        /*13*/ otherChargeGstAmnt3,
        /*14*/ otherChargeGstAmnt4,
        /*15*/ otherChargeGstAmnt5,
        /*16*/ totalGstController,
        /*17*/ netAmountController,
        /*18*/ roundOFController
      ];

      return finalcalculation;

      /* _basicAmountController.text = Tot_BasicAmount.toStringAsFixed(2);
      _otherChargeWithTaxController.text =
          Tot_otherChargeWithTax.toStringAsFixed(2);
      //TempproductList[0].toStringAsFixed(2);
      _otherChargeExcludeTaxController.text =
          Tot_otherChargeExcludeTax.toStringAsFixed(2);
      // TempproductList[3].toStringAsFixed(2);

      _totalCGSST_AMOUNT_Controller.text = Tot_CGSTAmt.toStringAsFixed(2);
      _totalSGSST_AMOUNT_Controller.text = Tot_SGSTAmt.toStringAsFixed(2);
      _totalIGSST_AMOUNT_Controller.text = Tot_IGSTAmt.toStringAsFixed(2);

      otherChargeGstBasicAmnt1Controller.text =
          otherChargeGstBasicAmnt1.toStringAsFixed(2);
      otherChargeGstBasicAmnt2Controller.text =
          otherChargeGstBasicAmnt2.toStringAsFixed(2);
      otherChargeGstBasicAmnt3Controller.text =
          otherChargeGstBasicAmnt3.toStringAsFixed(2);
      otherChargeGstBasicAmnt4Controller.text =
          otherChargeGstBasicAmnt4.toStringAsFixed(2);
      otherChargeGstBasicAmnt5Controller.text =
          otherChargeGstBasicAmnt5.toStringAsFixed(2);

      otherChargeGstAmnt1Controller.text =
          otherChargeGstAmnt1.toStringAsFixed(2);
      otherChargeGstAmnt2Controller.text =
          otherChargeGstAmnt2.toStringAsFixed(2);
      otherChargeGstAmnt3Controller.text =
          otherChargeGstAmnt3.toStringAsFixed(2);
      otherChargeGstAmnt4Controller.text =
          otherChargeGstAmnt4.toStringAsFixed(2);
      otherChargeGstAmnt5Controller.text =
          otherChargeGstAmnt5.toStringAsFixed(2);

      _totalGstController.text = totalGstController.toStringAsFixed(2);
      _netAmountController.text = netAmountController.toStringAsFixed(2);
      _roundOFController.text = roundOFController.toStringAsFixed(2);*/
    }
  }

  space(double height) {
    return SizedBox(
      height: height,
    );
  }

  void _onBankDetailsList(
      BankDetailsListResponseState bankDetailsListResponseState) {
    if (bankDetailsListResponseState.response.details.length != 0) {
      arr_ALL_Name_ID_For_Sales_Order_Bank_Name.clear();
      for (int i = 0;
          i < bankDetailsListResponseState.response.details.length;
          i++) {
        if (i == 0) {
          _controller_bank_name.text =
              bankDetailsListResponseState.response.details[i].bankName;
          _controller_bank_ID.text =
              bankDetailsListResponseState.response.details[i].pkID.toString();
        }
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name =
            bankDetailsListResponseState.response.details[i].bankName;
        all_name_id.pkID =
            bankDetailsListResponseState.response.details[i].pkID;
        arr_ALL_Name_ID_For_Sales_Order_Bank_Name.add(all_name_id);
      }
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      ALL_EmployeeList_Response state) {
    arr_ALL_Name_ID_For_Sales_Order_Sales_Executive.clear();
    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.pkID = state.details[i].pkID;
        arr_ALL_Name_ID_For_Sales_Order_Sales_Executive.add(all_name_id);
      }
    }
  }

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);
        showcustomdialogWithID(
            values: arr_ALL_Name_ID_For_Sales_Order_Sales_Executive,
            context1: context,
            controller: _controller_sales_executive,
            controllerID: _controller_sales_executiveID,
            lable: "Assign To");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*SizedBox(
                  height: 5,
                ),*/
          Card(
            elevation: 3,
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
                    child: TextField(
                      controller: _controller_sales_executive,
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 7),
                        hintText: "Tap to select executive",
                        hintStyle:
                            TextStyle(fontSize: 13, color: colorGrayDark),
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF000000),
                      )
                      // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                      ,
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
    );
  }

  void _OnProjectList(QuotationProjectListResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_ProjectList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].projectName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].projectName;
        all_name_id.pkID = state.response.details[i].pkID;
        arr_ALL_Name_ID_For_ProjectList.add(all_name_id);
      }
      /* showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_ProjectList,
          context1: context,
          controller: _controller_projectName,
          controllerID: _controller_projectID,
          lable: "Select Project ");*/
    }
  }

  void _OnTermsAndConditionResponse(QuotationTermsCondtionResponseState state) {
    /*if (state.response.details.length != 0) {

      */ /* showcustomdialogWithMultipleID(
          values: arr_ALL_Name_ID_For_Terms_And_Condition,
          context1: context,
          controller: edt_TermConditionHeader,
          controllerID: edt_TermConditionHeaderID,
          controller2: edt_TermConditionFooter,
          lable: "Select Term & Condition ");*/ /*
    }*/

    arr_ALL_Name_ID_For_Terms_And_Condition.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      print("InquiryStatus : " + state.response.details[i].tNCHeader);
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = state.response.details[i].tNCHeader;
      all_name_id.pkID = state.response.details[i].pkID;
      all_name_id.Name1 = state.response.details[i].tNCContent;

      arr_ALL_Name_ID_For_Terms_And_Condition.add(all_name_id);
    }

    showcustomdialogWithMultipleID(
        values: arr_ALL_Name_ID_For_Terms_And_Condition,
        context1: context,
        controller: _contrller_select_terms_and_condition,
        controllerID: _contrller_select_terms_and_conditionID,
        controller2: _contrller_terms_and_condition,
        lable: "Select Term & Condition ");
  }

  Widget QualifiedCountry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Country *",
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
        InkWell(
            onTap: () =>
                _onTapOfSearchCountryView(edt_QualifiedCountryCode.text),
            child: Card(
              elevation: 5,
              color: colorLightGray,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: edt_QualifiedCountry,
                          decoration: InputDecoration(
                            //contentPadding: EdgeInsets.only(bottom: 10),

                            hintText: "Country",
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
            )),
      ],
    );
  }

  _onTapOfSearchCountryView(String sw) {
    navigateTo(context, SearchCountryScreen.routeName,
            arguments: CountryArguments(sw))
        .then((value) {
      if (value != null) {
        _searchDetails = SearchCountryDetails();
        _searchDetails = value;
        print("CountryName IS From SearchList" + _searchDetails.countryCode);
        edt_QualifiedCountryCode.text = _searchDetails.countryCode;
        edt_QualifiedCountry.text = _searchDetails.countryName;
        setState(() {});
      }
    });
  }

  Widget QualifiedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("State * ",
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
        InkWell(
          onTap: () {
            _onTapOfSearchStateView(edt_QualifiedCountryCode.text);
          },
          /*=> isAllEditable==true?_onTapOfSearchStateView(
              _searchDetails == null ? "" : _searchDetails.countryCode):Container(),*/
          child: Card(
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
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedState,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10),

                          hintText: "State",
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
          ),
        )
      ],
    );
  }

  Future<void> _onTapOfSearchStateView(String sw1) async {
    navigateTo(context, SearchStateScreen.routeName,
            arguments: StateArguments(sw1))
        .then((value) {
      if (value != null) {
        _searchStateDetails = value;
        edt_QualifiedStateCode.text = _searchStateDetails.value.toString();
        edt_QualifiedState.text = _searchStateDetails.label.toString();
      }
    });
  }

  Widget QualifiedCity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("City * ",
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
        InkWell(
          onTap: () {
            _onTapOfSearchCityView(edt_QualifiedStateCode.text);
          },
          /*=> isAllEditable==true?_onTapOfSearchCityView(_searchStateDetails == null
              ? ""
              : _searchStateDetails.value.toString()):Container(),*/
          child: Card(
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
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedCity,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10),

                          hintText: "City",
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
          ),
        )
      ],
    );
  }

  Future<void> _onTapOfSearchCityView(String talukaCode) async {
    navigateTo(context, SearchCityScreen.routeName,
            arguments: CityArguments(talukaCode))
        .then((value) {
      if (value != null) {
        _searchCityDetails = value;
        edt_QualifiedCityCode.text = _searchCityDetails.cityCode.toString();
        edt_QualifiedCity.text = _searchCityDetails.cityName.toString();
      }
    });
  }

  Widget QualifiedPinCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("PinCode",
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
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_QualifiedPinCode,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 10),
                        counterText: "",
                        hintText: "PinCode",
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

  void fillData() async {
    /* pkID = _editModel.pkID;
    edt_InquiryDate.text = _editModel.quotationDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseInquiryDate.text = _editModel.quotationDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_CustomerName.text = _editModel.customerName.toString();
    edt_CustomerpkID.text = _editModel.customerID.toString();*/
    pkID = _editModel.pkID;
    _controller_order_no.text = _editModel.orderNo.toString();
    _controller_order_date.text = _editModel.orderDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    _controller_rev_order_date.text = _editModel.orderDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    _controller_customer_name.text = _editModel.customerName.toString();
    _controller_customer_pkID.text = _editModel.customerID.toString();
    _controller_sales_executive.text = _editModel.employeeName;
    _controller_sales_executiveID.text = _editModel.employeeID.toString();

    edt_HeaderDisc.text = _editModel.discountAmt.toString();
    _contrller_terms_and_condition.text = _editModel.termsCondition.toString();
    // HeaderDisAmnt = _editModel.discountAmt;
    SalesOrderNo = _editModel.orderNo.toString();
    if (_editModel.customerID != 0 || _editModel.customerID != null) {
      _salesOrderBloc.add(SearchCustomerListByNumberCallEvent(
          "",
          CustomerSearchByIdRequest(
              companyId: CompanyID,
              loginUserID: LoginUserID,
              CustomerID: _editModel.customerID.toString())));
    }

    if (_editModel.orderNo.toString() != "") {
      _salesOrderBloc.add(MultiNoToProductDetailsRequestEvent(
          "Edit",
          MultiNoToProductDetailsRequest(
              FetchType: "SalesOrder",
              No: "," + _editModel.orderNo.toString() + ",",
              CustomerID: _editModel.customerID.toString(),
              CompanyId: CompanyID.toString())));
    }

    await getInquiryProductDetails();

    _salesOrderBloc.add(DeleteGenericAddditionalChargesEvent());

    _salesOrderBloc.add(AddGenericAddditionalChargesEvent(
        GenericAddditionalCharges(
            _editModel.discountAmt.toString(),
            _editModel.chargeID1.toString(),
            _editModel.chargeAmt1.toString(),
            _editModel.chargeID2.toString(),
            _editModel.chargeAmt2.toString(),
            _editModel.chargeID3.toString(),
            _editModel.chargeAmt3.toString(),
            _editModel.chargeID4.toString(),
            _editModel.chargeAmt4.toString(),
            _editModel.chargeID5.toString(),
            _editModel.chargeAmt5.toString(),
            _editModel.chargeName1,
            _editModel.chargeName2,
            _editModel.chargeName3,
            _editModel.chargeName4,
            _editModel.chargeName5)));

    addditionalCharges = AddditionalCharges(
      DiscountAmt: _editModel.discountAmt.toString(),
      SGSTAmt: _editModel.sGSTAmt.toString(),
      CGSTAmt: _editModel.cGSTAmt.toString(),
      IGSTAmt: _editModel.iGSTAmt
          .toString(), //_totalIGSST_AMOUNT_Controller.text.toString(),

      ChargeID1: _editModel.chargeID1.toString(),
      ChargeName1: _editModel.chargeName1.toString(),
      ChargeAmt1: _editModel.chargeAmt1.toString(),
      ChargeBasicAmt1: _editModel.chargeBasicAmt1.toString(),
      ChargeGSTAmt1: _editModel.chargeGSTAmt1.toString(),
      ChargeTaxType1: "0",
      ChargeGstPer1: "",
      ChargeIsBeforGst1: "",

      ChargeID2: _editModel.chargeID2.toString(),
      ChargeName2: _editModel.chargeName2.toString(),
      ChargeAmt2: _editModel.chargeAmt2.toString(),
      ChargeBasicAmt2: _editModel.chargeBasicAmt2.toString(),
      ChargeGSTAmt2: _editModel.chargeGSTAmt2.toString(),
      ChargeTaxType2: "0",
      ChargeGstPer2: "0.00",
      ChargeIsBeforGst2: "0.00",

      ChargeID3: _editModel.chargeID3.toString(),
      ChargeName3: _editModel.chargeName3.toString(),
      ChargeAmt3: _editModel.chargeAmt3.toString(),
      ChargeBasicAmt3: _editModel.chargeBasicAmt3.toString(),
      ChargeGSTAmt3: _editModel.chargeGSTAmt3.toString(),
      ChargeTaxType3: "0",
      ChargeGstPer3: "0.00",
      ChargeIsBeforGst3: "0.00",

      ChargeID4: _editModel.chargeID4.toString(),
      ChargeName4: _editModel.chargeName4.toString(),
      ChargeAmt4: _editModel.chargeAmt4.toString(),
      ChargeBasicAmt4: _editModel.chargeBasicAmt4.toString(),
      ChargeGSTAmt4: _editModel.chargeGSTAmt4.toString(),
      ChargeTaxType4: "0",
      ChargeGstPer4: "0.00",
      ChargeIsBeforGst4: "0.00",

      ChargeID5: _editModel.chargeID5.toString(),
      ChargeName5: _editModel.chargeName5.toString(),
      ChargeAmt5: _editModel.chargeAmt5.toString(),
      ChargeBasicAmt5: _editModel.chargeBasicAmt5.toString(),
      ChargeGSTAmt5: _editModel.chargeGSTAmt5.toString(),
      ChargeTaxType5: "0",
      ChargeGstPer5: "0.00",
      ChargeIsBeforGst5: "0.00",

      NetAmt: _editModel.netAmt.toString(),
      BasicAmt: _editModel.basicAmt.toString(),
      ROffAmt: _editModel.roffAmt.toString(),
      ChargePer1: "0.00",
      ChargePer2: "0.00",
      ChargePer3: "0.00",
      ChargePer4: "0.00",
      ChargePer5: "0.00",
    );

    _controller_select_email_subject.text = _editModel.EmailContent;
    _controller_select_email_subject_ID.text = _editModel.EmailContent;
    _contrller_email_subject.text = _editModel.EmailHeader;

    //  _soShipmentlistResponseDetails
    _soShipmentlistResponseDetails =
        widget.arguments.soShipmentlistResponseDetails;
    _controller_company_name.text = _soShipmentlistResponseDetails.sCompanyName;
    _controller_GSTNO.text = _soShipmentlistResponseDetails.sGSTNo;
    _controller_contact_no.text = _soShipmentlistResponseDetails.sContactNo;
    _controller_contact_person_name.text =
        _soShipmentlistResponseDetails.sContactPersonName;
    _controller_address.text = _soShipmentlistResponseDetails.sAddress;
    _controller_area.text = _soShipmentlistResponseDetails.sArea;
    edt_QualifiedCountry.text = _soShipmentlistResponseDetails.countryName;
    edt_QualifiedCountryCode.text = _soShipmentlistResponseDetails.sCountryCode;
    edt_QualifiedCity.text = _soShipmentlistResponseDetails.cityName;
    edt_QualifiedCityCode.text =
        _soShipmentlistResponseDetails.sCityCode.toString();
    edt_QualifiedState.text = _soShipmentlistResponseDetails.stateName;
    edt_QualifiedStateCode.text =
        _soShipmentlistResponseDetails.sStateCode.toString();
    edt_QualifiedPinCode.text = _soShipmentlistResponseDetails.sPincode;

    //_onSO ExportList Response

    _soExportListResponse = widget.arguments.soExportListResponse;

    _controller_transport_name.text =
        _soExportListResponse.details[0].preCarrBy;
    _controller_place_of_rec.text =
        _soExportListResponse.details[0].preCarrRecPlace;
    _controller_flight_no.text = _soExportListResponse.details[0].flightNo;
    _controller_port_of_loading.text =
        _soExportListResponse.details[0].portOfLoading;
    _controller_port_of_dispatch.text =
        _soExportListResponse.details[0].portOfDispatch;
    _controller_port_of_destination.text =
        _soExportListResponse.details[0].portOfDestination;
    _controller_container_no.text = _soExportListResponse.details[0].marksNo;

    _controller_packages.text = _soExportListResponse.details[0].packages;
    _controller_net_weight.text = _soExportListResponse.details[0].netWeight;

    _controller_gross_weight.text =
        _soExportListResponse.details[0].grossWeight;

    _controller_type_of_package.text =
        _soExportListResponse.details[0].packageType;

    _controller_FOB.text = _soExportListResponse.details[0].freeOnBoard;
  }

  BankDetails(BuildContext context) {
    return EditText(context,
        hint: "Select Bank Name",
        radius: 10,
        readOnly: true,
        controller: _controller_bank_name,
        boxheight: 40, onPressed: () {
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Sales_Order_Bank_Name,
          context1: context,
          controller: _controller_bank_name,
          controllerID: _controller_bank_ID,
          lable: "Bank Details");
    },
        inputTextStyle: TextStyle(fontSize: 15),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: colorGrayDark,
          size: 32,
        ));
  }

  Widget _ModuleDropDown(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_controller_select_inquiry.text != "") {
          if (arr_ALL_Name_ID_For_INQ_QT_SO_List.length != 0) {
            navigateTo(context, ModuleNoListScreen.routeName,
                    arguments: AddModuleNoScreenArguments(
                        arr_ALL_Name_ID_For_INQ_QT_SO_List,
                        _controller_select_inquiry.text))
                .then((value) {
              setState(() {
                arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List = value;

                print("7upyyt" +
                    arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.length
                        .toString());

                if (arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.length != 0) {
                  List<String> ModuleNoList = [];
                  for (int i = 0;
                      i < arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.length;
                      i++) {
                    print("sldsdf" +
                        " Filter InqList : " +
                        arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List[i].Name +
                        " ISChecked : " +
                        arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List[i]
                            .isChecked
                            .toString());
                    ModuleNoList.add(
                        arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List[i].Name);
                    if (ModuleNoList.length != 0) {
                      var stringwe = ModuleNoList.join(',');
                      print("7upTTT7upTTT" + stringwe);
                      _controller_Module_NO.text = stringwe.toString();

                      _salesOrderBloc.add(MultiNoToProductDetailsRequestEvent(
                          "Edit",
                          MultiNoToProductDetailsRequest(
                              FetchType: _controller_select_inquiry.text,
                              No: "," + stringwe.toString() + ",",
                              CustomerID: _controller_customer_pkID.text,
                              CompanyId: CompanyID.toString())));
                    }
                  }
                }
              });
            });
          } else {
            showCommonDialogWithSingleOption(
                context, _controller_select_inquiry.text + " No. Not Exist !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.pop(context);
            });
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Customer name is required To view Option !",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.pop(context);
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createTextLabel("Inq/QT/SO No.", 10.0, 0.0),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: _controller_Module_NO,
                        enabled: false,
                        //expands: true,
                        decoration: InputDecoration(
                          hintText: "Select Module No.",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 7),
                        ),
                        style: TextStyle(
                          fontSize: 13,
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
    );
  }

  ModuleNo(BuildContext context) {
    return EditText(context,
        hint: "View Module No",
        radius: 10,
        readOnly: true,
        boxheight: 40, onPressed: () {
      if (_controller_select_inquiry.text != "") {
        navigateTo(context, ModuleNoListScreen.routeName,
                arguments: AddModuleNoScreenArguments(
                    arr_ALL_Name_ID_For_INQ_QT_SO_List,
                    _controller_select_inquiry.text))
            .then((value) {
          setState(() {
            arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List = value;
          });
        });
      } else {
        showCommonDialogWithSingleOption(
            context, "Customer name is required To view Option !",
            positiveButtonTitle: "OK");
      }
    },
        inputTextStyle: TextStyle(fontSize: 15),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: colorGrayDark,
          size: 32,
        ));
  }

  void _OnINQ_QT_SO_NO_Response(
      SalesBill_INQ_QT_SO_NO_ListResponseState state) {
    arr_ALL_Name_ID_For_INQ_QT_SO_List.clear();

    if (state.response.details.length != 0) {
      for (int i = 0; i < state.response.details.length; i++) {
        print("lsdfsdf" + " Order No " + state.response.details[i].orderNo);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].orderNo;
        all_name_id.isChecked = false;
        arr_ALL_Name_ID_For_INQ_QT_SO_List.add(all_name_id);
      }
    }
  }

  void getSelectOptionList() {
    arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry.clear();
    for (var i = 0; i < 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Inquiry";
      } else if (i == 1) {
        all_name_id.Name = "Quotation";
      }
      arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry.add(all_name_id);
    }
  }

  void _On_No_To_ProductDetails(
      MultiNoToProductDetailsResponseState state) async {
    if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLSalesOrderProduct();

      for (var i = 0; i < state.response.details.length; i++) {
        double Quantity = state.response.details[i].quantity;
        double UnitPrice = state.response.details[i].unitPrice;
        double DisPer = 0.00;
        double NetRate = 0.00;
        double Amount = 0.00;
        double TaxPer = state.response.details[i].taxRate;
        double TaxAmount = 0.00;
        int TaxType = state.response.details[i].taxType;
        double Amount1 = 0.00;
        double TaxAmount1 = 0.00;
        double TotalAmount = 0.00;
        double NetRate1 = 0.00; //(UnitPrice * DisPer) / 100;
        /* double CGSTPer1 =0.00;
      double SGSTPer1 =0.00;
      double IGSTPer1 =0.00;
      double CGSTAmount1 =0.00;
      double SGSTAmount1 =0.00;
      double IGSTAmount1 =0.00;*/
        double CGSTPer = 0.00;
        double SGSTPer = 0.00;
        double IGSTPer = 0.00;
        double CGSTAmount = 0.00;
        double SGSTAmount = 0.00;
        double IGSTAmount = 0.00;

        NetRate1 = UnitPrice;
        NetRate = NetRate1;
        if (TaxType == 1) {
          Amount1 = Quantity * NetRate1;
          Amount = Amount1;
          TaxAmount1 = (Amount1 * TaxPer) / 100;
          TaxAmount = TaxAmount1;
          TotalAmount = Amount1 + TaxAmount1;
        } else {
          Amount1 = 0.00;
          TaxAmount1 = 0.00;
          TotalAmount = 0.00;

          TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);
          TaxAmount = TaxAmount1;

          Amount1 = (Quantity * NetRate1) - TaxAmount1;
          Amount = Amount1;

          TotalAmount = (Quantity * NetRate1);
          // _totalAmountController.text = getNumber(TotalAmount,precision: 2).toString();
        }

        if (_offlineLoggedInData.details[0].stateCode ==
            int.parse(edt_StateCode.text)) {
          CGSTPer = TaxPer / 2;
          SGSTPer = TaxPer / 2;
          CGSTAmount = TaxAmount / 2;
          SGSTAmount = TaxAmount / 2;
          IGSTPer = 0.00;
          IGSTAmount = 0.00;
        } else {
          CGSTPer = 0.00;
          SGSTPer = 0.00;
          CGSTAmount = 0.00;
          SGSTAmount = 0.00;
          IGSTPer = TaxPer;
          IGSTAmount = TaxAmount;
        }

        await OfflineDbHelper.getInstance().insertSalesOrderProduct(
            SalesOrderTable(
                "",
                state.response.details[i].productSpecification,
                state.response.details[i].productID,
                state.response.details[i].productName,
                state.response.details[i].unit,
                Quantity,
                UnitPrice,
                0.00,
                0.00,
                NetRate,
                Amount,
                TaxPer,
                TaxAmount,
                TotalAmount,
                TaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                int.parse(edt_StateCode.text),
                0,
                LoginUserID,
                CompanyID.toString(),
                0,
                0.00,
                selectedDate.year.toString() +
                    "-" +
                    selectedDate.month.toString() +
                    "-" +
                    selectedDate.day.toString()));
      }

      if (state.FetchFromWhichScreen == "Add") {
        navigateTo(context, SOProductListScreen.routeName,
            arguments: SOProductListArgument(
                SalesOrderNo, edt_StateCode.text, edt_HeaderDisc.text));
      }
      /*navigateTo(context, SOProductListScreen.routeName,
          arguments: SOProductListArgument(
              SalesOrderNo, edt_StateCode.text, edt_HeaderDisc.text));*/
    }
  }

  void _OnEmailContentResponse(SaleBillEmailContentResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_Email_Subject.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].contentData);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].subject;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].contentData;

        arr_ALL_Name_ID_For_Email_Subject.add(all_name_id);
      }
      showcustomdialogWithMultipleID(
          values: arr_ALL_Name_ID_For_Email_Subject,
          context1: context,
          controller: _controller_select_email_subject,
          controllerID: _controller_select_email_subject_ID,
          controller2: _contrller_email_subject,
          lable: "Select Email Content ");
    }
  }

  Widget EmailSubjectWithMultiID1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              print("sfdfsfffff");

              _salesOrderBloc.add(SalesBillEmailContentRequestEvent(
                  SalesBillEmailContentRequest(
                      CompanyId: CompanyID.toString(),
                      LoginUserID: LoginUserID)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*SizedBox(
                  height: 5,
                ),*/
                Card(
                  elevation: 3,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: _controller_select_email_subject,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 7),
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

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  void _OnPaymentScheduleSucessList(PaymentScheduleListResponseState state) {
    //arr_PaymentScheduleList.add(state.response);
    arr_PaymentScheduleList.clear();
    for (int i = 0; i < state.response.length; i++) {
      arr_PaymentScheduleList.add(SoPaymentScheduleTable(
          state.response[i].amount,
          state.response[i].dueDate,
          state.response[i].revdueDate,
          id: state.response[i].id));
    }
  }

  void _onInsertPaymentScheduleSucess(PaymentScheduleResponseState state) {
    print("Paymenf" + state.response);
    _salesOrderBloc.add(PaymentScheduleListEvent());
  }

  void _ondeletePaymentSchedule(PaymentScheduleDeleteResponseState state) {
    print("Paymenf" + state.response);
    _salesOrderBloc.add(PaymentScheduleListEvent());
  }

  showcustomdialogSendEmail({
    BuildContext context1,
    int updatedID,
    // SoPaymentScheduleTable paymentScheduleModel
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
                    "Update Payment Schedule",
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
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Amount",
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
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller: _controllerAmountDialog,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter Amount",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Date",
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
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          _selectOrderDate(
                                              context,
                                              _controllerDueDateDialog,
                                              _controllerRevDueDateDialog);
                                        },
                                        child: TextField(
                                            controller:
                                                _controllerDueDateDialog,
                                            enabled: false,
                                            decoration: InputDecoration(
                                              hintText: "DD-MM-YYYY",
                                              labelStyle: TextStyle(
                                                color: Color(0xFF000000),
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF000000),
                                            ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () async {
                              //soPaymentScheduleTable

                              // SoPaymentScheduleTable soPaymentScheduleTable =

                              if (_controllerAmountDialog.text != "") {
                                if (_controllerDueDateDialog.text != "") {
                                  _salesOrderBloc.add(PaymentScheduleEditEvent(
                                      SoPaymentScheduleTable(
                                          double.parse(
                                              _controllerAmountDialog.text),
                                          _controllerDueDateDialog.text,
                                          _controllerRevDueDateDialog.text,
                                          id: updatedID)));
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Date is Required !",
                                      positiveButtonTitle: "OK");
                                }
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Amount is Required !",
                                    positiveButtonTitle: "OK");
                              }

                              Navigator.pop(context);
                            },
                            "Update",
                            textSize: 12,
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () {
                              Navigator.pop(context);
                            },
                            "Close",
                            textSize: 12,
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  void OnUpdatePaymentSchedule(PaymentScheduleEditResponseState state) {
    print("UpdatePayment" + state.response);
    _salesOrderBloc.add(PaymentScheduleListEvent());
  }

  void _OnSalesOrderHeaderSaveSucessResponse(
      SaleOrderHeaderSaveResponseState state) {
    int returnPKID = 0;
    String retrunQT_No = "";
    for (int i = 0; i < state.response.details.length; i++) {
      returnPKID = int.parse(state.response.details[i].column3);
      retrunQT_No = state.response.details[i].column4;
    }

    updateRetrunInquiryNoToDB(state.context, returnPKID, retrunQT_No);
  }

  void updateRetrunInquiryNoToDB(
      context1, int returnPKID, String retrunSO_No) async {
    /* await getInquiryProductDetails();



    arrSOProductList.clear();

    for (int i = 0; i < _inquiryProductList.length; i++) {
      SalesOrderProductRequest salesOrderProductRequest =
          SalesOrderProductRequest(
        pkID: "0",
        OrderNo: retrunSO_No,
        ProductID: int.parse(_inquiryProductList[i].ProductID.toString()),
        Quantity: double.parse(_inquiryProductList[i].Quantity.toString()),
        Unit: _inquiryProductList[i].Unit,
        UnitRate:
            double.parse(_inquiryProductList[i].UnitRate.toStringAsFixed(2)),
        DiscountPercent: double.parse(
            _inquiryProductList[i].DiscountPercent.toStringAsFixed(2)),
        NetRate:
            double.parse(_inquiryProductList[i].NetRate.toStringAsFixed(2)),
        Amount: double.parse(_inquiryProductList[i].Amount.toStringAsFixed(2)),
        TaxAmount:
            double.parse(_inquiryProductList[i].TaxAmount.toStringAsFixed(2)),
        NetAmount:
            double.parse(_inquiryProductList[i].NetAmount.toStringAsFixed(2)),
        LoginUserID: LoginUserID,
        TaxRate:
            double.parse(_inquiryProductList[i].TaxRate.toStringAsFixed(2)),
        SGSTPer:
            double.parse(_inquiryProductList[i].SGSTPer.toStringAsFixed(2)),
        SGSTAmt:
            double.parse(_inquiryProductList[i].SGSTAmt.toStringAsFixed(2)),
        CGSTPer:
            double.parse(_inquiryProductList[i].CGSTPer.toStringAsFixed(2)),
        CGSTAmt:
            double.parse(_inquiryProductList[i].CGSTAmt.toStringAsFixed(2)),
        IGSTPer:
            double.parse(_inquiryProductList[i].IGSTPer.toStringAsFixed(2)),
        IGSTAmt:
            double.parse(_inquiryProductList[i].IGSTAmt.toStringAsFixed(2)),
        TaxType: _inquiryProductList[i].TaxType,
        DiscountAmt:
            double.parse(_inquiryProductList[i].DiscountAmt.toStringAsFixed(2)),
        HeaderDiscAmt: double.parse(
            _inquiryProductList[i].HeaderDiscAmt.toStringAsFixed(2)),
        DeliveryDate: _inquiryProductList[i].DeliveryDate.toString(),
        CompanyId: int.parse(CompanyID.toString()),
      );

      arrSOProductList.add(salesOrderProductRequest);
    }
    print("dsljdf1" + arrSOProductList.length.toString());

    _salesOrderBloc.add(
        SaleOrderProductSaveCallEvent(context1, retrunSO_No, arrSOProductList));*/

    await getInquiryProductDetails();

    List<SalesOrderTable> TempproductList1 =
        SalesOrderHeaderDiscountCalculation.txtHeadDiscount_WithZero(
            _inquiryProductList,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    List<SalesOrderTable> TempproductList =
        SalesOrderHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
            TempproductList1,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    /* TempproductList.forEach((element) {
      element.pkID = pkID;
      element.LoginUserID = LoginUserID;
      element.CompanyId = CompanyID.toString();
    });*/

    arrSOProductList.clear();
    for (int i = 0; i < TempproductList.length; i++) {
      SalesOrderProductRequest salesOrderProductRequest =
          SalesOrderProductRequest(
        pkID: "0",
        OrderNo: retrunSO_No,
        ProductID: int.parse(TempproductList[i].ProductID.toString()),
        Quantity: double.parse(TempproductList[i].Quantity.toString()),
        Unit: TempproductList[i].Unit,
        UnitRate: double.parse(TempproductList[i].UnitRate.toStringAsFixed(2)),
        DiscountPercent:
            double.parse(TempproductList[i].DiscountPercent.toStringAsFixed(2)),
        NetRate: double.parse(TempproductList[i].NetRate.toStringAsFixed(2)),
        Amount: double.parse(TempproductList[i].Amount.toStringAsFixed(2)),
        TaxAmount:
            double.parse(TempproductList[i].TaxAmount.toStringAsFixed(2)),
        NetAmount:
            double.parse(TempproductList[i].NetAmount.toStringAsFixed(2)),
        LoginUserID: LoginUserID,
        TaxRate: double.parse(TempproductList[i].TaxRate.toStringAsFixed(2)),
        SGSTPer: double.parse(TempproductList[i].SGSTPer.toStringAsFixed(2)),
        SGSTAmt: double.parse(TempproductList[i].SGSTAmt.toStringAsFixed(2)),
        CGSTPer: double.parse(TempproductList[i].CGSTPer.toStringAsFixed(2)),
        CGSTAmt: double.parse(TempproductList[i].CGSTAmt.toStringAsFixed(2)),
        IGSTPer: double.parse(TempproductList[i].IGSTPer.toStringAsFixed(2)),
        IGSTAmt: double.parse(TempproductList[i].IGSTAmt.toStringAsFixed(2)),
        TaxType: TempproductList[i].TaxType,
        DiscountAmt:
            double.parse(TempproductList[i].DiscountAmt.toStringAsFixed(2)),
        HeaderDiscAmt:
            double.parse(TempproductList[i].HeaderDiscAmt.toStringAsFixed(2)),
        DeliveryDate: TempproductList[i].DeliveryDate.toString(),
        CompanyId: int.parse(CompanyID.toString()),
      );

      arrSOProductList.add(salesOrderProductRequest);
    }

    _salesOrderBloc.add(
        SaleOrderProductSaveCallEvent(context1, retrunSO_No, arrSOProductList));
  }

  void _OnSaleOrderProductSaveResponse(
      SaleOrderProductSaveResponseState state) async {
    String Msg = _isForUpdate == true
        ? "SalesOrder Updated Successfully"
        : "SalesOrder Added Successfully";

    showCommonDialogWithSingleOption(context, Msg, positiveButtonTitle: "OK",
        onTapOfPositiveButton: () {
      navigateTo(context, SalesOrderListScreen.routeName, clearAllStack: true);
    });
    /* await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK");
    Navigator.of(context).pop();*/
  }

  void _OnGenericIsertCallSucess(AddGenericAddditionalChargesState state) {
    print("_OnGenericIsertCallSucess" + state.response);
  }

  void _onDeleteAllGenericAddtionalAmount(
      DeleteAllGenericAddditionalChargesState state) {
    print("DeleteAllGenericAddditionalChargesState" + state.response);
  }

  void _ONOnlyCustomerDetails(
      SearchCustomerListByNumberCallResponseState state) {
    edt_StateCode.text = state.response.details[0].stateCode.toString();
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLSalesOrderProduct();
  }

  void _OnGenricOtherChargeResponse(
      GenericOtherCharge1ListResponseState state) {
    arrGenericOtheCharge.clear();

    for (int i = 0;
        i < state.quotationOtherChargesListResponse.details.length;
        i++) {
      arrGenericOtheCharge
          .add(state.quotationOtherChargesListResponse.details[i]);
    }
    //.add(state.quotationOtherChargesListResponse.details[i]);
  }

  void AddAddtionalCharge() async {
    await OfflineDbHelper.getInstance()
        .insertGenericAddditionalCharges(GenericAddditionalCharges(
      edt_HeaderDisc.text,
      _editModel.chargeID1.toString(),
      _editModel.chargeAmt1.toString(),
      _editModel.chargeID2.toString(),
      _editModel.chargeAmt2.toString(),
      _editModel.chargeID3.toString(),
      _editModel.chargeAmt3.toString(),
      _editModel.chargeID4.toString(),
      _editModel.chargeAmt4.toString(),
      _editModel.chargeID5.toString(),
      _editModel.chargeAmt5.toString(),
      _editModel.chargeName1,
      _editModel.chargeName2,
      _editModel.chargeName3,
      _editModel.chargeName4,
      _editModel.chargeName5,
    ));
  }

  void _ONCurrencyResponse(SOCurrencyListResponseState state) {
    arr_ALL_Name_ID_For_Sales_Order_Select_Currency.clear();
    if (state.response.details.length != 0) {
      for (int i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].currencyName;
        all_name_id.Name1 = state.response.details[i].currencySymbol;
        arr_ALL_Name_ID_For_Sales_Order_Select_Currency.add(all_name_id);
      }

      showcustomdialog(
          values: arr_ALL_Name_ID_For_Sales_Order_Select_Currency,
          context1: context,
          controller: _controller_currency,
          controller2: _controller_currency_Symbol,
          lable: "Select Currency");
    }
  }

  ProductAndAddtionalCharges() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrimary, borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Products & Additional Charges",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      BASIC_INFORMATION,
                      width: 27,
                    ),
                  ),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        productDetails(),
                        Visibility(
                          visible: true,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.bottomCenter,
                            child: getCommonButton(baseTheme, () async {
                              await getInquiryProductDetails();

                              if (_inquiryProductList.length != 0) {
                                print("HeaderDiscll" +
                                    edt_HeaderDisc.text.toString());

                                navigateTo(
                                        context,
                                        NewSalesOrderOtherChargeScreen
                                            .routeName,
                                        arguments:
                                            NewSalesOrderOtherChargesScreenArguments(
                                                int.parse(
                                                    edt_StateCode.text == null
                                                        ? 0
                                                        : edt_StateCode.text),
                                                _editModel,
                                                edt_HeaderDisc.text,
                                                "OtherCharge",
                                                addditionalCharges))
                                    .then((value) {
                                  setState(() {
                                    addditionalCharges = value;

                                    isUpdateCalculation = true;

                                    edt_HeaderDisc.text =
                                        addditionalCharges.DiscountAmt;

                                    print("jjff23kj" +
                                        addditionalCharges.DiscountAmt);
                                  });
                                });
                              } else {
                                showCommonDialogWithSingleOption(context,
                                    "Atleast one product is required to view other charges !",
                                    positiveButtonTitle: "OK");
                              }
                            }, "Additional Charges",
                                width: 600,
                                textColor: colorPrimary,
                                backGroundColor: colorGreenLight,
                                radius: 25.0),
                          ),
                        ),
                        space(5),
                        Visibility(
                          visible: true,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            alignment: Alignment.bottomCenter,
                            child: getCommonButton(baseTheme, () async {
                              await getInquiryProductDetails();

                              if (_inquiryProductList.length != 0) {
                                print("HeaderDiscll" +
                                    edt_HeaderDisc.text.toString());

                                navigateTo(
                                        context,
                                        NewSalesOrderOtherChargeScreen
                                            .routeName,
                                        arguments:
                                            NewSalesOrderOtherChargesScreenArguments(
                                                int.parse(
                                                    edt_StateCode.text == null
                                                        ? 0
                                                        : edt_StateCode.text),
                                                _editModel,
                                                edt_HeaderDisc.text,
                                                "Calculation",
                                                addditionalCharges))
                                    .then((value) {
                                  setState(() {
                                    addditionalCharges = value;

                                    isUpdateCalculation = true;

                                    edt_HeaderDisc.text =
                                        addditionalCharges.DiscountAmt;

                                    print("jjff23kj" +
                                        addditionalCharges.DiscountAmt);
                                  });
                                });
                              } else {
                                showCommonDialogWithSingleOption(context,
                                    "Atleast one product is required to view other charges !",
                                    positiveButtonTitle: "OK");
                              }
                            }, "Final Summary",
                                width: 600,
                                textColor: colorPrimary,
                                backGroundColor: colorGreenLight,
                                radius: 25.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  showcustomdialogEmailContent({
    BuildContext context1,
    String Email,
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
                    "Add Email Subject",
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
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Subject *",
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
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller:
                                              _contrller_Email_Add_Subject,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter Subject",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Email Content *",
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
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                width: double.maxFinite,
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller:
                                              _contrller_Email_Add_Content,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter content",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(baseTheme, () async {
                            if (_contrller_Email_Add_Subject.text != "") {
                              if (_contrller_Email_Add_Content.text != "") {
                                Navigator.pop(context123);

                                _salesOrderBloc.add(
                                    SaveEmailContentRequestEvent(
                                        SaveEmailContentRequest(
                                            pkID: "0",
                                            Subject:
                                                _contrller_Email_Add_Subject
                                                    .text,
                                            ContentData:
                                                _contrller_Email_Add_Content
                                                    .text,
                                            LoginUserID: LoginUserID,
                                            CompanyId: CompanyID.toString())));
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Email content is required !",
                                    positiveButtonTitle: "OK");
                              }
                            } else {
                              showCommonDialogWithSingleOption(
                                  context, "Subject is required !",
                                  positiveButtonTitle: "OK");
                            }
                          }, "Add",
                              backGroundColor: colorPrimary,
                              textColor: colorWhite,
                              radius: 36),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(baseTheme, () {
                            Navigator.pop(context);
                          }, "Close",
                              backGroundColor: colorPrimary,
                              textColor: colorWhite,
                              radius: 36),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  void _OnSaveEmailContentResponse(SaveEmailContentResponseState state) {
    showCommonDialogWithSingleOption(context, state.response.details[0].column2,
        positiveButtonTitle: "OK");
  }

  void _onDeleteAllQTAssemblyResponse(SOAssemblyTableDeleteALLState state) {
    print("deleteAllSalesOrderAssembly" + state.response);
  }
}
