import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/salesbill/salesbill_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:for_practice_the_app/models/api_requests/SalesOrder/multi_no_to_product_details_request.dart';
import 'package:for_practice_the_app/models/api_requests/bank_voucher/bank_drop_down_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_all_product_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_export_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_export_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_product_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesBill/sb_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/city_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/state_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/saleBill/headerToDetailsResponse.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:for_practice_the_app/models/common/sales_bill_table.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/customer_search/customer_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salebill/sale_bill_list/sales_bill_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/sales_bill_db_details/sales_bill_summary_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/sales_bill_db_details/sb_product_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/calculation/additional_charges_calculation.dart';
import 'package:for_practice_the_app/utils/calculation/model/additonalChargeDetails.dart';
import 'package:for_practice_the_app/utils/calculation/sales_bill_calculation/sales_bill_header_discount_calculation.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'module_no_list_screen.dart';

class AddUpdateSaleBillScreenArguments {
  //SaleBillDetails editModel;
  HeaderToDetailsResponseDetails editModel;
  AddUpdateSaleBillScreenArguments(this.editModel);
}

class SalesBillAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/SalesBillAddEditScreen';

  final AddUpdateSaleBillScreenArguments arguments;

  SalesBillAddEditScreen(this.arguments);

  @override
  _SalesBillAddEditScreenState createState() => _SalesBillAddEditScreenState();
}

