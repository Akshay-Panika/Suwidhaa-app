import 'package:flutter/material.dart';

class OttSchoolScreen extends StatefulWidget {
  const OttSchoolScreen({super.key});

  @override
  State<OttSchoolScreen> createState() => _OttSchoolScreenState();
}

class _OttSchoolScreenState extends State<OttSchoolScreen> {
  // ==================== CLASSES ====================
  final List<String> _classes = [
    'Nursery',
    'LKG',
    'UKG',
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12',
  ];

  // ==================== SUBJECTS PER CLASS ====================
  final Map<String, List<String>> _subjectsByClass = {
    'Nursery': ['All', 'Rhymes', 'ABC', 'Numbers', 'Colors', 'Shapes', 'Fun'],
    'LKG': ['All', 'English', 'Maths', 'Rhymes', 'EVS', 'Fun'],
    'UKG': ['All', 'English', 'Maths', 'EVS', 'Rhymes', 'Fun'],
    'Class 1': ['All', 'English', 'Maths', 'EVS', 'Hindi', 'Fun'],
    'Class 2': ['All', 'English', 'Maths', 'EVS', 'Hindi', 'Fun'],
    'Class 3': ['All', 'English', 'Maths', 'EVS', 'Hindi', 'Fun'],
    'Class 4': ['All', 'English', 'Maths', 'Science', 'Social', 'Hindi'],
    'Class 5': ['All', 'English', 'Maths', 'Science', 'Social', 'Hindi'],
    'Class 6': ['All', 'English', 'Maths', 'Science', 'Social', 'Hindi'],
    'Class 7': ['All', 'English', 'Maths', 'Science', 'Social', 'Hindi'],
    'Class 8': ['All', 'English', 'Maths', 'Science', 'Social', 'Hindi'],
    'Class 9': [
      'All',
      'English',
      'Maths',
      'Science',
      'Social',
      'Hindi',
      'Computer'
    ],
    'Class 10': [
      'All',
      'English',
      'Maths',
      'Science',
      'Social',
      'Hindi',
      'Computer'
    ],
    'Class 11': [
      'All',
      'English',
      'Physics',
      'Chemistry',
      'Maths',
      'Biology',
      'Commerce',
      'Computer'
    ],
    'Class 12': [
      'All',
      'English',
      'Physics',
      'Chemistry',
      'Maths',
      'Biology',
      'Commerce',
      'Computer'
    ],
  };

