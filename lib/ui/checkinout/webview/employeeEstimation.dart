import 'package:flutter/material.dart';


class EmployeeEstimation extends StatefulWidget {
  @override
  _EmployeeEstimationState createState() => _EmployeeEstimationState();
}class _EmployeeEstimationState extends State<EmployeeEstimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Under Maintenance'),
      ),
       body:Center(child: Image.asset('assets/img/underconstruction.png'))
      
    );
  }  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Under Maintenance'),
            content: Text('Masih Dalam Pengembangan'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('CANCEL')),
            ],
          );
        });
  }
}