class _SalesBillAddEditScreenState extends BaseState<SalesBillAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  SalesBillBloc salesBillBloc;
  final _formKey = GlobalKey<FormState>();
  bool _isForUpdate;
  HeaderToDetailsResponseDetails _editModel;
  int pkID = 0;

  SearchDetails _searchInquiryListResponse;

  TextEditingController _controller_order_no = TextEditingController();
  TextEditingController _controller_customer_name = TextEditingController();
  TextEditingController _controller_customer_pkID = TextEditingController();

  TextEditingController _controller_order_date = TextEditingController();
  TextEditingController _controller_rev_order_date = TextEditingController();
  TextEditingController _controller_PINO = TextEditingController();
  TextEditingController _controller_PI_date = TextEditingController();
  TextEditingController _controller_rev_PI_date = TextEditingController();
  TextEditingController _controller_AC_name = TextEditingController();
  TextEditingController _controller_AC_ID = TextEditingController();
  TextEditingController _controller_bank_name = TextEditingController();
  TextEditingController _controller_bank_ID = TextEditingController();

  TextEditingController _controller_select_inquiry = TextEditingController();
  TextEditingController _controller_Module_NO = TextEditingController();

  TextEditingController _controller_inquiry_no = TextEditingController();
  TextEditingController _controller_sales_executive = TextEditingController();
  TextEditingController _controller_supplier_ref_no = TextEditingController();
  TextEditingController _controller_reference_date = TextEditingController();

  TextEditingController _controller_work_Due_date = TextEditingController();
  TextEditingController _controller_work_Due_date_Reverse =
      TextEditingController();
  TextEditingController _controller_delivery_date = TextEditingController();
  TextEditingController _controller_rev_delivery_date = TextEditingController();
  TextEditingController _controller_rev_reference_date =
      TextEditingController();
  TextEditingController _controller_Project = TextEditingController();
  TextEditingController _controller_CR_Days = TextEditingController();
  TextEditingController _controller_credit_days = TextEditingController();
  TextEditingController _controller_OtherRef_no = TextEditingController();
  TextEditingController _controller_docNo = TextEditingController();

  final TextEditingController edt_QualifiedState = TextEditingController();
  final TextEditingController edt_QualifiedStateCode = TextEditingController();
  final TextEditingController edt_QualifiedCity = TextEditingController();
  final TextEditingController edt_QualifiedCityCode = TextEditingController();
  TextEditingController _controller_vihical_no = TextEditingController();
  TextEditingController _controller_Delivery_Notes = TextEditingController();

  TextEditingController _contrller_terms_and_condition =
      TextEditingController();
  TextEditingController _contrller_select_terms_and_condition =
      TextEditingController();
  TextEditingController _contrller_select_terms_and_conditionID =
      TextEditingController();
  TextEditingController _controller_select_email_subject =
      TextEditingController();
  TextEditingController _controller_select_email_subject_ID =
      TextEditingController();
  TextEditingController _contrller_email_subject = TextEditingController();
  TextEditingController _contrller_email_introcuction = TextEditingController();
  TextEditingController _controller_amount = TextEditingController();
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
  TextEditingController _controller_mode_of_transfer = TextEditingController();
  TextEditingController _controller_Transporter = TextEditingController();

  TextEditingController _controller_LR_NO = TextEditingController();

  TextEditingController _controller_Remarks = TextEditingController();
  TextEditingController _controller_e_way_bill_No = TextEditingController();
  TextEditingController _controller_Mode_of_Payment = TextEditingController();
  TextEditingController _controller_DeliverTo = TextEditingController();

  TextEditingController _controller_LR_date = TextEditingController();
  TextEditingController _controller_LR_date_Reveres = TextEditingController();

  TextEditingController edt_StateCode = TextEditingController();

  TextEditingController edt_HeaderDisc = TextEditingController();
  TextEditingController _controller_currency = TextEditingController();
  TextEditingController _controller_currency_Symbol = TextEditingController();
  TextEditingController _controllerExchangeRate = TextEditingController();
  TextEditingController edt_ProjectName = TextEditingController();
  TextEditingController edt_ProjectID = TextEditingController();
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_AC_Name = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Bank_Name = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_INQ_QT_SO_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Sales_Executive = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Project = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Terms_And_Condition = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Email_Subject = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ModeOfTransfer = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Currency = [];
  List<SaleBillTable> _inquiryProductList = [];

  DateTime selectedDate = DateTime.now();

  DateTime selectedInvoiceDate = DateTime.now();
  DateTime selectedRefDate = DateTime.now();
  DateTime selectedDueDate = DateTime.now();
  DateTime selectedLRDate = DateTime.now();
  DateTime selectedDeliveryDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();
  double dateFontSize = 13;
  double CardViewHieght = 35;

  SearchStateDetails _searchStateDetails;
  SearchCityDetails _searchCityDetails;

  List<File> MultipleVideoList = [];
  final imagepicker = ImagePicker();

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  String InquiryNo = "";

  AddditionalCharges addditionalCharges = AddditionalCharges();

  bool isUpdateCalculation = false;

  String SalesBillNo = "";

  double HeaderDisAmnt = 0.00; //double.parse(edt_HeaderDisc.toString());

  double Tot_otherChargeWithTax = 0.00;
  double Tot_otherChargeExcludeTax = 0.00;

  List<OtherChargeDetails> arrGenericOtheCharge = [];

  List<SBProductSaveRequest> arrSOProductList = [];

  @override
  void initState() {
    super.initState();

    salesBillBloc = SalesBillBloc(baseBloc);

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    _isForUpdate = widget.arguments != null;

    getAccountNameAPI();

    getSelectOptionList();

    getModeOfTransport();

    salesBillBloc.add(QuotationBankDropDownCallEvent(BankDropDownRequest(
        CompanyID: CompanyID.toString(), LoginUserID: LoginUserID, pkID: "")));
    salesBillBloc.add(QuotationTermsConditionCallEvent(
        QuotationTermsConditionRequest(
            CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));

    salesBillBloc.add(SalesBillEmailContentRequestEvent(
        SalesBillEmailContentRequest(
            CompanyId: CompanyID.toString(), LoginUserID: LoginUserID)));

    salesBillBloc.add(GenericOtherChargeCallEvent(
        CompanyID.toString(), QuotationOtherChargesListRequest(pkID: "")));

    salesBillBloc.add(SBAssemblyTableALLDeleteEvent());

    _controller_select_inquiry.addListener(() {
      setState(() {
        if (_controller_customer_pkID.text != null ||
            _controller_customer_pkID.text != "") {
          if (_controller_select_inquiry.text == "Inquiry") {
            salesBillBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                SaleBill_INQ_QT_SO_NO_ListRequest(
                    CompanyId: CompanyID.toString(),
                    CustomerID: _controller_customer_pkID.text.toString(),
                    ModuleType: "Inquiry")));
          } else if (_controller_select_inquiry.text == "Quotation") {
            salesBillBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                SaleBill_INQ_QT_SO_NO_ListRequest(
                    CompanyId: CompanyID.toString(),
                    CustomerID: _controller_customer_pkID.text.toString(),
                    ModuleType: "Quotation")));
          } else if (_controller_select_inquiry.text == "SalesOrder") {
            salesBillBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                SaleBill_INQ_QT_SO_NO_ListRequest(
                    CompanyId: CompanyID.toString(),
                    CustomerID: _controller_customer_pkID.text.toString(),
                    ModuleType: "SalesOrder")));
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Customer name is required To view Option !",
              positiveButtonTitle: "OK");
        }
      });
    });

    _controller_transport_name.text = "";
    _controller_place_of_rec.text = "";
    _controller_flight_no.text = "";
    _controller_port_of_loading.text = "";
    _controller_port_of_dispatch.text = "";
    _controller_port_of_destination.text = "";
    _controller_container_no.text = "";
    _controller_packages.text = "";
    _controller_type_of_package.text = "";
    _controller_net_weight.text = "";
    _controller_gross_weight.text = "";
    _controller_FOB.text = "";

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
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

      _controller_reference_date.text = selectedRefDate.day.toString() +
          "-" +
          selectedRefDate.month.toString() +
          "-" +
          selectedRefDate.year.toString();
      _controller_rev_reference_date.text = selectedRefDate.year.toString() +
          "-" +
          selectedRefDate.month.toString() +
          "-" +
          selectedRefDate.day.toString();

      edt_StateCode.text = "";

      salesBillBloc.add(DeleteGenericAddditionalChargesEvent());

      salesBillBloc.add(AddGenericAddditionalChargesEvent(
          GenericAddditionalCharges("0.00", "0", "0.00", "0", "0.00", "0",
              "0.00", "0", "0.00", "0", "0.00", "", "", "", "", "")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => salesBillBloc,
      child: BlocConsumer<SalesBillBloc, SalesBillStates>(
        builder: (BuildContext context, SalesBillStates state) {
          if (state is QuotationBankDropDownResponseState) {
            _OnBankDetailsSucess(state);
          }
          if (state is QuotationTermsCondtionResponseState) {
            _OnTermsAndConditionResponse(state);
          }
          if (state is SaleBillEmailContentResponseState) {
            _OnEmailContentResponse(state);
          }

          if (state is AddGenericAddditionalChargesState) {
            _OnGenericIsertCallSucess(state);
          }

          if (state is DeleteAllGenericAddditionalChargesState) {
            _onDeleteAllGenericAddtionalAmount(state);
          }

          if (state is GenericOtherCharge1ListResponseState) {
            _OnGenricOtherChargeResponse(state);
          }

          if (state is SBExportListResponseState) {
            _OnSBExportListResponse(state);
          }
          if (state is SBAssemblyTableDeleteALLState) {
            _onDeleteAllQTAssemblyResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is QuotationBankDropDownResponseState ||
              currentState is QuotationTermsCondtionResponseState ||
              currentState is SaleBillEmailContentResponseState ||
              currentState is AddGenericAddditionalChargesState ||
              currentState is DeleteAllGenericAddditionalChargesState ||
              currentState is GenericOtherCharge1ListResponseState ||
              currentState is SBExportListResponseState ||
              currentState is SBAssemblyTableDeleteALLState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, SalesBillStates state) {
          if (state is SalesBill_INQ_QT_SO_NO_ListResponseState) {
            _OnINQ_QT_SO_NO_Response(state);
          }

          if (state is SBHeaderSaveResponseState) {
            _OnSalesOrderHeaderSaveSucessResponse(state);
          }

          if (state is SBProductSaveResponseState) {
            _OnSaleOrderProductSaveResponse(state);
          }

          if (state is MultiNoToProductDetailsResponseState) {
            _On_No_To_ProductDetails(state);
          }

         /* if (state is SBProductSaveResponseState) {
            _OnSBExportSaveResponse(state);
          }*/

          if (state is SOCurrencyListResponseState) {
            _ONCurrencyResponse(state);
          }

          if (state is QuotationProjectListResponseState) {
            _OnGetProjectList(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SalesBill_INQ_QT_SO_NO_ListResponseState ||
              currentState is MultiNoToProductDetailsResponseState ||
              currentState is SBHeaderSaveResponseState ||
              currentState is SBProductSaveResponseState ||
              //currentState is SBProductSaveResponseState ||
              currentState is SOCurrencyListResponseState ||
              currentState is QuotationProjectListResponseState) {
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
            appBar: NewGradientAppBar(
              title: Text('Sales Bill Details'),
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple, Colors.red]),
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
                        //#CustomerInformation
                        MandatoryDetails(),
                        BasicInformation(),
                        ProductAndAddtionalCharges(),
                        EmailContent(),
                        TermsCondition(),
                        TransportDetails(),
                        //ShipmentDetails(),

                        Attachments(),

                        SizedBox(
                          height: 20,
                        ),
                        /* getCommonButton(baseTheme, () {}, "Save",
                            radius: 20, backGroundColor: colorPrimary)*/
                        save()
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, SalesBillListScreen.routeName, clearAllStack: true);
  }

  void fillData() async {
    pkID = _editModel.pkID;
    print("PKID" + _editModel.inquiryNo);

    _controller_order_no.text = _editModel.invoiceNo;

    _controller_order_date.text = _editModel.invoiceDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    _controller_rev_order_date.text = _editModel.invoiceDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    _controller_work_Due_date.text = _editModel.dueDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_ProjectName.text = _editModel.projectName;

    _controller_currency.text = _editModel.currencyName;
    _controller_currency_Symbol.text = _editModel.currencySymbol;
    _controllerExchangeRate.text = _editModel.exchangeRate.toString();
    _controller_customer_name.text = _editModel.customerName.toString();
    _controller_customer_pkID.text = _editModel.customerID.toString();
    _controller_AC_name.text = _editModel.fixedLedgerAccount.toString();
    _controller_AC_ID.text = _editModel.fixedLedgerID.toString();
    _controller_bank_name.text = _editModel.bankName.toString();
    _controller_bank_ID.text = _editModel.bankID.toString();
    _controller_supplier_ref_no.text = _editModel.supplierRef.toString();
    _controller_reference_date.text = _editModel.supplierRefDate == ""
        ? selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString()
        : _editModel.supplierRefDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    _controller_rev_reference_date.text = _editModel.supplierRefDate == ""
        ? selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString()
        : _editModel.supplierRefDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_QualifiedState.text =
        _editModel.terminationOfDelieryStatename.toString();
    edt_QualifiedStateCode.text = _editModel.terminationOfDeliery.toString();
    edt_QualifiedCity.text = _editModel.terminationOfDelieryCityName.toString();
    edt_QualifiedCityCode.text = _editModel.terminationOfDelieryCity.toString();
    _controller_OtherRef_no.text = _editModel.otherRef.toString();
    _controller_docNo.text = _editModel.dispatchDocNo.toString();
    _controller_CR_Days.text = _editModel.cRDays.toString();
    _controller_select_email_subject_ID.text =
        _editModel.emailSubject.toString();
    _controller_select_email_subject.text = _editModel.emailSubject.toString();
    _contrller_email_subject.text = _editModel.emailContent.toString();
    _contrller_terms_and_condition.text = _editModel.termsCondition.toString();
    _controller_mode_of_transfer.text = _editModel.modeOfTransport.toString();
    _controller_Transporter.text = _editModel.transporterName.toString();

    _controller_LR_NO.text = _editModel.lRNo.toString();
    _controller_LR_date.text = _editModel.lRDate == ""
        ? selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString()
        : _editModel.lRDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");

    _controller_LR_date_Reveres.text = _editModel.lRDate == ""
        ? selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString()
        : _editModel.lRDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    _controller_Remarks.text = _editModel.transportRemark.toString();

    _controller_vihical_no.text = _editModel.vehicleNo.toString();
    _controller_Delivery_Notes.text = _editModel.deliveryNote.toString();
    _controller_e_way_bill_No.text = _editModel.ewayBillNo.toString();
    _controller_Mode_of_Payment.text = _editModel.modeOfPayment.toString();
    _controller_DeliverTo.text = _editModel.deliverTo.toString();
    _controller_delivery_date.text = _editModel.deliveryDate == ""
        ? selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString()
        : _editModel.deliveryDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");

    _controller_rev_delivery_date.text = _editModel.deliveryDate == ""
        ? selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString()
        : _editModel.deliveryDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    InquiryNo = _editModel.invoiceNo.toString();

    edt_StateCode.text = _editModel.terminationOfDeliery.toString();

    edt_QualifiedState.text =
        _editModel.terminationOfDelieryStatename.toString();
    edt_QualifiedStateCode.text = _editModel.terminationOfDeliery.toString();
    edt_QualifiedCity.text = _editModel.terminationOfDelieryCityName.toString();
    edt_QualifiedCityCode.text = _editModel.terminationOfDelieryCity.toString();

    if (_editModel.invoiceNo.toString() != "") {
      salesBillBloc.add(MultiNoToProductDetailsRequestEvent(
          "Edit",
          MultiNoToProductDetailsRequest(
              FetchType: "SalesBill",
              No: "," + _editModel.invoiceNo.toString() + ",",
              CustomerID: _editModel.customerID.toString(),
              CompanyId: CompanyID.toString())));

      salesBillBloc.add(SBExportListRequestEvent(SBExportListRequest(
          pkID: "",
          InvoiceNo: _editModel.invoiceNo.toString(),
          LoginUserID: LoginUserID,
          CompanyId: CompanyID.toString())));
    }
    HeaderDisAmnt = _editModel.discountAmt;
    await getInquiryProductDetails();

    salesBillBloc.add(DeleteGenericAddditionalChargesEvent());

    salesBillBloc.add(AddGenericAddditionalChargesEvent(
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
      ROffAmt: _editModel.rOffAmt.toString(),
      ChargePer1: "0.00",
      ChargePer2: "0.00",
      ChargePer3: "0.00",
      ChargePer4: "0.00",
      ChargePer5: "0.00",
    );
  }

  Widget BasicDetails() {}

  /*Widget createTextFormField(
      TextEditingController _controller, String _hintText,
      {int minLines = 1,
      int maxLines = 1,
      double height = 40,
      double left = 5,
      double right = 5,
      double top = 8,
      double bottom = 10,
      bool isEnable =true,
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
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          enabled: isEnable,
          minLines: minLines,
          maxLines: maxLines,
          style: TextStyle(fontSize: 13),
          controller: _controller,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardInput,
          decoration: InputDecoration(
              hintText: _hintText,
              hintStyle: TextStyle(fontSize: 13, color: colorGrayDark),
              filled: true,
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
  }*/

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

  Widget _buildOrderDate() {
    return InkWell(
      onTap: () {
        _selectDate(
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
                          fontSize: 15),
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

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Search Customer *",
                style: TextStyle(
                    fontSize: 11,
                    color: colorBlack,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 5,
          ),
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
                        controller: _controller_customer_name,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 7),
                          hintText: "Search customer",
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
    await OfflineDbHelper.getInstance().deleteALLSalesBillProduct();

    if (_isForUpdate == false) {
      navigateTo(context, SearchInquiryCustomerScreen.routeName).then((value) {
        if (value != null) {
          _searchInquiryListResponse = value;
          _controller_customer_name.text = _searchInquiryListResponse.label;
          _controller_customer_pkID.text =
              _searchInquiryListResponse.value.toString();

          arr_ALL_Name_ID_For_INQ_QT_SO_List.clear();
          arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.clear();
          _controller_Module_NO.text = "";
          _controller_select_inquiry.text = "";

          edt_StateCode.text = _searchInquiryListResponse.stateCode.toString();
          edt_QualifiedState.text =
              _searchInquiryListResponse.stateName.toString();
          edt_QualifiedStateCode.text =
              _searchInquiryListResponse.stateCode.toString();
          edt_QualifiedCity.text =
              _searchInquiryListResponse.CityName.toString();
          edt_QualifiedCityCode.text =
              _searchInquiryListResponse.CityCode.toString();

          /* _searchInquiryListResponse = value;
          _controller_customer_name.text = _searchInquiryListResponse.label;
          _controller_customer_pkID.text =
              _searchInquiryListResponse.value.toString();

          edt_StateCode.text = _searchInquiryListResponse.stateCode.toString();
          edt_QualifiedState.text =
              _searchInquiryListResponse.stateName.toString();
          edt_QualifiedStateCode.text =
              _searchInquiryListResponse.stateCode.toString();
          edt_QualifiedCity.text =
              _searchInquiryListResponse.CityName.toString();
          edt_QualifiedCityCode.text =
              _searchInquiryListResponse.CityCode.toString();

          arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.clear();
          _controller_select_inquiry.text = "";

          if (_controller_customer_pkID.text != null ||
              _controller_customer_pkID.text != "") {
            if (_controller_select_inquiry.text == "Inquiry") {
              salesBillBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                  SaleBill_INQ_QT_SO_NO_ListRequest(
                      CompanyId: CompanyID.toString(),
                      CustomerID: _controller_customer_pkID.text.toString(),
                      ModuleType: "Inquiry")));
            } else if (_controller_select_inquiry.text == "Quotation") {
              salesBillBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                  SaleBill_INQ_QT_SO_NO_ListRequest(
                      CompanyId: CompanyID.toString(),
                      CustomerID: _controller_customer_pkID.text.toString(),
                      ModuleType: "Quotation")));
            } else if (_controller_select_inquiry.text == "SalesOrder") {
              salesBillBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                  SaleBill_INQ_QT_SO_NO_ListRequest(
                      CompanyId: CompanyID.toString(),
                      CustomerID: _controller_customer_pkID.text.toString(),
                      ModuleType: "SalesOrder")));
            }
          } else {
            showCommonDialogWithSingleOption(
                context, "Customer name is required To view Option !",
                positiveButtonTitle: "OK");
          }*/
        }
      });
    }
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
              if (Category == "Option") {
                if (_controller_customer_name.text != "") {
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
              } else {
                showcustomdialogWithOnlyName(
                    values: Custom_values1,
                    context1: context,
                    controller: controllerForLeft,
                    lable: "$Category");
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
                lable: "Select $Category"),
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

  Widget CustomDropDownWithMultiID1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithMultipleID(
                values: arr_ALL_Name_ID_For_Terms_And_Condition,
                context1: context,
                controller: _contrller_select_terms_and_condition,
                controllerID: _contrller_select_terms_and_conditionID,
                controller2: _contrller_terms_and_condition,
                lable: "Select Term & Condition "),
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
            onTap: () => showcustomdialogWithMultipleID(
                values: arr_ALL_Name_ID_For_Email_Subject,
                context1: context,
                controller: _controller_select_email_subject,
                controllerID: _controller_select_email_subject_ID,
                controller2: _contrller_email_subject,
                lable: "Select Term & Condition "),
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

  Future<void> _selectDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedInvoiceDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedInvoiceDate = picked;
        selectedRefDate = picked;
        selectedDueDate = picked;
        selectedLRDate = picked;
        selectedDeliveryDate = picked;
        F_datecontroller.text = selectedInvoiceDate.day.toString() +
            "-" +
            selectedInvoiceDate.month.toString() +
            "-" +
            selectedInvoiceDate.year.toString();
        Rev_dateController.text = selectedInvoiceDate.year.toString() +
            "-" +
            selectedInvoiceDate.month.toString() +
            "-" +
            selectedInvoiceDate.day.toString();

        _controller_reference_date.text = selectedInvoiceDate.day.toString() +
            "-" +
            selectedInvoiceDate.month.toString() +
            "-" +
            selectedInvoiceDate.year.toString();
        _controller_rev_reference_date.text =
            selectedInvoiceDate.year.toString() +
                "-" +
                selectedInvoiceDate.month.toString() +
                "-" +
                selectedInvoiceDate.day.toString();
        _controller_work_Due_date.text = selectedInvoiceDate.day.toString() +
            "-" +
            selectedInvoiceDate.month.toString() +
            "-" +
            selectedInvoiceDate.year.toString();
        _controller_work_Due_date_Reverse.text =
            selectedInvoiceDate.year.toString() +
                "-" +
                selectedInvoiceDate.month.toString() +
                "-" +
                selectedInvoiceDate.day.toString();

        _controller_LR_date.text = selectedInvoiceDate.day.toString() +
            "-" +
            selectedInvoiceDate.month.toString() +
            "-" +
            selectedInvoiceDate.year.toString();
        _controller_LR_date_Reveres.text = selectedInvoiceDate.year.toString() +
            "-" +
            selectedInvoiceDate.month.toString() +
            "-" +
            selectedInvoiceDate.day.toString();
        _controller_delivery_date.text = selectedInvoiceDate.day.toString() +
            "-" +
            selectedInvoiceDate.month.toString() +
            "-" +
            selectedInvoiceDate.year.toString();

        _controller_rev_delivery_date.text =
            selectedInvoiceDate.year.toString() +
                "-" +
                selectedInvoiceDate.month.toString() +
                "-" +
                selectedInvoiceDate.day.toString();
      });
  }

  Future<void> _selectDueDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDueDate,
        firstDate: selectedInvoiceDate,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDueDate = picked;
        F_datecontroller.text = selectedDueDate.day.toString() +
            "-" +
            selectedDueDate.month.toString() +
            "-" +
            selectedDueDate.year.toString();
        Rev_dateController.text = selectedDueDate.year.toString() +
            "-" +
            selectedDueDate.month.toString() +
            "-" +
            selectedDueDate.day.toString();
      });
  }

  Future<void> _selectRefDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedRefDate,
        firstDate: selectedInvoiceDate,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedRefDate = picked;
        F_datecontroller.text = selectedRefDate.day.toString() +
            "-" +
            selectedRefDate.month.toString() +
            "-" +
            selectedRefDate.year.toString();
        Rev_dateController.text = selectedRefDate.year.toString() +
            "-" +
            selectedRefDate.month.toString() +
            "-" +
            selectedRefDate.day.toString();
      });
  }

  Future<void> _selectLRDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedLRDate,
        firstDate: selectedInvoiceDate,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedLRDate = picked;
        F_datecontroller.text = selectedLRDate.day.toString() +
            "-" +
            selectedLRDate.month.toString() +
            "-" +
            selectedLRDate.year.toString();
        Rev_dateController.text = selectedLRDate.year.toString() +
            "-" +
            selectedLRDate.month.toString() +
            "-" +
            selectedLRDate.day.toString();
      });
  }

  Future<void> _selectDeliveryDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDeliveryDate,
        firstDate: selectedInvoiceDate,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDeliveryDate = picked;
        F_datecontroller.text = selectedDeliveryDate.day.toString() +
            "-" +
            selectedDeliveryDate.month.toString() +
            "-" +
            selectedDeliveryDate.year.toString();
        Rev_dateController.text = selectedDeliveryDate.year.toString() +
            "-" +
            selectedDeliveryDate.month.toString() +
            "-" +
            selectedDeliveryDate.day.toString();
      });
  }

  Widget _buildReferenceDate() {
    return InkWell(
      onTap: () {
        _selectRefDate(context, _controller_reference_date,
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

  Widget _inqQtSoDropdown() {
    return InkWell(
      onTap: () {},
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
                    Icons.arrow_drop_down,
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

  Widget _ModuleDropDown(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_controller_customer_name.text != "") {
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

                      salesBillBloc.add(MultiNoToProductDetailsRequestEvent(
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
              positiveButtonTitle: "OK");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          createTextLabel("Inq/QT/SO No.", 10.0, 0.0),
          arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.length != 0
              ? Card(
                  elevation: 5,
                  color: colorLightGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: double.maxFinite,
                            height: 60,
                            child: /*Row(
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
                    ),*/

                                ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Card(
                                    elevation: 5,
                                    color: colorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List[
                                                index]
                                            .Name,
                                        style: TextStyle(
                                            fontSize: 12, color: colorWhite),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                                  arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List
                                      .length,
                            )),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: colorGrayDark,
                        size: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                )
              : Card(
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
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 7),
                                hintText: "Tap to Select No.",
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
                ),
        ],
      ),
    );
  }

  Widget _buildLRDate() {
    return InkWell(
      onTap: () {
        _selectLRDate(
            context, _controller_LR_date, _controller_LR_date_Reveres);
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
                      _controller_LR_date.text == null ||
                              _controller_LR_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_LR_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_LR_date.text == null ||
                                  _controller_LR_date.text == ""
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
        _selectDueDate(context, _controller_work_Due_date,
            _controller_work_Due_date_Reverse);
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
                      _controller_work_Due_date.text == null ||
                              _controller_work_Due_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_work_Due_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_work_Due_date.text == null ||
                                  _controller_work_Due_date.text == ""
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

  Widget QualifiedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Term.Of Del.-State",
              style: TextStyle(
                  fontSize: 11,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () => _onTapOfSearchStateView("IND"),
          child: Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: CardViewHieght,
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
                          contentPadding: EdgeInsets.only(bottom: 10),
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
          child: Text("Term.Of Del.-City",
              style: TextStyle(
                  fontSize: 11,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () => _onTapOfSearchCityView(
              edt_QualifiedStateCode.text == null
                  ? ""
                  : edt_QualifiedStateCode.text.toString()),
          child: Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: CardViewHieght,
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
                          contentPadding: EdgeInsets.only(bottom: 10),
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

  EmailContent() {
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
                        createTextLabel("Select Subject", 10.0, 0.0),
                        SizedBox(
                          height: 3,
                        ),
                        EmailSubjectWithMultiID1("Email Subject",
                            enable1: false,
                            title: "Email Subject",
                            hintTextvalue: "Tap to Select Subject",
                            icon: Icon(Icons.arrow_drop_down),
                            Custom_values1: arr_ALL_Name_ID_For_Email_Subject),
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

  TermsCondition() {
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
                        CustomDropDownWithMultiID1("Terms & Conditions",
                            enable1: false,
                            title: "Terms & Conditions",
                            hintTextvalue: "Tap to Select Terms & Conditions",
                            icon: Icon(Icons.arrow_drop_down),
                            Custom_values1:
                                arr_ALL_Name_ID_For_Terms_And_Condition),
                        SizedBox(
                          height: 10,
                        ),
                        createTextLabel("Terms & Condition", 10.0, 0.0),
                        createTextFormField(
                            _contrller_terms_and_condition, "Terms & Condition",
                            minLines: 2,
                            maxLines: 10,
                            height: 100,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
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

  BasicInformation() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
              dividerColor: Colors.transparent,
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
                    fontSize: 17,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      BASIC_INFORMATION,
                      width: 28,
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
                        Row(
                          children: [
                            Flexible(
                              child: createTextLabel("Supp.Ref #", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel("Ref. Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_supplier_ref_no, "Reference No.",
                                  keyboardInput: TextInputType.text),
                            ),
                            Flexible(child: _buildReferenceDate())
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 1, child: QualifiedState()),
                            Expanded(flex: 1, child: QualifiedCity()),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel(
                                "Other's Ref.",
                                10.0,
                                0.0,
                              ),
                            ),
                            Flexible(
                              child: createTextLabel(
                                  "Dispatch Doc. No.", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: createTextFormField(
                                    _controller_OtherRef_no, "Other's Ref.",
                                    keyboardInput: TextInputType.text)),
                            Flexible(
                                child: createTextFormField(
                                    _controller_docNo, "Dispatch Doc No.",
                                    keyboardInput: TextInputType.text))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel("CR Days", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel("Due Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: createTextFormField(
                                    _controller_CR_Days, "CR Days")),
                            Flexible(child: _buildWorkOrdereDate())
                          ],
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                createTextLabel("Currency", 10.0, 0.0),
                                CurrencyDropDown("Currency",
                                    enable1: false,
                                    title: "Select Currency",
                                    hintTextvalue: "Tap to Select Currency",
                                    icon: Icon(Icons.arrow_drop_down),
                                    controllerForLeft: _controller_currency,
                                    Custom_values1:
                                        arr_ALL_Name_ID_For_Sales_Order_Select_Currency)
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                createTextLabel("Exchange Rate", 10.0, 0.0),
                                createTextFormField(
                                    _controllerExchangeRate, "Exchange Rate"),
                              ],
                            )
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

  Widget CurrencyDropDown(String Category,
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
              salesBillBloc.add(SOCurrencyListRequestEvent(
                  SOCurrencyListRequest(
                      LoginUserID: LoginUserID,
                      CurrencyName: "",
                      CompanyID: CompanyID.toString())));
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

  MandatoryDetails() {
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
                  Flexible(child: createTextLabel("Invoice No.", 10.0, 0.0)),
                  Flexible(
                    flex: 2,
                    child: createTextLabel("Invoice Date", 10.0, 0.0),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: createTextFormField(
                        _controller_order_no, "InvoiceNo.",
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
                width: 20,
                height: 15,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text("Sales A/c*",
                    style: TextStyle(
                        fontSize: 11,
                        color: colorBlack,
                        fontWeight: FontWeight
                            .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),
              ),
              CustomDropDownWithID1("Sales A/c",
                  enable1: false,
                  title: "Sales A/c*",
                  hintTextvalue: "Tap to Select Sales A/c",
                  icon: Icon(Icons.arrow_drop_down),
                  controllerForLeft: _controller_AC_name,
                  controllerForID: _controller_AC_ID,
                  Custom_values1: arr_ALL_Name_ID_For_Sales_Order_AC_Name),
              SizedBox(
                width: 20,
                height: 15,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Text("Bank Name *",
                    style: TextStyle(
                        fontSize: 11,
                        color: colorBlack,
                        fontWeight: FontWeight
                            .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),
              ),
              CustomDropDownWithID1("Bank Name",
                  enable1: false,
                  title: "Bank Name",
                  hintTextvalue: "Tap to Select Bank",
                  icon: Icon(Icons.arrow_drop_down),
                  controllerForLeft: _controller_bank_name,
                  controllerForID: _controller_bank_ID,
                  Custom_values1: arr_ALL_Name_ID_For_Sales_Order_Bank_Name),
              SizedBox(
                width: 20,
                height: 15,
              ),
              ProjectList("Project",
                  enable1: false,
                  title: "Project",
                  hintTextvalue: "Tap to Select Project",
                  icon: Icon(Icons.arrow_drop_down),
                  controllerForLeft: edt_ProjectName,
                  controllerpkID: edt_ProjectID,
                  Custom_values1: arr_ALL_Name_ID_For_ProjectList),
              SizedBox(
                width: 20,
                height: 15,
              ),
              _isForUpdate == true
                  ? Container()
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Select Option", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            CustomDropDown1("Option",
                                enable1: false,
                                title: "Select Option",
                                hintTextvalue: "Tap to select",
                                icon: Icon(Icons.arrow_drop_down),
                                controllerForLeft: _controller_select_inquiry,
                                Custom_values1:
                                    arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry),
                            SizedBox(
                              height: 10,
                            ),
                            _ModuleDropDown(context),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
      // height: 60,
    );
  }

  ProductDetails() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          child: getCommonButton(baseTheme, () {
            if (_controller_customer_name.text != "") {
              // print("INWWWE" + InquiryNo.toString());

              navigateTo(context, SBProductListScreen.routeName,
                  arguments: SBProductListArgument(
                      InquiryNo, edt_StateCode.text, edt_HeaderDisc.text));
            } else {
              showCommonDialogWithSingleOption(
                  context, "Customer name is required To view Product !",
                  positiveButtonTitle: "OK");
            }
          }, "Products",
              width: 600,
              textColor: colorPrimary,
              backGroundColor: colorGreenLight,
              radius: 25.0),
        ),
      ],
    );
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<SaleBillTable> temp =
        await OfflineDbHelper.getInstance().getSalesBillProduct();
    _inquiryProductList.addAll(temp);
    setState(() {});
  }

  TransportDetails() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
              dividerColor: Colors.transparent,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Transport Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      BASIC_INFORMATION,
                      width: 28,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel(
                                  "Mode Of Transport #", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel(
                                  "Transporter Name", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              // flex: 2,
                              child: CustomDropDown1("Mode Of Transport #",
                                  enable1: false,
                                  title: "Select Mode",
                                  hintTextvalue: "Tap to select",
                                  icon: Icon(Icons.arrow_drop_down),
                                  controllerForLeft:
                                      _controller_mode_of_transfer,
                                  Custom_values1:
                                      arr_ALL_Name_ID_For_ModeOfTransfer),
                            ),
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    _controller_Transporter, "Transporter Name",
                                    keyboardInput: TextInputType.text)),
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
                                  createTextLabel("LR No./DC No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("LR Date/DC Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    _controller_LR_NO, "LR No./DC No.")),
                            Flexible(child: _buildLRDate())
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        createTextLabel("Remarks", 10.0, 0.0),
                        createTextFormField(
                            _controller_Remarks, "Tap to enter remarks",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            keyboardInput: TextInputType.text),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel("Vehicle No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Delivery Note", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    _controller_vihical_no, "Vehicle No.",
                                    keyboardInput: TextInputType.text)),
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    _controller_Delivery_Notes, "Delivery Note",
                                    keyboardInput: TextInputType.text)),
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
                                  createTextLabel("e-Way Bill No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Mode Of Payment", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    _controller_e_way_bill_No, "Bill No.",
                                    keyboardInput: TextInputType.text)),
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    _controller_Mode_of_Payment,
                                    "Mode Of Payment",
                                    keyboardInput: TextInputType.text)),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel("Deliver To", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Delivery Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    _controller_DeliverTo, "Deliver To",
                                    keyboardInput: TextInputType.text)),
                            Flexible(child: _buildDeliveryDate())
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

  Attachments() {
    return Visibility(
      visible: false,
      child: Container(
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          elevation: 2,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xff362d8b),
                borderRadius: BorderRadius.circular(20)
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
                    "Attachment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  leading: Container(child: Icon(Icons.attachment)),
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
                          AttachedFileList(),
                          SizedBox(
                            height: 5,
                          ),
                          getCommonButton(baseTheme, () async {
                            if (await Permission.storage.isDenied) {
                              //await Permission.storage.request();

                              checkPhotoPermissionStatus();
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return SafeArea(
                                      child: Container(
                                        child: new Wrap(
                                          children: <Widget>[
                                            new ListTile(
                                                leading: new Icon(
                                                    Icons.photo_library),
                                                title: new Text('Choose Files'),
                                                onTap: () async {
                                                  Navigator.of(context).pop();
                                                  FilePickerResult result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    allowMultiple: true,
                                                  );
                                                  if (result != null) {
                                                    List<File> files = result
                                                        .paths
                                                        .map((path) =>
                                                            File(path))
                                                        .toList();
                                                    setState(() {
                                                      MultipleVideoList.addAll(
                                                          files);
                                                    });
                                                  } else {
                                                    // User canceled the picker
                                                  }
                                                }),
                                            new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_camera),
                                              title: new Text('Choose Image'),
                                              onTap: () async {
                                                Navigator.of(context).pop();

                                                XFile file =
                                                    await imagepicker.pickImage(
                                                  source: ImageSource.camera,
                                                );
                                                setState(() {
                                                  MultipleVideoList.add(
                                                      File(file.path));
                                                });
                                              },
                                            ),
                                            new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_camera),
                                              title: new Text('Choose Video'),
                                              onTap: () async {
                                                Navigator.of(context).pop();

                                                XFile file =
                                                    await imagepicker.pickVideo(
                                                        source:
                                                            ImageSource.camera,
                                                        maxDuration:
                                                            const Duration(
                                                                seconds: 10));
                                                setState(() {
                                                  MultipleVideoList.add(
                                                      File(file.path));
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }, "Choose File",
                              radius: 20,
                              backGroundColor: Color(0xff02b1fc),
                              textColor: colorWhite)
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

  ShipmentDetails() {
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
                                  _controller_flight_no, "Enter Flight No."),
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
                                  "Enter Container No."),
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
                                  _controller_net_weight, "Enter Net Weight"),
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
                                  "Enter Gross Weight"),
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

  AttachedFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showCommonDialogWithTwoOptions(context,
                          "Are you sure you want to delete this File ?",
                          negativeButtonTitle: "No", positiveButtonTitle: "Yes",
                          onTapOfPositiveButton: () {
                        Navigator.of(context).pop();
                        MultipleVideoList.removeAt(index);
                        setState(() {});
                      });
                    },
                    child: Icon(
                      Icons.delete_forever,
                      size: 32,
                      color: colorPrimary,
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: colorLightGray,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      width: 300,
                      /* decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: colorLightGray,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),*/
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              OpenFile.open(MultipleVideoList[index].path);
                            },
                            child: Text(
                              MultipleVideoList[index].path.split('/').last,
                              // overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 10, color: colorPrimary),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            );

            // }
          },
          shrinkWrap: true,
          itemCount: MultipleVideoList.length,
        ),
      ],
    );
  }

  void getAccountNameAPI() {
    ALL_Name_ID all_name_id = ALL_Name_ID();
    all_name_id.Name = "KISHAN RATHOD A/C";
    all_name_id.pkID = 91769;
    arr_ALL_Name_ID_For_Sales_Order_AC_Name.add(all_name_id);
  }

  void _OnBankDetailsSucess(QuotationBankDropDownResponseState state) {
    arr_ALL_Name_ID_For_Sales_Order_Bank_Name.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.response.details[i].pkID;
      all_name_id.Name = state.response.details[i].bankName;
      arr_ALL_Name_ID_For_Sales_Order_Bank_Name.add(all_name_id);
    }
  }

  void _OnTermsAndConditionResponse(QuotationTermsCondtionResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_Terms_And_Condition.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].tNCHeader);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].tNCHeader;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].tNCContent;

        arr_ALL_Name_ID_For_Terms_And_Condition.add(all_name_id);
      }
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
    }
  }

  void _OnGenericIsertCallSucess(AddGenericAddditionalChargesState state) {
    print("_OnGenericIsertCallSucess" + state.response);
  }

  void _onDeleteAllGenericAddtionalAmount(
      DeleteAllGenericAddditionalChargesState state) {
    print("DeleteAllGenericAddditionalChargesState" + state.response);
  }

  void getSelectOptionList() {
    arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Inquiry";
      } else if (i == 1) {
        all_name_id.Name = "Quotation";
      } else if (i == 2) {
        all_name_id.Name = "SalesOrder";
      }
      arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry.add(all_name_id);
    }
  }

  void getModeOfTransport() {
    arr_ALL_Name_ID_For_ModeOfTransfer.clear();
    for (var i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Road";
      } else if (i == 1) {
        all_name_id.Name = "Rail";
      } else if (i == 2) {
        all_name_id.Name = "Air";
      } else if (i == 3) {
        all_name_id.Name = "Ship";
      }
      arr_ALL_Name_ID_For_ModeOfTransfer.add(all_name_id);
    }
  }

  //arr_ALL_Name_ID_For_ModeOfTransfer

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

  save() {
    return // Save
        Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            child: getCommonButton(
              baseTheme,
              () async {
                if (_controller_order_date.text != "") {
                  if (_controller_customer_name.text != "") {
                    if (_controller_bank_name.text != "") {
                      if (_controller_AC_ID.text != "") {
                        List<SaleBillTable> temp =
                            await OfflineDbHelper.getInstance()
                                .getSalesBillProduct();

                        if (temp.length != 0) {
                          showCommonDialogWithTwoOptions(context,
                              "Are you sure you want to Save this SalesBill ?",
                              negativeButtonTitle: "No",
                              positiveButtonTitle: "Yes",
                              onTapOfPositiveButton: () async {
                            Navigator.of(context).pop();

                            if (InquiryNo != '') {
                              /* salesBillBloc.add(
                                SalesOrderProductDeleteRequestEvent(
                                    pkID,
                                    SalesOrderAllProductDeleteRequest(
                                        CompanyId: CompanyID.toString())));*/
                            } else {}

                            HeaderDisAmnt = edt_HeaderDisc.text.isNotEmpty
                                ? double.parse(edt_HeaderDisc.text)
                                : 0.00;

                            List<SaleBillTable> TempproductList1 =
                                SalesBillOrderHeaderDiscountCalculation
                                    .txtHeadDiscount_WithZero(
                                        temp,
                                        HeaderDisAmnt,
                                        _offlineLoggedInData
                                            .details[0].stateCode
                                            .toString(),
                                        edt_StateCode.text.toString());

                            List<SaleBillTable> TempproductList =
                                SalesBillOrderHeaderDiscountCalculation
                                    .txtHeadDiscount_TextChanged(
                                        TempproductList1,
                                        HeaderDisAmnt,
                                        _offlineLoggedInData
                                            .details[0].stateCode
                                            .toString(),
                                        edt_StateCode.text.toString());


                            for (int i = 0; i < temp.length; i++) {
                              print("productList2322rty" +
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
                              print("sjsdkfjsj90-0" +
                                  " AmountCalculation : " +
                                  TempproductList1[i]
                                      .DiscountPercent
                                      .toString() +
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
                              print("4545fsdfsdf" +
                                  " AmountCalculation : " +
                                  TempproductList[i]
                                      .DiscountPercent
                                      .toString() +
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

                            String SupplRefNo = _controller_supplier_ref_no.text
                                            .toString() !=
                                        "" ||
                                    _controller_supplier_ref_no.text
                                            .toString() !=
                                        null
                                ? _controller_supplier_ref_no.text.toString()
                                : "";

                            String OtherRef =
                                _controller_OtherRef_no.text.toString() != "" ||
                                        _controller_OtherRef_no.text
                                                .toString() !=
                                            null
                                    ? _controller_OtherRef_no.text.toString()
                                    : "";

                            String DispatchNo =
                                _controller_docNo.text.toString() != "" ||
                                        _controller_docNo.text.toString() !=
                                            null
                                    ? _controller_docNo.text.toString()
                                    : "";

                            String EmailSubject =
                                _controller_select_email_subject.text
                                                .toString() !=
                                            "" ||
                                        _controller_select_email_subject.text
                                                .toString() !=
                                            null
                                    ? _controller_select_email_subject.text
                                        .toString()
                                    : "";

                            String EmailContent = _contrller_email_subject.text
                                            .toString() !=
                                        "" ||
                                    _contrller_email_subject.text.toString() !=
                                        null
                                ? _contrller_email_subject.text.toString()
                                : "";

                            String Terms_Condition =
                                _contrller_terms_and_condition.text
                                                .toString() !=
                                            "" ||
                                        _contrller_terms_and_condition.text
                                                .toString() !=
                                            null
                                    ? _contrller_terms_and_condition.text
                                        .toString()
                                    : "";

                            String ModeOfTransfer = _controller_mode_of_transfer
                                            .text
                                            .toString() !=
                                        "" ||
                                    _controller_mode_of_transfer.text
                                            .toString() !=
                                        null
                                ? _controller_mode_of_transfer.text.toString()
                                : "";

                            String TransporterName =
                                _controller_Transporter.text.toString() != "" ||
                                        _controller_Transporter.text
                                                .toString() !=
                                            null
                                    ? _controller_Transporter.text.toString()
                                    : "";

                            String LrNo = _controller_LR_NO.text.toString() !=
                                        "" ||
                                    _controller_LR_NO.text.toString() != null
                                ? _controller_LR_NO.text.toString()
                                : "";

                            String LrDate = _controller_LR_date_Reveres.text
                                            .toString() !=
                                        "" ||
                                    _controller_LR_date_Reveres.text
                                            .toString() !=
                                        null
                                ? _controller_LR_date_Reveres.text.toString()
                                : "";

                            String TransporterRemarks =
                                _controller_Remarks.text.toString() != "" ||
                                        _controller_Remarks.text.toString() !=
                                            null
                                    ? _controller_Remarks.text.toString()
                                    : "";

                            String VehicalNo =
                                _controller_vihical_no.text.toString() != "" ||
                                        _controller_vihical_no.text
                                                .toString() !=
                                            null
                                    ? _controller_vihical_no.text.toString()
                                    : "";

                            String DeliveryNote =
                                _controller_Delivery_Notes.text.toString() !=
                                            "" ||
                                        _controller_Delivery_Notes.text
                                                .toString() !=
                                            null
                                    ? _controller_Delivery_Notes.text.toString()
                                    : "";

                            String eWayBillNo = _controller_e_way_bill_No.text
                                            .toString() !=
                                        "" ||
                                    _controller_e_way_bill_No.text.toString() !=
                                        null
                                ? _controller_e_way_bill_No.text.toString()
                                : "";

                            String ModeOfPayment = _controller_Mode_of_Payment
                                            .text
                                            .toString() !=
                                        "" ||
                                    _controller_Mode_of_Payment.text
                                            .toString() !=
                                        null
                                ? _controller_Mode_of_Payment.text.toString()
                                : "";

                            String DeliveryTo =
                                _controller_DeliverTo.text.toString() != "" ||
                                        _controller_DeliverTo.text.toString() !=
                                            null
                                    ? _controller_DeliverTo.text.toString()
                                    : "";

                            String DeliveryDate = _controller_rev_delivery_date
                                            .text
                                            .toString() !=
                                        "" ||
                                    _controller_rev_delivery_date.text
                                            .toString() !=
                                        null
                                ? _controller_rev_delivery_date.text.toString()
                                : "";

                            String FixedLedgerID =
                                _controller_AC_ID.text.toString() != "" ||
                                        _controller_AC_ID.text.toString() !=
                                            null
                                    ? _controller_AC_ID.text.toString()
                                    : "0";

                            salesBillBloc.add(SBHeaderSaveRequestEvent(
                                context,
                                pkID,
                                SBHeaderSaveRequest(
                                    InvoiceNo: InquiryNo,
                                    InvoiceDate:
                                        _controller_rev_order_date.text,
                                    FixedLedgerID: FixedLedgerID.toString()=="null"?"0":FixedLedgerID,
                                    CustomerID: _controller_customer_pkID.text,
                                    LocationID: "",
                                    BankID: _controller_bank_ID.text,
                                    TerminationOfDeliery:
                                        edt_QualifiedStateCode.text,
                                    TerminationOfDelieryCity:
                                        edt_QualifiedCityCode.text,
                                    TermsCondition: Terms_Condition,
                                    InquiryNo: "",
                                    OrderNo: "",
                                    QuotationNo: "",
                                    ComplaintNo: "",
                                    RefType: "",
                                    SupplierRef: SupplRefNo,
                                    SupplierRefDate:
                                        _controller_rev_reference_date.text,
                                    EmailSubject: EmailSubject,
                                    EmailContent: EmailContent,
                                    OtherRef: OtherRef,
                                    PatientName: "",
                                    PatientType: "",
                                    Amount: "0.00",
                                    Percentage: "0.00",
                                    EstimatedAmt: "0.00",
                                    BasicAmt: finalPrice[0].toStringAsFixed(2),
                                    DiscountAmt: edt_HeaderDisc.text.toString(),
                                    SGSTAmt: finalPrice[4].toStringAsFixed(2),
                                    CGSTAmt: finalPrice[3].toStringAsFixed(2),
                                    IGSTAmt: finalPrice[5].toStringAsFixed(2),
                                    ROffAmt: finalPrice[18].toStringAsFixed(2),
                                    ChargeID1: quotationOtherChargesListResponse[0]
                                        .ChargeID1,
                                    ChargeAmt1: quotationOtherChargesListResponse[0]
                                        .ChargeAmt1,
                                    ChargeBasicAmt1:
                                        finalPrice[6].toStringAsFixed(2),
                                    ChargeGSTAmt1:
                                        finalPrice[11].toStringAsFixed(2),
                                    ChargeID2: quotationOtherChargesListResponse[0]
                                        .ChargeID2,
                                    ChargeAmt2: quotationOtherChargesListResponse[0]
                                        .ChargeAmt2,
                                    ChargeBasicAmt2:
                                        finalPrice[7].toStringAsFixed(2),
                                    ChargeGSTAmt2:
                                        finalPrice[12].toStringAsFixed(2),
                                    ChargeID3: quotationOtherChargesListResponse[0]
                                        .ChargeID3,
                                    ChargeAmt3: quotationOtherChargesListResponse[0]
                                        .ChargeAmt3,
                                    ChargeBasicAmt3: finalPrice[8].toStringAsFixed(2),
                                    ChargeGSTAmt3: finalPrice[13].toStringAsFixed(2),
                                    ChargeID4: quotationOtherChargesListResponse[0].ChargeID4,
                                    ChargeAmt4: quotationOtherChargesListResponse[0].ChargeAmt4,
                                    ChargeBasicAmt4: finalPrice[9].toStringAsFixed(2),
                                    ChargeGSTAmt4: finalPrice[14].toStringAsFixed(2),
                                    ChargeID5: quotationOtherChargesListResponse[0].ChargeID5,
                                    ChargeAmt5: quotationOtherChargesListResponse[0].ChargeAmt5,
                                    ChargeBasicAmt5: finalPrice[10].toStringAsFixed(2),
                                    ChargeGSTAmt5: finalPrice[15].toStringAsFixed(2),
                                    NetAmt: finalPrice[17].toStringAsFixed(2),
                                    ModeOfTransport: ModeOfTransfer,
                                    TransporterName: TransporterName,
                                    DeliverTo: DeliveryTo,
                                    VehicleNo: VehicalNo,
                                    LRNo: LrNo,
                                    DeliveryNote: DeliveryNote,
                                    DeliveryDate: DeliveryDate,
                                    DispatchDocNo: DispatchNo,
                                    LRDate: LrDate,
                                    EwayBillNo: eWayBillNo,
                                    ModeOfPayment: ModeOfPayment,
                                    TransportRemark: TransporterRemarks,
                                    LoginUserID: LoginUserID,
                                    ReturnInvoiceNo: "",
                                    CompanyId: CompanyID.toString(),
                                    CRDays: _controller_CR_Days.text.toString(),
                                    DueDate: _controller_work_Due_date_Reverse.text.toString(),
                                    CurrencyName: _controller_currency.text.toString(),
                                    CurrencySymbol: _controller_currency_Symbol.text.toString(),
                                    ExchangeRate: _controllerExchangeRate.text.toString(),
                                    ProjectName: edt_ProjectName.text),
                                SBExportSaveRequest(
                                    InvoiceNo: "",
                                    PreCarrBy: _controller_transport_name.text.toString(),
                                    PreCarrRecPlace: _controller_place_of_rec.text.toString(),
                                    FlightNo: _controller_flight_no.text.toString(),
                                    PortOfLoading: _controller_port_of_loading.text.toString(),
                                    PortOfDispatch: _controller_port_of_dispatch.text.toString(),
                                    PortOfDestination: _controller_port_of_destination.text.toString(),
                                    MarksNo: _controller_container_no.text.toString(),
                                    Packages: _controller_packages.text.toString(),
                                    NetWeight: _controller_net_weight.text.toString(),
                                    GrossWeight: _controller_gross_weight.text.toString(),
                                    PackageType: _controller_type_of_package.text.toString(),
                                    FreeOnBoard: _controller_FOB.text.toString(),
                                    LoginUserID: LoginUserID.toString(),
                                    CompanyId: CompanyID.toString()),
                                SbAllProductDeleteRequest(
                                    InvoiceNo: "",
                                    CompanyId: CompanyID.toString()
                                )
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
                        //Ledger Selection is required.
                        showCommonDialogWithSingleOption(
                            context, "Ledger Selection is required !",
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

                    // await getInquiryProductDetails();
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
      List<SaleBillTable> tempproductList,
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

      /*  if (_otherChargeNameController4.isNotEmpty) {
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
          SalesBillOrderHeaderDiscountCalculation.funCalculateTotal(
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

  void _OnGenricOtherChargeResponse(
      GenericOtherCharge1ListResponseState state) {
    arrGenericOtheCharge.clear();

    for (int i = 0;
        i < state.quotationOtherChargesListResponse.details.length;
        i++) {
      arrGenericOtheCharge
          .add(state.quotationOtherChargesListResponse.details[i]);
    }
  }

  void _OnSalesOrderHeaderSaveSucessResponse(SBHeaderSaveResponseState state) {
    int returnPKID = 0;
    String retrunQT_No = "";
    for (int i = 0; i < state.sbHeaderSaveResponse.details.length; i++) {
      returnPKID =
          0; //int.parse(state.sbHeaderSaveResponse.details[i].column3);
      retrunQT_No = state.sbHeaderSaveResponse.details[i].column3;
    }

    if (_isForUpdate == true) {
      retrunQT_No = _editModel.invoiceNo;
    }

    /*salesBillBloc.add(SBExportSaveRequestEvent(SBExportSaveRequest(
        InvoiceNo: retrunQT_No,
        PreCarrBy: _controller_transport_name.text.toString(),
        PreCarrRecPlace: _controller_place_of_rec.text.toString(),
        FlightNo: _controller_flight_no.text.toString(),
        PortOfLoading: _controller_port_of_loading.text.toString(),
        PortOfDispatch: _controller_port_of_dispatch.text.toString(),
        PortOfDestination: _controller_port_of_destination.text.toString(),
        MarksNo: _controller_container_no.text.toString(),
        Packages: _controller_packages.text.toString(),
        NetWeight: _controller_net_weight.text.toString(),
        GrossWeight: _controller_gross_weight.text.toString(),
        PackageType: _controller_type_of_package.text.toString(),
        FreeOnBoard: _controller_FOB.text.toString(),
        LoginUserID: LoginUserID.toString(),
        CompanyId: CompanyID.toString())));*/



   /* salesBillBloc.add(SbAllProductDeleteRequestCallEvent(
        SbAllProductDeleteRequest(
          InvoiceNo: retrunQT_No,
          CompanyId: CompanyID.toString()
        )
    ));*/

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

    List<SaleBillTable> TempproductList1 =
        SalesBillOrderHeaderDiscountCalculation.txtHeadDiscount_WithZero(
            _inquiryProductList,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    List<SaleBillTable> TempproductList =
        SalesBillOrderHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
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

    print("BothListSizedsdsdsd" + " TempListCount : " +  TempproductList.length.toString() + " ArrayProductListCount : " + arrSOProductList.length.toString());

    for (int i = 0; i < TempproductList.length; i++) {
      SBProductSaveRequest salesOrderProductRequest =
          /* SalesOrderProductRequest(
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
      );*/

          SBProductSaveRequest(
              pkID: 0,
              InvoiceNo: retrunSO_No,
              ProductID: TempproductList[i].ProductID.toString(),
              TaxType: TempproductList[i].TaxType.toString(),
              UnitQty: "0",
              Qty: TempproductList[i].Quantity.toString(),
              Unit: TempproductList[i].Unit.toString(),
              Rate: TempproductList[i].UnitRate.toStringAsFixed(2),
              DiscountPer:
                  TempproductList[i].DiscountPercent.toStringAsFixed(2),
              DiscountAmt: TempproductList[i].DiscountAmt.toStringAsFixed(2),
              NetRate: TempproductList[i].NetRate.toStringAsFixed(2),
              Amount: TempproductList[i].Amount.toStringAsFixed(2),
              SGSTPer: TempproductList[i].SGSTPer.toStringAsFixed(2),
              SGSTAmt: TempproductList[i].SGSTAmt.toStringAsFixed(2),
              CGSTPer: TempproductList[i].CGSTPer.toStringAsFixed(2),
              CGSTAmt: TempproductList[i].CGSTAmt.toStringAsFixed(2),
              IGSTPer: TempproductList[i].IGSTPer.toStringAsFixed(2),
              IGSTAmt: TempproductList[i].IGSTAmt.toStringAsFixed(2),
              AddTaxPer: TempproductList[i].TaxRate.toString(),
              AddTaxAmt: TempproductList[i].TaxAmount.toStringAsFixed(2),
              NetAmt: TempproductList[i].NetAmount.toStringAsFixed(2),
              HeaderDiscAmt:
                  TempproductList[i].HeaderDiscAmt.toStringAsFixed(2),
              ForOrderNo: "",
              LocationID: "",
              ProductSpecification: "",
              LoginUserID: LoginUserID,
              CompanyId: CompanyID);

      arrSOProductList.add(salesOrderProductRequest);
    }


    print("BothListSized" + " TempListCount : " +  TempproductList.length.toString() + " ArrayProductListCount : " + arrSOProductList.length.toString());

    salesBillBloc.add(
        SBProductSaveRequestEvent(context1, retrunSO_No, arrSOProductList));
  }

  void _OnSaleOrderProductSaveResponse(SBProductSaveResponseState state) async {
    String Msg = _isForUpdate == true
        ? "SalesBill Updated Successfully"
        : "SalesBill Added Successfully";

    showCommonDialogWithSingleOption(state.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(state.context, SalesBillListScreen.routeName,
          clearAllStack: true);
    });
    /* await showCommonDialogWithSingleOption(Globals.context, Msg,
        positiveButtonTitle: "OK");
    Navigator.of(context).pop();*/
  }

  void _On_No_To_ProductDetails(
      MultiNoToProductDetailsResponseState state) async {
    if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLSalesBillProduct();

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

        await OfflineDbHelper.getInstance().insertSalesBillProduct(
            SaleBillTable(
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
                0.00));
      }

      if (state.FetchFromWhichScreen == "Add") {
        navigateTo(context, SBProductListScreen.routeName,
            arguments: SBProductListArgument(
                InquiryNo, edt_StateCode.text, edt_HeaderDisc.text));
      }
      /*navigateTo(context, SOProductListScreen.routeName,
          arguments: SOProductListArgument(
              SalesOrderNo, edt_StateCode.text, edt_HeaderDisc.text));*/
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
                        ProductDetails(),
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

                                navigateTo(context,
                                        NewSalesBillOtherChargeScreen.routeName,
                                        arguments:
                                            NewSalesBillOtherChargesScreenArguments(
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
                        SizedBox(
                          height: 10,
                        ),
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

                                navigateTo(context,
                                        NewSalesBillOtherChargeScreen.routeName,
                                        arguments:
                                            NewSalesBillOtherChargesScreenArguments(
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

  void _OnSBExportListResponse(SBExportListResponseState state) {
    _controller_transport_name.text = "";
    _controller_place_of_rec.text = "";
    _controller_flight_no.text = "";
    _controller_port_of_loading.text = "";
    _controller_port_of_dispatch.text = "";
    _controller_port_of_destination.text = "";
    _controller_container_no.text = "";
    _controller_packages.text = "";
    _controller_type_of_package.text = "";
    _controller_net_weight.text = "";
    _controller_gross_weight.text = "";
    _controller_FOB.text = "";


    if(state.response.details.isNotEmpty)
      {
        _controller_transport_name.text = state.response.details[0].preCarrBy;
        _controller_place_of_rec.text = state.response.details[0].preCarrRecPlace;
        _controller_flight_no.text = state.response.details[0].flightNo.toString();
        _controller_port_of_loading.text =
            state.response.details[0].portOfLoading.toString();
        _controller_port_of_dispatch.text =
            state.response.details[0].portOfDispatch.toString();
        _controller_port_of_destination.text =
            state.response.details[0].portOfDestination.toString();
        _controller_container_no.text =
            state.response.details[0].marksNo.toString();
        _controller_packages.text = state.response.details[0].packages.toString();
        _controller_type_of_package.text =
            state.response.details[0].packageType.toString();
        _controller_net_weight.text =
            state.response.details[0].netWeight.toString();
        _controller_gross_weight.text =
            state.response.details[0].grossWeight.toString();
        _controller_FOB.text = state.response.details[0].freeOnBoard.toString();
      }
    else{
      _controller_transport_name.text = "";
      _controller_place_of_rec.text = "";
      _controller_flight_no.text = "";
      _controller_port_of_loading.text =
          "";
      _controller_port_of_dispatch.text =
          "";
      _controller_port_of_destination.text =
          "";
      _controller_container_no.text =
          "";
      _controller_packages.text = "";
      _controller_type_of_package.text =
          "";
      _controller_net_weight.text =
          "";
      _controller_gross_weight.text =
          "";
      _controller_FOB.text = "";
    }


  }

  void _OnSBExportSaveResponse(SBProductSaveResponseState state) {
    print("SBSaveResponse" +
        "ExportDetails Response" +
        state.sbProductSaveResponse.details[0].column2);
  }

  void _onDeleteAllQTAssemblyResponse(SBAssemblyTableDeleteALLState state) {
    print("deleteAllSalesOrderAssembly" + state.response);
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

  Widget ProjectList(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          InkWell(
            onTap:
                () => /*showcustomdialogWithID(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                controllerID: controllerpkID,
                lable: "Select $Category")*/

                    salesBillBloc.add(QuotationProjectListCallEvent(
                        QuotationProjectListRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 10,
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

  void _OnGetProjectList(QuotationProjectListResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_ProjectList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].projectName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].projectName;
        all_name_id.pkID = state.response.details[i].pkID;
        arr_ALL_Name_ID_For_ProjectList.add(all_name_id);
      }
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_ProjectList,
          context1: context,
          controller: edt_ProjectName,
          controllerID: edt_ProjectID,
          lable: "Select Project ");
    }

    else{
      showCommonDialogWithSingleOption(
          context, "Project is not available ",
          positiveButtonTitle: "OK");
    }
  }
}
