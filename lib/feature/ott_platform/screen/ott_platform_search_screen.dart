import 'package:flutter/material.dart';
import 'package:untitled/core/utils/app_color.dart';

class OttPlatformSearchScreen extends StatelessWidget {
   OttPlatformSearchScreen({super.key});

  final List<Map<String, dynamic>> searchResults = const [
    {'title': 'Stranger Things', 'type': 'TV Show', 'year': '2022', 'rating': '4.8'},
    {'title': 'The Crown', 'type': 'TV Show', 'year': '2022', 'rating': '4.7'},
    {'title': 'Breaking Bad', 'type': 'TV Show', 'year': '2010', 'rating': '4.9'},
    {'title': 'Avatar 2', 'type': 'Movie', 'year': '2022', 'rating': '4.6'},
    {'title': 'Top Gun Maverick', 'type': 'Movie', 'year': '2022', 'rating': '4.9'},
    {'title': 'The Witcher', 'type': 'TV Show', 'year': '2023', 'rating': '4.3'},
  ];

  final List<String> popularSearches = [
    'Action', 'Comedy', 'Drama', 'Sci-Fi', 'Thriller', 'Romance',
    'Horror', 'Documentary', 'Anime', 'Kids'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search movies, shows...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
              prefixIcon: Icon(Icons.search, color: AppColors.primary, size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (value) {},
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic, color: AppColors.primary, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent Searches
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Searches",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Clear All",
                    style: TextStyle(color: AppColors.primary, fontSize: 13),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['The Witcher', 'Action Movies', 'Comedy Shows'].map((search) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history, color: AppColors.primary, size: 14),
                      SizedBox(width: 4),
                      Text(search, style: TextStyle(fontSize: 13)),
                    ],
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Popular Searches
            Text(
              "Popular Searches",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: popularSearches.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tag,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            popularSearches[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Search Results (commented)
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: searchResults.length,
            //   itemBuilder: (context, index) {
            //     return _buildResultItem(searchResults[index]);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: Icon(Icons.movie, color: Colors.grey[600]),
        ),
        title: Text(
          item['title'],
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            Text(item['type'], style: TextStyle(fontSize: 12)),
            SizedBox(width: 6),
            Icon(Icons.star, color: Colors.amber, size: 12),
            Text(item['rating'], style: TextStyle(fontSize: 12)),
            SizedBox(width: 6),
            Text(item['year'], style: TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.play_arrow, color: Colors.white, size: 16),
        ),
        onTap: () {},
      ),
    );
  }
}