  // ==================== VIDEOS DATA ====================
  // Structure: class -> list of videos
  final Map<String, List<Map<String, String>>> _videosByClass = {
    'Nursery': [
      {
        'title': 'ABC Song - Fun Rhymes',
        'subject': 'ABC',
        'rating': '4.9',
        'duration': '5 min',
        'image': 'https://picsum.photos/seed/abc1/200/300',
        'age': '3+',
      },
      {
        'title': 'Numbers 1-10 Song',
        'subject': 'Numbers',
        'rating': '4.8',
        'duration': '6 min',
        'image': 'https://picsum.photos/seed/num1/200/300',
        'age': '3+',
      },
      {
        'title': 'Color Learning Fun',
        'subject': 'Colors',
        'rating': '4.7',
        'duration': '4 min',
        'image': 'https://picsum.photos/seed/color1/200/300',
        'age': '3+',
      },
      {
        'title': 'Shapes Song for Kids',
        'subject': 'Shapes',
        'rating': '4.8',
        'duration': '5 min',
        'image': 'https://picsum.photos/seed/shape1/200/300',
        'age': '3+',
      },
      {
        'title': 'Twinkle Twinkle Little Star',
        'subject': 'Rhymes',
        'rating': '4.9',
        'duration': '3 min',
        'image': 'https://picsum.photos/seed/rhyme1/200/300',
        'age': '3+',
      },
      {
        'title': 'Old MacDonald Had a Farm',
        'subject': 'Rhymes',
        'rating': '4.8',
        'duration': '4 min',
        'image': 'https://picsum.photos/seed/rhyme2/200/300',
        'age': '3+',
      },
    ],
    'LKG': [
      {
        'title': 'Phonics Song - A to Z',
        'subject': 'English',
        'rating': '4.9',
        'duration': '8 min',
        'image': 'https://picsum.photos/seed/lkg1/200/300',
        'age': '4+',
      },
      {
        'title': 'Counting 1-20',
        'subject': 'Maths',
        'rating': '4.8',
        'duration': '6 min',
        'image': 'https://picsum.photos/seed/lkg2/200/300',
        'age': '4+',
      },
      {
        'title': 'My Family - EVS',
        'subject': 'EVS',
        'rating': '4.7',
        'duration': '7 min',
        'image': 'https://picsum.photos/seed/lkg3/200/300',
        'age': '4+',
      },
      {
        'title': 'Johny Johny Yes Papa',
        'subject': 'Rhymes',
        'rating': '4.9',
        'duration': '3 min',
        'image': 'https://picsum.photos/seed/lkg4/200/300',
        'age': '4+',
      },
    ],
    'UKG': [
      {
        'title': 'Three Letter Words',
        'subject': 'English',
        'rating': '4.8',
        'duration': '10 min',
        'image': 'https://picsum.photos/seed/ukg1/200/300',
        'age': '5+',
      },
      {
        'title': 'Addition for Kids',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '9 min',
        'image': 'https://picsum.photos/seed/ukg2/200/300',
        'age': '5+',
      },
      {
        'title': 'Animals and Birds',
        'subject': 'EVS',
        'rating': '4.7',
        'duration': '8 min',
        'image': 'https://picsum.photos/seed/ukg3/200/300',
        'age': '5+',
      },
    ],
    'Class 1': [
      {
        'title': 'Nouns - English Grammar',
        'subject': 'English',
        'rating': '4.8',
        'duration': '12 min',
        'image': 'https://picsum.photos/seed/c1e/200/300',
        'age': '6+',
      },
      {
        'title': 'Numbers up to 100',
        'subject': 'Maths',
        'rating': '4.7',
        'duration': '15 min',
        'image': 'https://picsum.photos/seed/c1m/200/300',
        'age': '6+',
      },
      {
        'title': 'Plants Around Us',
        'subject': 'EVS',
        'rating': '4.8',
        'duration': '11 min',
        'image': 'https://picsum.photos/seed/c1ev/200/300',
        'age': '6+',
      },
      {
        'title': 'Hindi Varnamala',
        'subject': 'Hindi',
        'rating': '4.9',
        'duration': '10 min',
        'image': 'https://picsum.photos/seed/c1h/200/300',
        'age': '6+',
      },
    ],
    'Class 2': [
      {
        'title': 'Verbs and Tenses',
        'subject': 'English',
        'rating': '4.8',
        'duration': '14 min',
        'image': 'https://picsum.photos/seed/c2e/200/300',
        'age': '7+',
      },
      {
        'title': 'Multiplication Tables',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '18 min',
        'image': 'https://picsum.photos/seed/c2m/200/300',
        'age': '7+',
      },
      {
        'title': 'Our Body Parts',
        'subject': 'EVS',
        'rating': '4.7',
        'duration': '12 min',
        'image': 'https://picsum.photos/seed/c2ev/200/300',
        'age': '7+',
      },
    ],
    'Class 3': [
      {
        'title': 'Reading Comprehension',
        'subject': 'English',
        'rating': '4.8',
        'duration': '20 min',
        'image': 'https://picsum.photos/seed/c3e/200/300',
        'age': '8+',
      },
      {
        'title': 'Fractions Basics',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '16 min',
        'image': 'https://picsum.photos/seed/c3m/200/300',
        'age': '8+',
      },
      {
        'title': 'Water Cycle',
        'subject': 'EVS',
        'rating': '4.8',
        'duration': '14 min',
        'image': 'https://picsum.photos/seed/c3ev/200/300',
        'age': '8+',
      },
    ],
    'Class 4': [
      {
        'title': 'Essay Writing Skills',
        'subject': 'English',
        'rating': '4.7',
        'duration': '22 min',
        'image': 'https://picsum.photos/seed/c4e/200/300',
        'age': '9+',
      },
      {
        'title': 'Geometry - Shapes & Angles',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '25 min',
        'image': 'https://picsum.photos/seed/c4m/200/300',
        'age': '9+',
      },
      {
        'title': 'Solar System',
        'subject': 'Science',
        'rating': '4.8',
        'duration': '20 min',
        'image': 'https://picsum.photos/seed/c4s/200/300',
        'age': '9+',
      },
    ],
    'Class 5': [
      {
        'title': 'Tenses - Complete Guide',
        'subject': 'English',
        'rating': '4.8',
        'duration': '28 min',
        'image': 'https://picsum.photos/seed/c5e/200/300',
        'age': '10+',
      },
      {
        'title': 'Decimals & Percentages',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '24 min',
        'image': 'https://picsum.photos/seed/c5m/200/300',
        'age': '10+',
      },
      {
        'title': 'Human Body Systems',
        'subject': 'Science',
        'rating': '4.7',
        'duration': '26 min',
        'image': 'https://picsum.photos/seed/c5s/200/300',
        'age': '10+',
      },
    ],
    'Class 6': [
      {
        'title': 'Active & Passive Voice',
        'subject': 'English',
        'rating': '4.8',
        'duration': '30 min',
        'image': 'https://picsum.photos/seed/c6e/200/300',
        'age': '11+',
      },
      {
        'title': 'Integers - Full Chapter',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '35 min',
        'image': 'https://picsum.photos/seed/c6m/200/300',
        'age': '11+',
      },
      {
        'title': 'Food & Nutrition',
        'subject': 'Science',
        'rating': '4.8',
        'duration': '28 min',
        'image': 'https://picsum.photos/seed/c6s/200/300',
        'age': '11+',
      },
    ],
    'Class 7': [
      {
        'title': 'Direct & Indirect Speech',
        'subject': 'English',
        'rating': '4.7',
        'duration': '32 min',
        'image': 'https://picsum.photos/seed/c7e/200/300',
        'age': '12+',
      },
      {
        'title': 'Algebra Basics',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '38 min',
        'image': 'https://picsum.photos/seed/c7m/200/300',
        'age': '12+',
      },
      {
        'title': 'Heat & Temperature',
        'subject': 'Science',
        'rating': '4.8',
        'duration': '30 min',
        'image': 'https://picsum.photos/seed/c7s/200/300',
        'age': '12+',
      },
    ],
    'Class 8': [
      {
        'title': 'Grammar - Complete Revision',
        'subject': 'English',
        'rating': '4.8',
        'duration': '40 min',
        'image': 'https://picsum.photos/seed/c8e/200/300',
        'age': '13+',
      },
      {
        'title': 'Linear Equations',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '42 min',
        'image': 'https://picsum.photos/seed/c8m/200/300',
        'age': '13+',
      },
      {
        'title': 'Force & Pressure',
        'subject': 'Science',
        'rating': '4.8',
        'duration': '35 min',
        'image': 'https://picsum.photos/seed/c8s/200/300',
        'age': '13+',
      },
    ],
    'Class 9': [
      {
        'title': 'English Literature - Beehive',
        'subject': 'English',
        'rating': '4.8',
        'duration': '45 min',
        'image': 'https://picsum.photos/seed/c9e/200/300',
        'age': '14+',
      },
      {
        'title': 'Polynomials - Full Chapter',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '50 min',
        'image': 'https://picsum.photos/seed/c9m/200/300',
        'age': '14+',
      },
      {
        'title': 'Matter in Our Surroundings',
        'subject': 'Science',
        'rating': '4.8',
        'duration': '48 min',
        'image': 'https://picsum.photos/seed/c9s/200/300',
        'age': '14+',
      },
      {
        'title': 'India - Size and Location',
        'subject': 'Social',
        'rating': '4.7',
        'duration': '40 min',
        'image': 'https://picsum.photos/seed/c9so/200/300',
        'age': '14+',
      },
    ],
    'Class 10': [
      {
        'title': 'First Flight - Complete',
        'subject': 'English',
        'rating': '4.9',
        'duration': '55 min',
        'image': 'https://picsum.photos/seed/c10e/200/300',
        'age': '15+',
      },
      {
        'title': 'Trigonometry - Full',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '60 min',
        'image': 'https://picsum.photos/seed/c10m/200/300',
        'age': '15+',
      },
      {
        'title': 'Chemical Reactions',
        'subject': 'Science',
        'rating': '4.8',
        'duration': '52 min',
        'image': 'https://picsum.photos/seed/c10s/200/300',
        'age': '15+',
      },
      {
        'title': 'Nationalism in India',
        'subject': 'Social',
        'rating': '4.8',
        'duration': '48 min',
        'image': 'https://picsum.photos/seed/c10so/200/300',
        'age': '15+',
      },
    ],
    'Class 11': [
      {
        'title': 'Physics - Kinematics',
        'subject': 'Physics',
        'rating': '4.9',
        'duration': '65 min',
        'image': 'https://picsum.photos/seed/c11p/200/300',
        'age': '16+',
      },
      {
        'title': 'Chemistry - Atomic Structure',
        'subject': 'Chemistry',
        'rating': '4.8',
        'duration': '60 min',
        'image': 'https://picsum.photos/seed/c11c/200/300',
        'age': '16+',
      },
      {
        'title': 'Maths - Sets & Functions',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '58 min',
        'image': 'https://picsum.photos/seed/c11m/200/300',
        'age': '16+',
      },
      {
        'title': 'Biology - Cell Structure',
        'subject': 'Biology',
        'rating': '4.8',
        'duration': '55 min',
        'image': 'https://picsum.photos/seed/c11b/200/300',
        'age': '16+',
      },
    ],
    'Class 12': [
      {
        'title': 'Physics - Electrostatics',
        'subject': 'Physics',
        'rating': '4.9',
        'duration': '70 min',
        'image': 'https://picsum.photos/seed/c12p/200/300',
        'age': '17+',
      },
      {
        'title': 'Chemistry - Solutions',
        'subject': 'Chemistry',
        'rating': '4.8',
        'duration': '65 min',
        'image': 'https://picsum.photos/seed/c12c/200/300',
        'age': '17+',
      },
      {
        'title': 'Maths - Calculus',
        'subject': 'Maths',
        'rating': '4.9',
        'duration': '72 min',
        'image': 'https://picsum.photos/seed/c12m/200/300',
        'age': '17+',
      },
      {
        'title': 'Biology - Genetics',
        'subject': 'Biology',
        'rating': '4.8',
        'duration': '68 min',
        'image': 'https://picsum.photos/seed/c12b/200/300',
        'age': '17+',
      },
    ],
  };

