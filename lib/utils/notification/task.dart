import 'package:flutter/material.dart';

class Task {
  final String title;
  final String message;
  final String time;
  final Color color;
  final bool comment;
  final String href;

  Task(
      {this.title,
      this.message,
      this.time,
      this.color,
      this.comment,
      this.href});
}
