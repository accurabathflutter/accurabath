import 'package:flutter/material.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/ToDo/to_do_add_edit_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/home_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';

class ToDoPaginationListScreen extends BaseStatefulWidget {
  static const routeName = '/ToDo';

  @override
  _ToDoPaginationListScreenState createState() =>
      _ToDoPaginationListScreenState();
}

/*class JosKeys {
  static final cardA = GlobalKey<ExpansionTileCardState>();
  static final refreshKey  = GlobalKey<RefreshIndicatorState>();
}*/
class _ToDoPaginationListScreenState extends BaseState<ToDoPaginationListScreen>
    with BasicScreen, WidgetsBindingObserver, SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  ///listener to multiple states of bloc to handles api responses
  ///use only BlocListener if only need to listen to events
/*
  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerPaginationListScreenBloc, CustomerPaginationListScreenStates>(
      bloc: _authenticationBloc,
      listener: (BuildContext context, CustomerPaginationListScreenStates state) {
        if (state is CustomerPaginationListScreenResponseState) {
          _onCustomerPaginationListScreenCallSuccess(state.response);
        }
      },
      child: super.build(context),
    );
  }
*/

  ///listener and builder to multiple states of bloc to handles api responses
  ///use BlocProvider if need to listen and build
/*  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerPaginationListScreenBloc
        ..add(CustomerPaginationListCallEvent(
            CustomerPaginationRequest(
                companyId: 8033, loginUserID: "admin", CustomerID: ""),
            _page + 1)),
      child: BlocConsumer<CustomerPaginationScreenBloc,
          CustomerPaginationScreenStates>(
        builder: (BuildContext context, CustomerPaginationScreenStates state) {
          //handle states
          if (state is CustomerPaginationListCallEventResponseState) {
            //_onGetListCallSuccess(state.response);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          //return true for state for which builder method should be called
          if (currentState is CustomerPaginationListCallEventResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, CustomerPaginationScreenStates state) {
          //handle states
          if (state is CustomerLabelvalueEventResponseState) {
           // _onGetListLabelValueCallSuccess(state.customerlabelvalueresponse);
          }
          if (state is CustomerSearchByIdEventResponseState) {
            //_onGetSearchCustomerByIDCallSuccess(
              //  state.arr_customersearchbyidresponse);
          }
        },
        listenWhen: (oldState, currentState) {
          //return true for state for which listener method should be called
          if (currentState is CustomerLabelvalueEventResponseState) {
            return true;
          }
          if (currentState is CustomerSearchByIdEventResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }*/

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF27442),
          title: Text("ToDo List"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.water_damage_sharp),
                onPressed: () {
                  //_onTapOfLogOut();
                  /* navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);*/
                })
          ],
        ),
        body: Container(
          child: Column(
            children: [],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            navigateTo(context, ToDoAddEditScreen.routeName);
          },
          child: const Icon(Icons.add),
          backgroundColor: Color(0xFFF27442),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }
}
