import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoListScreen extends StatefulWidget {
  final String playlistId;

  const VideoListScreen({super.key, required this.playlistId});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // For a playlist, we might need to fetch the videos using YouTube API or just play the playlist.
    // However, youtube_player_flutter creates a player.
    // For a list of videos to select and play, we usually need the video IDs.
    // Since we don't have a backend fetching the playlist items, we might need a list of video IDs
    // or use a playlist player.
    // Let's assume for now we just play the playlist directly or show a list if we had the data.
    // The simplest "embedded" experience for a playlist is often just loading the playlist in the player.

    _controller = YoutubePlayerController(
      initialVideoId: _playlist.first, // Start with first video
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  // Placeholder list of video IDs - in a real app updates, you'd fetch this from YouTube Data API
  // or hardcode the specific video IDs for the category if not using the Data API.
  // Since we only have a playlist ID usually, we can't easily get the video list without an API key.
  // ALTERNATIVE: Use a WebView to show the playlist or just hardcode specific important videos for now.
  // Let's assume the user will provide specific VIDEO IDs or we set up a player that takes a playlist?
  // youtube_player_flutter supports playlists? Yes, but usually via a list of IDs.

  final List<String> _playlist = [
    'gQDldM2Qkzg', // Sample 1
    'HuFCkS5D_gU', // Sample 2
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _playlist.length,
      itemBuilder: (context, index) {
        final videoId = _playlist[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                    disableDragSeek: true,
                    loop: false,
                    isLive: false,
                    forceHD: false,
                    enableCaption: true,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
              ),
              ListTile(
                title: Text('Video ${index + 1}'),
                subtitle: const Text('Tap to play'),
              ),
            ],
          ),
        );
      },
    );
  }
}
