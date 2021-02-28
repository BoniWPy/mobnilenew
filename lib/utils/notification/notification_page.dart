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
  bool showOnlyComment = false;

  var thisdate = DateTime.now();
  var dateFormat = DateFormat();

  // List<Task> tasks = [
  //   new Task(
  //       title: "Reminder for Upcoming Closing Date",
  //       message: "Tutup buku periode :string :date -",
  //       time: "08:55",
  //       color: Colors.orange,
  //       comment: false),
  //   new Task(
  //       title: "Irvandy Goutama completed this task",
  //       message: "Project Notification",
  //       time: "09:16",
  //       color: Colors.cyan,
  //       comment: true),
  //   new Task(
  //       title: "Reminder for Upcoming Closing Date",
  //       message: "Tutup buku periode :string :date -",
  //       time: "13:55",
  //       color: Colors.orange,
  //       comment: false),
  //   new Task(
  //       title: "Irvandy Goutama completed this task",
  //       message: "Project Notification",
  //       time: "14:16",
  //       color: Colors.cyan,
  //       comment: true),
  //   new Task(
  //       title: "Reminder for Upcoming Closing Date",
  //       message: "Tutup buku periode :string :date -",
  //       time: "15:55",
  //       color: Colors.orange,
  //       comment: false),
  //   new Task(
  //       title: "Irvandy Goutama completed this task",
  //       message: "Project Notification",
  //       time: "19:16",
  //       color: Colors.cyan,
  //       comment: true),
  // ];
  List<Task> tasks = [];
  // initializeDateFormatting('id');
  // print(DateFormat().format(now)); // This will return date using the default locale

  // print(DateFormat.yMMMMd().format(now)); // print long date
  // print(DateFormat.yMd().format(now)); // print short date
  // print(DateFormat.jms().format(now)); // print time v

  var userinfo, company_name, name;
  var databaseHelper = new DatabaseHelper();

  @override
  void initState() {
    super.initState();
    print(DateFormat().format(thisdate));
    // postRequest();
  }

  Future<String> getNotification() async {
    var userinfo = await Data.getData();
    var dbClient = await databaseHelper.db;
    var getNotification = await dbClient
        .rawQuery('select * from notifikasi order by tanggal desc, jam desc');

    // String _id_content;
    // String _title;
    // String _body;
    // String _tanggal;
    // String _jam;
    // String _jenis_notifikasi;
    // String _status;
    // String _group;
    // String _click_action;

    for (var i = 0; i < getNotification.length; i++) {
      tasks.add(
        new Task(
            title: getNotification[i]['title'].toString(),
            message: getNotification[i]['body'].toString(),
            time: getNotification[i]['tanggal'].toString() +
                " " +
                getNotification[i]['jam'].toString(),
            color: Colors.orange,
            comment: false),
      );
    }
    listModel = new ListModel(_listKey, tasks);

    print("panjang DB " + tasks.length.toString());

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
              print(company_name);
              print('nama company');
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
