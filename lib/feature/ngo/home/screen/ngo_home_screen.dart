import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import '../../services/screen/donation_details_screen.dart';

class NgoHomeScreen extends StatefulWidget {
  final Function(int index, {String? category})? onNavigate;
  const NgoHomeScreen({super.key, this.onNavigate});

  @override
  State<NgoHomeScreen> createState() => _NgoHomeScreenState();
}

class _NgoHomeScreenState extends State<NgoHomeScreen> {
  static const Color primaryColor = Colors.teal;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Education", "icon": Icons.school, "color": Colors.blue},
    {"name": "Health", "icon": Icons.health_and_safety, "color": Colors.red},
    {"name": "Environment", "icon": Icons.nature, "color": Colors.green},
    {"name": "Animal Welfare", "icon": Icons.pets, "color": Colors.orange},
    {"name": "Women Empowerment", "icon": Icons.woman, "color": Colors.purple},
    {"name": "Child Care", "icon": Icons.child_care, "color": Colors.pink},
    {"name": "Elderly Care", "icon": Icons.elderly, "color": Colors.brown},
    {"name": "All", "icon": Icons.apps, "color": Colors.teal},
  ];

  final List<Map<String, dynamic>> _banners = [
    {
      "title": "Support Education",
      "subtitle": "Help children access quality education",
      "image": "📚",
      "color": Colors.blue,
      "buttonText": "Donate Now",
    },
    {
      "title": "Save Environment",
      "subtitle": "Join the green revolution",
      "image": "🌍",
      "color": Colors.green,
      "buttonText": "Plant Trees",
    },
    {
      "title": "Health for All",
      "subtitle": "Provide healthcare to the needy",
      "image": "🏥",
      "color": Colors.red,
      "buttonText": "Support Health",
    },
  ];

  // ─────────────────────────────────────────────────────────────
  // OPEN DONATIONS
  // ─────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _openDonations = [
    {
      "name": "Education Fund",
      "raised": 7500,
      "target": 10000,
      "color": Colors.blue,
      "category": "Education",
      "rating": 4.6,
      "location": "Mumbai, Maharashtra",
      "beneficiaries": 1200,
      "founded": "2015",
      "imageUrl":
      "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
      "description":
      "We work to provide quality education to underprivileged children. Our mission is to ensure every child has access to education and the opportunity to build a better future.",
      "gallery": [
        "https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=400",
        "https://images.unsplash.com/photo-1509062522246-3755977927d7?w=400",
        "https://images.unsplash.com/photo-1588072432836-e10032774350?w=400",
        "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
        "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400",
        "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400",
      ],
      "team": [
        {
          "name": "Priya Sharma",
          "role": "Founder",
          "image":
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200"
        },
        {
          "name": "Rahul Verma",
          "role": "Director",
          "image":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200"
        },
        {
          "name": "Anita Desai",
          "role": "Volunteer Lead",
          "image":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200"
        },
        {
          "name": "Vikram Singh",
          "role": "Field Manager",
          "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200"
        },
      ],
      "impact": [
        {"icon": "school", "value": "1200+", "label": "Children Educated"},
        {"icon": "book", "value": "25", "label": "Schools Supported"},
        {"icon": "family", "value": "500+", "label": "Families Helped"},
        {"icon": "star", "value": "15", "label": "Awards Won"},
      ],
      "timeline": [
        {
          "date": "Jan 2024",
          "title": "Campaign Started",
          "desc": "Launched with a goal of ₹10,000"
        },
        {
          "date": "Mar 2024",
          "title": "First Milestone",
          "desc": "Raised 25% — 300 children enrolled"
        },
        {
          "date": "Jun 2024",
          "title": "Expansion",
          "desc": "Extended to 5 more villages"
        },
        {
          "date": "Dec 2024",
          "title": "Goal Target",
          "desc": "Expected completion date"
        },
      ],
    },
    {
      "name": "Medical Camp",
      "raised": 4500,
      "target": 8000,
      "color": Colors.red,
      "category": "Health",
      "rating": 4.8,
      "location": "Delhi NCR",
      "beneficiaries": 850,
      "founded": "2018",
      "imageUrl":
      "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400",
      "description":
      "Free healthcare services for rural communities. We organize medical camps, distribute medicines, and provide preventive care to those who cannot afford it.",
      "gallery": [
        "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=400",
        "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400",
        "https://images.unsplash.com/photo-1588072432836-e10032774350?w=400",
      ],
      "team": [
        {
          "name": "Dr. Kavita Nair",
          "role": "Lead Doctor",
          "image":
          "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200"
        },
        {
          "name": "Suresh Menon",
          "role": "Coordinator",
          "image":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200"
        },
      ],
      "impact": [
        {"icon": "people", "value": "850+", "label": "Patients Treated"},
        {"icon": "favorite", "value": "40", "label": "Medical Camps"},
        {"icon": "star", "value": "8", "label": "Partner Hospitals"},
        {"icon": "book", "value": "12", "label": "Health Programs"},
      ],
      "timeline": [
        {
          "date": "Feb 2024",
          "title": "Camp Launch",
          "desc": "Started with ₹8,000 goal"
        },
        {
          "date": "Apr 2024",
          "title": "Milestone 1",
          "desc": "500 patients treated"
        },
        {
          "date": "Aug 2024",
          "title": "Expansion",
          "desc": "Added 3 new districts"
        },
        {
          "date": "Jan 2025",
          "title": "Target Complete",
          "desc": "Expected finish"
        },
      ],
    },
    {
      "name": "Tree Plantation",
      "raised": 3000,
      "target": 5000,
      "color": Colors.green,
      "category": "Environment",
      "rating": 4.4,
      "location": "Bengaluru, Karnataka",
      "beneficiaries": 3000,
      "founded": "2019",
      "imageUrl":
      "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400",
      "description":
      "Planting trees for a greener future. Every donation plants and maintains a sapling for its first year of growth, ensuring a healthy ecosystem.",
      "gallery": [
        "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400",
        "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400",
      ],
      "team": [
        {
          "name": "Arun Kumar",
          "role": "Green Lead",
          "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200"
        },
      ],
      "impact": [
        {"icon": "nature", "value": "15000+", "label": "Trees Planted"},
        {"icon": "people", "value": "2000+", "label": "Volunteers"},
        {"icon": "star", "value": "6", "label": "Cities Covered"},
        {"icon": "family", "value": "300", "label": "Communities"},
      ],
      "timeline": [
        {
          "date": "Mar 2024",
          "title": "Kickoff",
          "desc": "Target ₹5,000 for 500 saplings"
        },
        {
          "date": "May 2024",
          "title": "1000 Saplings",
          "desc": "First month milestone"
        },
        {
          "date": "Sep 2024",
          "title": "Monsoon Drive",
          "desc": "Massive plantation drive"
        },
        {
          "date": "Feb 2025",
          "title": "Final Stretch",
          "desc": "Last 500 saplings"
        },
      ],
    },
    {
      "name": "Animal Shelter",
      "raised": 2000,
      "target": 6000,
      "color": Colors.orange,
      "category": "Animal Welfare",
      "rating": 4.7,
      "location": "Pune, Maharashtra",
      "beneficiaries": 400,
      "founded": "2017",
      "imageUrl":
      "https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400",
      "description":
      "Providing shelter, food, and medical care for stray animals. We rescue injured animals and find them loving homes.",
      "gallery": [
        "https://images.unsplash.com/photo-1545249390-6bdfa286032f?w=400",
        "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400",
      ],
      "team": [
        {
          "name": "Ravi Pawar",
          "role": "Rescue Head",
          "image":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200"
        },
        {
          "name": "Pooja Shah",
          "role": "Veterinarian",
          "image":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200"
        },
      ],
      "impact": [
        {"icon": "favorite", "value": "400+", "label": "Animals Rescued"},
        {"icon": "family", "value": "250", "label": "Adoptions"},
        {"icon": "star", "value": "5", "label": "Shelters"},
        {"icon": "people", "value": "80", "label": "Volunteers"},
      ],
      "timeline": [
        {
          "date": "Apr 2024",
          "title": "Shelter Launch",
          "desc": "Started with ₹6,000 goal"
        },
        {
          "date": "Jul 2024",
          "title": "100 Rescues",
          "desc": "First milestone reached"
        },
        {
          "date": "Nov 2024",
          "title": "New Shelter",
          "desc": "Second shelter opened"
        },
        {
          "date": "Mar 2025",
          "title": "Final Goal",
          "desc": "Complete funding needed"
        },
      ],
    },
  ];

  // ─────────────────────────────────────────────────────────────
  // ALL DONATIONS
  // ─────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _allDonations = [
    {
      "name": "Women Empowerment",
      "raised": 12000,
      "target": 15000,
      "color": Colors.purple,
      "category": "Women Empowerment",
      "rating": 4.9,
      "location": "Jaipur, Rajasthan",
      "beneficiaries": 600,
      "founded": "2016",
      "imageUrl":
      "https://images.unsplash.com/photo-1573496799652-408c2ac9fe98?w=400",
      "description":
      "Empowering women through education, skill development, and financial independence. We run vocational training centers and self-help groups.",
      "gallery": [
        "https://images.unsplash.com/photo-1573496799652-408c2ac9fe98?w=400",
        "https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=400",
      ],
      "team": [
        {
          "name": "Sunita Devi",
          "role": "Founder",
          "image":
          "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200"
        },
      ],
      "impact": [
        {"icon": "people", "value": "600+", "label": "Women Trained"},
        {"icon": "star", "value": "30", "label": "Self-Help Groups"},
        {"icon": "school", "value": "15", "label": "Training Centers"},
        {"icon": "favorite", "value": "120", "label": "Businesses Started"},
      ],
      "timeline": [
        {
          "date": "Jan 2024",
          "title": "Program Launch",
          "desc": "Started with 100 women"
        },
        {
          "date": "Jun 2024",
          "title": "Scale Up",
          "desc": "Reached 400 women"
        },
        {
          "date": "Dec 2024",
          "title": "Expansion",
          "desc": "Added 2 new districts"
        },
        {
          "date": "Apr 2025",
          "title": "Target",
          "desc": "600 women by year-end"
        },
      ],
    },
    {
      "name": "Child Education",
      "raised": 8000,
      "target": 10000,
      "color": Colors.pink,
      "category": "Child Care",
      "rating": 4.6,
      "location": "Kolkata, West Bengal",
      "beneficiaries": 900,
      "founded": "2020",
      "imageUrl":
      "https://images.unsplash.com/photo-1588072432836-e10032774350?w=400",
      "description":
      "Ensuring every child gets access to quality education regardless of their background. We provide books, uniforms, and tuition support.",
      "gallery": [
        "https://images.unsplash.com/photo-1588072432836-e10032774350?w=400",
        "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400",
      ],
      "team": [
        {
          "name": "Anjali Bose",
          "role": "Director",
          "image":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200"
        },
      ],
      "impact": [
        {"icon": "school", "value": "900+", "label": "Children Helped"},
        {"icon": "book", "value": "40", "label": "Schools Partnered"},
        {"icon": "family", "value": "700+", "label": "Families Supported"},
        {"icon": "star", "value": "10", "label": "Awards"},
      ],
      "timeline": [
        {
          "date": "Feb 2024",
          "title": "Kickoff",
          "desc": "Started in 5 schools"
        },
        {
          "date": "May 2024",
          "title": "Milestone 1",
          "desc": "Reached 500 children"
        },
        {
          "date": "Oct 2024",
          "title": "Expansion",
          "desc": "Partnered with 20 more schools"
        },
        {
          "date": "Mar 2025",
          "title": "Final Goal",
          "desc": "Hit 1000 children target"
        },
      ],
    },
    {
      "name": "Clean Water",
      "raised": 5000,
      "target": 7000,
      "color": Colors.cyan,
      "category": "Environment",
      "rating": 4.5,
      "location": "Rural Gujarat",
      "beneficiaries": 2500,
      "founded": "2018",
      "imageUrl":
      "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400",
      "description":
      "Providing clean drinking water to remote villages. We install hand pumps, water filters, and rainwater harvesting systems.",
      "gallery": [
        "https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400",
        "https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400",
      ],
      "team": [
        {
          "name": "Mahesh Patel",
          "role": "Project Lead",
          "image":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200"
        },
      ],
      "impact": [
        {"icon": "people", "value": "2500+", "label": "People Served"},
        {"icon": "star", "value": "45", "label": "Villages Covered"},
        {"icon": "favorite", "value": "120", "label": "Hand Pumps"},
        {"icon": "family", "value": "500", "label": "Families"},
      ],
      "timeline": [
        {
          "date": "Mar 2024",
          "title": "Pilot",
          "desc": "First 5 villages"
        },
        {
          "date": "Jun 2024",
          "title": "1000 People",
          "desc": "Milestone reached"
        },
        {
          "date": "Nov 2024",
          "title": "Scale Up",
          "desc": "25 more villages"
        },
        {
          "date": "Apr 2025",
          "title": "Goal",
          "desc": "45 villages target"
        },
      ],
    },
    {
      "name": "Food Distribution",
      "raised": 6000,
      "target": 9000,
      "color": Colors.orange,
      "category": "Health",
      "rating": 4.7,
      "location": "Chennai, Tamil Nadu",
      "beneficiaries": 1800,
      "founded": "2019",
      "imageUrl":
      "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=400",
      "description":
      "Distributing nutritious meals to homeless individuals, daily wage workers, and families in need. We run community kitchens across the city.",
      "gallery": [
        "https://images.unsplash.com/photo-1593113598332-cd288d649433?w=400",
        "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400",
      ],
      "team": [
        {
          "name": "Karthik Iyer",
          "role": "Operations Head",
          "image":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200"
        },
      ],
      "impact": [
        {"icon": "people", "value": "1800+", "label": "Daily Meals"},
        {"icon": "favorite", "value": "5", "label": "Community Kitchens"},
        {"icon": "family", "value": "800+", "label": "Families Fed"},
        {"icon": "star", "value": "3", "label": "Cities Covered"},
      ],
      "timeline": [
        {
          "date": "Jan 2024",
          "title": "Started",
          "desc": "1 kitchen in Chennai"
        },
        {
          "date": "Apr 2024",
          "title": "Scale",
          "desc": "Expanded to 3 kitchens"
        },
        {
          "date": "Sep 2024",
          "title": "Growth",
          "desc": "1000 meals per day"
        },
        {
          "date": "Feb 2025",
          "title": "Target",
          "desc": "1800 meals per day"
        },
      ],
    },
  ];

  final CarouselSliderController _carouselController =
  CarouselSliderController();
  int _currentBannerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ── Banner Slider ──
          SliverToBoxAdapter(
            child: SizedBox(
               height: 200,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(child: Container(color: Colors.teal,)),
                      Expanded(child: Container(color: Colors.white70,)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: CarouselSlider(
                            controller: _carouselController,
                            items:
                            _banners.map((b) => _buildBannerCard(b)).toList(),
                            options: CarouselOptions(
                              height: 180,
                              viewportFraction: 1,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              onPageChanged: (index, reason) {
                                setState(() => _currentBannerIndex = index);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _banners.length,
                                (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentBannerIndex == index ? 24 : 8,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentBannerIndex == index
                                    ? primaryColor
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Sticky Search ──
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchBoxDelegate(
              onSearchTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Search'),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      body: const Center(child: Text('Search Screen')),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Categories ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Categories",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) =>
                        _buildCategoryCard(index),
                  ),
                ],
              ),
            ),
          ),

          // ── Open Donations ──
          SliverToBoxAdapter(
            child: Container(
              color: Colors.teal.shade50,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Open Donations",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 400,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: _openDonations.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                       crossAxisSpacing: 10,
                       mainAxisSpacing: 10,
                       childAspectRatio: 0.7
                      ),
                      itemBuilder: (context, index) {
                        return _buildDonationCard(_openDonations[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── All Donations ──
          SliverToBoxAdapter(
            child: Container(
              color: Colors.teal.shade100,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All Donations",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 400,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: _allDonations.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7
                      ),
                      itemBuilder: (context, index) {
                        return _buildDonationCard(_openDonations[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BANNER CARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildBannerCard(Map<String, dynamic> banner) {
    return Card(
      elevation: 0.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: banner["color"],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    banner["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    banner["subtitle"],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                           DonationDetailsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: banner["color"],
                    ),
                    child: Text(banner["buttonText"]),
                  ),
                ],
              ),
            ),
            Text(banner["image"], style: const TextStyle(fontSize: 40)),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CATEGORY CARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildCategoryCard(int index) {
    final category = _categories[index];
    return InkWell(
      onTap: () {
        widget.onNavigate?.call(1, category: category["name"]);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: category["color"].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category["icon"],
                color: category["color"],
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category["name"],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DONATION CARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildDonationCard(Map<String, dynamic> donation) {
    final progress =
    (donation["raised"] / donation["target"]).clamp(0.0, 1.0);
    final color = donation["color"] as Color? ?? primaryColor;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DonationDetailsScreen(donationData: donation),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:
          Border.all(color: primaryColor.withOpacity(0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + badges
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14)),
                    child: Image.network(
                      donation["imageUrl"],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  if (donation["category"] != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          donation["category"],
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  if (donation["rating"] != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 11),
                            const SizedBox(width: 2),
                            Text(
                              "${donation["rating"]}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donation["name"] ?? "",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  if (donation["location"] != null)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 11, color: Colors.grey[600]),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            donation["location"],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      color: color,
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${donation["raised"]}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        "₹${donation["target"]}",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${(progress * 100).toStringAsFixed(0)}% funded",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      Text(
                        "${donation["beneficiaries"] ?? 0}+ helped",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[600],
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
  }
}

// ═══════════════════════════════════════════════════════════════════
// STICKY SEARCH BOX
// ═══════════════════════════════════════════════════════════════════
class _StickySearchBoxDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback onSearchTap;

  _StickySearchBoxDelegate({required this.onSearchTap});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: maxExtent,
        padding: const EdgeInsets.symmetric(horizontal: 16,),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.teal,width: 0.3),
          borderRadius: BorderRadius.circular(12)
        ),
        child: InkWell(
          onTap: onSearchTap,
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600], size: 22),
              const SizedBox(width: 12),
              Text(
                "Search here...",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}