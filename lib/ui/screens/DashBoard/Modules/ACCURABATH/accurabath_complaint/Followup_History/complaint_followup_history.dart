import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/Accurabath_complaint/accurabath_complaint_followup_history_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/Accurabath_complaint/accurabath_complaint_followup_list_response.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class AccuraBathComplaintFollowupHistoryScreenArguments {
  String InqNo;
  AccuraBathComplaintFollowupHistoryScreenArguments(this.InqNo);
}

class AccuraBathComplaintFollowupHistoryScreen extends BaseStatefulWidget {
  static const routeName = '/AccuraBathComplaintFollowupHistoryScreen';
  final AccuraBathComplaintFollowupHistoryScreenArguments arguments;

  AccuraBathComplaintFollowupHistoryScreen(this.arguments);
  @override
  _AccuraBathComplaintFollowupHistoryScreenState createState() =>
      _AccuraBathComplaintFollowupHistoryScreenState();
}

class _AccuraBathComplaintFollowupHistoryScreenState
    extends BaseState<AccuraBathComplaintFollowupHistoryScreen>
    with BasicScreen, WidgetsBindingObserver {
  FollowupBloc _FollowupBloc;
  AccuraBathComplaintFollowupHistoryListResponse _searchCustomerListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  String InqNo;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    screenStatusBarColor = colorPrimary;
    _FollowupBloc = FollowupBloc(baseBloc);
    InqNo = widget.arguments.InqNo;
    _FollowupBloc
      ..add(AccuraBathComplaintFollowupHistoryListRequestEvent(
          AccuraBathComplaintFollowupHistoryListRequest(
        pkID: InqNo,
        SearchKey: "",
        CompanyID: CompanyID.toString(),
        LoginUserID: LoginUserID,
        PageNo: "1",
        PageSize: "100000",
      )));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc,
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          if (state is AccuraBathComplaintFollowupHistoryListResponseState) {
            _onSearchInquiryListCallSuccess(
                state.complaintFollowupHistoryListResponse);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState
              is AccuraBathComplaintFollowupHistoryListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, FollowupStates state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        NewGradientAppBar(
          title: Text('Followup History'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              top: 25,
            ),
            child: Column(
              children: [Expanded(child: _buildInquiryList())],
            ),
          ),
        ),
      ],
    );
  }

  ///builds header and title view

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_searchCustomerListResponse != null) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildSearchInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _searchCustomerListResponse.details.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED, height: 200, width: 200),
      );
    }
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    AccuraBathComplaintFollowupHistoryListResponseDetails model =
        _searchCustomerListResponse.details[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Color(0xffffff8d),
                Color(0xffffff8d),
                Color(0xffb9f6ca),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            _buildTitleWithValueView(
                "Notes",
                model.meetingNotes == "" || model.meetingNotes == null
                    ? '-'
                    : model.meetingNotes),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: _buildTitleWithValueView(
                    "Followup Date",
                    model.followupDate.getFormattedDate(
                            fromFormat: "yyyy-MM-ddTHH:mm:ss",
                            toFormat: "dd-MM-yyyy") ??
                        "-"),
              ),
              Expanded(
                child: _buildTitleWithValueView(
                    "Next Followup Date",
                    model.nextFollowupDate.getFormattedDate(
                            fromFormat: "yyyy-MM-ddTHH:mm:ss",
                            toFormat: "dd-MM-yyyy") ??
                        "-"),
              ),
            ]),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            Row(children: [
              Expanded(
                child: _buildTitleWithValueView(
                    "Followup Type", model.followupSource ?? "-"),
              ),
            ]),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
          ]),
        ),
      ),
    );
  }

  ///calls search list api

  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        Text(value,
            style: TextStyle(
                fontSize: _fontSize_Title,
                color:
                    colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            )
      ],
    );
  }

  void _onSearchInquiryListCallSuccess(
      AccuraBathComplaintFollowupHistoryListResponse
          followupHistoryListResponse) {
    _searchCustomerListResponse = followupHistoryListResponse;
  }
}
