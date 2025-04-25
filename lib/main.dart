import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_first_app/ProductDetail.dart';
import 'package:shimmer/shimmer.dart';

const Color primaryColor = Color(0xFF1E3A8A);
const Color accentColor = Color(0xFFFF6B6B);
const Color backgroundColor = Color(0xFFF8FAFC);
const Color cardColor = Colors.white;
const Color secondaryColor = Color(0xFF6B7280);

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
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme:
            GoogleFonts.poppinsTextTheme().apply(bodyColor: secondaryColor),
        cardColor: cardColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
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

  final List<Map<String, dynamic>> _cartItems = [];
  bool _showCartDropdown = false;
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _filteredBooks = books; // Initially show all books
    _searchController.addListener(_filterBooks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBooks() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = books;
      } else {
        _filteredBooks = books.where((book) {
          final title = book['title'].toString().toLowerCase();
          final author = book['author'].toString().toLowerCase();
          return title.contains(query) || author.contains(query);
        }).toList();
      }
    });
  }

  void _toggleCartDropdown() {
    if (_showCartDropdown) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry = _createCartOverlay();
      Overlay.of(context)?.insert(_overlayEntry!);
    }
    setState(() {
      _showCartDropdown = !_showCartDropdown;
    });
  }

  OverlayEntry _createCartOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleCartDropdown,
              child: Container(color: Colors.black12.withOpacity(0.2)),
            ),
          ),
          Positioned(
            right: 10,
            top: offset.dy + 56,
            width: 280,
            child: AnimatedSlide(
              offset: _showCartDropdown ? Offset.zero : Offset(0, -0.5),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                color: cardColor.withOpacity(0.95),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Cart',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Divider(color: secondaryColor.withOpacity(0.3)),
                      _cartItems.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Your cart is empty',
                                style:
                                    GoogleFonts.poppins(color: secondaryColor),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _cartItems.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      _cartItems[index]['image'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    _cartItems[index]['title'],
                                    style: GoogleFonts.poppins(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_circle,
                                        color: accentColor),
                                    onPressed: () {
                                      setState(() {
                                        _cartItems.removeAt(index);
                                        if (_cartItems.isEmpty) {
                                          _toggleCartDropdown();
                                        } else {
                                          _overlayEntry?.markNeedsBuild();
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                      if (_cartItems.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.payment, size: 18),
                          label: Text('Checkout'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Icon(Icons.person, size: 50, color: primaryColor),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'User',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        title: Text(
          'BOOK STORE',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: _toggleCartDropdown,
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Text(
                      '${_cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.9,
              ),
              items: bannerImages.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          imagePath,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search books by title or author...',
                    hintStyle: GoogleFonts.poppins(
                      color: secondaryColor.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: cardColor,
                    prefixIcon: Icon(Icons.search, color: primaryColor),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: secondaryColor),
                            onPressed: () {
                              _searchController.clear();
                              _filterBooks();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: accentColor, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: GoogleFonts.poppins(fontSize: 14, color: secondaryColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'Categories',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            Container(
              height: 50,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: categories[index],
                    isSelected: index == 0,
                    onTap: () {
                      // Add category selection logic here
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'Top Selling',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            _filteredBooks.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No books found',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: _filteredBooks.length,
                    itemBuilder: (context, index) {
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 300 + index * 100),
                        child: BookCard(
                          title: _filteredBooks[index]['title']!,
                          author: _filteredBooks[index]['author']!,
                          rating: _filteredBooks[index]['rating']!,
                          image: _filteredBooks[index]['image']!,
                          onAddToCart: () {
                            setState(() {
                              _cartItems.add(_filteredBooks[index]);
                              if (_showCartDropdown) {
                                _overlayEntry?.markNeedsBuild();
                              }
                            });
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailPage(
                                  book: _filteredBooks[index],
                                  onAddToCart: () {
                                    setState(() {
                                      _cartItems.add(_filteredBooks[index]);
                                      if (_showCartDropdown) {
                                        _overlayEntry?.markNeedsBuild();
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  ListTile buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {},
    );
  }
}

// Ensure BookCard, CategoryChip, AnimatedBottomNavBar, and BookDetailPage are included in the same file or imported correctly
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : secondaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  final String title;
  final String author;
  final String rating;
  final String image;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;

  const BookCard({
    required this.title,
    required this.author,
    required this.rating,
    required this.image,
    this.onAddToCart,
    this.onTap,
  });

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              shadowColor: Colors.black12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Hero(
                      tag: widget.image,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        child: Stack(
                          children: [
                            Image.asset(
                              widget.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black54,
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.author,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: secondaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              widget.rating,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.add_shopping_cart,
                                size: 20,
                                color: accentColor,
                              ),
                              onPressed: widget.onAddToCart,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    Center(child: Text("Home", style: TextStyle(color: primaryColor))),
    Center(child: Text("Live", style: TextStyle(color: primaryColor))),
    Center(child: Text("Message", style: TextStyle(color: primaryColor))),
    Center(child: Text("Follow", style: TextStyle(color: primaryColor))),
    Center(child: Text("Profile", style: TextStyle(color: primaryColor))),
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
  Widget build(context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
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
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      height: isSelected ? 50 : 40,
                      width: isSelected ? 50 : 40,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [accentColor, primaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.grey[200],
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        _icons[index],
                        size: 24,
                        color: isSelected ? Colors.white : secondaryColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _labels[index],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isSelected ? accentColor : secondaryColor,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
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