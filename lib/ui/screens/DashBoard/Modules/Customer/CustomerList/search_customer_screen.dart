import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/customer/customer_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/customer/customer_label_value_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/customer/customer_label_value_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class SearchCustomerScreen extends BaseStatefulWidget {
  static const routeName = '/SearchCustomerScreen';

  @override
  _SearchCustomerScreenState createState() => _SearchCustomerScreenState();
}

class _SearchCustomerScreenState extends BaseState<SearchCustomerScreen>
    with BasicScreen, WidgetsBindingObserver {
  CustomerBloc _CustomerBloc;
  CustomerLabelvalueRsponse _searchCustomerListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    screenStatusBarColor = colorPrimary;
    _CustomerBloc = CustomerBloc(baseBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc,
      child: BlocConsumer<CustomerBloc, CustomerStates>(
        builder: (BuildContext context, CustomerStates state) {
          if (state is CustomerListByNameCallResponseState) {
            _onSearchInquiryListCallSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CustomerListByNameCallResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CustomerStates state) {},
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
          title: Text('Search Customer'),
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
              children: [
                _buildSearchView(),
                Expanded(child: _buildInquiryList())
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 20),
          child: Text("Min. 3 chars to search Customer",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight.bold)),
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
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      _onSearchChanged(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Tap to enter customer name",
                      border: InputBorder.none,
                    ),
                    style: baseTheme.textTheme.subtitle2
                        .copyWith(color: colorBlack),
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
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_searchCustomerListResponse == null) {
      return Container();
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildSearchInquiryListItem(index);
      },
      shrinkWrap: true,
      itemCount: _searchCustomerListResponse.details.length,
    );
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    SearchDetails model = _searchCustomerListResponse.details[index];

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(model);
        },
        child: Card(
          elevation: 5,
          color: colorBackGroundGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    /* Text(
                      model.label + "\n" + model.ContactNo1,
                      style: baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                    ),*/
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.assignment_ind,
                            color: Color(0xff108dcf),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        model.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      /* Text(
                        model.label + "\n" + model.ContactNo1,
                        style: baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                      ),*/
                      Container(
                        margin: EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.mobile_friendly,
                              color: Color(0xff108dcf),
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          model.ContactNo1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          margin: EdgeInsets.only(top: 10),
        ),
      ),
    );
  }

  ///calls search list api
  void _onSearchChanged(String value) {
    if (value.trim().length > 2) {
      _CustomerBloc.add(SearchCustomerListByNameCallEvent(
          CustomerLabelValueRequest(
              word: value,
              CompanyId: CompanyID.toString(),
              LoginUserID: LoginUserID)));
    }
  }

  void _onSearchInquiryListCallSuccess(
      CustomerListByNameCallResponseState state) {
    _searchCustomerListResponse = state.response;
  }
}
