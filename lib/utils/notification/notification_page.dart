import 'package:flutter/material.dart';
import 'package:new_payrightsystem/utils/notification/animated_fab.dart';
import 'package:new_payrightsystem/utils/notification/diagonal_clipper.dart';
import 'package:new_payrightsystem/utils/notification/list_model.dart';
import 'package:new_payrightsystem/utils/notification/initial_list.dart';
import 'package:new_payrightsystem/utils/notification/task_row.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  // initializeDateFormatting('id');
  // print(DateFormat().format(now)); // This will return date using the default locale

  // print(DateFormat.yMMMMd().format(now)); // print long date
  // print(DateFormat.yMd().format(now)); // print short date
  // print(DateFormat.jms().format(now)); // print time v

  @override
  void initState() {
    super.initState();
    listModel = new ListModel(_listKey, tasks);
    print(DateFormat().format(thisdate));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildTimeline(),
          _buildIamge(),
          _buildTopHeader(),
          _buildProfileRow(),
          _buildBottomPart(),
          _buildFab(),
        ],
      ),
    );
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
          'assets/img/notification_1.png',
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
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            minRadius: 28.0,
            maxRadius: 28.0,
            backgroundImage: new AssetImage('assets/img/notification_2.png'),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  'Imam Mutaqien',
                  style: new TextStyle(
                      fontSize: 26.0,
                      color: Colors.black87,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400),
                ),
                new Text(
                  'PT. Tabulasi Akurat Digifindo',
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
      ),
    );
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
      child: new AnimatedList(
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
          new Text(
            '$dateFormat.format(thisdate)',
            style: new TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                fontSize: 12.0),
          ),
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
}
