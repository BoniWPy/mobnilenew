import 'package:flutter/material.dart';

class Task {
  final String title;
  final String message;
  final String time;
  final Color color;
  final bool group;
  final String href;
  final String group_id;
  final String jenis_notifikasi;

  Task({
    this.title,
    this.message,
    this.time,
    this.color,
    this.group,
    this.href,
    this.group_id,
    this.jenis_notifikasi,
  });
}
