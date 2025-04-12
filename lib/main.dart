import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

void main() {
  runApp(BookstoreApp());
}

class BookstoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luxury Bookstore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFD4A373), // Soft gold
        scaffoldBackgroundColor: Color(0xFFFFFFFF), // White
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          headlineSmall: GoogleFonts.playfairDisplay(
            color: Color(0xFF8B6F47), // Medium brown
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.lato(
            color: Color(0xFF8B6F47),
          ),
        ),
        cardColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD4A373),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  List<String> categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Fantasy',
    'Mystery'
  ];
  List<Map<String, dynamic>> books = [
    {
      'title': 'Whispers of Time',
      'author': 'Clara Evans',
      'price': 24.99,
      'image': 'https://via.placeholder.com/150/FFE5D9/000000?text=Book+1',
      'isWishlisted': false
    },
    {
      'title': 'Golden Horizons',
      'author': 'Liam Carter',
      'price': 19.99,
      'image': 'https://via.placeholder.com/150/D8E2DC/000000?text=Book+2',
      'isWishlisted': false
    },
    {
      'title': 'Silent Realms',
      'author': 'Sophia Lee',
      'price': 29.99,
      'image': 'https://via.placeholder.com/150/ECE4DB/000000?text=Book+3',
      'isWishlisted': false
    },
    {
      'title': 'Eternal Echoes',
      'author': 'James Wright',
      'price': 22.99,
      'image': 'https://via.placeholder.com/150/FFF1E6/000000?text=Book+4',
      'isWishlisted': false
    },
  ];

  List<Map<String, String>> banners = [
    {
      'image':
          'https://via.placeholder.com/600x200/FFE5D9/000000?text=New+Arrivals',
      'text': 'Discover New Arrivals'
    },
    {
      'image':
          'https://via.placeholder.com/600x200/D8E2DC/000000?text=Best+Sellers',
      'text': 'Best Sellers of 2025'
    },
    {
      'image':
          'https://via.placeholder.com/600x200/ECE4DB/000000?text=Exclusive',
      'text': 'Exclusive Collections'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            title: FadeInDown(
              child: Text(
                'Luxury Bookstore',
                style: GoogleFonts.playfairDisplay(
                  color: Color(0xFF8B6F47),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Color(0xFF8B6F47)),
                onPressed: () {
                  showSearch(context: context, delegate: BookSearchDelegate());
                },
              ),
            ],
          ),
          // Main Content
          SliverList(
            delegate: SliverChildListDelegate([
              // Banners
              FadeInUp(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 24),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 220,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.easeInOutCubic,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.85,
                    ),
                    items: banners.map((banner) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  Image.network(
                                    banner['image']!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: Text(
                                      banner['text']!,
                                      style: GoogleFonts.playfairDisplay(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Categories
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Text(
                  'Browse by Category',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B6F47),
                  ),
                ),
              ),
              FadeInLeft(
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = _selectedCategory == categories[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = categories[index];
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.only(right: 16),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Color(0xFFD4A373) : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected
                                  ? Color(0xFFD4A373)
                                  : Color(0xFF8B6F47).withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            categories[index],
                            style: GoogleFonts.lato(
                              color:
                                  isSelected ? Colors.white : Color(0xFF8B6F47),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Best Sellers
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Text(
                  'Best Sellers',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B6F47),
                  ),
                ),
              ),
              FadeInRight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 330,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return PremiumBookCard(
                          book: books[index],
                          onWishlistToggle: () {
                            setState(() {
                              books[index]['isWishlisted'] =
                                  !books[index]['isWishlisted'];
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              // All Books
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Text(
                  'Explore Our Collection',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B6F47),
                  ),
                ),
              ),
            ]),
          ),
          // Books Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childCount: books.length,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: PremiumBookCard(
                    book: books[index],
                    onWishlistToggle: () {
                      setState(() {
                        books[index]['isWishlisted'] =
                            !books[index]['isWishlisted'];
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Color(0xFFD4A373),
              unselectedItemColor: Color(0xFF8B6F47).withOpacity(0.6),
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: GoogleFonts.lato(fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.lato(),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'Wishlist'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumBookCard extends StatefulWidget {
  final Map<String, dynamic> book;
  final VoidCallback onWishlistToggle;

  const PremiumBookCard({required this.book, required this.onWishlistToggle});

  @override
  _PremiumBookCardState createState() => _PremiumBookCardState();
}

class _PremiumBookCardState extends State<PremiumBookCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          width: 180,
          height: 550,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      'assets/image/flutter.jpeg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: widget.onWishlistToggle,
                      child: ElasticIn(
                        child: Icon(
                          widget.book['isWishlisted']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.book['isWishlisted']
                              ? Color(0xFFD4A373)
                              : Colors.white,
                          size: 28,
                          shadows: [
                            Shadow(color: Colors.black45, blurRadius: 4)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book['title'],
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B6F47),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Text(
                        widget.book['author'],
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Color(0xFF8B6F47).withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '\$${widget.book['price'].toStringAsFixed(2)}',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4A373),
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
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final List<String> suggestions = [
    'Whispers of Time',
    'Golden Horizons',
    'Silent Realms',
    'Eternal Echoes',
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      primaryColor: Colors.white,
      textTheme: TextTheme(
        titleLarge: GoogleFonts.lato(
          color: Color(0xFF8B6F47),
          fontSize: 18,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        hintStyle: GoogleFonts.lato(
          color: Color(0xFF8B6F47).withOpacity(0.5),
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Color(0xFF8B6F47)),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Color(0xFF8B6F47)),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        'Showing results for "$query"',
        style: GoogleFonts.lato(
          fontSize: 18,
          color: Color(0xFF8B6F47),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredSuggestions = suggestions
        .where((suggestion) =>
            suggestion.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: filteredSuggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              filteredSuggestions[index],
              style: GoogleFonts.lato(
                color: Color(0xFF8B6F47),
                fontSize: 16,
              ),
            ),
            onTap: () {
              query = filteredSuggestions[index];
              showResults(context);
            },
          );
        },
      ),
    );
  }
}
