import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_first_app/ProductDetail.dart';
import 'package:my_first_app/authentication.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(BookStoreApp());
}

class BookStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        primaryColor: Color(0xFF1E3A8A),
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black),
      ),
      home: AnimatedBottomNavBar(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = [
    'All',
    'Fiction',
    'Science',
    'Thriller',
    'Romantic',
    'Fantasy',
    'Crime',
    'Mystery',
    'Funny',
  ];

  final List<String> bannerImages = [
    "assets/image/book9.jpeg",
    "assets/image/book15.jpeg",
    "assets/image/book16.jpeg",
  ];

  final List<Map<String, dynamic>> books = [
    {
      "title": "Psychology of Money",
      "author": "Morgan Housel",
      "rating": "4.5",
      "image": "assets/image/book1.jpeg"
    },
    {
      "title": "The Subtle Art of Not Giving a F*ck",
      "author": "Mark Manson",
      "rating": "4.5",
      "image": "assets/image/book2.jpeg"
    },
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "rating": "4.5",
      "image": "assets/image/book3.jpeg"
    },
    {
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "rating": "4.5",
      "image": "assets/image/book4.jpeg"
    },
    {
      "title": "Thinking, Fast and Slow",
      "author": "Daniel Kahneman",
      "rating": "4.5",
      "image": "assets/image/book5.jpeg"
    },
    {
      "title": "The Alchemist",
      "author": "Paulo Coelho",
      "rating": "4.5",
      "image": "assets/image/book6.jpeg"
    },
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Color(0xFF1E3A8A),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF1E3A8A)),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.person,
                          size: 40, color: Color(0xFF1E3A8A)),
                    ),
                    SizedBox(height: 10),
                    Text('User',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
              buildDrawerItem(Icons.search, 'Search'),
              buildDrawerItem(Icons.logout, 'Logout'),
              buildDrawerItem(Icons.settings, 'Settings'),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E3A8A),
        title: Text('BOOK STORE',
            style: GoogleFonts.stixTwoText(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            CarouselSlider(
              options: CarouselOptions(
                height: 160.0,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
              items: bannerImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePath,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 50,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: categories[index],
                    isSelected:
                        index == 0, // just for demo, set selected logic later
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Top Selling',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.5,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookCard(
                  title: books[index]['title']!,
                  author: books[index]['author']!,
                  rating: books[index]['rating']!,
                  image: books[index]['image']!,
                );
              },
            ),
          ],
        ),
      ),

    );
  }

  ListTile buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
        backgroundColor: isSelected ? Color(0xFF1E3A8A) : Colors.grey[200],
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String rating;
  final String image;

  const BookCard(
      {required this.title,
      required this.author,
      required this.rating,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(image,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                Text(author,
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Text(rating, style: TextStyle(fontSize: 11)),
                    SizedBox(width: 2),
                    Icon(Icons.star, size: 12, color: Colors.orange),
                    Spacer(),
                    Icon(Icons.favorite_border, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class AnimatedBottomNavBar extends StatefulWidget {
  @override
  _AnimatedBottomNavBarState createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(), 
    Center(child: Text("Home")),
    Center(child: Text("Live")),
    Center(child: Text("Message")),
    Center(child: Text("Follow")),
    Center(child: Text("Profile")),
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.videocam_outlined,
    Icons.message_outlined,
    Icons.favorite_outline_sharp,
    Icons.person_outline,
  ];

  final List<String> _labels = [
    "Home",
    "Live",
    "Message",
    "Follow",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      backgroundColor: Color(0xFF1E3A8A),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isSelected = index == _selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 12),
                curve: Curves.easeInOut,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: isSelected ? 55 : 45,
                      width: isSelected ? 55 : 45,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1E3A8A) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Icon(
                        _icons[index],
                        size: 24,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _labels[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.lightBlueAccent : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
