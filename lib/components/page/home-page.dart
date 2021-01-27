import 'package:employeetracker/authenticate/authenticate-bloc.dart';
import 'package:employeetracker/authenticate/authenticate-event.dart';
import 'package:employeetracker/components/shared/loading.dart';

import 'package:employeetracker/components/vacation-request-dialog.dart';
import 'package:employeetracker/model/enum/vacation-status.enum.dart';
import 'package:employeetracker/model/user.dart';
import 'package:employeetracker/model/vacation-request.dart';
import 'package:employeetracker/services/employee-service.dart';
import 'package:employeetracker/services/user-service.dart';
import 'package:employeetracker/util/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EmployeeService employeeService = EmployeeService();
  String dateFormat = "yyyy-MM-dd";

  List<VacationRequest> vacationRequestList = List();
  var selectedUser = User();

  var future;
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    future = getVacationList();
    setDate();
  }

  Future setDate() async {
    UserService.user.then((u) {
      setState(() {
        selectedUser = u;
        isLoading = false;
      });
    });

    print(selectedUser);
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (isLoading) return LoadingIndicator();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: selectedUser != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${selectedUser?.email}"),
                          Text("${selectedUser?.fullName}"),
                          if (selectedUser?.isEmployee)
                            Text(
                                "Vacation Day: ${selectedUser?.vacationDateCount}")
                          else
                            Container(),
                        ],
                      )
                    : Container(),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  logout(BlocProvider.of<AuthenticationBloc>(context));
                },
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedUser.isEmployee
                ? Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Available Vacation(Day): ${selectedUser?.vacationDateCount}"),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Flexible(
              child: FutureBuilder(
                  future: future,
                  builder: (context, vacationSnap) {
                    if (vacationSnap.connectionState == ConnectionState.none &&
                        vacationSnap.hasData == null) {
                      //print('project snapshot data is: ${projectSnap.data}');
                      return Container();
                    } else if (vacationSnap.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: vacationSnap.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var vacationRequest = vacationSnap.data[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Start-End Date: ${Utilities.formatDateTime(dateFormat, vacationRequest.startDate)} / ${Utilities.formatDateTime(dateFormat, vacationRequest.endDate)}"),
                                Text(
                                    "${getSelectedVacationDateInDays(vacationRequest)} day vacation selected"),
                                Text(
                                    "Description: ${vacationRequest.description}"),
                                getStatusIcon(vacationRequest.status),
                                isEditable(vacationRequest)
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          RaisedButton(
                                            onPressed: () async {
                                              changeVacationRequest(
                                                      vacationRequest.id,
                                                      VacationStatus.Approved)
                                                  .then((result) {
                                                setState(() {
                                                  vacationSnap.data[index] =
                                                      result;
                                                });
                                              });
                                            },
                                            color: Colors.green,
                                            child: Text(
                                              "Approve",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          RaisedButton(
                                            onPressed: () async {
                                              changeVacationRequest(
                                                      vacationRequest.id,
                                                      VacationStatus.Declined)
                                                  .then((result) {
                                                setState(() {
                                                  vacationSnap.data[index] =
                                                      result;
                                                });
                                              });
                                            },
                                            color: Colors.red,
                                            child: Text("Decline"),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async => await makeVacationRequest(),
          tooltip: 'Hey',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  bool isEditable(VacationRequest vacationRequest) {
    if (selectedUser.isEmployee) return false;

    return vacationRequest.status == VacationStatus.InProgress;
  }

  getStatusIcon(VacationStatus status) {
    switch (status) {
      case VacationStatus.Approved:
        return Icon(
          Icons.check,
          color: Colors.green,
        );
        break;
      case VacationStatus.InProgress:
        return Icon(
          Icons.schedule,
          color: Colors.orange,
        );
        break;
      case VacationStatus.Declined:
        return Icon(Icons.clear, color: Colors.red);
        break;
      default:
    }
  }

  makeVacationRequest() async {
    VacationRequest vacationRequest = await showDialog(
        context: context,
        builder: (_) => VacationRequestDialog(
              userId: selectedUser.id,
            ));

    setState(() {
      vacationRequestList.add(vacationRequest);
    });
  }

  int getSelectedVacationDateInDays(VacationRequest vacationRequest) =>
      vacationRequest.endDate.difference(vacationRequest.startDate).inDays +
      1; //NOTE: add 1 because we are counting already selected date to

  void logout(AuthenticationBloc authenticationBloc) async {
    return authenticationBloc.add(LoggedOut());
  }

  getVacationList() async {
    var result = await employeeService.getVacationRequests();
    return result;
  }

  Future<VacationRequest> changeVacationRequest(
      vacationRequestId, vacationRequestStatus) async {
    var vacationRequestParameter = VacationRequestParameter(
        vacationRequestId: vacationRequestId,
        vacationStatus: vacationRequestStatus);
    var result = await employeeService.changeStatus(vacationRequestParameter);
    return result;
  }

  Future _refresh() async {
    print("refresh");
    setState(() {
      future = getVacationList();
    });
  }
}
