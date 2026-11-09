import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/ott/home/screen/play_movie_screen.dart';
import 'package:untitled/feature/ott/home/screen/play_webseries_screen.dart';
import 'package:untitled/feature/ott/content/model/ott_content_model.dart';

class PlayDashboardScreen extends StatelessWidget {
  final OttContentModel content;

  const PlayDashboardScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // Check if it's a webseries
    if (content.categoryName.toLowerCase() == 'webseries' || content.categoryName.toLowerCase() == 'web series') {
      return PlayWebSeriesScreen(contentId: content.id, contentType: "webseries");
    }

    // Otherwise default to movie screen
    return PlayMovieScreen(content: content);
  }
}