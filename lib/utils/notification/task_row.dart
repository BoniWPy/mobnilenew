import 'package:new_payrightsystem/utils/notification/notification_child.dart';
import 'package:new_payrightsystem/utils/notification/task.dart';
import 'package:flutter/material.dart';
import 'package:new_payrightsystem/ui/Home/webviewMain.dart';

class TaskRow extends StatelessWidget {
  final Task task;
  final double dotSize = 12.0;
  final Animation<double> animation;

  const TaskRow({Key key, this.task, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
      opacity: animation,
      child: new SizeTransition(
          sizeFactor: animation,
          child: GestureDetector(
            child: new Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 32.0 - dotSize / 2),
                    child: new Container(
                      height: dotSize,
                      width: dotSize,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle, color: task.color),
                    ),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          task.title,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                        new Text(
                          task.message,
                          style:
                              new TextStyle(fontSize: 12.0, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: new Text(
                      task.time,
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              print('apakah ini task group');
              print(task.group);
              print('group id nya');
              print(task.group_id);
              print('lanjut kemana gais');
              print(task.href);
              if (!task.group) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => InAppWebViewExampleScreen(task.href)));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        NotificationChild(task.href, task.group_id)));
              }
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (_) => NotificationChild(task.href, task.group_id)));
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (_) => InAppWebViewExampleScreen(task.href)));
            },
          )),
    );
  }
}