  // ==================== STATE ====================
  int _selectedClassIndex = 0;
  int _selectedSubjectIndex = 0;
  bool _isClassSelected = false;

  // ==================== GETTERS ====================
  String get _currentClass => _classes[_selectedClassIndex];
  List<String> get _currentSubjects =>
      _subjectsByClass[_currentClass] ?? ['All'];
  String get _currentSubject => _currentSubjects[_selectedSubjectIndex];

  List<Map<String, String>> get _filteredVideos {
    final classVideos = _videosByClass[_currentClass] ?? [];
    if (_selectedSubjectIndex == 0) {
      return classVideos;
    }
    return classVideos
        .where((video) => video['subject'] == _currentSubject)
        .toList();
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _isClassSelected ? _buildVideoScreen() : _buildClassSelection(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: _isClassSelected
          ? IconButton(
        onPressed: () {
          setState(() {
            _isClassSelected = false;
            _selectedSubjectIndex = 0;
          });
        },
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      )
          : null,
      automaticallyImplyLeading: false,
      title: Text(
        _isClassSelected ? '🎓 $_currentClass' : '🎓 School',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
      ],
    );
  }

  Widget _buildClassSelection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Select Your Class',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Choose a class to see subject-wise videos',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Class Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final className = _classes[index];
                final isPrePrimary = index < 3;
                final isPrimary = index >= 3 && index < 8;
                final isMiddle = index >= 8 && index < 11;
                final isHigh = index >= 11;

