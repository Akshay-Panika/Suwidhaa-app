import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/app_color.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedCategoryIndex = 0;
  String _selectedClass = 'All';

  final List<String> _classes = ['All', '10-A', '10-B', '10-C', '9-A', '9-B', '8-A', '8-B'];

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'emoji': '📚', 'color': const Color(0xFFFF6B35)},
    {'name': 'Science', 'emoji': '🔬', 'color': AppColors.primary},
    {'name': 'History', 'emoji': '📜', 'color': AppColors.school},
    {'name': 'Literature', 'emoji': '📖', 'color': AppColors.ott},
    {'name': 'Mathematics', 'emoji': '🔢', 'color': Colors.purple},
    {'name': 'Computer', 'emoji': '💻', 'color': Colors.cyan},
  ];

  final List<Map<String, dynamic>> books = [
    {'title': 'Physics Fundamentals', 'author': 'Dr. H.C. Verma', 'category': 'Science', 'year': '2023', 'copies': 5, 'available': 3, 'rating': 4.8},
    {'title': 'Mathematics for Class 10', 'author': 'R.S. Aggarwal', 'category': 'Mathematics', 'year': '2024', 'copies': 8, 'available': 5, 'rating': 4.6},
    {'title': 'India\'s Struggle for Freedom', 'author': 'Bipin Chandra', 'category': 'History', 'year': '2022', 'copies': 4, 'available': 2, 'rating': 4.9},
    {'title': 'English Grammar', 'author': 'Wren & Martin', 'category': 'Literature', 'year': '2023', 'copies': 6, 'available': 4, 'rating': 4.7},
    {'title': 'Computer Science', 'author': 'Sumita Arora', 'category': 'Computer', 'year': '2024', 'copies': 7, 'available': 3, 'rating': 4.5},
    {'title': 'Organic Chemistry', 'author': 'Morrison & Boyd', 'category': 'Science', 'year': '2022', 'copies': 3, 'available': 1, 'rating': 4.8},
    {'title': 'World History', 'author': 'Norman Lowe', 'category': 'History', 'year': '2023', 'copies': 5, 'available': 2, 'rating': 4.4},
    {'title': 'Linear Algebra', 'author': 'Gilbert Strang', 'category': 'Mathematics', 'year': '2024', 'copies': 4, 'available': 4, 'rating': 4.6},
  ];

  // Class-wise books with proper typing
  final Map<String, List<Map<String, dynamic>>> classBooks = {
    'All': [
      {'title': 'Physics Fundamentals', 'author': 'Dr. H.C. Verma', 'category': 'Science', 'year': '2023', 'available': 3, 'rating': 4.8},
      {'title': 'Mathematics for Class 10', 'author': 'R.S. Aggarwal', 'category': 'Mathematics', 'year': '2024', 'available': 5, 'rating': 4.6},
      {'title': 'India\'s Struggle for Freedom', 'author': 'Bipin Chandra', 'category': 'History', 'year': '2022', 'available': 2, 'rating': 4.9},
      {'title': 'English Grammar', 'author': 'Wren & Martin', 'category': 'Literature', 'year': '2023', 'available': 4, 'rating': 4.7},
      {'title': 'Computer Science', 'author': 'Sumita Arora', 'category': 'Computer', 'year': '2024', 'available': 3, 'rating': 4.5},
      {'title': 'Organic Chemistry', 'author': 'Morrison & Boyd', 'category': 'Science', 'year': '2022', 'available': 1, 'rating': 4.8},
      {'title': 'World History', 'author': 'Norman Lowe', 'category': 'History', 'year': '2023', 'available': 2, 'rating': 4.4},
      {'title': 'Linear Algebra', 'author': 'Gilbert Strang', 'category': 'Mathematics', 'year': '2024', 'available': 4, 'rating': 4.6},
    ],
    '10-A': [
      {'title': 'Physics Fundamentals', 'author': 'Dr. H.C. Verma', 'category': 'Science', 'year': '2023', 'available': 3, 'rating': 4.8},
      {'title': 'Mathematics for Class 10', 'author': 'R.S. Aggarwal', 'category': 'Mathematics', 'year': '2024', 'available': 5, 'rating': 4.6},
      {'title': 'English Grammar', 'author': 'Wren & Martin', 'category': 'Literature', 'year': '2023', 'available': 4, 'rating': 4.7},
    ],
    '10-B': [
      {'title': 'Physics Fundamentals', 'author': 'Dr. H.C. Verma', 'category': 'Science', 'year': '2023', 'available': 3, 'rating': 4.8},
      {'title': 'Mathematics for Class 10', 'author': 'R.S. Aggarwal', 'category': 'Mathematics', 'year': '2024', 'available': 5, 'rating': 4.6},
      {'title': 'India\'s Struggle for Freedom', 'author': 'Bipin Chandra', 'category': 'History', 'year': '2022', 'available': 2, 'rating': 4.9},
      {'title': 'Computer Science', 'author': 'Sumita Arora', 'category': 'Computer', 'year': '2024', 'available': 3, 'rating': 4.5},
    ],
    '10-C': [
      {'title': 'Organic Chemistry', 'author': 'Morrison & Boyd', 'category': 'Science', 'year': '2022', 'available': 1, 'rating': 4.8},
      {'title': 'Mathematics for Class 10', 'author': 'R.S. Aggarwal', 'category': 'Mathematics', 'year': '2024', 'available': 5, 'rating': 4.6},
      {'title': 'World History', 'author': 'Norman Lowe', 'category': 'History', 'year': '2023', 'available': 2, 'rating': 4.4},
    ],
    '9-A': [
      {'title': 'Physics Fundamentals', 'author': 'Dr. H.C. Verma', 'category': 'Science', 'year': '2023', 'available': 3, 'rating': 4.8},
      {'title': 'English Grammar', 'author': 'Wren & Martin', 'category': 'Literature', 'year': '2023', 'available': 4, 'rating': 4.7},
    ],
    '9-B': [
      {'title': 'Mathematics for Class 10', 'author': 'R.S. Aggarwal', 'category': 'Mathematics', 'year': '2024', 'available': 5, 'rating': 4.6},
      {'title': 'Computer Science', 'author': 'Sumita Arora', 'category': 'Computer', 'year': '2024', 'available': 3, 'rating': 4.5},
    ],
    '8-A': [
      {'title': 'English Grammar', 'author': 'Wren & Martin', 'category': 'Literature', 'year': '2023', 'available': 4, 'rating': 4.7},
      {'title': 'World History', 'author': 'Norman Lowe', 'category': 'History', 'year': '2023', 'available': 2, 'rating': 4.4},
    ],
    '8-B': [
      {'title': 'Physics Fundamentals', 'author': 'Dr. H.C. Verma', 'category': 'Science', 'year': '2023', 'available': 3, 'rating': 4.8},
      {'title': 'Mathematics for Class 10', 'author': 'R.S. Aggarwal', 'category': 'Mathematics', 'year': '2024', 'available': 5, 'rating': 4.6},
    ],
  };

  final List<Map<String, dynamic>> issuedBooks = [
    {'title': 'Physics Fundamentals', 'issueDate': '2026-01-05', 'returnDate': '2026-01-20', 'status': 'Issued'},
    {'title': 'Mathematics for Class 10', 'issueDate': '2026-01-10', 'returnDate': '2026-01-25', 'status': 'Issued'},
    {'title': 'English Grammar', 'issueDate': '2026-01-12', 'returnDate': '2026-01-27', 'status': 'Overdue'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _getFilteredBooks();
    final classSpecificBooks = _getClassBooks();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Card
          _buildStatisticsCard(),
          const SizedBox(height: 16),

          // Class Selector
          _buildClassSelector(),
          const SizedBox(height: 16),

          // Categories
          _buildSectionHeader("📂 Browse Categories"),
          const SizedBox(height: 12),
          _buildCategoryGrid(),
          const SizedBox(height: 24),

          // Featured Books
          _buildSectionHeader("⭐ Featured Books"),
          const SizedBox(height: 12),
          _buildFeaturedBooks(),
          const SizedBox(height: 24),

          // My Issued Books
          _buildSectionHeader("📖 My Issued Books"),
          const SizedBox(height: 12),
          _buildIssuedBooks(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==================== STATISTICS CARD ====================
  Widget _buildStatisticsCard() {
    final totalBooks = books.length;
    final totalAvailable = books.fold(0, (sum, book) => sum + (book['available'] as int));
    final totalIssued = issuedBooks.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('📚', '$totalBooks', 'Total Books', Colors.white),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem('✅', '$totalAvailable', 'Available', Colors.white),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem('📖', '$totalIssued', 'Issued', Colors.white),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label, Color textColor) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // ==================== CLASS SELECTOR ====================
  Widget _buildClassSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.class_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Select Class',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final classItem = _classes[index];
                final isSelected = _selectedClass == classItem;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedClass = classItem;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFFF6B35)],
                        )
                            : null,
                        color: isSelected ? null : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        classItem,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==================== SECTION HEADER ====================
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textMain,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'View All',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== CATEGORY GRID ====================
  Widget _buildCategoryGrid() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategoryIndex == index;
          final color = categories[index]['color'] as Color;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ] : [],
              ),
              child: Row(
                children: [
                  Text(
                    categories[index]['emoji'],
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    categories[index]['name'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textMain,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
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
  // ==================== FEATURED BOOKS ====================
  Widget _buildFeaturedBooks() {
    final featuredBooks = books.take(3).toList();

    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredBooks.length,
        itemBuilder: (context, index) {
          final book = featuredBooks[index];
          return InkWell(
            onTap: () {
              _showBookDetail(book);
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      color: _getCategoryColor(book['category'] ?? '').withOpacity(0.1),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 48,
                        color: _getCategoryColor(book['category'] ?? ''),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          book['author'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                            Text(
                              book['rating']?.toString() ?? '4.5',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
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

  // ==================== ISSUED BOOKS ====================
  Widget _buildIssuedBooks() {
    if (issuedBooks.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.book_rounded, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text(
              'No books issued',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: issuedBooks.map((book) {
        final bool isOverdue = book['status'] == 'Overdue';
        final Color statusColor = isOverdue ? Colors.red : AppColors.ngo;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isOverdue ? Colors.red.withOpacity(0.2) : AppColors.ngo.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isOverdue ? Colors.red.withOpacity(0.1) : AppColors.ngo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOverdue ? '📕' : '📘',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Issued: ${_formatDate(book['issueDate'])}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: isOverdue ? Colors.red : Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Return: ${_formatDate(book['returnDate'])}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isOverdue ? Colors.red : Colors.grey[600],
                                fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      book['status'],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ==================== BOOK DETAIL DIALOG ====================
  void _showBookDetail(Map<String, dynamic> book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BookDetailScreen(
        title: book['title'],
        author: book['author'],
        category: book['category'] ?? 'General',
        rating: book['rating'] ?? 4.5,
        available: book['available'] ?? 0,
        year: book['year'] ?? '2024',
      ),
    );
  }

  // ==================== HELPER METHODS ====================
  List<Map<String, dynamic>> _getFilteredBooks() {
    if (_selectedCategoryIndex == 0) {
      return books;
    }
    final category = categories[_selectedCategoryIndex]['name'];
    return books.where((book) => book['category'] == category).toList();
  }

  List<Map<String, dynamic>> _getClassBooks() {
    // Return class-specific books or all books if class not found
    final booksForClass = classBooks[_selectedClass];
    if (booksForClass != null) {
      return booksForClass;
    }
    // Fallback to all books
    return classBooks['All'] ?? [];
  }

  Color _getCategoryColor(String category) {
    final cat = categories.firstWhere(
          (c) => c['name'] == category,
      orElse: () => categories[0],
    );
    return cat['color'] as Color;
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}

// ==================== BOOK DETAIL SCREEN ====================
class BookDetailScreen extends StatefulWidget {
  final String title;
  final String author;
  final String category;
  final double rating;
  final int available;
  final String year;

  const BookDetailScreen({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    required this.rating,
    required this.available,
    required this.year,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  int _quantity = 1;

  Future<void> _pickDate(bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(widget.category);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Book Info
          Row(
            children: [
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 48,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '✍️ ${widget.author}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.category,
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 16),

          // Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem('📅 Year', widget.year),
              _buildDetailItem('📚 Copies', '${widget.available}'),
              _buildDetailItem('📖 Status', widget.available > 0 ? 'Available' : 'Out of Stock'),
            ],
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 16),

          // Date Selection
          const Text(
            '📅 Select Issue Dates',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDateButton("From", _startDate, () => _pickDate(true)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDateButton("To", _endDate, () => _pickDate(false)),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Quantity
          Row(
            children: [
              const Text(
                'Quantity:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() => _quantity--);
                        }
                      },
                      icon: const Icon(Icons.remove, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    Container(
                      width: 30,
                      alignment: Alignment.center,
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_quantity < widget.available) {
                          setState(() => _quantity++);
                        }
                      },
                      icon: const Icon(Icons.add, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Request Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: (_startDate != null && _endDate != null && widget.available > 0)
                  ? () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '✅ "${widget.title}" requested successfully!',
                    ),
                    backgroundColor: AppColors.ngo,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
                  : null,
              child: Text(
                widget.available > 0 ? '📤 Request Issue' : '❌ Out of Stock',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String emoji, String value) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildDateButton(String label, DateTime? date, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: const Color(0xFFFF6B35)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: date != null ? const Color(0xFFFF6B35) : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            date == null ? label : DateFormat('dd MMM yyyy').format(date),
            style: TextStyle(
              color: date == null ? Colors.grey : AppColors.textMain,
              fontWeight: date != null ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final Map<String, Color> categoryColors = {
      'Science': AppColors.primary,
      'History': AppColors.school,
      'Literature': AppColors.ott,
      'Mathematics': Colors.purple,
      'Computer': Colors.cyan,
    };
    return categoryColors[category] ?? const Color(0xFFFF6B35);
  }
}