import 'package:flutter/material.dart';
import 'package:new_payrightsystem/utils/notification/animated_fab.dart';
import 'package:new_payrightsystem/utils/notification/diagonal_clipper.dart';
import 'package:new_payrightsystem/utils/notification/list_model.dart';
import 'package:new_payrightsystem/utils/notification/task.dart';
import 'package:new_payrightsystem/utils/notification/task_row.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

//for notifiaction
import 'package:new_payrightsystem/data/model/NotifikasiModel.dart';
import 'package:new_payrightsystem/data/DatabaseHelper.dart';
import 'package:new_payrightsystem/utils/shared_preferences.dart';

class notificationPage extends StatefulWidget {
  notificationPage({Key key}) : super(key: key);

  @override
  _notificationPageState createState() => new _notificationPageState();
}

class _notificationPageState extends State<notificationPage> {
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();
  final double _imageHeight = 256.0;
  ListModel listModel;
  bool showOnlyGroup = false;

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
    var userinfo = await Data.getData();
    var dbClient = await databaseHelper.db;
    var getNotification = await dbClient
        .rawQuery('select * from notifikasi order by tanggal desc, jam desc');

    for (var i = 0; i < getNotification.length; i++) {
      var col;
      var group;

      if (getNotification[i]['jenis_notifikasi'].toString() == 'private') {
        col = Colors.orange;
        group = false;
      } else {
        col = Colors.blue;
        group = true;
      }
      ;

      tasks.add(
        new Task(
          title: getNotification[i]['title'].toString(),
          message: getNotification[i]['body'].toString(),
          time: getNotification[i]['tanggal'].toString() +
              " " +
              getNotification[i]['jam'].toString(),
          color: col,
          group: group,
          href: getNotification[i]['href'].toString(),
          group_id: getNotification[i]['group_id'].toString(),
        ),
      );
    }
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
    showOnlyGroup = !showOnlyGroup;
    tasks.where((task) => !task.group).forEach((task) {
      if (showOnlyGroup) {
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
          IconButton(
            icon: Icon(Icons.arrow_back, size: 32.0, color: Colors.grey[300]),
            onPressed: () => Navigator.pop(context, false),
          ),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[300],
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          // new Icon(Icons.linear_scale, color: Colors.white),
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
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400),
                        ),
                        new Text(
                          // company_name ? company_name : '',
                          company_name,
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[200],
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
          return new TaskRow(
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
            '',
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

    return 'ada data';
  }
}
