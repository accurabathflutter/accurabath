import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/bank_voucher/bank_drop_down_request.dart';
import 'package:for_practice_the_app/models/api_requests/customer/cust_id_inq_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/followup/followup_type_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_to_product_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/other/specification_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/qt_Organization_drop_down_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/qt_spec_save_api_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_header_save_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_kind_att_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_no_to_product_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_product_delete_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:for_practice_the_app/models/api_requests/quotation/save_email_content_request.dart';
import 'package:for_practice_the_app/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:for_practice_the_app/models/common/generic_other_charge.dart';
import 'package:for_practice_the_app/models/common/other_charge_table.dart';
import 'package:for_practice_the_app/models/common/qt_other_charge_temp.dart';
import 'package:for_practice_the_app/models/common/quotationtable.dart';
import 'package:for_practice_the_app/models/pushnotification/get_report_to_token_request.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/addtional_charges/quotation_summary_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/products/old_quotation_product_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/quotation_general_customer_search_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/calculation/additional_charges_calculation.dart';
import 'package:for_practice_the_app/utils/calculation/header_discount_calculation.dart';
import 'package:for_practice_the_app/utils/calculation/model/additonalChargeDetails.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

class AddUpdateQuotationScreenArguments {
  QuotationDetails editModel;

  AddUpdateQuotationScreenArguments(this.editModel);
}

class QuotationAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/QuotationAddEditScreen';
  final AddUpdateQuotationScreenArguments arguments;

  QuotationAddEditScreen(this.arguments);

  @override
  _QuotationAddEditScreenState createState() => _QuotationAddEditScreenState();
}

