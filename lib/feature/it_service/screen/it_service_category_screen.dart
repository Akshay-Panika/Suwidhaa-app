import 'package:flutter/material.dart';
import 'it_service_details_screen.dart';

class ItServiceCategoryScreen extends StatefulWidget {
  final int initialIndex;

  const ItServiceCategoryScreen({super.key, this.initialIndex = 0});

  @override
  State<ItServiceCategoryScreen> createState() => _ItServiceCategoryScreenState();
}

class _ItServiceCategoryScreenState extends State<ItServiceCategoryScreen> {
  late int _selectedCategoryIndex;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Development', 'icon': Icons.code_rounded, 'color': const Color(0xFF6366F1)},
    {'name': 'Design', 'icon': Icons.design_services_rounded, 'color': const Color(0xFF0EA5E9)},
    {'name': 'Marketing', 'icon': Icons.trending_up_rounded, 'color': const Color(0xFF10B981)},
    {'name': 'Consulting', 'icon': Icons.psychology_rounded, 'color': const Color(0xFFF43F5E)},
    {'name': 'DevOps', 'icon': Icons.build_rounded, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Support', 'icon': Icons.support_agent_rounded, 'color': const Color(0xFFF59E0B)},
  ];

  final Map<int, List<Map<String, dynamic>>> servicesByCategory = {
    0: [
      {
        'title': 'Mobile App Development',
        'desc': 'Native & cross-platform apps for iOS and Android with stunning UI.',
        'imageUrl': 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&q=80',
        'tag': 'Premium',
        'color': const Color(0xFF6366F1),
        'rating': 4.9,
        'reviews': 128,
        'price': '₹15,000',
      },
      {
        'title': 'Web Development',
        'desc': 'Full-stack web applications with modern frameworks and cloud integration.',
        'imageUrl': 'https://images.unsplash.com/photo-1547658719-da2b81166b58?w=400&q=80',
        'tag': 'Trending',
        'color': const Color(0xFF6366F1),
        'rating': 4.8,
        'reviews': 96,
        'price': '₹12,000',
      },
      {
        'title': 'IoT Solutions',
        'desc': 'Smart device integration and automation for industrial applications.',
        'imageUrl': 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=400&q=80',
        'tag': 'Next-Gen',
        'color': const Color(0xFF6366F1),
        'rating': 4.7,
        'reviews': 45,
        'price': '₹20,000',
      },
      {
        'title': 'Blockchain Development',
        'desc': 'Smart contracts, DApps, and decentralized solutions.',
        'imageUrl': 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=400&q=80',
        'tag': 'New',
        'color': const Color(0xFF6366F1),
        'rating': 4.6,
        'reviews': 34,
        'price': '₹25,000',
      },
      {
        'title': 'AI/ML Solutions',
        'desc': 'Machine learning models, AI chatbots, and predictive analytics.',
        'imageUrl': 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=400&q=80',
        'tag': 'AI Powered',
        'color': const Color(0xFF6366F1),
        'rating': 4.9,
        'reviews': 56,
        'price': '₹22,000',
      },
    ],
    1: [
      {
        'title': 'UI/UX Design',
        'desc': 'User-centric designs with interactive prototypes and wireframes.',
        'imageUrl': 'https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?w=400&q=80',
        'tag': 'Top Rated',
        'color': const Color(0xFF0EA5E9),
        'rating': 4.9,
        'reviews': 156,
        'price': '₹10,000',
      },
      {
        'title': 'Graphic Design',
        'desc': 'Corporate branding, logo design, and visual communication.',
        'imageUrl': 'https://images.unsplash.com/photo-1626785774573-4b799315345d?w=400&q=80',
        'tag': 'Creative',
        'color': const Color(0xFF0EA5E9),
        'rating': 4.8,
        'reviews': 89,
        'price': '₹8,000',
      },
      {
        'title': 'Motion Graphics',
        'desc': 'Animated videos, explainers, and motion design for marketing.',
        'imageUrl': 'https://images.unsplash.com/photo-1611162616475-46b635cb6868?w=400&q=80',
        'tag': 'Popular',
        'color': const Color(0xFF0EA5E9),
        'rating': 4.6,
        'reviews': 67,
        'price': '₹12,000',
      },
      {
        'title': 'Product Design',
        'desc': 'End-to-end product design from concept to prototype.',
        'imageUrl': 'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?w=400&q=80',
        'tag': 'Expert',
        'color': const Color(0xFF0EA5E9),
        'rating': 4.7,
        'reviews': 45,
        'price': '₹14,000',
      },
    ],
    2: [
      {
        'title': 'Digital Marketing',
        'desc': 'SEO, PPC, social media marketing, and analytics.',
        'imageUrl': 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&q=80',
        'tag': 'Growth',
        'color': const Color(0xFF10B981),
        'rating': 4.7,
        'reviews': 112,
        'price': '₹9,000',
      },
      {
        'title': 'Content Marketing',
        'desc': 'Blog writing, copywriting, and content strategy.',
        'imageUrl': 'https://images.unsplash.com/photo-1432888498266-38ffec3eaf0a?w=400&q=80',
        'tag': 'Engaging',
        'color': const Color(0xFF10B981),
        'rating': 4.5,
        'reviews': 78,
        'price': '₹7,000',
      },
      {
        'title': 'Social Media Management',
        'desc': 'Complete social media strategy, content creation, and engagement.',
        'imageUrl': 'https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?w=400&q=80',
        'tag': 'Popular',
        'color': const Color(0xFF10B981),
        'rating': 4.6,
        'reviews': 92,
        'price': '₹6,000',
      },
      {
        'title': 'Email Marketing',
        'desc': 'Campaign design, automation, and analytics for email marketing.',
        'imageUrl': 'https://images.unsplash.com/photo-1557200134-90327ee9febe?w=400&q=80',
        'tag': 'Effective',
        'color': const Color(0xFF10B981),
        'rating': 4.4,
        'reviews': 56,
        'price': '₹5,000',
      },
    ],
    3: [
      {
        'title': 'IT Consulting',
        'desc': 'Strategic technology planning and digital transformation.',
        'imageUrl': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400&q=80',
        'tag': 'Expert',
        'color': const Color(0xFFF43F5E),
        'rating': 4.9,
        'reviews': 45,
        'price': '₹25,000',
      },
      {
        'title': 'Cloud Services',
        'desc': 'AWS, Azure, and GCP implementation and management.',
        'imageUrl': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&q=80',
        'tag': 'Enterprise',
        'color': const Color(0xFFF43F5E),
        'rating': 4.8,
        'reviews': 34,
        'price': '₹18,000',
      },
      {
        'title': 'Cybersecurity',
        'desc': 'Security audits, penetration testing, and compliance solutions.',
        'imageUrl': 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=400&q=80',
        'tag': 'Secure',
        'color': const Color(0xFFF43F5E),
        'rating': 4.7,
        'reviews': 28,
        'price': '₹20,000',
      },
      {
        'title': 'Data Analytics',
        'desc': 'Business intelligence, data visualization, and predictive modeling.',
        'imageUrl': 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&q=80',
        'tag': 'Insightful',
        'color': const Color(0xFFF43F5E),
        'rating': 4.6,
        'reviews': 39,
        'price': '₹16,000',
      },
    ],
    4: [
      {
        'title': 'CI/CD Pipeline Setup',
        'desc': 'Automated deployment pipelines with Jenkins, GitLab CI, and GitHub Actions.',
        'imageUrl': 'https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?w=400&q=80',
        'tag': 'Automation',
        'color': const Color(0xFF8B5CF6),
        'rating': 4.8,
        'reviews': 56,
        'price': '₹15,000',
      },
      {
        'title': 'Kubernetes & Docker',
        'desc': 'Container orchestration with Kubernetes and Docker implementation.',
        'imageUrl': 'https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?w=400&q=80',
        'tag': 'Enterprise',
        'color': const Color(0xFF8B5CF6),
        'rating': 4.9,
        'reviews': 78,
        'price': '₹18,000',
      },
      {
        'title': 'AWS Cloud Services',
        'desc': 'AWS infrastructure setup, management, and optimization.',
        'imageUrl': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&q=80',
        'tag': 'Cloud',
        'color': const Color(0xFF8B5CF6),
        'rating': 4.7,
        'reviews': 92,
        'price': '₹20,000',
      },
      {
        'title': 'Infrastructure as Code',
        'desc': 'Terraform, Ansible, and CloudFormation for infrastructure automation.',
        'imageUrl': 'https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9?w=400&q=80',
        'tag': 'Automation',
        'color': const Color(0xFF8B5CF6),
        'rating': 4.6,
        'reviews': 45,
        'price': '₹14,000',
      },
      {
        'title': 'Monitoring & Logging',
        'desc': 'Prometheus, Grafana, ELK stack for monitoring and logging.',
        'imageUrl': 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&q=80',
        'tag': 'Observability',
        'color': const Color(0xFF8B5CF6),
        'rating': 4.5,
        'reviews': 34,
        'price': '₹12,000',
      },
    ],
    5: [
      {
        'title': '24/7 Technical Support',
        'desc': 'Round-the-clock technical support for your IT infrastructure.',
        'imageUrl': 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400&q=80',
        'tag': '24/7',
        'color': const Color(0xFFF59E0B),
        'rating': 4.9,
        'reviews': 156,
        'price': '₹10,000',
      },
      {
        'title': 'Help Desk Services',
        'desc': 'Professional help desk support for all your IT queries.',
        'imageUrl': 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=400&q=80',
        'tag': 'Responsive',
        'color': const Color(0xFFF59E0B),
        'rating': 4.7,
        'reviews': 89,
        'price': '₹8,000',
      },
      {
        'title': 'Server Maintenance',
        'desc': 'Regular server maintenance, updates, and security patches.',
        'imageUrl': 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&q=80',
        'tag': 'Reliable',
        'color': const Color(0xFFF59E0B),
        'rating': 4.8,
        'reviews': 67,
        'price': '₹12,000',
      },
      {
        'title': 'Data Backup & Recovery',
        'desc': 'Automated data backup solutions and disaster recovery plans.',
        'imageUrl': 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&q=80',
        'tag': 'Secure',
        'color': const Color(0xFFF59E0B),
        'rating': 4.6,
        'reviews': 78,
        'price': '₹9,000',
      },
      {
        'title': 'Network Support',
        'desc': 'Network setup, troubleshooting, and performance optimization.',
        'imageUrl': 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=400&q=80',
        'tag': 'Expert',
        'color': const Color(0xFFF59E0B),
        'rating': 4.5,
        'reviews': 56,
        'price': '₹11,000',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    // Ensure the initial index is valid
    _selectedCategoryIndex = widget.initialIndex.clamp(0, categories.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final currentServices = servicesByCategory[_selectedCategoryIndex] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categories[_selectedCategoryIndex]['name'],
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded, color: Color(0xFF64748B)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 80,
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                bool isSelected = _selectedCategoryIndex == index;
                final Color color = cat['color'] as Color;

                return InkWell(
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? color : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? color.withOpacity(0.15) : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
                            ),
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: isSelected ? color : Colors.grey[500],
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? color : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Service List
          Expanded(
            child: currentServices.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: Color(0xFF64748B)),
                  SizedBox(height: 12),
                  Text(
                    "No services found",
                    style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: currentServices.length,
              itemBuilder: (context, index) {
                final service = currentServices[index];
                return _buildServiceCard(context, service);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    final Color color = service['color'] as Color;
    final double rating = service['rating'] ?? 4.5;
    final int reviews = service['reviews'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              service['imageUrl'],
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 120,
                  color: Colors.grey[100],
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.grey[100],
                child: Icon(Icons.image_outlined, color: Colors.grey[400], size: 40),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service['tag'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  service['desc'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber[600], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          ' ($reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      service['price'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItServiceDetailsScreen(serviceData: service),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Quote',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
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