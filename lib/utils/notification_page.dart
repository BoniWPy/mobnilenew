// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:new_payrightsystem/ui/Home/dashboardzakir.dart';
// import 'dart:convert' as JSON;

// // import 'package:html/parser.dart';
// // import 'package:nb_utils/nb_utils.dart';
// // import 'package:skp/common/apidata.dart';
// // import 'package:skp/common/config.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:skp/modules/berita/screen/detailBeritaScreen.dart';
// // import 'package:skp/modules/kelas/screen/detailKelasScreenVideo.dart';
// // import 'package:skp/modules/kelas/screen/detailKelasScreenWebinar.dart';
// // import 'package:skp/modules/pembayaran/screen/pembayaranScreen.dart';
// // import 'package:skp/service/DatabaseHelper.dart';

// // ConfigClass configClass = new ConfigClass();

// class NotifikasiScreen extends StatefulWidget {
//   @override
//   _NotifikasiScreenState createState() => _NotifikasiScreenState();
// }

// class _NotifikasiScreenState extends State<NotifikasiScreen> {
//   bool _loadingMore;
//   bool _hasMoreItems;
//   int _maxItems;
//   String lastIdInserting = "";
//   int fromLimit = 0;
//   int terload = 0;
//   List<Widget> listViews = <Widget>[];
//   List<int> arrayList = [];
//   List<String> arrayIdBerita = [];

//   ScrollController _scrollController;
//   Orientation orientation;
//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     _scrollController.addListener(_scrollListener);
//     super.initState();
//   }

//   _scrollListener() {
//     if (_scrollController.offset >=
//             _scrollController.position.maxScrollExtent &&
//         !_scrollController.position.outOfRange) {
//       setState(() {
//         print("reach the bottom");
//         terload = 0;
//       });
//     }
//     if (_scrollController.offset <=
//             _scrollController.position.minScrollExtent &&
//         !_scrollController.position.outOfRange) {
//       setState(() {
//         print("reach the top");
//       });
//     }
//   }

// // Widget showImage(Orientation orientation, String image) {
// //     return AspectRatio(
// //         aspectRatio: orientation == Orientation.portrait ? 15 / 9 : 20.2 / 6,
// //         child: Stack(
// //           children: [
// //             image == null ? Container(
// //                   decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(15.0),
// //                 image: DecorationImage(
// //                   image: AssetImage('assets/img/slider.png'),
// //                   fit: BoxFit.cover,
// //                 ),
// //               )
// //             ) :
// //             CachedNetworkImage(
// //               // imageUrl: APIData.sliderImages + image,
// //               imageUrl:  image,
// //               imageBuilder: (context, imageProvider) => Container(
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(15.0),
// //                   image: DecorationImage(
// //                     image: imageProvider,
// //                     fit: BoxFit.cover,
// //                   ),
// //                 ),
// //               ),
// //               placeholder: (context, url) => Container(
// //                   decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(15.0),
// //                 image: DecorationImage(
// //                   image: AssetImage('assets/placeholder/slider.png'),
// //                   fit: BoxFit.cover,
// //                 ),
// //               )),
// //               errorWidget: (context, url, error) => Icon(Icons.error),
// //             ),
// //             Container(
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(15.0),
// //                 gradient: LinearGradient(
// //                     begin: Alignment.bottomCenter,
// //                     end: Alignment.topCenter,
// //                     stops: [
// //                       0.0,
// //                       0.6
// //                     ],
// //                     colors: [
// //                       Colors.black,
// //                       Colors.black.withOpacity(0.0),
// //                     ]),
// //               ),
// //             )
// //           ],
// //         ));
// //   }
//   Widget detailsOnImage(String heading) {
//     return Positioned(
//       child: Container(
//         padding: EdgeInsets.only(top: 110, left: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Flexible(
//             //   child:
//             Text(
//               heading,
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.w800),
//             ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//   // var databaseHelper = new  DatabaseHelper() ;

//   Map<String, dynamic> dataNotifikasiScreen;
//   List<Widget> listWidgetNotif = [];
//   Future<bool> _loadNotifikasi() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //var dbClient = await databaseHelper.db;
//     listWidgetNotif = [];
//     // List<Map> listNotifikasi = await dbClient.rawQuery(
//     //     "SELECT * FROM notifikasi where status ='unread' order by tanggal desc, jam desc");
//     // for (var i = 0; i < listNotifikasi.length; i++) {
//     //   listWidgetNotif.add(
//     //     GestureDetector(
//     //       child: notificationTile(
//     //           FontAwesomeIcons.bell,
//     //           listNotifikasi[i]['title'],
//     //           listNotifikasi[i]['body'],
//     //           listNotifikasi[i]['message'],
//     //           Color(0xFF3F4654)),
//     //       onTap: () async {
//     //         setState(() {});
//     //         Navigator.of(context).push(
//     //             MaterialPageRoute(builder: (contet) => dashboard(true, true)));
//     //       },
//     //     ),
//     //   );
//     // }

//     List<Map> listNotifikasi =

