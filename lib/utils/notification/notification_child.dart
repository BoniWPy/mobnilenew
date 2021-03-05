import 'package:flutter/material.dart';
import 'package:new_payrightsystem/utils/notification/animated_fab.dart';
import 'package:new_payrightsystem/utils/notification/diagonal_clipper.dart';
import 'package:new_payrightsystem/utils/notification/list_model.dart';
import 'package:new_payrightsystem/utils/notification/task.dart';
import 'package:new_payrightsystem/utils/notification/task_child.dart';
import 'package:new_payrightsystem/utils/notification/task_row.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

//for notifiaction
import 'package:new_payrightsystem/data/model/NotifikasiModel.dart';
import 'package:new_payrightsystem/data/DatabaseHelper.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class NotificationChild extends StatefulWidget {
  String urlDetail;
  NotificationChild(this.urlDetail);
  @override
  NotificationChildState createState() => new NotificationChildState();
}

class NotificationChildState extends State<NotificationChild> {
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();
  final double _imageHeight = 256.0;
  ListModel listModel;
  bool showOnlyComment = false;

  var thisdate = DateTime.now();
  var dateFormat = DateFormat();
  List<Task> tasks = [];

  var userinfo, company_name, name;
  var databaseHelper = new DatabaseHelper();

  @override
  void initState() {
    super.initState();

    // postRequest();
  }

  Future<String> getNotification() async {
    // await http.post(widget.urlDetail,
    await http
        .get("https://api.payright.dev/v1/auth/cekNotif")
        .then((response) async {
      print(response.body);
      var extractdata = JSON.jsonDecode(response.body);
      List<dynamic> dataChild = extractdata;
      for (var i = 0; i < dataChild.length; i++) {
        tasks.add(new Task(
          title: dataChild[i]['title'],
          message: dataChild[i]['body'],
          time: dataChild[i]['time'],
          color: Colors.orange,
          comment: false,
          href: dataChild[i]['detail_url'],
        ));
      }
    });

    // tasks.add(new Task(
    //   title: "judulChild",
    //   message: "body Child",
    //   time: "20 Februari 2021, 12:02:39",
    //   color: Colors.orange,
    //   comment: false,
    //   href:
    //       "https:\/\/go.payrightsystem.com\/employeeproject?project_detail=4CJT8-2kF1tJm6VE%3E",
    // ));
    // for (var i = 0; i < getNotification.length; i++) {
    //   tasks.add(
    //     new Task(
    //       title: getNotification[i]['title'].toString(),
    //       message: getNotification[i]['body'].toString(),
    //       time: getNotification[i]['tanggal'].toString() +
    //           " " +
    //           getNotification[i]['jam'].toString(),
    //       color: Colors.orange,
    //       comment: false,
    //       href: getNotification[i]['href'].toString(),
    //     )
    //   );
    // }
    listModel = new ListModel(_listKey, tasks);

    return "hai";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: FutureBuilder<String>(
            future: getNotification(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: <Widget>[
                    _buildTimeline(),
                    _buildIamge(),
                    _buildTopHeader(),
                    _buildProfileRow(),
                    _buildBottomPart(),
                    _buildFab(),
                  ],
                );
              } else {
                return Container();
              }
            }));
  }

  Widget _buildFab() {
    return new Positioned(
        top: _imageHeight - 100.0,
        right: -40.0,
        child: new AnimatedFab(
          onClick: _changeFilterState,
        ));
  }

  void _changeFilterState() {
    showOnlyComment = !showOnlyComment;
    tasks.where((task) => !task.comment).forEach((task) {
      if (showOnlyComment) {
        listModel.removeAt(listModel.indexOf(task));
      } else {
        listModel.insert(tasks.indexOf(task), task);
      }
    });
  }

  Widget _buildIamge() {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Image.asset(
          'assets/img/notifications.png',
          fit: BoxFit.cover,
          height: _imageHeight,
          colorBlendMode: BlendMode.srcOver,
          color: new Color.fromARGB(120, 20, 10, 40),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.menu, size: 32.0, color: Colors.white),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "Notifikasi",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          new Icon(Icons.linear_scale, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildProfileRow() {
    return new Padding(
        padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
        child: FutureBuilder(
          future: postRequest(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Row(
                children: <Widget>[
                  new CircleAvatar(
                    minRadius: 28.0,
                    maxRadius: 28.0,
                    backgroundImage:
                        new AssetImage('assets/img/notification_2.png'),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          // name ? name : '',
                          name,
                          style: new TextStyle(
                              fontSize: 26.0,
                              color: Colors.black87,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400),
                        ),
                        new Text(
                          // company_name ? company_name : '',
                          company_name,
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget _buildBottomPart() {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    return new Expanded(
      child: AnimatedList(
        initialItemCount: tasks.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new TaskChild(
            task: listModel[index],
            animation: animation,
          );
        },
      ),
    );
  }

  Widget _buildMyTasksHeader() {
    return new Padding(
      padding: new EdgeInsets.only(left: 64.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            'Notifikasi',
            style: new TextStyle(fontSize: 34.0, fontFamily: "Poppins"),
          ),
          // new Text(
          //   '$dateFormat.format(thisdate)',
          //   style: new TextStyle(
          //       color: Colors.grey,
          //       fontWeight: FontWeight.w600,
          //       fontFamily: "Poppins",
          //       fontSize: 12.0),
          // ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  Future<String> postRequest() async {
    var userinfo = await Data.getData();

    company_name = userinfo['company_name'];
    name = userinfo['name'];
    print('postrekuest beraksi');
    // var dbClient = await databaseHelper.db;

    // var getNotif = await dbClient
    //     .rawQuery('select * from notifikasi order by tanggal desc, jam desc');

    // for (var i = 0; i < getNotif.lenght; i++) {
    //   tasks.add(
    //     Task(
    //         name: getNotif[i]['nama'],
    //         category: getNotif[i]['kategori'],
    //         time: getNotif[i]['jam'],
    //         color: Colors.orange,
    //         comment: false),
    //   );
    // }

    return 'ada data';
  }
}
