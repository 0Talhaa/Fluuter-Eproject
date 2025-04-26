import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:my_first_app/signup.dart';
import 'package:my_first_app/checkOut.dart';
import 'package:my_first_app/ProductDetail.dart';

// Color palette
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
      home: AnimatedBottomNavBar(
      ),
      routes: {
        '/signup':(context)=>LoginPage(),
       
        // '/products':(context)=>isLoggedIn ?MyProducts() : Login(),
        // '/add':(context)=>(isLoggedIn && isAdmin) ? AddProductPage() : Login(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<String> categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Thriller',
    'Romance',
    'Fantasy',
    'Crime',
    'Mystery',
    'Humor',
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
      "image": "assets/image/book1.jpeg",
      "category": "Non-Fiction",
      "price": 12.99,
    },
    {
      "title": "The Subtle Art of Not Giving a F*ck",
      "author": "Mark Manson",
      "rating": "4.5",
      "image": "assets/image/book2.jpeg",
      "category": "Non-Fiction",
      "price": 14.99,
    },
    {
      "title": "Atomic Habits",
      "author": "James Clear",
      "rating": "4.5",
      "image": "assets/image/book3.jpeg",
      "category": "Non-Fiction",
      "price": 11.99,
    },
    {
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "rating": "4.5",
      "image": "assets/image/book4.jpeg",
      "category": "Fiction",
      "price": 10.99,
    },
    {
      "title": "Thinking, Fast and Slow",
      "author": "Daniel Kahneman",
      "rating": "4.5",
      "image": "assets/image/book5.jpeg",
      "category": "Non-Fiction",
      "price": 13.99,
    },
    {
      "title": "The Alchemist",
      "author": "Paulo Coelho",
      "rating": "4.5",
      "image": "assets/image/book6.jpeg",
      "category": "Fiction",
      "price": 9.99,
    },
  ];

  final List<Map<String, dynamic>> _cartItems = [];
  bool _showCartDropdown = false;
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredBooks = [];
  String _selectedCategory = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _filteredBooks = books;
    _searchController.addListener(_filterBooks);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _filterBooks() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredBooks = books.where((book) {
        final title = book['title'].toString().toLowerCase();
        final author = book['author'].toString().toLowerCase();
        final matchesQuery =
            query.isEmpty || title.contains(query) || author.contains(query);
        final matchesCategory =
            _selectedCategory == 'All' || book['category'] == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _toggleCartDropdown() {
    if (_showCartDropdown) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _overlayEntry = _createCartOverlay();
      Overlay.of(context).insert(_overlayEntry!);
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
                                  subtitle: Text(
                                    '\$${_cartItems[index]['price'].toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: accentColor,
                                    ),
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
                          onPressed: () {
                            _toggleCartDropdown();
                            Navigator.push(
                              context,
                              SlidePageRoute(
                                  page: CheckoutPage(cartItems: _cartItems)),
                            ).then((value) {
                              if (value == true) {
                                setState(() {
                                  _cartItems.clear();
                                });
                              }
                            });
                          },
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
              buildDrawerItem(Icons.info_outline, 'About', () {
                Navigator.push(
                  context,
                  SlidePageRoute(page: AboutPage()),
                );
              }),
              buildDrawerItem(Icons.settings, 'Settings'),
              buildDrawerItem(Icons.logout, 'Logout', () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to logout?',
                      style: GoogleFonts.poppins(color: secondaryColor),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(color: accentColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Logout',
                          style: GoogleFonts.poppins(color: accentColor),
                        ),
                      ),
                    ],
                  ),
                );
              }),
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
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
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: secondaryColor),
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
                      isSelected: _selectedCategory == categories[index],
                      onTap: () {
                        setState(() {
                          _selectedCategory = categories[index];
                          _filterBooks();
                        });
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                            price: _filteredBooks[index]['price'],
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
                                SlidePageRoute(
                                  page: BookDetailPage(
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
      ),
    );
  }

  ListTile buildDrawerItem(IconData icon, String title, [VoidCallback? onTap]) {
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
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
    );
  }
}

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.0, 0.5, curve: Curves.easeInOut)),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.2, 0.8, curve: Curves.easeOutBack)),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'About Book Store',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, primaryColor.withOpacity(0.1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: primaryColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About Our Book Store',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Welcome to Book Store, your one-stop destination for discovering and purchasing a wide range of books across various genres. Our mission is to inspire a love for reading by providing an intuitive and delightful shopping experience.',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: secondaryColor,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Features',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          buildFeatureItem('Extensive Collection',
                              'Browse thousands of books from Fiction to Non-Fiction.'),
                          buildFeatureItem('Easy Search',
                              'Find your favorite books by title, author, or category.'),
                          buildFeatureItem('Secure Checkout',
                              'Shop with confidence with our secure payment system.'),
                          SizedBox(height: 16),
                          Text(
                            'App Info',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Version: 1.0.0\nDeveloped by: Book Store Team\nContact: support@bookstore.com',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFeatureItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: accentColor, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
  final double price;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;

  const BookCard({
    required this.title,
    required this.author,
    required this.rating,
    required this.image,
    required this.price,
    this.onAddToCart,
    this.onTap,
  });

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard>
    with SingleTickerProviderStateMixin {
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
                                      Colors.transparent
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
                        SizedBox(height: 4),
                        Text(
                          '\$${widget.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                          ),
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
    Center(child: Text("Discover", style: TextStyle(color: primaryColor))),
    Center(child: Text("Orders", style: TextStyle(color: primaryColor))),
    Center(child: Text("Wishlist", style: TextStyle(color: primaryColor))),
    Center(child: Text("Profile", style: TextStyle(color: primaryColor))),
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.explore_outlined,
    Icons.receipt_outlined,
    Icons.favorite_outline,
    Icons.person_outline,
  ];

  final List<String> _labels = [
    "Home",
    "Discover",
    "Orders",
    "Wishlist",
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

// Custom Slide Page Route for Transitions
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

// Placeholder classes to avoid compilation errors
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Login Page Placeholder')),
    );
  }
}

// class BookDetailPage extends StatelessWidget {
//   final Map<String, dynamic> book;
//   final VoidCallback onAddToCart;

//   BookDetailPage({required this.book, required this.onAddToCart});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text('Book Detail Page Placeholder')),
//     );
//   }
// }

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  CheckoutPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Checkout Page Placeholder')),
    );
  }
}

class Authentication {
  static bool isLoggedIn() {
    return false; // Mock implementation
  }
}
