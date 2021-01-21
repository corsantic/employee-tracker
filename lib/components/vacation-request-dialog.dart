import 'package:employeetracker/model/enum/vacation-status.enum.dart';
import 'package:employeetracker/model/vacation-request.dart';
import 'package:employeetracker/util/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VacationRequestDialog extends StatefulWidget {
  final userId;
  VacationRequestDialog({Key key, @required this.userId}) : super(key: key);

  @override
  _VacationRequestDialogState createState() => _VacationRequestDialogState();
}

class _VacationRequestDialogState extends State<VacationRequestDialog> {
  final descriptionController = TextEditingController();
  String dateFormat = "yyyy-MM-dd";
  var selectedDateTimeRange = DateTimeRange(
      start: DateTime.now().add(Duration(days: 1)),
      end: DateTime.now().add(Duration(days: 2)));
  var vacationRequest = VacationRequest();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    vacationRequest.userId = widget.userId;
    setDateRange();
  }

  @override
  Widget build(BuildContext context) {
    selectDateRange(BuildContext context) async {
      showDateRangePicker(
              context: context,
              initialDateRange: selectedDateTimeRange,
              firstDate: DateTime.now().add(Duration(days: 1)),
              lastDate: DateTime(2100))
          .then((picked) {
        if (picked == null) return;
        setState(() {
          selectedDateTimeRange = picked;
          setDateRange();
          print("$selectedDateTimeRange");
        });
      });
    }

    return Center(
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(
                child: Text("Date Picker"),
                onPressed: () async {
                  await selectDateRange(context);
                },
              ),
              Text(
                  "${Utilities.formatDateTime(dateFormat, selectedDateTimeRange.start)} / ${Utilities.formatDateTime(dateFormat, selectedDateTimeRange.end)}"),
              Text("${getSelectedVacationDateInDays()} day vacation selected"),
              TextField(
                controller: descriptionController,
                // decoration: InputDecoration(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    child: Text('Add'),
                    onPressed: () {
                      vacationRequest.status = VacationStatus.InProgress;
                      vacationRequest.description = descriptionController.text;
                      Navigator.of(context).pop(vacationRequest);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setDateRange() {
    vacationRequest.startDate = selectedDateTimeRange.start;
    vacationRequest.endDate = selectedDateTimeRange.end;
  }

  int getSelectedVacationDateInDays() =>
      selectedDateTimeRange.end.difference(selectedDateTimeRange.start).inDays +
      1; //NOTE: add 1 because we are counting already selected date to
}
