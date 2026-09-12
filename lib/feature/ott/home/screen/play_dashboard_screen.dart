import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/feature/ott/home/screen/play_movie_screen.dart';
import 'package:untitled/feature/ott/home/screen/play_webseries_screen.dart';

class PlayDashboardScreen extends StatelessWidget {
  final int contentId;
  final String contentType;
  const PlayDashboardScreen({super.key, required this.contentId, required this.contentType});

  @override
  Widget build(BuildContext context) {
    if(contentType=="webseries"){
      return PlayWebSeriesScreen(contentId: contentId,contentType: "webseries",);
    }
    return PlayMovieScreen(contentId: contentId, contentType: contentType);
  }
}
