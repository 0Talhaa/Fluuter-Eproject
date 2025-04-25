import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color palette from HomePage
const Color primaryColor = Color(0xFF1E3A8A); // Deep blue
const Color accentColor = Color(0xFFFF6B6B); // Vibrant coral
const Color backgroundColor = Color(0xFFF8FAFC); // Light gray
const Color cardColor = Colors.white;
const Color secondaryColor = Color(0xFF6B7280); // Gray for text

class BookDetailPage extends StatefulWidget {
  final Map<String, dynamic> book;
  final VoidCallback? onAddToCart;

  const BookDetailPage({super.key, required this.book, this.onAddToCart});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> with SingleTickerProviderStateMixin {
  int _quantity = 1;
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [
    {'user': 'Jane Smith', 'text': 'Loved this book! A must-read for writers.'},
    {'user': 'Alex Brown', 'text': 'Really insightful and beautifully written.'},
  ];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    _commentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) _quantity--;
    });
  }

  void _submitComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.add({
          'user': 'Current User', // Replace with auth user in real app
          'text': _commentController.text.trim(),
        });
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
          widget.book['title'] ?? 'Book Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              Container(
                margin: EdgeInsets.all(20),
                child: Hero(
                  tag: widget.book['image'] ?? 'book_image',
                  child: Transform(
                    transform: Matrix4.rotationZ(-0.05),
                    alignment: Alignment.center,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.book['image'] ?? 'assets/image/book1.jpeg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Content Section
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand
                      Row(
                        children: [
                          Icon(Icons.menu_book, color: primaryColor, size: 24),
                          SizedBox(width: 8),
                          Text(
                            "BOOKSHELF",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Title & Author
                      Text(
                        widget.book['title'] ?? 'THE ART OF WRITING',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                      Text(
                        'by ${widget.book['author'] ?? 'John Doe'}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: secondaryColor.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Description
                      Text(
                        'Discover the timeless art of storytelling in this beautifully written guide. Perfect for aspiring writers and literary enthusiasts.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: secondaryColor,
                          height: 1.5,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      // Rating
                      Row(
                        children: [
                          ...List.generate(
                            3,
                            (_) => Icon(Icons.star, color: Colors.amber, size: 20),
                          ),
                          Icon(Icons.star_half, color: Colors.amber, size: 20),
                          Icon(Icons.star_border, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            widget.book['rating'] ?? '4.5',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: secondaryColor,
                            ),
                          ),
                          Text(
                            ' (234 reviews)',
                            style: GoogleFonts.poppins(
                              color: secondaryColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.favorite_border, color: secondaryColor, size: 20),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Price
                      Text(
                        '\$19.99',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      Text(
                        'Shipping and taxes extra.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: secondaryColor.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Edition Option
                      Row(
                        children: [
                          Text(
                            'Choose your edition: ',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: secondaryColor,
                            ),
                          ),
                          ...[Colors.black, Colors.grey.shade300, Colors.brown].map(
                            (color) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: color,
                                child: color == Colors.black
                                    ? Icon(Icons.check, color: Colors.white, size: 14)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Quantity and Add to Cart
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Quantity',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: secondaryColor,
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: _decrementQuantity,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                width: 50,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: secondaryColor.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(10),
                                  color: backgroundColor,
                                ),
                                child: Center(
                                  child: Text(
                                    _quantity.toString().padLeft(2, '0'),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: _incrementQuantity,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: widget.onAddToCart,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [accentColor, accentColor.withOpacity(0.8)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Add to Cart',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      // Comments Section
                      Text(
                        'Comments',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Comment Input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: GoogleFonts.poppins(
                                  color: secondaryColor.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: backgroundColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: secondaryColor.withOpacity(0.3)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              style: GoogleFonts.poppins(fontSize: 14),
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          GestureDetector(
                            onTap: _submitComment,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Comments List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: secondaryColor.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment['user']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: secondaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    comment['text']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: secondaryColor.withOpacity(0.8),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
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