//     // Map<String, dynamic> dataNotifikasiScreen;
//     //List<Widget> listWidgetNotif = [];
//     // Future<bool> _loadNotifikasi() async {
//     //   SharedPreferences prefs = await SharedPreferences.getInstance();
//     //   var dbClient = await databaseHelper.db;
//     //   listWidgetNotif = [];
//     //   List<Map> listNotifikasi = await dbClient.rawQuery(
//     //       "SELECT * FROM notifikasi where status ='unread' order by tanggal desc, jam desc");
//     //   for (var i = 0; i < listNotifikasi.length; i++) {
//     //     listWidgetNotif.add(
//     //       GestureDetector(
//     //         child: notificationTile(
//     //             FontAwesomeIcons.bell,
//     //             listNotifikasi[i]['title'],
//     //             listNotifikasi[i]['body'],
//     //             configClass.generateDate(listNotifikasi[i]['tanggal']) +
//     //                 " " +
//     //                 listNotifikasi[i]['jam'],
//     //             Color(0xFF3F4654)),
//     //         onTap: () async {
//     //           if (listNotifikasi[i]['jenis_notifikasi'] == 'KELAS BARU') {
//     //             if (listNotifikasi[i]['content_type'] == '1') {
//     //               await dbClient.rawQuery(
//     //                   "update notifikasi set status = 'read' where id = " +
//     //                       listNotifikasi[i]['id'].toString() +
//     //                       "  ");
//     //               setState(() {});
//     //               Navigator.of(context).push(MaterialPageRoute(
//     //                   builder: (contet) => DetailKelasScreenVideo(
//     //                       listNotifikasi[i]['id_content'].toString())));
//     //             } else {
//     //               await dbClient.rawQuery(
//     //                   "update notifikasi set status = 'read' where id = " +
//     //                       listNotifikasi[i]['id'].toString() +
//     //                       "  ");
//     //               setState(() {});
//     //               Navigator.of(context).push(MaterialPageRoute(
//     //                   builder: (contet) => DetailKelasScreenWebinar(
//     //                       listNotifikasi[i]['id_content'].toString())));
//     //             }
//     //           } else if (listNotifikasi[i]['jenis_notifikasi'] == 'BERITA BARU') {
//     //             await dbClient.rawQuery(
//     //                 "update notifikasi set status = 'read' where id = " +
//     //                     listNotifikasi[i]['id'].toString() +
//     //                     "  ");
//     //             setState(() {});
//     //             Navigator.of(context).push(MaterialPageRoute(
//     //                 builder: (contet) => DetailBeritaScreen(
//     //                     listNotifikasi[i]['id_content'].toString())));
//     //           } else if (listNotifikasi[i]['jenis_notifikasi'] ==
//     //               'PAYMENT SUCCESS') {
//     //             await dbClient.rawQuery(
//     //                 "update notifikasi set status = 'read' where id = " +
//     //                     listNotifikasi[i]['id'].toString() +
//     //                     "  ");
//     //             setState(() {});
//     //             Navigator.of(context).push(
//     //                 MaterialPageRoute(builder: (contet) => PembayaranScreen()));
//     //           }
//     //         },
//     //       ),
//     //     );
//     //   }

//     return true;
//   }

//   Widget notificationTile(
//       icon, title, subTitle, String tanggalJam, Color txtColor) {
//     return Container(
//         margin: EdgeInsets.only(left: 10, bottom: 10, right: 10, top: 10),
//         color: Colors.white,
//         child: ListTile(
//           leading: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(20)),
//             alignment: Alignment.center,
//             child: Icon(
//               icon,
//               size: 15,
//               color: Color(0xffb4bac6),
//             ),
//           ),
//           title: Text(
//             title,
//             style: TextStyle(
//                 fontSize: 18.3, fontWeight: FontWeight.w600, color: txtColor),
//           ),
//           subtitle: Text(
//             subTitle == null || subTitle == "null"
//                 ? "N/A"
//                 : subTitle + "\n $tanggalJam",
//             style: TextStyle(color: txtColor),
//           ),
//         ));
//   }

//   SliverAppBar appB() {
//     return SliverAppBar(
//       elevation: 0,
//       backgroundColor: Color(0xff29303b),
//       centerTitle: true,
//       title: Text(
//         "Berita",
//         style: TextStyle(fontSize: 16.0),
//       ),
//       leading: IconButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         icon: Icon(Icons.arrow_back_ios),
//         iconSize: 18.0,
//       ),
//     );
//   }

//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     orientation = MediaQuery.of(context).orientation;
//     return Scaffold(key: _scaffoldKey, body: scaffoldBody());
//   }

//   Widget scaffoldBody() {
//     return FutureBuilder<bool>(
//       future: _loadNotifikasi(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Container(
//               color: Color(0xffE5E5EF),
//               child: CustomScrollView(
//                 slivers: [
//                   appB(),
//                   SliverToBoxAdapter(
//                     child: Container(
//                       width: double.infinity,
//                       margin: EdgeInsets.only(
//                           top: 20.0, bottom: 5.0, left: 16, right: 16),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Notifikasi",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 22,
//                                 fontFamily: 'Bold'),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SliverPadding(padding: EdgeInsets.only(bottom: 15.0)),
//                   SliverToBoxAdapter(
//                     child: Column(
//                       children: listWidgetNotif,
//                     ),
//                   ),
//                 ],
//               ));
//         } else {
//           return Center(
//               child: CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
//           ));
//         }
//       },
//     );
//   }
// }