class _QuotationAddEditScreenState extends BaseState<QuotationAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  QuotationBloc _inquiryBloc;
  int _pageNo = 0;
  bool expanded = true;
  double sizeboxsize = 12;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  //CustomerSourceResponse _offlineCustomerSource;
  //InquiryStatusListResponse _offlineInquiryLeadStatusData;

  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  DateTime selectedNextFollowupDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController edt_InquiryDate = TextEditingController();
  final TextEditingController edt_ReverseInquiryDate = TextEditingController();
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_Priority = TextEditingController();
  final TextEditingController edt_LeadStatus = TextEditingController();
  final TextEditingController edt_LeadStatusID = TextEditingController();
  final TextEditingController edt_LeadSource = TextEditingController();
  final TextEditingController edt_LeadSourceID = TextEditingController();
  final TextEditingController edt_Reference_Name = TextEditingController();
  final TextEditingController edt_Reference_No = TextEditingController();
  final TextEditingController edt_Description = TextEditingController();
  final TextEditingController edt_FollowupNotes = TextEditingController();

  final TextEditingController edt_NextFollowupDate = TextEditingController();
  final TextEditingController edt_StateCode = TextEditingController();

  final TextEditingController edt_ReverseNextFollowupDate =
      TextEditingController();
  final TextEditingController edt_PreferedTime = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_Priority = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadSource = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_KindAttList = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_OrganizationList = [];

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TermConditionList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_InqNoList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Email_Subject = [];

  final TextEditingController edt_KindAtt = TextEditingController();
  final TextEditingController edt_KindAttID = TextEditingController();

  final TextEditingController edt_OrganizationName = TextEditingController();
  final TextEditingController edt_OrganizationCode = TextEditingController();
  final TextEditingController edt_ProjectName = TextEditingController();
  final TextEditingController edt_ProjectID = TextEditingController();
  final TextEditingController edt_TermConditionHeader = TextEditingController();
  final TextEditingController edt_TermConditionHeaderID =
      TextEditingController();

  final TextEditingController edt_TermConditionFooter = TextEditingController();
  final TextEditingController edt_InquiryNo = TextEditingController();
  final TextEditingController edt_InquiryNoID = TextEditingController();
  final TextEditingController edt_InquiryNoExist = TextEditingController();

  final TextEditingController edt_ChargeID1 = TextEditingController();
  final TextEditingController edt_ChargeName1 = TextEditingController();

  final TextEditingController edt_ChargeTaxType1 = TextEditingController();
  final TextEditingController edt_ChargeGstPer1 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST1 = TextEditingController();

  final TextEditingController edt_ChargeID2 = TextEditingController();
  final TextEditingController edt_ChargeName2 = TextEditingController();

  final TextEditingController edt_ChargeTaxType2 = TextEditingController();
  final TextEditingController edt_ChargeGstPer2 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST2 = TextEditingController();

  final TextEditingController edt_ChargeID3 = TextEditingController();
  final TextEditingController edt_ChargeName3 = TextEditingController();

  final TextEditingController edt_ChargeTaxType3 = TextEditingController();
  final TextEditingController edt_ChargeGstPer3 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST3 = TextEditingController();

  final TextEditingController edt_ChargeID4 = TextEditingController();
  final TextEditingController edt_ChargeName4 = TextEditingController();

  final TextEditingController edt_ChargeTaxType4 = TextEditingController();
  final TextEditingController edt_ChargeGstPer4 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST4 = TextEditingController();

  final TextEditingController edt_ChargeID5 = TextEditingController();
  final TextEditingController edt_ChargeName5 = TextEditingController();

  final TextEditingController edt_ChargeTaxType5 = TextEditingController();
  final TextEditingController edt_ChargeGstPer5 = TextEditingController();
  final TextEditingController edt_ChargeBeforGST5 = TextEditingController();
  final TextEditingController edt_HeaderDisc = TextEditingController();

  final TextEditingController _controller_exchange_rate =
      TextEditingController();
  final TextEditingController _controller_credit_days = TextEditingController();
  TextEditingController _controller_currency = TextEditingController();
  TextEditingController _controller_currency_Symbol = TextEditingController();
  TextEditingController _controller_reference_no = TextEditingController();
  TextEditingController _controller_reference_date = TextEditingController();
  TextEditingController _controller_rev_reference_date =
      TextEditingController();
  DateTime selectedDateRefrence = DateTime.now();

  double dateFontSize = 13;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Currency = [];

  //

  TextEditingController _controller_select_email_subject =
      TextEditingController();
  TextEditingController _controller_select_email_subject_ID =
      TextEditingController();
  TextEditingController _controller_Ref_Inquiry = TextEditingController();
  TextEditingController _contrller_other_Remarks = TextEditingController();
  TextEditingController _contrller_Email_Discription = TextEditingController();
  TextEditingController _contrller_Email_Add_Subject = TextEditingController();
  TextEditingController _contrller_Email_Add_Content = TextEditingController();

  QuotationDetails _editModel;
  bool _isForUpdate;
  String InquiryNo = "";
  int pkID = 0;
  List<QuotationTable> _inquiryProductList = [];
  FocusNode ReferenceFocusNode;

  // SearchInquiryListResponse _searchInquiryListResponse;
  // SearchInquiryCustomer _searchInquiryListResponse;
  SearchDetails _searchInquiryListResponse;

  List<ALL_Name_ID> arr_ALL_Name_ID_For_BankDropDownList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_FolowupType = [];
  final TextEditingController edt_FollowupType = TextEditingController();
  final TextEditingController edt_FollowupTypepkID = TextEditingController();

  //
  final TextEditingController edt_Portal_details = TextEditingController();
  final TextEditingController edt_Portal_details_ID = TextEditingController();
  String ReportToToken = "";

  String OtherChargName1 = "";
  String OtherChargeAmount1 = "0.00";
  String OtherChargeID1 = "0";
  String OtherChargeTaxType1 = "0.00";
  String OtherChargeGstPer1 = "0.00";
  String OtherChargeBeforGst1 = "0.00";

  String OtherChargName2 = "";
  String OtherChargeAmount2 = "0.00";
  String OtherChargeID2 = "0";
  String OtherChargeTaxType2 = "0.00";
  String OtherChargeGstPer2 = "0.00";
  String OtherChargeBeforGst2 = "0.00";

  String OtherChargName3 = "";
  String OtherChargeAmount3 = "0.00";
  String OtherChargeID3 = "0";
  String OtherChargeTaxType3 = "0.00";
  String OtherChargeGstPer3 = "0.00";
  String OtherChargeBeforGst3 = "0.00";

  String OtherChargName4 = "";
  String OtherChargeAmount4 = "0.00";
  String OtherChargeID4 = "0";
  String OtherChargeTaxType4 = "0.00";
  String OtherChargeGstPer4 = "0.00";
  String OtherChargeBeforGst4 = "0.00";

  String OtherChargName5 = "";
  String OtherChargeAmount5 = "0.00";
  String OtherChargeID5 = "0";
  String OtherChargeTaxType5 = "0.00";
  String OtherChargeGstPer5 = "0.00";
  String OtherChargeBeforGst5 = "0.00";

  double InclusiveBeforeGstAmnt1 = 0.00;
  double InclusiveBeforeGstAmnt_Minus1 = 0.00;
  double AfterInclusiveBeforeGstAmnt1 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus1 = 0.00;

  double ExclusiveBeforeGStAmnt1 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus1 = 0.00;
  double ExclusiveAfterGstAmnt1 = 0.00;

  double InclusiveBeforeGstAmnt2 = 0.00;
  double InclusiveBeforeGstAmnt_Minus2 = 0.00;
  double AfterInclusiveBeforeGstAmnt2 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus2 = 0.00;

  double ExclusiveBeforeGStAmnt2 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus2 = 0.00;
  double ExclusiveAfterGstAmnt2 = 0.00;

  double InclusiveBeforeGstAmnt3 = 0.00;
  double InclusiveBeforeGstAmnt_Minus3 = 0.00;
  double AfterInclusiveBeforeGstAmnt3 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus3 = 0.00;

  double ExclusiveBeforeGStAmnt3 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus3 = 0.00;
  double ExclusiveAfterGstAmnt3 = 0.00;

  double InclusiveBeforeGstAmnt4 = 0.00;
  double InclusiveBeforeGstAmnt_Minus4 = 0.00;
  double AfterInclusiveBeforeGstAmnt4 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus4 = 0.00;

  double ExclusiveBeforeGStAmnt4 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus4 = 0.00;
  double ExclusiveAfterGstAmnt4 = 0.00;

  double InclusiveBeforeGstAmnt5 = 0.00;
  double InclusiveBeforeGstAmnt_Minus5 = 0.00;
  double AfterInclusiveBeforeGstAmnt5 = 0.00;
  double AfterInclusiveBeforeGstAmnt_Minus5 = 0.00;

  double ExclusiveBeforeGStAmnt5 = 0.00;
  double ExclusiveBeforeGStAmnt_Minus5 = 0.00;
  double ExclusiveAfterGstAmnt5 = 0.00;

  double Tot_BasicAmount = 0.00;
  double Tot_otherChargeWithTax = 0.00;
  double Tot_GSTAmt = 0.00;
  double Tot_otherChargeExcludeTax = 0.00;
  double Tot_NetAmt = 0.00;

  String _basicAmountController =
      "0.00"; //_editModel.basicAmt.toStringAsFixed(2);
  String _otherChargeWithTaxController = "0.00";
  String _totalGstController = "0.00";
  String _otherChargeExcludeTaxController = "0.00";
  String netAmountController = "0.00";
  double HeaderDisAmnt = 0.00; //double.parse(edt_HeaderDisc.toString());

  bool IsWithoutTapOtherCharges = false;

  final TextEditingController editMode_netamount_controller =
      TextEditingController();
  AddditionalCharges addditionalCharges = AddditionalCharges();

  GenericOtherChargeDetails genericOtherChargeDetails =
      GenericOtherChargeDetails();
  bool isUpdateCalculation = false;

  List<OtherChargeDetails> arrGenericOtheCharge = [];
  bool ISQuotationDetails = false;
  bool ISProductReference = false;
  bool IsCurrencyDetails = false;

  bool ISBasicDetails = false;

  bool IsProductDetails = false;
  bool IsTerms_and_ConditionDetails = false;
  bool IsEmailContentDetails = false;
  bool IsFolloUpDetails = false;
  bool IsAssumptionOtherDetails = false;
  bool IsAttachementsDetails = false;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    // _offlineCustomerSource = SharedPrefHelper.instance.getCustomerSourceData();
    //  _offlineInquiryLeadStatusData = SharedPrefHelper.instance.getInquiryLeadStatus();
    // _onLeadSourceListTypeCallSuccess(_offlineCustomerSource);
    //_onLeadStatusListTypeCallSuccess(_offlineInquiryLeadStatusData);
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _inquiryBloc = QuotationBloc(baseBloc);
    ReferenceFocusNode = FocusNode();
    edt_LeadSource.addListener(() {
      ReferenceFocusNode.requestFocus();
    });
    edt_HeaderDisc.text = "0.00";

    _inquiryBloc.add(GetReportToTokenRequestEvent(GetReportToTokenRequest(
        CompanyId: CompanyID.toString(),
        EmployeeID: _offlineLoggedInData.details[0].employeeID.toString())));

    _inquiryBloc.add(GenericOtherChargeCallEvent(
        CompanyID.toString(), QuotationOtherChargesListRequest(pkID: "")));
    _inquiryBloc.add(DeleteGenericAddditionalChargesEvent());
    _inquiryBloc.add(DeleteAllQuotationSpecificationTableEvent());
    _inquiryBloc.add(QTAssemblyTableALLDeleteEvent());
    _inquiryBloc.add(QuotationBankDropDownCallEvent(BankDropDownRequest(
        CompanyID: CompanyID.toString(), LoginUserID: LoginUserID, pkID: "")));

    _isForUpdate = widget.arguments != null;
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;

      /*_inquiryBloc.add(AddGenericAddditionalChargesEvent(
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
              _editModel.chargeName5)));*/

      fillData();
    } else {
      edt_InquiryDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_ReverseInquiryDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

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

      edt_NextFollowupDate.text = selectedNextFollowupDate.day.toString() +
          "-" +
          selectedNextFollowupDate.month.toString() +
          "-" +
          selectedNextFollowupDate.year.toString();
      edt_ReverseNextFollowupDate.text =
          selectedNextFollowupDate.year.toString() +
              "-" +
              selectedNextFollowupDate.month.toString() +
              "-" +
              selectedNextFollowupDate.day.toString();

      edt_StateCode.text = "";
      setState(() {
        edt_InquiryNo.text = "";
      });

      _inquiryBloc.add(DeleteGenericAddditionalChargesEvent());

      _inquiryBloc.add(AddGenericAddditionalChargesEvent(
          GenericAddditionalCharges("0.00", "0", "0.00", "0", "0.00", "0",
              "0.00", "0", "0.00", "0", "0.00", "", "", "", "", "")));
    }

    edt_InquiryNo.addListener(() {
      if (edt_InquiryNo.text != "") {
        _inquiryBloc.add(InqNoToProductListCallEvent(
            InquiryNoToProductListRequest(
                InquiryNo: edt_InquiryNo.text,
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          if (state is GetReportToTokenResponseState) {
            _onGetTokenfromReportopersonResult(state);
          }

          if (state is GenericOtherCharge1ListResponseState) {
            _OnGenricOtherChargeResponse(state);
          }
          if (state is QuotationOtherCharge1ListResponseState) {
            _OnChargID1Response(state);
          }
          if (state is QuotationOtherCharge2ListResponseState) {
            _OnChargID2Response(state);
          }
          if (state is QuotationOtherCharge3ListResponseState) {
            _OnChargID3Response(state);
          }
          if (state is QuotationOtherCharge4ListResponseState) {
            _OnChargID4Response(state);
          }
          if (state is QuotationOtherCharge5ListResponseState) {
            _OnChargID5Response(state);
          }

          if (state is AddGenericAddditionalChargesState) {
            _OnGenericIsertCallSucess(state);
          }

          if (state is DeleteAllGenericAddditionalChargesState) {
            _onDeleteAllGenericAddtionalAmount(state);
          }

          if (state is SpecificationListResponseState) {
            _onGetQuotationSpecificationFromQuotationAPI(state);
          }

          if (state is InsertQuotationSpecificationTableState) {
            _onInsertQuotationSpecificationresponse(state);
          }

          if (state is DeleteALLQuotationSpecificationTableState) {
            _onDeleteAllSpecificationResponse(state);
          }
          if (state is QTAssemblyTableDeleteALLState) {
            _onDeleteAllQTAssemblyResponse(state);
          }
          if (state is QuotationBankDropDownResponseState) {
            _onBankVoucherSaveResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is GetReportToTokenResponseState ||
              currentState is QuotationOtherCharge1ListResponseState ||
              currentState is QuotationOtherCharge2ListResponseState ||
              currentState is QuotationOtherCharge3ListResponseState ||
              currentState is QuotationOtherCharge4ListResponseState ||
              currentState is QuotationOtherCharge5ListResponseState ||
              currentState is GenericOtherCharge1ListResponseState ||
              currentState is AddGenericAddditionalChargesState ||
              currentState is DeleteAllGenericAddditionalChargesState ||
              currentState is SpecificationListResponseState ||
              currentState is InsertQuotationSpecificationTableState ||
              currentState is DeleteALLQuotationSpecificationTableState ||
              currentState is QTAssemblyTableDeleteALLState ||
              currentState is QuotationBankDropDownResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, QuotationStates state) {
          if (state is QuotationNoToProductListCallResponseState) {
            _OnQuotationNoToProductListResponse(state);
          }

          if (state is QuotationKindAttListResponseState) {
            _OnKindAttListResponseSucess(state);
          }

          if (state is QuotationProjectListResponseState) {
            _OnProjectListResponseSucess(state);
          }
          if (state is QuotationTermsCondtionResponseState) {
            _OnTermConditionListResponse(state);
          }
          if (state is CustIdToInqListResponseState) {
            _OnCustIdToInqNoListResponse(state);
          }
          if (state is InqNoToProductListResponseState) {
            _OnInqNotoProductListResponse(state);
          }
          if (state is QuotationHeaderSaveResponseState) {
            _OnQuotationHeaderSaveSucessResponse(state);
          }
          if (state is QuotationProductSaveResponseState) {
            _OnQuotationProductSaveSucessResponse(state);
          }
          if (state is QuotationProductDeleteResponseState) {
            _OnInquiryNoTodeleteAllProduct(state);
          }
          /* if(state is QuotationOtherChargeListResponseState)
          {
            _onOtherChargeListResponse(state);
          }*/

          if (state is FCMNotificationResponseState) {
            _onRecevedNotification(state);
          }

          if (state is QuotationEmailContentResponseState) {
            _OnEmailContentResponse(state);
          }
          if (state is SaveEmailContentResponseState) {
            _OnSaveEmailContentResponse(state);
          }

          if (state is QT_OtherChargeInsertResponseState) {
            _onInsertAllQT_OtherTable(state);
          }

          if (state is SOCurrencyListResponseState) {
            _ONCurrencyResponse(state);
          }

          if (state is FollowupTypeListCallResponseState) {
            _onFollowupListTypeCallSuccess(state);
          }

          if (state is GetQuotationSpecificationQTnoTableState) {
            _onAfterProductSaveSuccess(state);
          }
          if (state is QTSpecSaveResponseState) {
            _onQTSpecificationSaveResponse(state);
          }
          if (state is QuotationOrganizationListResponseState) {
            _onQuotationOrganizationListResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is QuotationNoToProductListCallResponseState ||
                  currentState is QuotationKindAttListResponseState ||
                  currentState is QuotationProjectListResponseState ||
                  currentState is QuotationTermsCondtionResponseState ||
                  currentState is CustIdToInqListResponseState ||
                  currentState is InqNoToProductListResponseState ||
                  currentState is QuotationHeaderSaveResponseState ||
                  currentState is QuotationProductSaveResponseState ||
                  currentState is FCMNotificationResponseState ||
                  currentState is QuotationEmailContentResponseState ||
                  currentState is SaveEmailContentResponseState ||
                  currentState is QT_OtherChargeInsertResponseState ||
                  currentState is SOCurrencyListResponseState ||
                  currentState is FollowupTypeListCallResponseState ||
                  currentState is GetQuotationSpecificationQTnoTableState ||
                  currentState is QTSpecSaveResponseState ||
                  currentState is QuotationOrganizationListResponseState
/*
              currentState is QuotationOtherChargeListResponseState
*/
              ) {
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
        backgroundColor: colorTileBG,
        appBar: NewGradientAppBar(
          title: Text('Quotation Details'),
          gradient: LinearGradient(colors: [
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
                onPressed: () async {
                  //_onTapOfLogOut();
                  await _onTapOfDeleteALLProduct();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(10),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Quotation_Details(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        ProductReference(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        CurrencyDetails(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        BasicDetails(),

                        Container(
                          height: 2,
                          color: Colors.grey,
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                        ),
                        ProductsDetails(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Terms_Condition_Details(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Email_Content_Details(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Followup_Details(),
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),
                        Assuption_other_details(),

                        OldDesign(),
                        //
                        SizedBox(
                          width: 20,
                          height: 15,
                        ),

                        InkWell(
                          onTap: () {
                            _onTaptoSaveQuotationHeader(context);
                          },
                          child: Card(
                              elevation: 10,
                              color: colorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Center(
                                  child: Text("Save",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ),
                      ]))),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
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
                  "Email Content",
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
                        createTextLabel("Select Subject", 10.0, 0.0),
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
                                  hintTextvalue: "Tap to Select Subject",
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

                                    // navigateTo(context, QuotationAddEditScreen.routeName);
                                    showcustomdialogSendEmail(
                                        context1: context, Email: "sdfj");
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
                            _contrller_Email_Discription, "Email Introduction",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            bottom: 5,
                            top: 5,
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

  FollowupFiled() {
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
                  "Follow Up",
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
                        createTextLabel("Next FollowUpDate.", 10.0, 0.0),
                        _buildNextFollowupDate(),
                        FollowupType("FollowUp Type",
                            enable1: false,
                            title: "FollowUp Type",
                            hintTextvalue: "Tap to FollowUp Type",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_FollowupType,
                            controllerpkID: edt_FollowupTypepkID,
                            Custom_values1:
                                arr_ALL_Name_ID_For_TermConditionList),
                        createTextLabel("Meeting Notes", 10.0, 0.0),
                        createTextFormField(edt_FollowupNotes, "Enter Notes",
                            minLines: 2,
                            maxLines: 5,
                            height: 100,
                            bottom: 5,
                            top: 5,
                            keyboardInput: TextInputType.text),
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

  AssumptionandOthers() {
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
                  "Assumption & Others",
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
                        createTextLabel("Ref. Inquiry", 10.0, 0.0),
                        createTextFormField(
                            _controller_Ref_Inquiry, "Enter Description",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            bottom: 5,
                            top: 5,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        createTextLabel("Other Remarks", 10.0, 0.0),
                        createTextFormField(
                            _contrller_other_Remarks, "Enter Description",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            bottom: 5,
                            top: 5,
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
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.bottomCenter,
                          child: getCommonButton(baseTheme, () async {
                            if (edt_CustomerName.text != "") {
                              print("INWWWE" + edt_HeaderDisc.text.toString());
                              navigateTo(context,
                                      OldQuotationProductListScreen.routeName,
                                      arguments:
                                          OldAddQuotationProductListArgument(
                                              InquiryNo,
                                              edt_StateCode.text,
                                              edt_HeaderDisc.text))
                                  .then((value) async {
                                await getInquiryProductDetails();
                              });
                            } else {
                              showCommonDialogWithSingleOption(context,
                                  "Customer name is required To view Product !",
                                  positiveButtonTitle: "OK");
                            }
                          }, "Products",
                              width: 600,
                              textColor: colorPrimary,
                              backGroundColor: colorGreenLight,
                              radius: 25.0),
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
                                        NewQuotationOtherChargeScreen.routeName,
                                        arguments:
                                            NewQuotationOtherChargesScreenArguments(
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
                                        NewQuotationOtherChargeScreen.routeName,
                                        arguments:
                                            NewQuotationOtherChargesScreenArguments(
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
                    color: colorPrimary,
                    fontWeight: FontWeight.bold)),
          ],
        ),
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
            onTap: () {
              _inquiryBloc.add(QuotationEmailContentRequestEvent(
                  QuotationEmailContentRequest(
                      CompanyId: CompanyID.toString(),
                      LoginUserID: LoginUserID)));
            },
            /*=> */
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

  Widget createTextFormField(
      TextEditingController _controller, String _hintText,
      {int minLines = 1,
      int maxLines = 1,
      double height = 40,
      double left = 5,
      double right = 5,
      double top = 8,
      double bottom = 10,
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
        padding: EdgeInsets.all(5),
        height: height,
        decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
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
  }

  Widget _buildFollowupDate() {
    return InkWell(
      onTap: () {
        _selectDate(context, edt_InquiryDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Quotation Date *",
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
              height: 40,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_InquiryDate.text == null || edt_InquiryDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_InquiryDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_InquiryDate.text == null ||
                                  edt_InquiryDate.text == ""
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
    // DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_InquiryDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_ReverseInquiryDate.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
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
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Search Customer *",
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
              height: 40,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: edt_CustomerName,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search customer",
                          labelStyle: TextStyle(
                            color: Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 10),
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
    if (_isForUpdate == false) {
      await _onTapOfDeleteALLProduct();

      navigateTo(context, SearchQuotationCustomerScreen.routeName)
          .then((value) {
        if (value != null) {
          _searchInquiryListResponse = value;
          edt_CustomerName.text = _searchInquiryListResponse.label;
          edt_CustomerpkID.text = _searchInquiryListResponse.value.toString();
          setState(() {
            edt_InquiryNoExist.text = "true";
            edt_KindAtt.text = "";
            edt_KindAttID.text = "";
            arr_ALL_Name_ID_For_KindAttList.clear();
          });
          _inquiryBloc.add(CustIdToInqListCallEvent(CustIdToInqListRequest(
              CustomerID: _searchInquiryListResponse.value.toString(),
              ModuleType: "Inquiry",
              CompanyID: CompanyID.toString())));

          if (_searchInquiryListResponse.stateCode != 0) {
            edt_StateCode.text =
                _searchInquiryListResponse.stateCode.toString();
          } else {
            showCommonDialogWithSingleOption(context,
                "Customer State is Required !\nUpdate State From Customer Module",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              edt_CustomerName.text = "";
              Navigator.pop(context);
            });
          }
          //  _CustomerBloc.add(CustomerListCallEvent(1,CustomerPaginationRequest(companyId: 8033,loginUserID: "admin",CustomerID: "",ListMode: "L")));
        }
      });
    }
  }

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLProduct();
    navigateTo(context, QuotationListScreen.routeName, clearAllStack: true);
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_InquiryDate.text = _editModel.quotationDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_ReverseInquiryDate.text = _editModel.quotationDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_CustomerName.text = _editModel.customerName.toString();
    edt_CustomerpkID.text = _editModel.customerID.toString();
    /*  edt_Priority.text = _editModel.priority;
    edt_LeadStatus.text = _editModel.inquiryStatus.toString();
    edt_LeadStatusID.text = _editModel.inquiryStatusID.toString();
    edt_LeadSourceID.text = _editModel.inquirySource.toString();
    edt_LeadSource.text = _editModel.InquirySourceName.toString();
    edt_Reference_Name.text = _editModel.referenceName.toString();
    edt_Description.text = _editModel.meetingNotes.toString();*/
    edt_ProjectName.text = _editModel.projectName;
    _contrller_Email_Discription.text = _editModel.quotationHeader;
    edt_TermConditionFooter.text = _editModel.quotationFooter;
    _controller_select_email_subject.text = _editModel.quotationSubject;
    edt_ReverseNextFollowupDate.text = "";
    edt_PreferedTime.text = "";
    edt_FollowupNotes.text = "";
    InquiryNo = _editModel.quotationNo;
    edt_StateCode.text = _editModel.stateCode.toString();
    int StateCode = _editModel.stateCode;

    edt_OrganizationCode.text = _editModel.OrgCode;
    edt_OrganizationName.text = _editModel.OrganizationName;
    _controller_reference_no.text = _editModel.ReferenceNo;
    _controller_reference_date.text = _editModel.ReferenceDate == ""
        ? DateTime.now().day.toString() +
            "-" +
            DateTime.now().month.toString() +
            "-" +
            DateTime.now().year.toString()
        : _editModel.ReferenceDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");

    _controller_rev_reference_date.text = _editModel.ReferenceDate == ""
        ? DateTime.now().year.toString() +
            "-" +
            DateTime.now().month.toString() +
            "-" +
            DateTime.now().day.toString()
        : _editModel.ReferenceDate.getFormattedDate(
            fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    _controller_credit_days.text = _editModel.CreditDays;
    _controller_currency.text = _editModel.CurrencyName;
    _controller_currency_Symbol.text = _editModel.CurrencySymbol;
    _controller_exchange_rate.text = _editModel.ExchangeRate.toString();

    print("sdlfjdfsj" +
        _offlineLoggedInData.details[0].stateCode.toString() +
        " CustomerStateCode : " +
        _editModel.stateCode.toString());
    if (InquiryNo != '') {
      // await _onTapOfDeleteALLProduct();
      _inquiryBloc.add(QuotationNoToProductListCallEvent(
          StateCode,
          QuotationNoToProductListRequest(
              QuotationNo: InquiryNo, CompanyId: CompanyID.toString())));
    }

    _inquiryBloc.add(DeleteGenericAddditionalChargesEvent());

    _inquiryBloc.add(AddGenericAddditionalChargesEvent(
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

    /*GenericAddditionalCharges newGenericAddditionalCharges =
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
      _editModel.chargeName5,
    );*/

    setState(() {
      edt_InquiryNo.text = "";
    });

    edt_HeaderDisc.text = _editModel.discountAmt.toStringAsFixed(2);
    edt_ChargeID1.text = _editModel.chargeID1.toString();
    edt_ChargeID2.text = _editModel.chargeID2.toString();
    edt_ChargeID3.text = _editModel.chargeID3.toString();
    edt_ChargeID4.text = _editModel.chargeID4.toString();
    edt_ChargeID5.text = _editModel.chargeID5.toString();

    if (edt_ChargeID1.text != "") {
      _inquiryBloc.add(QuotationOtherCharge1CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID1.text)));
    }
    if (edt_ChargeID2.text != "") {
      _inquiryBloc.add(QuotationOtherCharge2CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID2.text)));
    }
    if (edt_ChargeID3.text != "") {
      _inquiryBloc.add(QuotationOtherCharge3CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID3.text)));
    }
    if (edt_ChargeID4.text != "") {
      _inquiryBloc.add(QuotationOtherCharge4CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID4.text)));
    }
    if (edt_ChargeID5.text != "") {
      _inquiryBloc.add(QuotationOtherCharge5CallEvent(CompanyID.toString(),
          QuotationOtherChargesListRequest(pkID: edt_ChargeID5.text)));
    }

    OtherChargName1 = _editModel.chargeName1;
    OtherChargeAmount1 = _editModel.chargeAmt1.toStringAsFixed(2);
    OtherChargeID1 = _editModel.chargeID1.toString();

    OtherChargName2 = _editModel.chargeName2;
    ;
    OtherChargeAmount2 = _editModel.chargeAmt2.toStringAsFixed(2);
    OtherChargeID2 = _editModel.chargeID2.toString();
    //OtherChargeTaxType2;
    // OtherChargeGstPer2;
    // OtherChargeBeforGst2;

    OtherChargName3 = _editModel.chargeName3;
    OtherChargeAmount3 = _editModel.chargeAmt3.toStringAsFixed(2);
    OtherChargeID3 = _editModel.chargeID3.toString();
    // OtherChargeTaxType3;
    // OtherChargeGstPer3;
    // OtherChargeBeforGst3;

    OtherChargName4 = _editModel.chargeName4;
    OtherChargeAmount4 = _editModel.chargeAmt4.toStringAsFixed(2);
    OtherChargeID4 = _editModel.chargeID3.toString();
    // OtherChargeTaxType4;
    // OtherChargeGstPer4;
    // OtherChargeBeforGst4;

    OtherChargName5 = _editModel.chargeName5;
    OtherChargeAmount5 = _editModel.chargeAmt5.toStringAsFixed(2);
    OtherChargeID5 = _editModel.chargeID5.toString();

    edt_Portal_details.text = _editModel.bankName;
    edt_Portal_details_ID.text = _editModel.bankID.toString();

    _controller_Ref_Inquiry.text = _editModel.assumptionRemark;
    _contrller_other_Remarks.text = _editModel.additionalRemark;

    print("ListTaxType" +
        "TaxType1 : " +
        SharedPrefHelper.instance.getGenricTaxtype() +
        "TaxType2 : " +
        genericOtherChargeDetails.OtherChargeTaxType2.toString() +
        "TaxType3 : " +
        edt_ChargeTaxType3.text +
        "TaxType4 : " +
        edt_ChargeTaxType4.text);

    addditionalCharges = AddditionalCharges(
      DiscountAmt: _editModel.discountAmt.toString(),
      SGSTAmt: _editModel.sGSTAmt.toString(),
      CGSTAmt: _editModel.cGSTAmt.toString(),
      IGSTAmt: _editModel.iGSTAmt.toString(),
      //_totalIGSST_AMOUNT_Controller.text.toString(),

      ChargeID1: _editModel.chargeID1.toString(),
      ChargeName1: _editModel.chargeName1.toString(),
      ChargeAmt1: _editModel.chargeAmt1.toString(),
      ChargeBasicAmt1: _editModel.chargeBasicAmt1.toString(),
      ChargeGSTAmt1: _editModel.chargeGSTAmt1.toString(),
      ChargeTaxType1: OtherChargeTaxType1,
      ChargeGstPer1: OtherChargeGstPer1,
      ChargeIsBeforGst1: OtherChargeBeforGst1,

      ChargeID2: _editModel.chargeID2.toString(),
      ChargeName2: _editModel.chargeName2.toString(),
      ChargeAmt2: _editModel.chargeAmt2.toString(),
      ChargeBasicAmt2: _editModel.chargeBasicAmt2.toString(),
      ChargeGSTAmt2: _editModel.chargeGSTAmt2.toString(),
      ChargeTaxType2: OtherChargeTaxType2,
      ChargeGstPer2: OtherChargeGstPer2,
      ChargeIsBeforGst2: OtherChargeBeforGst2,

      ChargeID3: _editModel.chargeID3.toString(),
      ChargeName3: _editModel.chargeName3.toString(),
      ChargeAmt3: _editModel.chargeAmt3.toString(),
      ChargeBasicAmt3: _editModel.chargeBasicAmt3.toString(),
      ChargeGSTAmt3: _editModel.chargeGSTAmt3.toString(),
      ChargeTaxType3: OtherChargeTaxType3,
      ChargeGstPer3: OtherChargeGstPer3,
      ChargeIsBeforGst3: OtherChargeBeforGst3,

      ChargeID4: _editModel.chargeID4.toString(),
      ChargeName4: _editModel.chargeName4.toString(),
      ChargeAmt4: _editModel.chargeAmt4.toString(),
      ChargeBasicAmt4: _editModel.chargeBasicAmt4.toString(),
      ChargeGSTAmt4: _editModel.chargeGSTAmt4.toString(),
      ChargeTaxType4: OtherChargeTaxType4,
      ChargeGstPer4: OtherChargeGstPer4,
      ChargeIsBeforGst4: OtherChargeBeforGst4,

      ChargeID5: _editModel.chargeID5.toString(),
      ChargeName5: _editModel.chargeName5.toString(),
      ChargeAmt5: _editModel.chargeAmt5.toString(),
      ChargeBasicAmt5: _editModel.chargeBasicAmt5.toString(),
      ChargeGSTAmt5: _editModel.chargeGSTAmt5.toString(),
      ChargeTaxType5: OtherChargeTaxType5,
      ChargeGstPer5: OtherChargeGstPer5,
      ChargeIsBeforGst5: OtherChargeBeforGst5,

      NetAmt: _editModel.netAmt.toString(),
      BasicAmt: _editModel.basicAmt.toString(),
      ROffAmt: _editModel.roffAmt.toString(),
      ChargePer1: "0.00",
      ChargePer2: "0.00",
      ChargePer3: "0.00",
      ChargePer4: "0.00",
      ChargePer5: "0.00",
    );

    print("ADDDitonalCharge" +
        " AdditionalChargeModel :  " +
        addditionalCharges.BasicAmt
            .toString() /*addditionalCharges.toJson().toString()*/);

    // OtherChargeTaxType5;
    // OtherChargeGstPer5;
    // OtherChargeBeforGst5;

    /* _inquiryBloc.add(QuotationOtherChargeCallEvent(CompanyID.toString(),
        QuotationOtherChargesListRequest(pkID: "")));*/
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<QuotationTable> temp =
        await OfflineDbHelper.getInstance().getQuotationProduct();
    _inquiryProductList.addAll(temp);
    setState(() {});
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteALLQuotationProduct();
    await OfflineDbHelper.getInstance().deleteALLOldQuotationProduct();
  }

  /* void updateRetrunInquiryNoToDB(String ReturnInquiryNo) {
    _inquiryProductList.forEach((element) {
      element.InquiryNo = ReturnInquiryNo;
      element.LoginUserID = LoginUserID;
      element.CompanyId = CompanyID.toString();
    });
  }*/

  _onTapOfAdd(
      String productName,
      String ProductID,
      String Quantity,
      String UnitPrice,
      double TotalAmount,
      String specification,
      String qtNo,
      String unit,
      double disc1,
      double discAmount1,
      double netRate1,
      double amount1,
      int taxtype1,
      double taxper1,
      double taxAmount1,
      double cgstPer,
      double sgstPer,
      double igstPer,
      double cgstAmount,
      double sgstAmount,
      double igstAmount,
      int stateCode,
      double HeaderDiscAmnr) async {
    int productID = int.parse(ProductID);
    double quantity = double.parse(Quantity);
    double unitPrice = double.parse(UnitPrice);
    double totalAmount = TotalAmount;
    double disc = disc1;
    double discAmount = discAmount1;
    double netRate = netRate1;
    double amount = amount1;
    double taxPer = taxper1;
    double taxAmount = taxAmount1;
    int taxtype = taxtype1;
    /*double Quantity,   double UnitRate,   double Disc,   double NetRate,   double Amount,   double TaxPer,   double TaxAmount,   double NetAmount,*/

    await OfflineDbHelper.getInstance().insertQuotationProduct(QuotationTable(
      qtNo,
      specification,
      productID,
      productName,
      unit,
      quantity,
      unitPrice,
      disc,
      discAmount,
      netRate,
      amount,
      taxPer,
      taxAmount,
      totalAmount,
      taxtype,
      cgstPer,
      sgstPer,
      igstPer,
      cgstAmount,
      sgstAmount,
      igstAmount,
      stateCode,
      0,
      LoginUserID,
      CompanyID.toString(),
      0,
      HeaderDiscAmnr,
    ));

    await OfflineDbHelper.getInstance()
        .insertOldQuotationProduct(QuotationTable(
      qtNo,
      specification,
      productID,
      productName,
      unit,
      quantity,
      unitPrice,
      disc,
      discAmount,
      netRate,
      amount,
      taxPer,
      taxAmount,
      totalAmount,
      taxtype,
      cgstPer,
      sgstPer,
      igstPer,
      cgstAmount,
      sgstAmount,
      igstAmount,
      stateCode,
      0,
      LoginUserID,
      CompanyID.toString(),
      0,
      HeaderDiscAmnr,
    ));
  }

  _OnInquiryNoTodeleteAllProduct(QuotationProductDeleteResponseState state) {
    print(
        "QuotationProductDeleteResponse " + state.response.details[0].column1);
  }

  Future<void> _selectRefrenceFollowupDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateRefrence)
      setState(() {
        selectedDateRefrence = picked;
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
      });
  }

  Future<void> _selectNextFollowupDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedNextFollowupDate)
      setState(() {
        selectedNextFollowupDate = picked;
        edt_NextFollowupDate.text = selectedNextFollowupDate.day.toString() +
            "-" +
            selectedNextFollowupDate.month.toString() +
            "-" +
            selectedNextFollowupDate.year.toString();
        edt_ReverseNextFollowupDate.text =
            selectedNextFollowupDate.year.toString() +
                "-" +
                selectedNextFollowupDate.month.toString() +
                "-" +
                selectedNextFollowupDate.day.toString();
      });
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController F_datecontroller) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;

        String AM_PM =
            selectedTime.periodOffset.toString() == "12" ? "PM" : "AM";
        String beforZeroHour = selectedTime.hourOfPeriod <= 9
            ? "0" + selectedTime.hourOfPeriod.toString()
            : selectedTime.hourOfPeriod.toString();
        String beforZerominute = selectedTime.minute <= 9
            ? "0" + selectedTime.minute.toString()
            : selectedTime.minute.toString();

        edt_PreferedTime.text = beforZeroHour +
            ":" +
            beforZerominute +
            " " +
            AM_PM; //picked_s.periodOffset.toString();
      });
  }

  void _OnQuotationNoToProductListResponse(
      QuotationNoToProductListCallResponseState state) {
    for (var i = 0; i < state.response.details.length; i++) {
      /* String LoginUserID="abc";
    String CompanyId="0";
    String InquiryNo="0";*/
      String ProductName = state.response.details[i].productName;
      String ProductID = state.response.details[i].productID.toString();
      String Unit = state.response.details[i].unit.toString();
      String Quantity = state.response.details[i].quantity.toString();
      String UnitPrice = state.response.details[i].unitRate.toString();
      double disc = state.response.details[i].discountPercent;
      double discAmount = state.response.details[i].discountAmt;

      double netRate = state.response.details[i].netRate;
      double amount = state.response.details[i].amount;
      int taxtype = state.response.details[i].taxType;
      double taxper = state.response.details[i].taxRate;
      double taxAmount = state.response.details[i].taxAmount;
      double netAmount = state.response.details[i].netAmount;
      double CGSTPer = state.response.details[i].cGSTPer;
      double SGSTPer = state.response.details[i].sGSTPer;
      double IGSTPer = state.response.details[i].iGSTPer;
      double CGSTAmount = state.response.details[i].cGSTAmt;
      double SGSTAmount = state.response.details[i].sGSTAmt;
      double IGSTAmount = state.response.details[i].iGSTAmt;
      double HeaderDiscAmnr = state.response.details[i].headerDiscAmt;

      // double totamnt = double.parse(Quantity) * double.parse(UnitPrice);
      //String TotalAmount = totamnt.toString();
      String Specification =
          state.response.details[i].productSpecification.toString();
      String QTNo = state.response.details[i].quotationNo.toString();
      int StateCode = state.StateCode;

      edt_HeaderDisc.text =
          state.response.details[i].headerDiscountAmt.toStringAsFixed(2);

      _onTapOfAdd(
          ProductName,
          ProductID,
          Quantity,
          UnitPrice,
          netAmount,
          Specification,
          QTNo,
          Unit,
          disc,
          discAmount,
          netRate,
          amount,
          taxtype,
          taxper,
          taxAmount,
          CGSTPer,
          SGSTPer,
          IGSTPer,
          CGSTAmount,
          SGSTAmount,
          IGSTAmount,
          StateCode,
          HeaderDiscAmnr);

      _inquiryBloc.add(QuotationSpecificationCallEvent(
          "quotation",
          SpecificationListRequest(
              Module: "quotation",
              QuotationNo: InquiryNo,
              FinishProductID: state.response.details[i].productID.toString(),
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString())));
    }
  }

  Widget InqNoList(String Category,
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
            onTap: () => showcustomdialogWithID(
                values: arr_ALL_Name_ID_For_InqNoList,
                context1: context,
                controller: edt_InquiryNo,
                controllerID: edt_InquiryNoID,
                lable: "Select InquiryNo. "),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
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
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget KindAttList(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (edt_CustomerpkID.text != "") {
                _inquiryBloc.add(QuotationKindAttListCallEvent(
                    QuotationKindAttListApiRequest(
                        CompanyId: CompanyID.toString(),
                        CustomerID: edt_CustomerpkID.text)));
              } else {
                showCommonDialogWithSingleOption(
                    context, "Customer Name is Required!",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.pop(context);
                });
              }
            },
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

                    _inquiryBloc.add(QuotationProjectListCallEvent(
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

  Widget TermsConditionList(String Category,
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

                    _inquiryBloc.add(QuotationTermsConditionCallEvent(
                        QuotationTermsConditionRequest(
                            CompanyId: CompanyID.toString(),
                            LoginUserID: LoginUserID))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
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
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  Widget FollowupType(String Category,
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
                    _inquiryBloc.add(FollowupTypeListByNameCallEvent(
                        FollowupTypeListRequest(
                            CompanyId: CompanyID.toString(),
                            pkID: "",
                            StatusCategory: "FollowUp",
                            LoginUserID: LoginUserID,
                            SearchKey: ""))),
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
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  void _OnKindAttListResponseSucess(QuotationKindAttListResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_KindAttList.clear();

      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].contactPerson1);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].contactPerson1;
        all_name_id.pkID = state.response.details[i].customerID;
        arr_ALL_Name_ID_For_KindAttList.add(all_name_id);
      }

      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_KindAttList,
          context1: context,
          controller: edt_KindAtt,
          controllerID: edt_KindAttID,
          lable: "Select Kind Att.");
    } else {
      showCommonDialogWithSingleOption(
          context, "Kind Attn is Empty , You can Add from Customer !",
          positiveButtonTitle: "OK");
    }
  }

  void _OnProjectListResponseSucess(QuotationProjectListResponseState state) {
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
  }

  void _OnTermConditionListResponse(QuotationTermsCondtionResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_TermConditionList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].tNCHeader);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].tNCHeader;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].tNCContent;

        arr_ALL_Name_ID_For_TermConditionList.add(all_name_id);
      }
      showcustomdialogWithMultipleID(
          values: arr_ALL_Name_ID_For_TermConditionList,
          context1: context,
          controller: edt_TermConditionHeader,
          controllerID: edt_TermConditionHeaderID,
          controller2: edt_TermConditionFooter,
          lable: "Select Term & Condition ");
    }
  }

  void _OnCustIdToInqNoListResponse(CustIdToInqListResponseState state) {
    if (state.response.details.length != 0) {
      setState(() {
        edt_InquiryNoExist.text = "true";
      });

      arr_ALL_Name_ID_For_InqNoList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].inquiryNo);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].inquiryNo;
        all_name_id.pkID = state.response.details[i].customerID;

        arr_ALL_Name_ID_For_InqNoList.add(all_name_id);
      }
    } else {
      setState(() {
        edt_InquiryNoExist.text = "";
      });
      arr_ALL_Name_ID_For_InqNoList.clear();
    }
  }

  void _OnInqNotoProductListResponse(
      InqNoToProductListResponseState state) async {
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

        /*TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);
        TaxAmount = getNumber(TaxAmount1, precision: 2);

        Amount1 = (Quantity * NetRate1) - getNumber(TaxAmount1, precision: 2);
        Amount = getNumber(Amount1, precision: 2);

        TotalAmount =
            (Quantity * NetRate1) + getNumber(TaxAmount1, precision: 2);*/
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

      await OfflineDbHelper.getInstance().insertQuotationProduct(QuotationTable(
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

      _inquiryBloc.add(QuotationSpecificationCallEvent(
          "pro",
          SpecificationListRequest(
              Module: "pro",
              QuotationNo: "",
              FinishProductID: state.response.details[i].productID.toString(),
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString())));
    }
  }

  double getNumber(double input, {int precision = 2}) => double.parse(
      '$input'.substring(0, '$input'.indexOf('.') + precision + 1));

  void _onTaptoSaveQuotationHeader(BuildContext context) async {
    print("netamountfj" + " NetAmnt2 : " + netAmountController.toString());

    print("NETAMNTRT" + " NETAMNT : " + editMode_netamount_controller.text);
    // await getInquiryProductDetails();
    List<QuotationTable> temp =
        await OfflineDbHelper.getInstance().getQuotationProduct();

    if (edt_InquiryDate.text != "") {
      if (edt_CustomerName.text != "") {
        if (edt_Portal_details.text != "") {
          if (temp.length != 0) {
            HeaderDisAmnt = edt_HeaderDisc.text.isNotEmpty
                ? double.parse(edt_HeaderDisc.text)
                : 0.00;

            List<QuotationTable> TempproductList1 =
                HeaderDiscountCalculation.txtHeadDiscount_WithZero(
                    temp,
                    HeaderDisAmnt,
                    _offlineLoggedInData.details[0].stateCode.toString(),
                    edt_StateCode.text.toString());

            List<QuotationTable> TempproductList =
                HeaderDiscountCalculation.txtHeadDiscount_TextChanged(
                    TempproductList1,
                    HeaderDisAmnt,
                    _offlineLoggedInData.details[0].stateCode.toString(),
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

            List<GenericAddditionalCharges> quotationOtherChargesListResponse =
                await OfflineDbHelper.getInstance()
                    .getGenericAddditionalCharges();

            List<double> finalPrice = UpdateHeaderDiscountCalculation(
                TempproductList, quotationOtherChargesListResponse);

            for (int i = 0; i < finalPrice.length; i++) {
              print("finalCalfk" + finalPrice[i].toString());
            }

            showCommonDialogWithTwoOptions(
                context, "Are you sure you want to Save this Quotation ?",
                negativeButtonTitle: "No",
                positiveButtonTitle: "Yes", onTapOfPositiveButton: () {
              _OnTaptoSave();
              print("netamountfj" +
                  " NetAmnt : " +
                  netAmountController.toString());
              PushAllOtherChargesToDb();
              print("netamountfj" +
                  " NetAmnt1 : " +
                  netAmountController.toString());

              Navigator.of(context).pop();

              if (InquiryNo != '') {
                _inquiryBloc.add(QuotationDeleteProductCallEvent(
                    InquiryNo,
                    QuotationProductDeleteRequest(
                        CompanyId: CompanyID.toString())));
              } else {}

              _inquiryBloc.add(QuotationHeaderSaveCallEvent(
                  context,
                  pkID,
                  QuotationHeaderSaveRequest(
                      pkID: pkID.toString(),
                      InquiryNo:
                          edt_InquiryNo.text == null ? "" : edt_InquiryNo.text,
                      QuotationNo: InquiryNo,
                      QuotationDate: edt_ReverseInquiryDate.text,
                      CustomerID: edt_CustomerpkID.text,
                      ProjectName: edt_ProjectName.text,
                      QuotationSubject: _controller_select_email_subject.text,
                      QuotationHeader: _contrller_Email_Discription.text,
                      QuotationFooter: edt_TermConditionFooter.text,
                      LoginUserID: LoginUserID,
                      Latitude: SharedPrefHelper.instance.getLatitude(),
                      Longitude: SharedPrefHelper.instance.getLongitude(),
                      DiscountAmt: edt_HeaderDisc.text.toString(),
                      SGSTAmt: finalPrice[4].toStringAsFixed(2),
                      CGSTAmt: finalPrice[3].toStringAsFixed(2),
                      IGSTAmt: finalPrice[5].toStringAsFixed(2),
                      ChargeID1: quotationOtherChargesListResponse[0].ChargeID1,
                      ChargeAmt1:
                          quotationOtherChargesListResponse[0].ChargeAmt1,
                      ChargeBasicAmt1: finalPrice[6].toStringAsFixed(2),
                      ChargeGSTAmt1: finalPrice[11].toStringAsFixed(2),
                      ChargeID2: quotationOtherChargesListResponse[0].ChargeID2,
                      ChargeAmt2:
                          quotationOtherChargesListResponse[0].ChargeAmt2,
                      ChargeBasicAmt2: finalPrice[7].toStringAsFixed(2),
                      ChargeGSTAmt2: finalPrice[12].toStringAsFixed(2),
                      ChargeID3: quotationOtherChargesListResponse[0].ChargeID3,
                      ChargeAmt3:
                          quotationOtherChargesListResponse[0].ChargeAmt3,
                      ChargeBasicAmt3: finalPrice[8].toStringAsFixed(2),
                      ChargeGSTAmt3: finalPrice[13].toStringAsFixed(2),
                      ChargeID4: quotationOtherChargesListResponse[0].ChargeID4,
                      ChargeAmt4:
                          quotationOtherChargesListResponse[0].ChargeAmt4,
                      ChargeBasicAmt4: finalPrice[9].toStringAsFixed(2),
                      ChargeGSTAmt4: finalPrice[14].toStringAsFixed(2),
                      ChargeID5: quotationOtherChargesListResponse[0].ChargeID5,
                      ChargeAmt5:
                          quotationOtherChargesListResponse[0].ChargeAmt5,
                      ChargeBasicAmt5: finalPrice[10].toStringAsFixed(2),
                      ChargeGSTAmt5: finalPrice[15].toStringAsFixed(2),
                      NetAmt: finalPrice[17].toStringAsFixed(2),
                      BasicAmt: finalPrice[0].toStringAsFixed(2),
                      ROffAmt: finalPrice[18].toStringAsFixed(2),
                      ChargePer1: "0.00",
                      ChargePer2: "0.00",
                      ChargePer3: "0.00",
                      ChargePer4: "0.00",
                      ChargePer5: "0.00",
                      CompanyId: CompanyID.toString(),
                      BankID: edt_Portal_details_ID.text,
                      AdditionalRemarks: _contrller_other_Remarks.text,
                      AssumptionRemarks: _controller_Ref_Inquiry.text,
                      OrgCode: edt_OrganizationCode.text.toString() == "null"
                          ? ""
                          : edt_OrganizationCode.text,
                      ReferenceNo: _controller_reference_no.text,
                      ReferenceDate: _controller_rev_reference_date.text,
                      CreditDays: _controller_credit_days.text,
                      CurrencyName: _controller_currency.text,
                      CurrencySymbol: _controller_currency_Symbol.text,
                      ExchangeRate: _controller_exchange_rate.text)));
            });
          } else {
            showCommonDialogWithSingleOption(
                context, "Quotation Product is required !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.pop(context);
            });
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Bank Details is required !", positiveButtonTitle: "OK",
              onTapOfPositiveButton: () {
            Navigator.pop(context);
          });
        }
      } else {
        showCommonDialogWithSingleOption(context, "Customer name is required !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.pop(context);
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Quotation date is required !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.pop(context);
      });
    }
  }

  void _OnQuotationHeaderSaveSucessResponse(
      QuotationHeaderSaveResponseState state) {
    int returnPKID = 0;
    String retrunQT_No = "";
    for (int i = 0; i < state.response.details.length; i++) {
      returnPKID = state.response.details[i].column3;
      retrunQT_No = state.response.details[i].column4;
    }

    _inquiryBloc.add(GetQuotationSpecificationwithQTNOTableEvent(retrunQT_No));
    updateRetrunInquiryNoToDB(state.context, returnPKID, retrunQT_No);

    String notiTitle = "Quotation";
    String updatemsg = _isForUpdate == true ? " Updated " : " Created ";

    ///state.inquiryHeaderSaveResponse.details[0].column3;
    String notibody = "Quotation " +
        retrunQT_No +
        updatemsg +
        " For " +
        edt_CustomerName.text +
        " By " +
        _offlineLoggedInData.details[0].employeeName;

    var request123 = {
      "to": ReportToToken,
      "notification": {"body": notibody, "title": notiTitle},
      "data": {
        "body": notibody,
        "title": notiTitle,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };

    print("Notificationdf" + request123.toString());

    if (ReportToToken != "") {
      _inquiryBloc.add(FCMNotificationRequestEvent(request123));
    }
  }

  void _OnQuotationProductSaveSucessResponse(
      QuotationProductSaveResponseState state) async {
    String Msg = _isForUpdate == true
        ? "Quotation Updated Successfully"
        : "Quotation Added Successfully";

    showCommonDialogWithSingleOption(state.context, Msg,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      navigateTo(state.context, QuotationListScreen.routeName,
          clearAllStack: true);
    });
  }

  void updateRetrunInquiryNoToDB(
      BuildContext context1, int pkID, String ReturnQT_No) async {
    await getInquiryProductDetails();

    List<QuotationTable> TempproductList1 =
        HeaderDiscountCalculation.txtHeadDiscount_WithZero(
            _inquiryProductList,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    List<QuotationTable> TempproductList =
        HeaderDiscountCalculation.txtHeadDiscount_TextChanged(
            TempproductList1,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    TempproductList.forEach((element) {
      element.pkID = pkID;
      element.LoginUserID = LoginUserID;
      element.CompanyId = CompanyID.toString();
    });
    _inquiryBloc.add(QuotationProductSaveCallEvent(
        context1, ReturnQT_No.replaceAll("/", "-"), TempproductList));
  }

  void _onOtherChargeListResponse(QuotationOtherChargeListResponseState state) {
    int chrID1 = 0;
    int chrID2 = 0;
    int chrID3 = 0;
    int chrID4 = 0;
    int chrID5 = 0;

    for (int i = 0;
        i < state.quotationOtherChargesListResponse.details.length;
        i++) {
      if (edt_ChargeID1.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID1 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID1.text = chrID1.toString();

        edt_ChargeName1.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType1.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer1.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST1.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      } else if (edt_ChargeID2.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID2 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID2.text = chrID2.toString();
        edt_ChargeName2.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType2.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer2.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST2.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      } else if (edt_ChargeID3.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID3 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID3.text = chrID3.toString();
        edt_ChargeName3.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType3.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer3.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST3.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      } else if (edt_ChargeID4.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID4 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID4.text = chrID4.toString();
        edt_ChargeName4.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType4.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer4.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST4.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      } else if (edt_ChargeID5.text ==
          state.quotationOtherChargesListResponse.details[i].pkId.toString()) {
        chrID5 = state.quotationOtherChargesListResponse.details[i].pkId;
        edt_ChargeID5.text = chrID5.toString();
        edt_ChargeName5.text =
            state.quotationOtherChargesListResponse.details[i].chargeName;

        edt_ChargeTaxType5.text = state
            .quotationOtherChargesListResponse.details[i].taxType
            .toString();
        edt_ChargeGstPer5.text = state
            .quotationOtherChargesListResponse.details[i].gSTPer
            .toString();
        edt_ChargeBeforGST5.text = state
            .quotationOtherChargesListResponse.details[i].beforeGST
            .toString();
      }
    }
  }

  Widget BankDropDown(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      TextEditingController controllerpkID,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () => showcustomdialogWithID(
                values: arr_ALL_Name_ID_For_BankDropDownList,
                context1: context,
                controller: edt_Portal_details,
                controllerID: edt_Portal_details_ID,
                lable: "Select Bank Portal"),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(title,
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
                                hintText: hintTextvalue,
                                labelStyle: TextStyle(
                                  color: Color(0xFF000000),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 10),
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

  void _onBankVoucherSaveResponse(QuotationBankDropDownResponseState state) {
    arr_ALL_Name_ID_For_BankDropDownList.clear();
    for (var i = 0; i < state.response.details.length; i++) {
      if (i == 0) {
        edt_Portal_details.text = state.response.details[0].bankName;
        edt_Portal_details_ID.text = state.response.details[0].pkID.toString();
      }

      ALL_Name_ID all_name_id = new ALL_Name_ID();
      all_name_id.pkID = state.response.details[i].pkID;
      all_name_id.Name = state.response.details[i].bankName;
      arr_ALL_Name_ID_For_BankDropDownList.add(all_name_id);
    }
  }

  void _onGetTokenfromReportopersonResult(GetReportToTokenResponseState state) {
    ReportToToken = state.response.details[0].reportPersonTokenNo;
  }

  void _onRecevedNotification(FCMNotificationResponseState state) {
    print("fcm_notification" +
        state.response.canonicalIds.toString() +
        state.response.failure.toString() +
        state.response.multicastId.toString() +
        state.response.success.toString() +
        state.response.results[0].messageId);
  }

  void _OnEmailContentResponse(QuotationEmailContentResponseState state) {
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
          controller2: _contrller_Email_Discription,
          lable: "Select Email Content ");
    }
  }

  showcustomdialogSendEmail({
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

                                _inquiryBloc.add(SaveEmailContentRequestEvent(
                                    SaveEmailContentRequest(
                                        pkID: "0",
                                        Subject:
                                            _contrller_Email_Add_Subject.text,
                                        ContentData:
                                            _contrller_Email_Add_Content.text,
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

  void _OnChargID1Response(QuotationOtherCharge1ListResponseState state) {
    if (state.quotationOtherChargesListResponse.details.isNotEmpty) {
      edt_ChargeTaxType1.text =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      edt_ChargeGstPer1.text = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      edt_ChargeBeforGST1.text = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();

      print("sdsdkfin" + "TaxType : " + edt_ChargeTaxType1.text.toString());

      OtherChargeGstPer1 = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      OtherChargeTaxType1 =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      OtherChargeBeforGst1 = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();

      genericOtherChargeDetails.OtherChargeTaxType1 =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();

      SharedPrefHelper.instance.setGenricTaxtype(state
          .quotationOtherChargesListResponse.details[0].taxType
          .toString());
    } else {
      edt_ChargeTaxType1.text = "0";
      edt_ChargeGstPer1.text = "0.00";
      edt_ChargeBeforGST1.text = "false";

      print("sdsdkfin" + "TaxType : " + edt_ChargeTaxType1.text.toString());

      OtherChargeGstPer1 = "0.00";
      OtherChargeTaxType1 = "0";
      OtherChargeBeforGst1 = "false";

      genericOtherChargeDetails.OtherChargeTaxType1 = "0";

      SharedPrefHelper.instance.setGenricTaxtype("0");
    }
  }

  void _OnChargID2Response(QuotationOtherCharge2ListResponseState state) {
    if (state.quotationOtherChargesListResponse.details.isNotEmpty) {
      edt_ChargeTaxType2.text =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      edt_ChargeGstPer2.text = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      edt_ChargeBeforGST2.text = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();

      OtherChargeGstPer2 = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      OtherChargeTaxType2 =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      OtherChargeBeforGst2 = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();

      genericOtherChargeDetails.OtherChargeTaxType2 =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
    } else {
      edt_ChargeTaxType2.text = "0";
      edt_ChargeGstPer2.text = "0.00";
      edt_ChargeBeforGST2.text = "false";

      print("sdsdkfin" + "TaxType : " + edt_ChargeTaxType2.text.toString());

      OtherChargeGstPer2 = "0.00";
      OtherChargeTaxType2 = "0";
      OtherChargeBeforGst2 = "false";

      genericOtherChargeDetails.OtherChargeTaxType2 = "0";

      SharedPrefHelper.instance.setGenricTaxtype("0");
    }
  }

  void _OnChargID3Response(QuotationOtherCharge3ListResponseState state) {
    if (state.quotationOtherChargesListResponse.details.isNotEmpty) {
      edt_ChargeTaxType3.text =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      edt_ChargeGstPer3.text = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      edt_ChargeBeforGST3.text = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();

      OtherChargeGstPer3 = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      OtherChargeTaxType3 =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      OtherChargeBeforGst3 = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();
      genericOtherChargeDetails.OtherChargeTaxType3 =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
    } else {
      edt_ChargeTaxType3.text = "0";
      edt_ChargeGstPer3.text = "0.00";
      edt_ChargeBeforGST3.text = "false";

      print("sdsdkfin" + "TaxType : " + edt_ChargeTaxType3.text.toString());

      OtherChargeGstPer3 = "0.00";
      OtherChargeTaxType3 = "0";
      OtherChargeBeforGst3 = "false";

      genericOtherChargeDetails.OtherChargeTaxType3 = "0";

      SharedPrefHelper.instance.setGenricTaxtype("0");
    }
  }

  void _OnChargID4Response(QuotationOtherCharge4ListResponseState state) {
    if (state.quotationOtherChargesListResponse.details.isNotEmpty) {
      edt_ChargeTaxType4.text =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      edt_ChargeGstPer4.text = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      edt_ChargeBeforGST4.text = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();

      OtherChargeGstPer4 = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      OtherChargeTaxType4 =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      OtherChargeBeforGst4 = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();
    } else {
      edt_ChargeTaxType4.text = "0";
      edt_ChargeGstPer4.text = "0.00";
      edt_ChargeBeforGST4.text = "false";

      print("sdsdkfin" + "TaxType : " + edt_ChargeTaxType4.text.toString());

      OtherChargeGstPer4 = "0.00";
      OtherChargeTaxType4 = "0";
      OtherChargeBeforGst4 = "false";

      genericOtherChargeDetails.OtherChargeTaxType4 = "0";

      SharedPrefHelper.instance.setGenricTaxtype("0");
    }
  }

  void _OnChargID5Response(QuotationOtherCharge5ListResponseState state) {
    if (state.quotationOtherChargesListResponse.details.isNotEmpty) {
      edt_ChargeTaxType5.text =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      edt_ChargeGstPer5.text = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      edt_ChargeBeforGST5.text = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();

      OtherChargeGstPer5 = state
          .quotationOtherChargesListResponse.details[0].gSTPer
          .toStringAsFixed(2);
      OtherChargeTaxType5 =
          state.quotationOtherChargesListResponse.details[0].taxType.toString();
      OtherChargeBeforGst5 = state
          .quotationOtherChargesListResponse.details[0].beforeGST
          .toString();
    } else {
      edt_ChargeTaxType5.text = "0";
      edt_ChargeGstPer5.text = "0.00";
      edt_ChargeBeforGST5.text = "false";

      print("sdsdkfin" + "TaxType : " + edt_ChargeTaxType5.text.toString());

      OtherChargeGstPer5 = "0.00";
      OtherChargeTaxType5 = "0";
      OtherChargeBeforGst5 = "false";

      genericOtherChargeDetails.OtherChargeTaxType5 = "0";

      SharedPrefHelper.instance.setGenricTaxtype("0");
    }
  }

  void _OnTaptoSave() async {
    HeaderDisAmnt = double.parse(edt_HeaderDisc.text.toString());

    TotalCalculation();
    TotalCalculation2();
    TotalCalculation3();
    TotalCalculation4();
    TotalCalculation5();

    double ChargeAmt1 = double.parse(OtherChargeAmount1);
    double ChargeAmt2 = double.parse(OtherChargeAmount2);
    double ChargeAmt3 = double.parse(OtherChargeAmount3);
    double ChargeAmt4 = double.parse(OtherChargeAmount4);
    double ChargeAmt5 = double.parse(OtherChargeAmount5);

    double TotalOtherAmnt =
        ChargeAmt1 + ChargeAmt2 + ChargeAmt3 + ChargeAmt4 + ChargeAmt5;

    Tot_BasicAmount = 0.00;
    Tot_otherChargeWithTax = 0.00;
    Tot_GSTAmt = 0.00;
    Tot_otherChargeExcludeTax = 0.00;
    Tot_NetAmt = 0.00;

    for (int i = 0; i < _inquiryProductList.length; i++) {
      Tot_BasicAmount = Tot_BasicAmount + _inquiryProductList[i].Amount;

      print(" GetBasicAmount " +
          " BasicTotal : " +
          _inquiryProductList[i].Amount.toStringAsFixed(2));
      Tot_otherChargeWithTax = 0.00;
      Tot_GSTAmt = Tot_GSTAmt + _inquiryProductList[i].TaxAmount;
      Tot_otherChargeExcludeTax = 0.00;
      Tot_NetAmt = Tot_NetAmt + _inquiryProductList[i].NetAmount;
    }

    UpdateAfterHeaderDiscount();
    Tot_otherChargeWithTax = (InclusiveBeforeGstAmnt1) +
        (ExclusiveBeforeGStAmnt1) +
        (InclusiveBeforeGstAmnt2) +
        (ExclusiveBeforeGStAmnt2) +
        (InclusiveBeforeGstAmnt3) +
        (ExclusiveBeforeGStAmnt3) +
        (InclusiveBeforeGstAmnt4) +
        (ExclusiveBeforeGStAmnt4) +
        (InclusiveBeforeGstAmnt5) +
        (ExclusiveBeforeGStAmnt5); //+ (ChargeAmt3 - devide3) + (ChargeAmt4 - devide4) + (ChargeAmt5 - devide5);
    Tot_GSTAmt = Tot_GSTAmt +
        InclusiveBeforeGstAmnt_Minus1 +
        ExclusiveBeforeGStAmnt_Minus1 +
        InclusiveBeforeGstAmnt_Minus2 +
        ExclusiveBeforeGStAmnt_Minus2 +
        InclusiveBeforeGstAmnt_Minus3 +
        ExclusiveBeforeGStAmnt_Minus3 +
        InclusiveBeforeGstAmnt_Minus4 +
        ExclusiveBeforeGStAmnt_Minus4 +
        InclusiveBeforeGstAmnt_Minus5 +
        ExclusiveBeforeGStAmnt_Minus5;
    Tot_otherChargeExcludeTax = AfterInclusiveBeforeGstAmnt1 +
        ExclusiveAfterGstAmnt1 +
        AfterInclusiveBeforeGstAmnt2 +
        ExclusiveAfterGstAmnt2 +
        AfterInclusiveBeforeGstAmnt3 +
        ExclusiveAfterGstAmnt3 +
        AfterInclusiveBeforeGstAmnt4 +
        ExclusiveAfterGstAmnt4 +
        AfterInclusiveBeforeGstAmnt5 +
        ExclusiveAfterGstAmnt5;

    _basicAmountController = Tot_BasicAmount.toStringAsFixed(2);
    _otherChargeWithTaxController = Tot_otherChargeWithTax.toStringAsFixed(2);

    ///Final Setup Befor GST
    _totalGstController = Tot_GSTAmt.toStringAsFixed(2);
    _otherChargeExcludeTaxController =
        Tot_otherChargeExcludeTax.toStringAsFixed(2);

    ///Final Setup After GST
    //double Tot_NetAmnt = Tot_NetAmt + Tot_otherChargeWithTax + Tot_otherChargeExcludeTax;

    double Tot_NetAmnt = Tot_NetAmt +
        TotalOtherAmnt +
        ExclusiveBeforeGStAmnt_Minus1 +
        ExclusiveBeforeGStAmnt_Minus2 +
        ExclusiveBeforeGStAmnt_Minus3 +
        ExclusiveBeforeGStAmnt_Minus4 +
        ExclusiveBeforeGStAmnt_Minus5;

    double MinusHeaderDiscamnt = Tot_NetAmnt - HeaderDisAmnt;

    netAmountController = /*nt.toStringAsFixed(
        2);*/
        MinusHeaderDiscamnt.toStringAsFixed(
            2); //Tot_BasicAmount.toStringAsFixed(2) + Tot_otherChargeWithTax.toStringAsFixed(2) + Tot_GSTAmt.toStringAsFixed(2) + Tot_otherChargeExcludeTax.toStringAsFixed(2);

    print("sNERg" + " NETAMNT : " + netAmountController);

    editMode_netamount_controller.text = MinusHeaderDiscamnt.toStringAsFixed(2);
  }

  void TotalCalculation() async {
    double ChargeAmt1 = double.parse(OtherChargeAmount1);

    double taxRate1 = double.parse(OtherChargeGstPer1);

    ///_otherChargeTaxTypeController1.text = 1 (Exclusive) -- _otherChargeTaxTypeController1.text = 0 (Inclusive)

    /// _otherChargeBeForeGSTController1.text=="true" (Before GST) _otherChargeBeForeGSTController1.text=="false" (After GST)
    ///
    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (OtherChargeTaxType1 != null) {
      Taxtype = double.parse(OtherChargeTaxType1);
      ISTaxType = Taxtype.toInt();
    }

    print("sdfjdlf" + ISTaxType.toString());
    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt1 = 0.00;
      InclusiveBeforeGstAmnt_Minus1 = 0.00;
      AfterInclusiveBeforeGstAmnt1 = 0.00;
      if (OtherChargeBeforGst1 == "true") {
        double multi1 = 0.00;
        double addtaxt1 = 0.00;
        double devide1 = 0.00;
        multi1 = ChargeAmt1 * taxRate1;
        addtaxt1 = 100;
        devide1 = multi1 / addtaxt1;

        ExclusiveBeforeGStAmnt1 = ChargeAmt1;
        ExclusiveBeforeGStAmnt_Minus1 = devide1;
        ExclusiveAfterGstAmnt1 = 0.00;

        print("jfjfj44" + devide1.toString());
        //Tot_otherChargeWithTax = ChargeAmt1+ChargeAmt2 +ChargeAmt3+ChargeAmt4+ChargeAmt5;
      } else {
        // Tot_otherChargeExcludeTax =   ChargeAmt1+  ChargeAmt2 +ChargeAmt3+ChargeAmt4+ChargeAmt5;
        ExclusiveAfterGstAmnt1 = ChargeAmt1;
        ExclusiveBeforeGStAmnt1 = 0.00;
        ExclusiveBeforeGStAmnt_Minus1 = 0.00;
      }

      // Tot_GSTAmt =  ((ChargeAmt1 * taxRate1)/100) + ((ChargeAmt2 * taxRate2)/100) + ((ChargeAmt3 * taxRate3)/100) + ((ChargeAmt4 * taxRate4)/100) + ((ChargeAmt5 * taxRate5)/100);
    } else {
      ExclusiveBeforeGStAmnt1 = 0.00;
      ExclusiveBeforeGStAmnt_Minus1 = 0.00;
      ExclusiveAfterGstAmnt1 = 0.00;

      if (OtherChargeBeforGst1 == "true") {
        double multi1 = 0.00;
        double addtaxt1 = 0.00;
        double devide1 = 0.00;
        double to_InclusiveBeforeGstAmnt1 = 0.00;

        multi1 = ChargeAmt1 * taxRate1;
        addtaxt1 = 100 + taxRate1;
        devide1 = multi1 / addtaxt1;

        InclusiveBeforeGstAmnt1 = ChargeAmt1 - devide1;
        InclusiveBeforeGstAmnt_Minus1 = devide1;
        AfterInclusiveBeforeGstAmnt1 = 0.00;
      } else {
        // Tot_otherChargeExcludeTax = ChargeAmt1+  ChargeAmt2 +ChargeAmt3+ChargeAmt4+ChargeAmt5;
        InclusiveBeforeGstAmnt1 = 0.00;
        InclusiveBeforeGstAmnt_Minus1 = 0.00;
        AfterInclusiveBeforeGstAmnt1 = ChargeAmt1;
      }
    }

    print("DFDFDFDF232" +
        " TotalBasicAmt : " +
        Tot_BasicAmount.toStringAsFixed(2) +
        " Tot_otherChargeWithTax : " +
        Tot_otherChargeWithTax.toStringAsFixed(2) +
        " Tot_GSTAmt : " +
        Tot_GSTAmt.toStringAsFixed(2) +
        " Tot_otherChargeExcludeTax : " +
        Tot_otherChargeExcludeTax.toStringAsFixed(2) +
        " Tot_NetAmt : " +
        Tot_NetAmt.toStringAsFixed(2));
  }

  void TotalCalculation2() async {
    double ChargeAmt2 = double.parse(OtherChargeAmount2);

    double taxRate2 = double.parse(OtherChargeGstPer2);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (OtherChargeTaxType2 != null) {
      Taxtype = double.parse(OtherChargeTaxType2);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt2 = 0.00;
      InclusiveBeforeGstAmnt_Minus2 = 0.00;
      AfterInclusiveBeforeGstAmnt2 = 0.00;
      if (OtherChargeBeforGst2 == "true") {
        double multi2 = 0.00;
        double addtaxt2 = 0.00;
        double devide2 = 0.00;

        multi2 = ChargeAmt2 * taxRate2;
        addtaxt2 = 100;
        devide2 = multi2 / addtaxt2;

        ExclusiveBeforeGStAmnt2 = ChargeAmt2;
        ExclusiveBeforeGStAmnt_Minus2 = devide2;
        ExclusiveAfterGstAmnt2 = 0.00;
      } else {
        //Tot_otherChargeExcludeTax =  ChargeAmt1+ChargeAmt2 +ChargeAmt3+ChargeAmt4+ChargeAmt5;
        ExclusiveAfterGstAmnt2 = ChargeAmt2;
        ExclusiveBeforeGStAmnt2 = 0.00;
        ExclusiveBeforeGStAmnt_Minus2 = 0.00;
      }

      //Tot_GSTAmt =  ((ChargeAmt1 * taxRate1)/100) + ((ChargeAmt2 * taxRate2)/100) + ((ChargeAmt3 * taxRate3)/100) + ((ChargeAmt4 * taxRate4)/100) + ((ChargeAmt5 * taxRate5)/100);
    } else {
      ExclusiveBeforeGStAmnt2 = 0.00;
      ExclusiveBeforeGStAmnt_Minus2 = 0.00;
      ExclusiveAfterGstAmnt2 = 0.00;

      if (OtherChargeBeforGst2 == "true") {
        double multi2 = 0.00;
        double addtaxt2 = 0.00;
        double devide2 = 0.00;
        double to_InclusiveBeforeGstAmnt2 = 0.00;

        multi2 = ChargeAmt2 * taxRate2;
        addtaxt2 = 100 + taxRate2;
        devide2 = multi2 / addtaxt2;

        InclusiveBeforeGstAmnt2 = ChargeAmt2 - devide2;
        InclusiveBeforeGstAmnt_Minus2 = devide2;
        AfterInclusiveBeforeGstAmnt2 = 0.00;
      } else {
        InclusiveBeforeGstAmnt2 = 0.00;
        InclusiveBeforeGstAmnt_Minus2 = 0.00;
        AfterInclusiveBeforeGstAmnt2 = ChargeAmt2;
      }
    }
  }

  void TotalCalculation3() async {
    double ChargeAmt3 = double.parse(OtherChargeAmount3);
    double taxRate3 = double.parse(OtherChargeGstPer3);
    double Taxtype = 0.00;
    int ISTaxType = 0;

    print("testOtherg" + OtherChargeTaxType3);

    if (OtherChargeTaxType3 != null) {
      Taxtype = double.parse(OtherChargeTaxType3);
      ISTaxType = Taxtype.toInt();
    }
    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt3 = 0.00;
      InclusiveBeforeGstAmnt_Minus3 = 0.00;
      AfterInclusiveBeforeGstAmnt3 = 0.00;
      if (OtherChargeBeforGst3 == "true") {
        double multi3 = 0.00;
        double addtaxt3 = 0.00;
        double devide3 = 0.00;

        multi3 = ChargeAmt3 * taxRate3;
        addtaxt3 = 100;
        devide3 = multi3 / addtaxt3;

        ExclusiveBeforeGStAmnt3 = ChargeAmt3;
        ExclusiveBeforeGStAmnt_Minus3 = devide3;
        ExclusiveAfterGstAmnt3 = 0.00;
      } else {
        ExclusiveAfterGstAmnt3 = ChargeAmt3;
        ExclusiveBeforeGStAmnt3 = 0.00;
        ExclusiveBeforeGStAmnt_Minus3 = 0.00;
      }
    } else {
      ExclusiveBeforeGStAmnt3 = 0.00;
      ExclusiveBeforeGStAmnt_Minus3 = 0.00;
      ExclusiveAfterGstAmnt3 = 0.00;

      if (OtherChargeBeforGst3 == "true") {
        double multi3 = 0.00;
        double addtaxt3 = 0.00;
        double devide3 = 0.00;
        double to_InclusiveBeforeGstAmnt2 = 0.00;

        multi3 = ChargeAmt3 * taxRate3;
        addtaxt3 = 100 + taxRate3;
        devide3 = multi3 / addtaxt3;

        InclusiveBeforeGstAmnt3 = ChargeAmt3 - devide3;
        InclusiveBeforeGstAmnt_Minus3 = devide3;
        AfterInclusiveBeforeGstAmnt3 = 0.00;
      } else {
        InclusiveBeforeGstAmnt3 = 0.00;
        InclusiveBeforeGstAmnt_Minus3 = 0.00;
        AfterInclusiveBeforeGstAmnt3 = ChargeAmt3;
      }
    }
  }

  void TotalCalculation4() async {
    double ChargeAmt4 = double.parse(OtherChargeAmount4);
    double taxRate4 = double.parse(OtherChargeGstPer4);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (OtherChargeTaxType4 != null) {
      Taxtype = double.parse(OtherChargeTaxType4);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt4 = 0.00;
      InclusiveBeforeGstAmnt_Minus4 = 0.00;
      AfterInclusiveBeforeGstAmnt4 = 0.00;
      if (OtherChargeBeforGst4 == "true") {
        double multi4 = 0.00;
        double addtaxt4 = 0.00;
        double devide4 = 0.00;

        multi4 = ChargeAmt4 * taxRate4;
        addtaxt4 = 100;
        devide4 = multi4 / addtaxt4;

        ExclusiveBeforeGStAmnt4 = ChargeAmt4;
        ExclusiveBeforeGStAmnt_Minus4 = devide4;
        ExclusiveAfterGstAmnt4 = 0.00;
      } else {
        ExclusiveAfterGstAmnt4 = ChargeAmt4;
        ExclusiveBeforeGStAmnt4 = 0.00;
        ExclusiveBeforeGStAmnt_Minus4 = 0.00;
      }
    } else {
      ExclusiveBeforeGStAmnt4 = 0.00;
      ExclusiveBeforeGStAmnt_Minus4 = 0.00;
      ExclusiveAfterGstAmnt4 = 0.00;

      if (OtherChargeBeforGst4 == "true") {
        double multi4 = 0.00;
        double addtaxt4 = 0.00;
        double devide4 = 0.00;
        double to_InclusiveBeforeGstAmnt4 = 0.00;

        multi4 = ChargeAmt4 * taxRate4;
        addtaxt4 = 100 + taxRate4;
        devide4 = multi4 / addtaxt4;

        InclusiveBeforeGstAmnt4 = ChargeAmt4 - devide4;
        InclusiveBeforeGstAmnt_Minus4 = devide4;
        AfterInclusiveBeforeGstAmnt4 = 0.00;
      } else {
        InclusiveBeforeGstAmnt4 = 0.00;
        InclusiveBeforeGstAmnt_Minus4 = 0.00;
        AfterInclusiveBeforeGstAmnt4 = ChargeAmt4;
      }
    }
  }

  void TotalCalculation5() async {
    double ChargeAmt5 = double.parse(OtherChargeAmount5);
    double taxRate5 = double.parse(OtherChargeGstPer5);

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (OtherChargeTaxType5 != null) {
      Taxtype = double.parse(OtherChargeTaxType5);
      ISTaxType = Taxtype.toInt();
    }

    if (ISTaxType == 1) {
      InclusiveBeforeGstAmnt5 = 0.00;
      InclusiveBeforeGstAmnt_Minus5 = 0.00;
      AfterInclusiveBeforeGstAmnt5 = 0.00;
      if (OtherChargeBeforGst5 == "true") {
        double multi5 = 0.00;
        double addtaxt5 = 0.00;
        double devide5 = 0.00;

        multi5 = ChargeAmt5 * taxRate5;
        addtaxt5 = 100;
        devide5 = multi5 / addtaxt5;

        ExclusiveBeforeGStAmnt5 = ChargeAmt5;
        ExclusiveBeforeGStAmnt_Minus5 = devide5;
        ExclusiveAfterGstAmnt5 = 0.00;
      } else {
        ExclusiveAfterGstAmnt5 = ChargeAmt5;
        ExclusiveBeforeGStAmnt5 = 0.00;
        ExclusiveBeforeGStAmnt_Minus5 = 0.00;
      }
    } else {
      ExclusiveBeforeGStAmnt5 = 0.00;
      ExclusiveBeforeGStAmnt_Minus5 = 0.00;
      ExclusiveAfterGstAmnt5 = 0.00;

      if (OtherChargeBeforGst5 == "true") {
        double multi5 = 0.00;
        double addtaxt5 = 0.00;
        double devide5 = 0.00;
        double to_InclusiveBeforeGstAmnt5 = 0.00;

        multi5 = ChargeAmt5 * taxRate5;
        addtaxt5 = 100 + taxRate5;
        devide5 = multi5 / addtaxt5;

        InclusiveBeforeGstAmnt5 = ChargeAmt5 - devide5;
        InclusiveBeforeGstAmnt_Minus5 = devide5;
        AfterInclusiveBeforeGstAmnt5 = 0.00;
      } else {
        InclusiveBeforeGstAmnt5 = 0.00;
        InclusiveBeforeGstAmnt_Minus5 = 0.00;
        AfterInclusiveBeforeGstAmnt5 = ChargeAmt5;
      }
    }
  }

  void UpdateAfterHeaderDiscount() async {
    double tot_amnt_net = 0.00;

    Tot_NetAmt = 0.00;

    for (int i = 0; i < _inquiryProductList.length; i++) {
      print("_inquiryProductList[i].NetAmount234" +
          " Tot_NetAmt : " +
          _inquiryProductList[i].NetAmount.toString());

      tot_amnt_net = tot_amnt_net + _inquiryProductList[i].NetAmount;
    }
    print("Tot_NetAmtTot_NetAmt" + " Tot_NetAmt : " + tot_amnt_net.toString());

    HeaderDisAmnt = double.parse(edt_HeaderDisc.text.toString());

    double ExclusiveItemWiseHeaderDisAmnt = 0.00;
    double ExclusiveItemWiseAmount = 0.00;
    double ExclusiveNetAmntAfterHeaderDisAmnt = 0.00;
    double ExclusiveItemWiseTaxAmnt = 0.00;
    double ExclusiveTaxPluse100 = 0.00;
    double ExclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

    double ExclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;

    double InclusiveItemWiseHeaderDisAmnt = 0.00;
    double InclusiveItemWiseAmount = 0.00;
    double InclusiveNetAmntAfterHeaderDisAmnt = 0.00;
    double InclusiveItemWiseTaxAmnt = 0.00;
    double InclusiveTaxPluse100 = 0.00;
    double InclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

    double InclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;
    double ExTotalBasic = 0.00;
    double ExTotalGSTamt = 0.00;
    double ExTotalNetAmnt = 0.00;
    double InTotalBasic = 0.00;
    double InTotalGSTamt = 0.00;
    double InTotalNetAmnt = 0.00;

    for (int i = 0; i < _inquiryProductList.length; i++) {
      if (_inquiryProductList[i].TaxType == 1) {
        ExclusiveItemWiseHeaderDisAmnt =
            (_inquiryProductList[i].NetAmount * HeaderDisAmnt) / tot_amnt_net;
        print("sdf434" +
            ExclusiveItemWiseHeaderDisAmnt.toString() +
            "  Net amnt : " +
            _inquiryProductList[i].NetAmount.toString() +
            " Hder : " +
            HeaderDisAmnt.toString());
        ExclusiveItemWiseAmount =
            _inquiryProductList[i].Quantity * _inquiryProductList[i].NetRate;
        ExclusiveNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount - ExclusiveItemWiseHeaderDisAmnt;
        ExclusiveItemWiseTaxAmnt = (ExclusiveNetAmntAfterHeaderDisAmnt *
                _inquiryProductList[i].TaxRate) /
            100;

        print("dfjfj221223" + ExclusiveNetAmntAfterHeaderDisAmnt.toString());

        ExclusiveFinalNetAmntAfterHeaderDisAmnt =
            ExclusiveNetAmntAfterHeaderDisAmnt;
        ExclusiveTotalNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount + ExclusiveItemWiseTaxAmnt;

        ExTotalBasic += ExclusiveFinalNetAmntAfterHeaderDisAmnt;
        ExTotalGSTamt += ExclusiveItemWiseTaxAmnt;
        ExTotalNetAmnt += ExclusiveTotalNetAmntAfterHeaderDisAmnt;
      } else {
        InclusiveItemWiseHeaderDisAmnt =
            (_inquiryProductList[i].NetAmount * HeaderDisAmnt) / tot_amnt_net;
        InclusiveItemWiseAmount =
            _inquiryProductList[i].Quantity * _inquiryProductList[i].NetRate;
        InclusiveNetAmntAfterHeaderDisAmnt =
            InclusiveItemWiseAmount - InclusiveItemWiseHeaderDisAmnt;
        InclusiveTaxPluse100 = 100 + _inquiryProductList[i].TaxRate;
        InclusiveItemWiseTaxAmnt = (InclusiveNetAmntAfterHeaderDisAmnt *
                _inquiryProductList[i].TaxRate) /
            InclusiveTaxPluse100;
        InclusiveFinalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt - InclusiveItemWiseTaxAmnt;
        InclusiveTotalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt; //+ InclusiveItemWiseTaxAmnt;

        InTotalBasic += InclusiveFinalNetAmntAfterHeaderDisAmnt;
        InTotalGSTamt += InclusiveItemWiseTaxAmnt;
        InTotalNetAmnt += InclusiveTotalNetAmntAfterHeaderDisAmnt;
      }

      /* double TotNet =0.00; // ExclusiveTotalNetAmntAfterHeaderDisAmnt+InclusiveTotalNetAmntAfterHeaderDisAmnt;
      print("TotNet3455gg"+" Total : "+TotNet.toStringAsFixed(2) + " TotExclNetAmnt : " + ExclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2) +
          " TotIncNetAmnt : " + InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2)
      );*/
    }
    print("testExclusive" +
        " Total ExcBasic : " +
        ExTotalBasic.toStringAsFixed(2) +
        "Total ExGSTAmnt : " +
        ExTotalGSTamt.toStringAsFixed(2) +
        "Total ExNetAmnt " +
        ExTotalNetAmnt.toStringAsFixed(2));
    print("testExclusive" +
        " Total ExcBasic : " +
        InTotalBasic.toStringAsFixed(2) +
        "Total ExGSTAmnt : " +
        InTotalGSTamt.toStringAsFixed(2) +
        "Total ExNetAmnt " +
        InTotalNetAmnt.toStringAsFixed(2));

    Tot_BasicAmount = ExTotalBasic + InTotalBasic;
    Tot_GSTAmt = ExTotalGSTamt + InTotalGSTamt;
    Tot_NetAmt = 0.00;
    double TotNet = ExTotalNetAmnt + InTotalNetAmnt;

    Tot_NetAmt = TotNet;

/*
     Tot_BasicAmount +=  ExclusiveFinalNetAmntAfterHeaderDisAmnt+InclusiveFinalNetAmntAfterHeaderDisAmnt;
     Tot_GSTAmt += ExclusiveItemWiseTaxAmnt+InclusiveItemWiseTaxAmnt;
     Tot_NetAmt =0.00;
     double TotNet = ExclusiveTotalNetAmntAfterHeaderDisAmnt+InclusiveTotalNetAmntAfterHeaderDisAmnt;
     print("TotNet3455gg"+" Total : "+TotNet.toStringAsFixed(2) + " TotExclNetAmnt : " + ExclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2) +
         " TotIncNetAmnt : " + InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2)
     );
     Tot_NetAmt +=  TotNet - HeaderDisAmnt;*/

    //print("TotNATe"+ " NetAmnt : " + Tot_NetAmt.toStringAsFixed(2));

    _basicAmountController = Tot_BasicAmount.toStringAsFixed(2);
    _otherChargeWithTaxController = Tot_otherChargeWithTax.toStringAsFixed(2);

    ///Final Setup Befor GST
    _totalGstController = Tot_GSTAmt.toStringAsFixed(2);
    _otherChargeExcludeTaxController =
        Tot_otherChargeExcludeTax.toStringAsFixed(2);

    ///Final Setup After GST
    // double Tot_NetAmnt = Tot_NetAmt + Tot_otherChargeWithTax +   Tot_otherChargeExcludeTax;
    netAmountController = Tot_NetAmt.toStringAsFixed(2);
    print("netamountfj" + " NetAmount4 : " + netAmountController);
    //Tot_BasicAmount.toStringAsFixed(2) + Tot_otherChargeWithTax.toStringAsFixed(2) + Tot_GSTAmt.toStringAsFixed(2) + Tot_otherChargeExcludeTax.toStringAsFixed(2);
  }

  void PushAllOtherChargesToDb() {
    /* List<QT_OtherChargeTable> arrTemp = await OfflineDbHelper.getInstance().getQuotationOtherCharge();

   if(arrTemp.isNotEmpty)
     {
         await OfflineDbHelper.getInstance().deleteALLQuotationOtherCharge();
     }*/

    print("BeforGSTAmnt" +
        "ChargeAmnt1 : " +
        OtherChargeAmount1.toString() +
        "ChargeAmnt2 : " +
        OtherChargeAmount2.toString() +
        " ChargeBasicAmnt1 : " +
        InclusiveBeforeGstAmnt1.toStringAsFixed(2) +
        " ChargeBasicAmnt2 : " +
        InclusiveBeforeGstAmnt2.toStringAsFixed(2) +
        " ChargeGstAmnt1 : " +
        InclusiveBeforeGstAmnt_Minus1.toStringAsFixed(2) +
        " ChargeGstAmnt2 : " +
        InclusiveBeforeGstAmnt_Minus2.toStringAsFixed(2));
    //  print("AfterGSTAmnt" + " AfterGSTAmnt1 : " + AfterInclusiveBeforeGstAmnt1.toStringAsFixed(2) + " AfterGSTAmnt2 : " + AfterInclusiveBeforeGstAmnt2.toStringAsFixed(2)  );
    print("AfterGSTAmnt" +
        "ChargeAmnt1 : " +
        OtherChargeAmount1.toString() +
        "ChargeAmnt2 : " +
        OtherChargeAmount2.toString() +
        " ChargeBasicAmnt1 : " +
        AfterInclusiveBeforeGstAmnt1.toStringAsFixed(2) +
        " ChargeBasicAmnt2 : " +
        AfterInclusiveBeforeGstAmnt2.toStringAsFixed(2) +
        " ChargeGstAmnt1 : " +
        "0.00" +
        " ChargeGstAmnt2 : " +
        "0.00");
    print("ExclusiveBeforeGst" +
        " BeforeGST_AMNT1 : " +
        ExclusiveBeforeGStAmnt1.toStringAsFixed(2) +
        " GSTMinus1 : " +
        ExclusiveBeforeGStAmnt_Minus1.toStringAsFixed(2) +
        " BeforeGST_AMNT2 : " +
        ExclusiveBeforeGStAmnt2.toStringAsFixed(2) +
        " GSTMinus2 : " +
        ExclusiveBeforeGStAmnt_Minus2.toStringAsFixed(2));

    print("ExclusiveAfterGst" +
        " AfterGST_AMNT1 : " +
        ExclusiveAfterGstAmnt1.toStringAsFixed(2) +
        " AfterGST_AMNT2 : " +
        ExclusiveAfterGstAmnt2.toStringAsFixed(2));

    QT_OtherChargeTemp qt_otherChargeTable = QT_OtherChargeTemp();
    print("ChargeID" + OtherChargeID2.toString());
    qt_otherChargeTable.ChargeID1 = int.parse(
        OtherChargeID1); //==null?0:_otherChargeIDController1.text.toString());
    qt_otherChargeTable.ChargeID2 = int.parse(
        OtherChargeID2); //==null?0:_otherChargeIDController2.text.toString());
    qt_otherChargeTable.ChargeID3 = int.parse(
        OtherChargeID3); //==null?0:_otherChargeIDController3.text.toString());
    qt_otherChargeTable.ChargeID4 = int.parse(
        OtherChargeID4); //==null?0:_otherChargeIDController4.text.toString());
    qt_otherChargeTable.ChargeID5 = int.parse(
        OtherChargeID5); //==null?0:_otherChargeIDController5.text.toString());
    qt_otherChargeTable.Headerdiscount = 0.00;
    qt_otherChargeTable.Tot_BasicAmt = double.parse(
        _basicAmountController == null ? 0.00 : _basicAmountController);
    qt_otherChargeTable.OtherChargeWithTaxamt = double.parse(
        _otherChargeWithTaxController == null
            ? 0.00
            : _otherChargeWithTaxController);
    qt_otherChargeTable.Tot_GstAmt =
        double.parse(_totalGstController == null ? 0.00 : _totalGstController);
    qt_otherChargeTable.OtherChargeExcludeTaxamt = double.parse(
        _otherChargeExcludeTaxController == null
            ? 0.00
            : _otherChargeExcludeTaxController);
    qt_otherChargeTable.Tot_NetAmount =
        double.parse(netAmountController == null ? 0.00 : netAmountController);
    qt_otherChargeTable.ChargeAmt1 = double.parse(OtherChargeAmount1);
    qt_otherChargeTable.ChargeAmt2 = double.parse(OtherChargeAmount2);
    qt_otherChargeTable.ChargeAmt3 = double.parse(OtherChargeAmount3);
    qt_otherChargeTable.ChargeAmt4 = double.parse(OtherChargeAmount4);
    qt_otherChargeTable.ChargeAmt5 = double.parse(OtherChargeAmount5);

    if (OtherChargeTaxType1 == "1") {
      if (OtherChargeBeforGst1 == "true") {
        qt_otherChargeTable.ChargeBasicAmt1 = ExclusiveBeforeGStAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = ExclusiveBeforeGStAmnt_Minus1;
      } else {
        qt_otherChargeTable.ChargeBasicAmt1 = ExclusiveAfterGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst1 == "true") {
        qt_otherChargeTable.ChargeBasicAmt1 = InclusiveBeforeGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = InclusiveBeforeGstAmnt_Minus1;
      } else {
        qt_otherChargeTable.ChargeBasicAmt1 = AfterInclusiveBeforeGstAmnt1;
        qt_otherChargeTable.ChargeGSTAmt1 = 0.00;
      }
    }

    if (OtherChargeTaxType2 == "1") {
      if (OtherChargeBeforGst2 == "true") {
        qt_otherChargeTable.ChargeBasicAmt2 = ExclusiveBeforeGStAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = ExclusiveBeforeGStAmnt_Minus2;
      } else {
        qt_otherChargeTable.ChargeBasicAmt2 = ExclusiveAfterGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst2 == "true") {
        qt_otherChargeTable.ChargeBasicAmt2 = InclusiveBeforeGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = InclusiveBeforeGstAmnt_Minus2;
      } else {
        qt_otherChargeTable.ChargeBasicAmt2 = AfterInclusiveBeforeGstAmnt2;
        qt_otherChargeTable.ChargeGSTAmt2 = 0.00;
      }
    }

    if (OtherChargeTaxType3 == "1") {
      if (OtherChargeBeforGst3 == "true") {
        qt_otherChargeTable.ChargeBasicAmt3 = ExclusiveBeforeGStAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = ExclusiveBeforeGStAmnt_Minus3;
      } else {
        qt_otherChargeTable.ChargeBasicAmt3 = ExclusiveAfterGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst3 == "true") {
        qt_otherChargeTable.ChargeBasicAmt3 = InclusiveBeforeGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = InclusiveBeforeGstAmnt_Minus3;
      } else {
        qt_otherChargeTable.ChargeBasicAmt3 = AfterInclusiveBeforeGstAmnt3;
        qt_otherChargeTable.ChargeGSTAmt3 = 0.00;
      }
    }

    if (OtherChargeTaxType4 == "1") {
      if (OtherChargeBeforGst4 == "true") {
        qt_otherChargeTable.ChargeBasicAmt4 = ExclusiveBeforeGStAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = ExclusiveBeforeGStAmnt_Minus4;
      } else {
        qt_otherChargeTable.ChargeBasicAmt4 = ExclusiveAfterGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst4 == "true") {
        qt_otherChargeTable.ChargeBasicAmt4 = InclusiveBeforeGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = InclusiveBeforeGstAmnt_Minus4;
      } else {
        qt_otherChargeTable.ChargeBasicAmt4 = AfterInclusiveBeforeGstAmnt4;
        qt_otherChargeTable.ChargeGSTAmt4 = 0.00;
      }
    }

    if (OtherChargeTaxType5 == "1") {
      if (OtherChargeBeforGst5 == "true") {
        qt_otherChargeTable.ChargeBasicAmt5 = ExclusiveBeforeGStAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = ExclusiveBeforeGStAmnt_Minus5;
      } else {
        qt_otherChargeTable.ChargeBasicAmt5 = ExclusiveAfterGstAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = 0.00;
      }
    } else {
      if (OtherChargeBeforGst5 == "true") {
        qt_otherChargeTable.ChargeBasicAmt5 = InclusiveBeforeGstAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = InclusiveBeforeGstAmnt_Minus5;
      } else {
        qt_otherChargeTable.ChargeBasicAmt5 = AfterInclusiveBeforeGstAmnt5;
        qt_otherChargeTable.ChargeGSTAmt5 = 0.00;
      }
    }

    print("hhfdh" +
        " ChargeID1 : " +
        qt_otherChargeTable.ChargeID1.toString() +
        " ChargeID2 : " +
        qt_otherChargeTable.ChargeID2.toString() +
        " ChargeID3 : " +
        qt_otherChargeTable.ChargeID3.toString() +
        " ChargeID4 : " +
        qt_otherChargeTable.ChargeID4.toString() +
        " ChargeID5 : " +
        qt_otherChargeTable.ChargeID5.toString());

    _inquiryBloc.add(QT_OtherChargeInsertRequestEvent(QT_OtherChargeTable(
      qt_otherChargeTable.Headerdiscount,
      qt_otherChargeTable.Tot_BasicAmt,
      qt_otherChargeTable.OtherChargeWithTaxamt,
      qt_otherChargeTable.Tot_GstAmt,
      qt_otherChargeTable.OtherChargeExcludeTaxamt,
      qt_otherChargeTable.Tot_NetAmount,
      qt_otherChargeTable.ChargeID1,
      qt_otherChargeTable.ChargeAmt1,
      qt_otherChargeTable.ChargeBasicAmt1,
      qt_otherChargeTable.ChargeGSTAmt1,
      qt_otherChargeTable.ChargeID2,
      qt_otherChargeTable.ChargeAmt2,
      qt_otherChargeTable.ChargeBasicAmt2,
      qt_otherChargeTable.ChargeGSTAmt2,
      qt_otherChargeTable.ChargeID3,
      qt_otherChargeTable.ChargeAmt3,
      qt_otherChargeTable.ChargeBasicAmt3,
      qt_otherChargeTable.ChargeGSTAmt3,
      qt_otherChargeTable.ChargeID4,
      qt_otherChargeTable.ChargeAmt4,
      qt_otherChargeTable.ChargeBasicAmt4,
      qt_otherChargeTable.ChargeGSTAmt4,
      qt_otherChargeTable.ChargeID5,
      qt_otherChargeTable.ChargeAmt5,
      qt_otherChargeTable.ChargeBasicAmt5,
      qt_otherChargeTable.ChargeGSTAmt5,
    )));
  }

  void _onInsertAllQT_OtherTable(QT_OtherChargeInsertResponseState state) {
    print("sucess123" + state.response.toString());
  }

  UpdateAfterHeaderDiscountToDB() {
    double tot_amnt_net = 0.00;

    double Tot_NetAmt = 0.00;

    List<QuotationTable> _TempinquiryProductList = [];

    _TempinquiryProductList.clear();
    _TempinquiryProductList.addAll(_inquiryProductList);

    _inquiryProductList.clear();

    QuotationTable tempQuotationTable;

    //await OfflineDbHelper.getInstance().deleteALLQuotationProduct();

    for (int i = 0; i < _TempinquiryProductList.length; i++) {
      print("_inquiryProductList[i].NetAmount234" +
          " Tot_NetAmt : " +
          _TempinquiryProductList[i].NetAmount.toString());

      tot_amnt_net = tot_amnt_net + _TempinquiryProductList[i].NetAmount;
    }
    print("Tot_NetAmtTot_NetAmt" + " Tot_NetAmt : " + tot_amnt_net.toString());

    double HeaderDisAmnt =
        double.parse(edt_HeaderDisc.text == null ? 0.00 : edt_HeaderDisc.text);
    double ExclusiveItemWiseHeaderDisAmnt = 0.00;
    double ExclusiveItemWiseAmount = 0.00;
    double ExclusiveNetAmntAfterHeaderDisAmnt = 0.00;
    double ExclusiveItemWiseTaxAmnt = 0.00;
    double ExclusiveTaxPluse100 = 0.00;
    double ExclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

    double ExclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;

    double InclusiveItemWiseHeaderDisAmnt = 0.00;
    double InclusiveItemWiseAmount = 0.00;
    double InclusiveNetAmntAfterHeaderDisAmnt = 0.00;
    double InclusiveItemWiseTaxAmnt = 0.00;
    double InclusiveTaxPluse100 = 0.00;
    double InclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

    double InclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;
    double ExTotalBasic = 0.00;
    double ExTotalGSTamt = 0.00;
    double ExTotalNetAmnt = 0.00;
    double InTotalBasic = 0.00;
    double InTotalGSTamt = 0.00;
    double InTotalNetAmnt = 0.00;

    for (int i = 0; i < _TempinquiryProductList.length; i++) {
      if (_TempinquiryProductList[i].TaxType == 1) {
        ExclusiveItemWiseHeaderDisAmnt =
            (_TempinquiryProductList[i].NetAmount * HeaderDisAmnt) /
                tot_amnt_net;
        ExclusiveItemWiseAmount = _TempinquiryProductList[i].Quantity *
            _TempinquiryProductList[i].NetRate;
        ExclusiveNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount - ExclusiveItemWiseHeaderDisAmnt;
        ExclusiveItemWiseTaxAmnt = (ExclusiveNetAmntAfterHeaderDisAmnt *
                _TempinquiryProductList[i].TaxRate) /
            100;
        ExclusiveFinalNetAmntAfterHeaderDisAmnt =
            ExclusiveNetAmntAfterHeaderDisAmnt;
        ExclusiveTotalNetAmntAfterHeaderDisAmnt =
            ExclusiveItemWiseAmount + ExclusiveItemWiseTaxAmnt;

        var CGSTPer = 0.00;
        var CGSTAmount = 0.00;
        var SGSTPer = 0.00;
        var SGSTAmount = 0.00;
        var IGSTPer = 0.00;
        var IGSTAmount = 0.00;
        if (_offlineLoggedInData.details[0].stateCode ==
            int.parse(_TempinquiryProductList[i].StateCode.toString())) {
          CGSTPer = _TempinquiryProductList[i].TaxRate / 2;
          SGSTPer = _TempinquiryProductList[i].TaxRate / 2;
          CGSTAmount = ExclusiveItemWiseTaxAmnt / 2;
          SGSTAmount = ExclusiveItemWiseTaxAmnt / 2;
          IGSTPer = 0.00;
          IGSTAmount = 0.00;
        } else {
          IGSTPer = _TempinquiryProductList[i].TaxRate;
          IGSTAmount = ExclusiveItemWiseTaxAmnt;
          CGSTPer = 0.00;
          SGSTPer = 0.00;
          CGSTAmount = 0.00;
          SGSTAmount = 0.00;
        }

        tempQuotationTable = QuotationTable(
            _TempinquiryProductList[i].QuotationNo,
            _TempinquiryProductList[i].ProductSpecification,
            _TempinquiryProductList[i].ProductID,
            _TempinquiryProductList[i].ProductName,
            _TempinquiryProductList[i].Unit,
            _TempinquiryProductList[i].Quantity,
            _TempinquiryProductList[i].UnitRate,
            _TempinquiryProductList[i].DiscountPercent,
            _TempinquiryProductList[i].DiscountAmt,
            _TempinquiryProductList[i].NetRate,
            ExclusiveFinalNetAmntAfterHeaderDisAmnt,
            _TempinquiryProductList[i].TaxRate,
            ExclusiveItemWiseTaxAmnt,
            ExclusiveTotalNetAmntAfterHeaderDisAmnt,
            _TempinquiryProductList[i].TaxType,
            CGSTPer,
            SGSTPer,
            IGSTPer,
            CGSTAmount,
            SGSTAmount,
            IGSTAmount,
            _TempinquiryProductList[i].StateCode,
            _TempinquiryProductList[i].pkID,
            LoginUserID,
            CompanyID.toString(),
            0,
            ExclusiveItemWiseHeaderDisAmnt);
        _inquiryProductList.add(tempQuotationTable);
        /* await OfflineDbHelper.getInstance().insertQuotationProduct(
            QuotationTable(
                _TempinquiryProductList[i].QuotationNo,
                _TempinquiryProductList[i].ProductSpecification,
                _TempinquiryProductList[i].ProductID,
                _TempinquiryProductList[i].ProductName,
                _TempinquiryProductList[i].Unit,
                _TempinquiryProductList[i].Quantity,
                _TempinquiryProductList[i].UnitRate,
                _TempinquiryProductList[i].DiscountPercent,
                _TempinquiryProductList[i].DiscountAmt,
                _TempinquiryProductList[i].NetRate,
                ExclusiveFinalNetAmntAfterHeaderDisAmnt,
                _TempinquiryProductList[i].TaxRate,
                ExclusiveItemWiseTaxAmnt,
                ExclusiveTotalNetAmntAfterHeaderDisAmnt,
                _TempinquiryProductList[i].TaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                _TempinquiryProductList[i].StateCode,
                _TempinquiryProductList[i].pkID,
                LoginUserID,
                CompanyID.toString(),
                0,
                ExclusiveItemWiseHeaderDisAmnt));*/
      } else {
        InclusiveItemWiseHeaderDisAmnt =
            (_TempinquiryProductList[i].NetAmount * HeaderDisAmnt) /
                tot_amnt_net;
        InclusiveItemWiseAmount = _TempinquiryProductList[i].Quantity *
            _TempinquiryProductList[i].NetRate;
        InclusiveNetAmntAfterHeaderDisAmnt =
            InclusiveItemWiseAmount - InclusiveItemWiseHeaderDisAmnt;
        InclusiveTaxPluse100 = 100 + _TempinquiryProductList[i].TaxRate;
        InclusiveItemWiseTaxAmnt = (InclusiveNetAmntAfterHeaderDisAmnt *
                _TempinquiryProductList[i].TaxRate) /
            InclusiveTaxPluse100;
        InclusiveFinalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt - InclusiveItemWiseTaxAmnt;
        InclusiveTotalNetAmntAfterHeaderDisAmnt =
            InclusiveNetAmntAfterHeaderDisAmnt; //+ InclusiveItemWiseTaxAmnt;

        var CGSTPer = 0.00;
        var CGSTAmount = 0.00;
        var SGSTPer = 0.00;
        var SGSTAmount = 0.00;
        var IGSTPer = 0.00;
        var IGSTAmount = 0.00;
        if (_offlineLoggedInData.details[0].stateCode ==
            int.parse(_TempinquiryProductList[i].StateCode.toString())) {
          CGSTPer = _TempinquiryProductList[i].TaxRate / 2;
          SGSTPer = _TempinquiryProductList[i].TaxRate / 2;
          CGSTAmount = InclusiveItemWiseTaxAmnt / 2;
          SGSTAmount = InclusiveItemWiseTaxAmnt / 2;
          IGSTPer = 0.00;
          IGSTAmount = 0.00;
        } else {
          IGSTPer = _TempinquiryProductList[i].TaxRate;
          IGSTAmount = InclusiveItemWiseTaxAmnt;
          CGSTPer = 0.00;
          SGSTPer = 0.00;
          CGSTAmount = 0.00;
          SGSTAmount = 0.00;
        }
        tempQuotationTable = QuotationTable(
            _TempinquiryProductList[i].QuotationNo,
            _TempinquiryProductList[i].ProductSpecification,
            _TempinquiryProductList[i].ProductID,
            _TempinquiryProductList[i].ProductName,
            _TempinquiryProductList[i].Unit,
            _TempinquiryProductList[i].Quantity,
            _TempinquiryProductList[i].UnitRate,
            _TempinquiryProductList[i].DiscountPercent,
            _TempinquiryProductList[i].DiscountAmt,
            _TempinquiryProductList[i].NetRate,
            InclusiveFinalNetAmntAfterHeaderDisAmnt,
            _TempinquiryProductList[i].TaxRate,
            InclusiveItemWiseTaxAmnt,
            InclusiveTotalNetAmntAfterHeaderDisAmnt,
            _TempinquiryProductList[i].TaxType,
            CGSTPer,
            SGSTPer,
            IGSTPer,
            CGSTAmount,
            SGSTAmount,
            IGSTAmount,
            _TempinquiryProductList[i].StateCode,
            _TempinquiryProductList[i].pkID,
            LoginUserID,
            CompanyID.toString(),
            0,
            InclusiveItemWiseHeaderDisAmnt);
        _inquiryProductList.add(tempQuotationTable);
        /*await OfflineDbHelper.getInstance().insertQuotationProduct(
            QuotationTable(
                _TempinquiryProductList[i].QuotationNo,
                _TempinquiryProductList[i].ProductSpecification,
                _TempinquiryProductList[i].ProductID,
                _TempinquiryProductList[i].ProductName,
                _TempinquiryProductList[i].Unit,
                _TempinquiryProductList[i].Quantity,
                _TempinquiryProductList[i].UnitRate,
                _TempinquiryProductList[i].DiscountPercent,
                _TempinquiryProductList[i].DiscountAmt,
                _TempinquiryProductList[i].NetRate,
                InclusiveFinalNetAmntAfterHeaderDisAmnt,
                _TempinquiryProductList[i].TaxRate,
                InclusiveItemWiseTaxAmnt,
                InclusiveTotalNetAmntAfterHeaderDisAmnt,
                _TempinquiryProductList[i].TaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                _TempinquiryProductList[i].StateCode,
                _TempinquiryProductList[i].pkID,
                LoginUserID,
                CompanyID.toString(),
                0,
                InclusiveItemWiseHeaderDisAmnt));*/
      }
    }
  }

  void UpdateCalculation() {}

  List<double> UpdateHeaderDiscountCalculation(
      List<QuotationTable> tempproductList,
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

      /* if (_otherChargeNameController4.isNotEmpty) {
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
          HeaderDiscountCalculation.funCalculateTotal(
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

  void _OnGenericIsertCallSucess(AddGenericAddditionalChargesState state) {
    print("_OnGenericIsertCallSucess" + state.response);
  }

  void _onDeleteAllGenericAddtionalAmount(
      DeleteAllGenericAddditionalChargesState state) {
    print("DeleteAllGenericAddditionalChargesState" + state.response);
  }

  void _onGetQuotationSpecificationFromQuotationAPI(
      SpecificationListResponseState state) {
    if (state.response.details.length != 0) {
      for (int i = 0; i < state.response.details.length; i++) {
        /*QuotationSpecificationTable quotationSpecificationTable =
            QuotationSpecificationTable(
          state.response.details[i].itemOrder.toString(),
          state.response.details[i].groupHead.toString(),
          state.response.details[i].materialHead.toString(),
          state.response.details[i].materialSpec.toString(),
          "",
          state.response.details[i].quotationNo.toString(),
          state.response.details[i].finishProductID.toString(),
        );
*/
        print("ssfsfd342ed" +
            state.response.details[i].finishProductID.toString());
        /* _inquiryBloc.add(InsertQuotationSpecificationTableEvent(
            quotationSpecificationTable));*/
      }
    }
  }

  void _onInsertQuotationSpecificationresponse(
      InsertQuotationSpecificationTableState state) {
    print("MSGG" + " Response Specification : " + state.response);
  }

  void _onDeleteAllSpecificationResponse(
      DeleteALLQuotationSpecificationTableState state) {
    print("DeleteSpecificationALL" + " DeleteMsdg : " + state.response);
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
                  "Basic Information",
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
                          KindAttList("Kind Attn.",
                              enable1: false,
                              title: "Kind Attn.",
                              hintTextvalue: "Tap to Select Kind Attn.",
                              icon: Icon(Icons.arrow_drop_down),
                              controllerForLeft: edt_KindAtt,
                              controllerpkID: edt_KindAttID,
                              Custom_values1: arr_ALL_Name_ID_For_KindAttList),
                          ProjectList("Project",
                              enable1: false,
                              title: "Project",
                              hintTextvalue: "Tap to Select Project",
                              icon: Icon(Icons.arrow_drop_down),
                              controllerForLeft: edt_ProjectName,
                              controllerpkID: edt_ProjectID,
                              Custom_values1: arr_ALL_Name_ID_For_ProjectList),
                          createTextLabel("Select Currency", 10.0, 0.0),
                          SizedBox(
                            height: 5,
                          ),
                          CustomDropDown1("Currency",
                              enable1: false,
                              title: "Select Currency",
                              hintTextvalue: "Tap to Select Currency",
                              icon: Icon(Icons.arrow_drop_down),
                              controllerForLeft: _controller_currency,
                              Custom_values1:
                                  arr_ALL_Name_ID_For_Sales_Order_Select_Currency),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child:
                                    createTextLabel("Exchange Rate", 10.0, 0.0),
                              ),
                              Flexible(
                                child:
                                    createTextLabel("Credit Days", 10.0, 0.0),
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
                          Row(
                            children: [
                              Flexible(
                                child:
                                    createTextLabel("Reference No.", 10.0, 0.0),
                              ),
                              Flexible(
                                child: createTextLabel(
                                    "Reference Date", 10.0, 0.0),
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
                        ],
                      )),
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
                  "Terms & Condition",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
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
                        TermsConditionList("Select Term & Condition",
                            enable1: false,
                            title: "Select Term & Condition",
                            hintTextvalue: "Tap to Select Term & Condition",
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_TermConditionHeader,
                            controllerpkID: edt_TermConditionHeaderID,
                            Custom_values1:
                                arr_ALL_Name_ID_For_TermConditionList),
                        SizedBox(
                          height: 10,
                        ),
                        createTextFormField(
                            edt_TermConditionFooter, "Terms & Condition",
                            minLines: 2,
                            maxLines: 10,
                            height: 150,
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
              _inquiryBloc.add(SOCurrencyListRequestEvent(SOCurrencyListRequest(
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

  Widget _buildReferenceDate() {
    return InkWell(
      onTap: () {
        _selectRefrenceFollowupDate(context, _controller_reference_date);
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

  Widget _buildNextFollowupDate() {
    return InkWell(
      onTap: () {
        _selectNextFollowupDate(context, edt_NextFollowupDate);
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
                      edt_NextFollowupDate.text == null ||
                              edt_NextFollowupDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_NextFollowupDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_NextFollowupDate.text == null ||
                                  edt_NextFollowupDate.text == ""
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

  void _onFollowupListTypeCallSuccess(FollowupTypeListCallResponseState state) {
    if (state.followupTypeListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_FolowupType.clear();
      for (var i = 0; i < state.followupTypeListResponse.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name =
            state.followupTypeListResponse.details[i].inquiryStatus;
        all_name_id.pkID = state.followupTypeListResponse.details[i].pkID;
        arr_ALL_Name_ID_For_FolowupType.add(all_name_id);
      }

      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_FolowupType,
          context1: context,
          controller: edt_FollowupType,
          controllerID: edt_FollowupTypepkID,
          lable: "Select Followup Type");
    }
  }

  void _onDeleteAllQTAssemblyResponse(QTAssemblyTableDeleteALLState state) {
    print("deleteAllAssembly" + state.response);
  }

  void _onAfterProductSaveSuccess(
      GetQuotationSpecificationQTnoTableState state) {
    List<QTSpecSaveRequest> arrQTSpecSaveRequest = [];
    if (state.response.length != 0) {
      for (int i = 0; i < state.response.length; i++) {
        QTSpecSaveRequest qtSpecSaveRequest = QTSpecSaveRequest();
        qtSpecSaveRequest.pkID = "0";
        qtSpecSaveRequest.QuotationNo = state.QtNo;
        qtSpecSaveRequest.FinishProductID = state.response[i].ProductID;
        qtSpecSaveRequest.GroupHead = state.response[i].Group_Description;
        qtSpecSaveRequest.MaterialHead = state.response[i].Head;
        qtSpecSaveRequest.MaterialSpec = state.response[i].Specification;
        qtSpecSaveRequest.MaterialRemarks = state.response[i].Material_Remarks;
        qtSpecSaveRequest.ItemOrder = state.response[i].OrderNo;
        qtSpecSaveRequest.LoginUserID = LoginUserID;
        qtSpecSaveRequest.CompanyId = CompanyID.toString();
        arrQTSpecSaveRequest.add(qtSpecSaveRequest);
      }

      _inquiryBloc.add(
          QuotationProductSpecificationSaveCallEvent(arrQTSpecSaveRequest));
    }
  }

  void _onQTSpecificationSaveResponse(QTSpecSaveResponseState state) {
    /* String Msg = _isForUpdate == true
        ? "Quotation Updated Successfully"
        : "Quotation Added Successfully";

    showCommonDialogWithSingleOption(context, Msg, positiveButtonTitle: "OK",
        onTapOfPositiveButton: () {
      navigateTo(context, QuotationListScreen.routeName, clearAllStack: true);
    });*/
    print("dljjdf434" + state.qTSpecSaveResponse.details[0].column2);
  }

  OldDesign() {
    return Visibility(
        visible: false,
        child: Column(
          children: [
            _buildFollowupDate(),
            SizedBox(
              width: 20,
              height: 5,
            ),
            _buildSearchView(),
            edt_InquiryNoExist.text == "true"
                ? InqNoList("Inquiry No.",
                    enable1: false,
                    title: "Inquiry No.",
                    hintTextvalue: "Tap to Select Inquiry No.",
                    icon: Icon(Icons.arrow_drop_down),
                    controllerForLeft: edt_InquiryNo,
                    controllerpkID: edt_InquiryNoID,
                    Custom_values1: arr_ALL_Name_ID_For_InqNoList)
                : Container(),
            SizedBox(
              width: 20,
              height: 5,
            ),
            BankDropDown("Bank Details *",
                enable1: false,
                title: "Bank Details *",
                hintTextvalue: "Tap to Select Bank Portal",
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: colorPrimary,
                ),
                controllerForLeft: edt_Portal_details,
                controllerpkID: edt_Portal_details_ID,
                Custom_values1: arr_ALL_Name_ID_For_BankDropDownList),
            SizedBox(
              width: 20,
              height: 15,
            ),
            basicInformation(),
            ProductAndAddtionalCharges(),
            termsAndCondition(),
            emailContent(),
            AssumptionandOthers(),
            Visibility(visible: false, child: FollowupFiled()),
          ],
        ));
  }

  ProductsDetails() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  IsProductDetails = !IsProductDetails;
                  ISBasicDetails = false;
                  IsTerms_and_ConditionDetails = false;
                  IsEmailContentDetails = false;
                  IsFolloUpDetails = false;
                  IsAssumptionOtherDetails = false;
                  IsAttachementsDetails = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Products & Additional Charges",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    IsProductDetails == true
                        ? Icon(
                            Icons.arrow_circle_up_rounded,
                            color: colorPrimary,
                          )
                        : Icon(Icons.arrow_circle_down_rounded,
                            color: colorPrimary)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: IsProductDetails,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () async {
                        if (edt_CustomerName.text != "") {
                          print("INWWWE" + edt_HeaderDisc.text.toString());
                          navigateTo(context,
                                  OldQuotationProductListScreen.routeName,
                                  arguments: OldAddQuotationProductListArgument(
                                      InquiryNo,
                                      edt_StateCode.text,
                                      edt_HeaderDisc.text))
                              .then((value) async {
                            await getInquiryProductDetails();
                          });
                        } else {
                          showCommonDialogWithSingleOption(context,
                              "Customer name is required To view Product !",
                              positiveButtonTitle: "OK");
                        }
                      }, "Products",
                          width: 600,
                          textColor: Colors.black,
                          backGroundColor: Colors.amber,
                          radius: 15.0),
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
                                    NewQuotationOtherChargeScreen.routeName,
                                    arguments:
                                        NewQuotationOtherChargesScreenArguments(
                                            int.parse(edt_StateCode.text == null
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
                                    addditionalCharges.DiscountAmt.toString() ==
                                            "null"
                                        ? "0.00"
                                        : addditionalCharges.DiscountAmt;

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
                            textColor: Colors.white,
                            backGroundColor: Colors.pink,
                            radius: 15.0),
                      ),
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
                                    NewQuotationOtherChargeScreen.routeName,
                                    arguments:
                                        NewQuotationOtherChargesScreenArguments(
                                            int.parse(edt_StateCode.text == null
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
                            textColor: Colors.white,
                            backGroundColor: Colors.cyan,
                            radius: 15.0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          IsTerms_and_ConditionDetails =
                              !IsTerms_and_ConditionDetails;
                          ISBasicDetails = false;
                          IsProductDetails = false;
                          IsEmailContentDetails = false;
                          IsFolloUpDetails = false;
                          IsAssumptionOtherDetails = false;
                          IsAttachementsDetails = false;
                        });
                      },
                      child: Card(
                          elevation: 10,
                          color: colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Quotation_Details() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  ISQuotationDetails = !ISQuotationDetails;
                  ISProductReference = false;
                  ISBasicDetails = false;
                  IsProductDetails = false;
                  IsTerms_and_ConditionDetails = false;
                  IsEmailContentDetails = false;
                  IsFolloUpDetails = false;
                  IsAssumptionOtherDetails = false;
                  IsAttachementsDetails = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Quotation Details",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    ISQuotationDetails == true
                        ? Icon(
                            Icons.arrow_circle_up_rounded,
                            color: colorPrimary,
                          )
                        : Icon(Icons.arrow_circle_down_rounded,
                            color: colorPrimary)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: ISQuotationDetails,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        _selectDate(context, edt_InquiryDate);
                      },
                      child: TextFormField(
                          controller: edt_InquiryDate,
                          enabled: false,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Quotation Date',
                              hintText: "DD-MM-YYYY"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _onTapOfSearchView();
                      },
                      child: TextFormField(
                          controller: edt_CustomerName,
                          enabled: false,
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Customer Name *',
                              hintText: "Tap to select Name"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    /*edt_InquiryNoExist.text == "true"
                        ? InkWell(
                            onTap: () {
                              // isAllEditable == true ? _onTapOfSearchView() : Container();

                              showcustomdialogWithID(
                                  values: arr_ALL_Name_ID_For_InqNoList,
                                  context1: context,
                                  controller: edt_InquiryNo,
                                  controllerID: edt_InquiryNoID,
                                  lable: "Select InquiryNo. ");
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: TextFormField(
                                  controller: edt_InquiryNo,
                                  enabled: false,
                                  decoration: const InputDecoration(
                                      suffixIcon:
                                          Icon(Icons.arrow_drop_down_sharp),
                                      border: UnderlineInputBorder(),
                                      labelText: 'Inquiry No',
                                      hintText: "Select Status"),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF000000),
                                  )),
                            ),
                          )
                        : Container(),*/

                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        showcustomdialogWithID(
                            values: arr_ALL_Name_ID_For_BankDropDownList,
                            context1: context,
                            controller: edt_Portal_details,
                            controllerID: edt_Portal_details_ID,
                            lable: "Select Bank Portal");
                      },
                      child: Container(
                        //margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_Portal_details,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Bank Details',
                                hintText: "Select Bank"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        if (edt_CustomerpkID.text != "") {
                          _inquiryBloc.add(QuotationKindAttListCallEvent(
                              QuotationKindAttListApiRequest(
                                  CompanyId: CompanyID.toString(),
                                  CustomerID: edt_CustomerpkID.text)));
                        } else {
                          showCommonDialogWithSingleOption(
                              context, "Customer Name is Required!",
                              positiveButtonTitle: "OK",
                              onTapOfPositiveButton: () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Container(
                        //margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_KindAtt,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Kind Attn.',
                                hintText: "Select Kind Attn."),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Visibility(
                      visible: _offlineLoggedInData.details[0].serialKey
                                      .toUpperCase() ==
                                  "TEST-0000-SI0F-0208" ||
                              _offlineLoggedInData.details[0].serialKey
                                      .toUpperCase() ==
                                  "KKS1-RR30-LL80-AA89" ||
                              _offlineLoggedInData.details[0].serialKey
                                      .toUpperCase() ==
                                  "GR5T-E7K3-EN2G-LAP4"
                          ? true
                          : false,
                      child: InkWell(
                        onTap: () {
                          // isAllEditable == true ? _onTapOfSearchView() : Container();

                          _inquiryBloc.add(
                              QuotationOrganazationListRequestEvent(
                                  QuotationOrganazationListRequest(
                                      CompanyID: CompanyID.toString(),
                                      LoginUserID: LoginUserID)));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: TextFormField(
                              controller: edt_OrganizationName,
                              enabled: false,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                  border: UnderlineInputBorder(),
                                  labelText: 'Organization Name',
                                  hintText: "Select Organization"),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              )),
                        ),
                      ),
                    ),

                    ///
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          controller: _controller_credit_days,
                          decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.today_sharp),
                              border: UnderlineInputBorder(),
                              labelText: 'Credit Days',
                              hintText: "Enter Days"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    /* Container(
                      //margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text("Details",
                          style: TextStyle(
                              fontSize: 12,
                              color: colorPrimary,
                              fontWeight: FontWeight
                                  .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                          ),
                    ),
                    TextFormField(
                      controller: edt_Description,
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Enter Details',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: colorPrimary),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ),*/

                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          ISProductReference = !ISProductReference;
                          ISQuotationDetails = false;
                          IsProductDetails = false;
                          ISBasicDetails = false;
                          IsTerms_and_ConditionDetails = false;
                          IsEmailContentDetails = false;
                          IsFolloUpDetails = false;
                          IsAssumptionOtherDetails = false;
                          IsAttachementsDetails = false;
                        });
                      },
                      child: Card(
                          elevation: 10,
                          color: colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Terms_Condition_Details() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  IsTerms_and_ConditionDetails = !IsTerms_and_ConditionDetails;
                  ISBasicDetails = false;
                  IsProductDetails = false;
                  IsEmailContentDetails = false;
                  IsFolloUpDetails = false;
                  IsAssumptionOtherDetails = false;
                  IsAttachementsDetails = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Terms & Condition",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    IsTerms_and_ConditionDetails == true
                        ? Icon(
                            Icons.arrow_circle_up_rounded,
                            color: colorPrimary,
                          )
                        : Icon(Icons.arrow_circle_down_rounded,
                            color: colorPrimary)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: IsTerms_and_ConditionDetails,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        _inquiryBloc.add(QuotationTermsConditionCallEvent(
                            QuotationTermsConditionRequest(
                                CompanyId: CompanyID.toString(),
                                LoginUserID: LoginUserID)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_TermConditionHeader,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Terms & Condition',
                                hintText: "Select Terms & Condition"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    TextFormField(
                      controller: edt_TermConditionFooter,
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Enter Terms & Condition',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: colorPrimary),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          IsEmailContentDetails = !IsEmailContentDetails;
                          ISBasicDetails = false;
                          IsTerms_and_ConditionDetails = false;
                          IsProductDetails = false;
                          IsFolloUpDetails = false;
                          IsAssumptionOtherDetails = false;
                          IsAttachementsDetails = false;
                        });
                      },
                      child: Card(
                          elevation: 10,
                          color: colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Email_Content_Details() {
    return Visibility(
      visible: _offlineCompanyData.details[0].pkId == 4132 ? true : false,
      child: Card(
          elevation: 20,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    IsEmailContentDetails = !IsEmailContentDetails;
                    ISBasicDetails = false;
                    IsProductDetails = false;
                    IsTerms_and_ConditionDetails = false;
                    IsFolloUpDetails = false;
                    IsAssumptionOtherDetails = false;
                    IsAttachementsDetails = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Text("Email Content",
                          style: TextStyle(
                              fontSize: 15,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      IsEmailContentDetails == true
                          ? Icon(
                              Icons.arrow_circle_up_rounded,
                              color: colorPrimary,
                            )
                          : Icon(Icons.arrow_circle_down_rounded,
                              color: colorPrimary)
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: IsEmailContentDetails,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: InkWell(
                              onTap: () {
                                // isAllEditable == true ? _onTapOfSearchView() : Container();

                                _inquiryBloc.add(
                                    QuotationEmailContentRequestEvent(
                                        QuotationEmailContentRequest(
                                            CompanyId: CompanyID.toString(),
                                            LoginUserID: LoginUserID)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: TextFormField(
                                    controller:
                                        _controller_select_email_subject,
                                    enabled: false,
                                    decoration: const InputDecoration(
                                        suffixIcon:
                                            Icon(Icons.arrow_drop_down_sharp),
                                        border: UnderlineInputBorder(),
                                        labelText: "Subject",
                                        hintText: "Select Subject"),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF000000),
                                    )),
                              ),
                            ),
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

                                  // navigateTo(context, QuotationAddEditScreen.routeName);
                                  showcustomdialogSendEmail(
                                      context1: context, Email: "sdfj");
                                },
                                child: const Icon(Icons.add),
                                backgroundColor: Colors.pinkAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: _controller_select_email_subject,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                counterText: "",
                                suffixIcon: Icon(Icons.web),
                                border: UnderlineInputBorder(),
                                labelText: 'Subject',
                                hintText: "Enter Subject"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                      TextFormField(
                        controller: _contrller_Email_Discription,
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Email Introduction',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(color: colorPrimary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            IsFolloUpDetails = !IsFolloUpDetails;
                            ISBasicDetails = false;
                            IsTerms_and_ConditionDetails = false;
                            IsProductDetails = false;
                            IsAssumptionOtherDetails = false;
                            IsEmailContentDetails = false;
                            IsAttachementsDetails = false;
                          });
                        },
                        child: Card(
                            elevation: 10,
                            color: colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Center(
                                child: Text("Next",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Assuption_other_details() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  IsAssumptionOtherDetails = !IsAssumptionOtherDetails;
                  ISBasicDetails = false;
                  IsProductDetails = false;
                  IsEmailContentDetails = false;
                  IsFolloUpDetails = false;
                  IsTerms_and_ConditionDetails = false;
                  IsAttachementsDetails = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Assumption & Others Details",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    IsAssumptionOtherDetails == true
                        ? Icon(
                            Icons.arrow_circle_up_rounded,
                            color: colorPrimary,
                          )
                        : Icon(Icons.arrow_circle_down_rounded,
                            color: colorPrimary)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: IsAssumptionOtherDetails,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _controller_Ref_Inquiry,
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Enter Reference Inquiry',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: colorPrimary),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _contrller_other_Remarks,
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          hintText: 'Other Remarks',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: colorPrimary),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          IsEmailContentDetails = false;
                          ISBasicDetails = false;
                          IsTerms_and_ConditionDetails = false;
                          IsProductDetails = false;
                          IsFolloUpDetails = false;
                          IsAssumptionOtherDetails = false;
                          IsAttachementsDetails = false;
                        });
                      },
                      child: Card(
                          elevation: 10,
                          color: colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Followup_Details() {
    return Visibility(
      visible: _offlineCompanyData.details[0].pkId == 4132 ? true : false,
      child: Card(
          elevation: 20,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    IsFolloUpDetails = !IsFolloUpDetails;
                    IsEmailContentDetails = false;
                    ISBasicDetails = false;
                    IsTerms_and_ConditionDetails = false;
                    IsProductDetails = false;
                    IsAssumptionOtherDetails = false;
                    IsAttachementsDetails = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Text("Followup Details ",
                          style: TextStyle(
                              fontSize: 15,
                              color: colorPrimary,
                              fontWeight: FontWeight.bold)),
                      Spacer(),
                      IsFolloUpDetails == true
                          ? Icon(
                              Icons.arrow_circle_up_rounded,
                              color: colorPrimary,
                            )
                          : Icon(Icons.arrow_circle_down_rounded,
                              color: colorPrimary)
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: IsFolloUpDetails,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          _selectNextFollowupDate(
                              context, edt_NextFollowupDate);
                        },
                        child: TextFormField(
                            controller: edt_NextFollowupDate,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today_outlined),
                                border: UnderlineInputBorder(),
                                labelText: 'Next Followup Date *',
                                hintText: "DD-MM-YYYY"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          // isAllEditable == true ? _onTapOfSearchView() : Container();

                          _inquiryBloc.add(FollowupTypeListByNameCallEvent(
                              FollowupTypeListRequest(
                                  CompanyId: CompanyID.toString(),
                                  pkID: "",
                                  StatusCategory: "FollowUp",
                                  LoginUserID: LoginUserID,
                                  SearchKey: "")));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: TextFormField(
                              controller: edt_FollowupType,
                              enabled: false,
                              decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                  border: UnderlineInputBorder(),
                                  labelText: 'Followup Type',
                                  hintText: "Select Type"),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF000000),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text("Followup Notes",
                            style: TextStyle(
                                fontSize: 12,
                                color: colorPrimary,
                                fontWeight: FontWeight
                                    .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                            ),
                      ),
                      TextFormField(
                        controller: edt_FollowupNotes,
                        minLines: 2,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Enter Notes',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(color: colorPrimary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            IsAssumptionOtherDetails =
                                !IsAssumptionOtherDetails;
                            IsEmailContentDetails = false;
                            ISBasicDetails = false;
                            IsTerms_and_ConditionDetails = false;
                            IsProductDetails = false;
                            IsFolloUpDetails = false;
                            IsAttachementsDetails = false;
                          });
                        },
                        child: Card(
                            elevation: 10,
                            color: colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Center(
                                child: Text("Next",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  ProductReference() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  ISProductReference = !ISProductReference;
                  ISQuotationDetails = false;
                  ISBasicDetails = false;
                  IsProductDetails = false;
                  IsTerms_and_ConditionDetails = false;
                  IsEmailContentDetails = false;
                  IsFolloUpDetails = false;
                  IsAssumptionOtherDetails = false;
                  IsAttachementsDetails = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Product Refrence",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    ISProductReference == true
                        ? Icon(
                            Icons.arrow_circle_up_rounded,
                            color: colorPrimary,
                          )
                        : Icon(Icons.arrow_circle_down_rounded,
                            color: colorPrimary)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: ISProductReference,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        if (_isForUpdate == false) {
                          if (edt_CustomerName.text != "") {
                            showcustomdialogWithID(
                                values: arr_ALL_Name_ID_For_InqNoList,
                                context1: context,
                                controller: edt_InquiryNo,
                                controllerID: edt_InquiryNoID,
                                lable: "Select InquiryNo. ");
                          } else {
                            showCommonDialogWithSingleOption(
                                context, "Customer Name is required !",
                                positiveButtonTitle: "OK",
                                onTapOfPositiveButton: () {
                              Navigator.pop(context);
                            });
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_InquiryNo,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Inquiry No',
                                hintText: "Select Status"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          ISBasicDetails = !ISBasicDetails;

                          ISProductReference = false;
                          ISQuotationDetails = false;
                          IsProductDetails = false;
                          IsTerms_and_ConditionDetails = false;
                          IsEmailContentDetails = false;
                          IsFolloUpDetails = false;
                          IsAssumptionOtherDetails = false;
                          IsAttachementsDetails = false;
                        });
                      },
                      child: Card(
                          elevation: 10,
                          color: colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  CurrencyDetails() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  IsCurrencyDetails = !IsCurrencyDetails;
                  ISQuotationDetails = false;
                  ISProductReference = false;
                  ISBasicDetails = false;
                  IsProductDetails = false;
                  IsTerms_and_ConditionDetails = false;
                  IsEmailContentDetails = false;
                  IsFolloUpDetails = false;
                  IsAssumptionOtherDetails = false;
                  IsAttachementsDetails = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Currency Details",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    IsCurrencyDetails == true
                        ? Icon(
                            Icons.arrow_circle_up_rounded,
                            color: colorPrimary,
                          )
                        : Icon(Icons.arrow_circle_down_rounded,
                            color: colorPrimary)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: IsCurrencyDetails,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        _inquiryBloc.add(SOCurrencyListRequestEvent(
                            SOCurrencyListRequest(
                                LoginUserID: LoginUserID,
                                CurrencyName: "",
                                CompanyID: CompanyID.toString())));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: _controller_currency,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Currency',
                                hintText: "Select Currency"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),

                    ///
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: _controller_exchange_rate,
                                decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.currency_exchange),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Exchange Rate',
                                    hintText: "Enter Rate"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),
                        /* SizedBox(
                          width: 10,
                        ),*/
                        /*Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: _controller_credit_days,
                                decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.today_sharp),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Credit Days',
                                    hintText: "Enter Days"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),*/
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          IsCurrencyDetails = false;
                          ISProductReference = false;
                          ISQuotationDetails = false;
                          IsProductDetails = false;
                          ISBasicDetails = !ISBasicDetails;
                          IsTerms_and_ConditionDetails = false;
                          IsEmailContentDetails = false;
                          IsFolloUpDetails = false;
                          IsAssumptionOtherDetails = false;
                          IsAttachementsDetails = false;
                        });
                      },
                      child: Card(
                          elevation: 10,
                          color: colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  BasicDetails() {
    return Card(
        elevation: 20,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  ISBasicDetails = !ISBasicDetails;
                  IsProductDetails = false;
                  IsTerms_and_ConditionDetails = false;
                  IsEmailContentDetails = false;
                  IsFolloUpDetails = false;
                  IsAssumptionOtherDetails = false;
                  IsAttachementsDetails = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Text("Basic Details",
                        style: TextStyle(
                            fontSize: 15,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                    Spacer(),
                    ISBasicDetails == true
                        ? Icon(
                            Icons.arrow_circle_up_rounded,
                            color: colorPrimary,
                          )
                        : Icon(Icons.arrow_circle_down_rounded,
                            color: colorPrimary)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: ISBasicDetails,
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // isAllEditable == true ? _onTapOfSearchView() : Container();

                        _inquiryBloc.add(QuotationProjectListCallEvent(
                            QuotationProjectListRequest(
                                CompanyId: CompanyID.toString(),
                                LoginUserID: LoginUserID)));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                            controller: edt_ProjectName,
                            enabled: false,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                                border: UnderlineInputBorder(),
                                labelText: 'Project',
                                hintText: "Select Project"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: _controller_reference_no,
                                decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.mobile_friendly),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Refrence No.',
                                    hintText: "Enter Number"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _selectRefrenceFollowupDate(
                                  context, _controller_reference_date);
                            },
                            child: TextFormField(
                                controller: _controller_reference_date,
                                enabled: false,
                                decoration: const InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.calendar_today_outlined),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Refrence Date',
                                    hintText: "DD-MM-YYYY"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          IsProductDetails = !IsProductDetails;
                          ISBasicDetails = false;
                          IsTerms_and_ConditionDetails = false;
                          IsEmailContentDetails = false;
                          IsFolloUpDetails = false;
                          IsAssumptionOtherDetails = false;
                          IsAttachementsDetails = false;
                        });
                      },
                      child: Card(
                          elevation: 10,
                          color: colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Center(
                              child: Text("Next",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void _onQuotationOrganizationListResponse(
      QuotationOrganizationListResponseState state) {
    //state.quotationOrganizationListResponse.details
    if (state.quotationOrganizationListResponse.details.length != 0) {
      arr_ALL_Name_ID_For_OrganizationList.clear();
      for (var i = 0;
          i < state.quotationOrganizationListResponse.details.length;
          i++) {
        // print("InquiryStatus : " + state.quotationOrganizationListResponse.details[i].contactPerson1);
        if (state.quotationOrganizationListResponse.details[i].activeFlag ==
            true) {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name =
              state.quotationOrganizationListResponse.details[i].orgName;
          all_name_id.Name1 =
              state.quotationOrganizationListResponse.details[i].orgCode;
          arr_ALL_Name_ID_For_OrganizationList.add(all_name_id);
        }
      }
      showcustomdialogWithTWOName(
          values: arr_ALL_Name_ID_For_OrganizationList,
          context1: context,
          controller: edt_OrganizationName,
          controller1: edt_OrganizationCode,
          lable: "Select Organization");
    }
  }
}