                Color cardColor;
                IconData icon;
                if (isPrePrimary) {
                  cardColor = Colors.pink;
                  icon = Icons.child_care;
                } else if (isPrimary) {
                  cardColor = Colors.orange;
                  icon = Icons.school;
                } else if (isMiddle) {
                  cardColor = Colors.blue;
                  icon = Icons.menu_book;
                } else {
                  cardColor = Colors.purple;
                  icon = Icons.workspace_premium;
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedClassIndex = index;
                      _selectedSubjectIndex = 0;
                      _isClassSelected = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cardColor.withOpacity(0.3),
                          cardColor.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: cardColor.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: cardColor, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          className,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_videosByClass[className] ?? []).length} videos',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==================== VIDEO SCREEN (class-wise) ====================
  Widget _buildVideoScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Subject Filter Chips
          _buildSubjectChips(),
          const SizedBox(height: 16),
          // Video Grid
          _buildVideoGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSubjectChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _currentSubjects.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedSubjectIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedSubjectIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey[800]!,
                  width: 1,
                ),
              ),
              child: Text(
                _currentSubjects[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoGrid() {
    final videos = _filteredVideos;

    if (videos.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.video_library,
                color: Colors.grey[700],
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'No videos found for $_currentSubject',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final ageColor =
          int.parse(video['age']!.replaceAll('+', '')) <= 4
              ? Colors.green
              : int.parse(video['age']!.replaceAll('+', '')) <= 6
              ? Colors.orange
              : Colors.red;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.shade800.withOpacity(0.2),
                  Colors.deepOrange.shade800.withOpacity(0.2),
                ],
              ),
              border: Border.all(
                color: Colors.orange.shade600.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          video['image']!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 160,
                              width: double.infinity,
                              color: Colors.grey[900],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 160,
                              width: double.infinity,
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.play_circle_outline,
                                color: Colors.orange,
                                size: 50,
                              ),
                            );
                          },
                        ),
                        // Play Button
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius:
                              const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        // Subject Badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              video['subject']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Age Badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ageColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.family_restroom,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  video['age']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Duration Badge
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '⏱ ${video['duration']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Info
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            video['rating']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _currentClass,
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}