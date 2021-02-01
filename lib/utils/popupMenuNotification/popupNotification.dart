// class popUNotifications extends State<HomePage> {
//   String _selectedItem = 'Sun';
//   List _options = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Popup Menu"),
//         actions: [
//           PopupMenuButton(
//             itemBuilder: (BuildContext bc) {
//               return _options
//                   .map((day) => PopupMenuItem(
//                         child: Text(day),
//                         value: day,
//                       ))
//                   .toList();
//             },
//             onSelected: (value) {
//               setState(() {
//                 _selectedItem = value;
//               });
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Text("Selected Day: $_selectedItem"),
//       ),
//     );
//   }
// }
