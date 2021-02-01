import 'package:flutter/material.dart';
import 'package:new_payrightsystem/ui/Home/notificationList.dart';

class NavigationItem {
  IconData iconData;

  NavigationItem(this.iconData);
}

List<NavigationItem> getNavigationItemList() {
  return <NavigationItem>[
    NavigationItem(Icons.home),
    NavigationItem(Icons.book),
    NavigationItem(Icons.local_library),
    NavigationItem(Icons.person),
  ];
}

class Book {
  String title;
  String description;
  Author author;
  String score;
  String image;

  Book(this.title, this.description, this.author, this.score, this.image);
}

List<Book> getBookList() {
  return <Book>[
    Book(
      "Tes Konten",
      "",
      Author(
        "Boiler CFB",
        90,
        "assets/authors/greer_hendricks.jpg",
      ),
      "4.14",
      "assets/books/an_anonymous_girl_by_greer_hendricks.jpg",
    ),
    Book(
      "Konten Video Desember 2020",
      "The Water Cure has drawn instant comparisons to The Handmaid’s Tale, and not just because author Margaret Atwood called it “a gripping, sinister fable.” The book centers on Grace, Lia, and Sky, three sisters who live on an isolated island with their mother and their father, whom they call King. When their father disappears, their lives—as well as everything they’ve been told about the outside world—are upended.",
      Author(
        "Generator A1",
        123,
        "assets/authors/sophie_mackintosh.jpg",
      ),
      "4.14",
      "assets/books/the_water_cure_by_sophie_mackintosh.jpg",
    ),
    Book(
      "Konten Testing",
      "Set in a Southern California college town, The Dreamers begins with the odd case of a student who walks into her dorm room, passes out, and doesn’t wake up. Soon a second girl falls asleep, then a third, and on it goes. The victims are locked in a heightened dream state, having wild fantasies and hallucinations—all while a group of students, teachers, and doctors struggle to wake them.",
      Author(
        "Generator A1",
        99,
        "assets/authors/karen_thompson_walker.jpg",
      ),
      "4.14",
      "assets/books/the_dreamers_by_karen_thompson.jpg",
    ),
  ];
}

class Author {
  String fullname;
  int books;
  String image;

  Author(this.fullname, this.books, this.image);
}

List<Author> getAuthorList() {
  return <Author>[
    Author(
      "Konten Testing",
      134,
      "assets/authors/stepanie_land.jpg",
    ),
    Author(
      "Konten Video Desember 2020",
      123,
      "assets/authors/sophie_mackintosh.jpg",
    ),
  ];
}

class Filter {
  String name;

  Filter(this.name);
}

List<Filter> getFilterList() {
  return <Filter>[
    Filter("Semua"),
    Filter("Share Project"),
    Filter("System"),
  ];
}
