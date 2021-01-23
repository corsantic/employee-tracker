import 'package:employeetracker/authenticate/authenticate-bloc.dart';
import 'package:employeetracker/authenticate/authenticate-event.dart';
import 'package:employeetracker/model/enum/role.enum.dart';

import 'package:employeetracker/components/vacation-request-dialog.dart';
import 'package:employeetracker/model/enum/vacation-status.enum.dart';
import 'package:employeetracker/model/user.dart';
import 'package:employeetracker/model/vacation-request.dart';
import 'package:employeetracker/services/employee-service.dart';
import 'package:employeetracker/util/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EmployeeService employeeService = EmployeeService();
  String dateFormat = "yyyy-MM-dd";

  List<VacationRequest> vacationRequestList = List();
  var selectedUser = User();

  @override
  void initState() {
    super.initState();
    setDate();
  }

  Future setDate() async {
    var userList = await employeeService.getJson();
    var vacationReqList = await employeeService.getVacationRequests();
    setState(() {
      selectedUser = userList[1];
      vacationRequestList = vacationReqList;
    });

    print(selectedUser);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                logout(BlocProvider.of<AuthenticationBloc>(context));
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Available Vacation(Day): ${selectedUser?.vacationDateCount}"),
                ),
              ],
            ),
          ),
          vacationRequestList != null && vacationRequestList.isNotEmpty
              ? Flexible(
                  child: ListView.builder(
                    itemCount: vacationRequestList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var vacationRequest = vacationRequestList[index];
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        RaisedButton(
                                          onPressed: () {},
                                          color: Colors.green,
                                          child: Text(
                                            "Approve",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        RaisedButton(
                                          onPressed: () {},
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
                  ),
                )
              : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await makeVacationRequest(),
        tooltip: 'Hey',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  bool isEditable(VacationRequest vacationRequest) {
    return vacationRequest.status == VacationStatus.InProgress &&
        RoleEnum.values.singleWhere((r) => r.index == selectedUser.roleId) ==
            RoleEnum.Employer;
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
    return authenticationBloc.dispatch(LoggedOut());
  }
}
