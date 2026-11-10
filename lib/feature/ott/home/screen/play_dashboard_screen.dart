import 'package:flutter/material.dart';
import 'package:untitled/feature/ott/home/screen/play_movie_screen.dart';
import 'package:untitled/feature/ott/home/screen/play_webseries_screen.dart';
import 'package:untitled/feature/ott/home/screen/play_tvshows_screen.dart';
import 'package:untitled/feature/ott/content/model/ott_content_model.dart';

class PlayDashboardScreen extends StatelessWidget {
  final OttContentModel content;

  const PlayDashboardScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final categoryName = content.categoryName.toLowerCase().trim();

    // ✅ 1. Web Series Check
    if (categoryName == 'webseries' || categoryName == 'web series') {
      return PlayWebSeriesScreen(content: content);
    }

    // ✅ 2. TV Shows Check
    if (categoryName == 'tvshows' || categoryName == 'tv shows' || categoryName == 'tv show') {
      return PlayTvshowsScreen(content: content);
    }

    // ✅ 3. Otherwise default to Movie/Content screen
    return PlayMovieScreen(content: content);
  }
}