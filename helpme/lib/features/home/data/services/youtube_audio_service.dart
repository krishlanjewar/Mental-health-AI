import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeAudioService {
  static final YoutubeAudioService _instance = YoutubeAudioService._internal();
  final _yt = YoutubeExplode();

  YoutubeAudioService._internal();

  factory YoutubeAudioService() {
    return _instance;
  }

  // Extract video ID from YouTube URL
  String? _extractVideoId(String videoUrlOrId) {
    // If it looks like a URL, extract the ID
    if (videoUrlOrId.contains('youtu.be')) {
      // Short URL format: youtu.be/VIDEO_ID
      final match = RegExp(r'youtu\.be/([^?]+)').firstMatch(videoUrlOrId);
      return match?.group(1);
    } else if (videoUrlOrId.contains('youtube.com')) {
      // Full URL format: youtube.com/watch?v=VIDEO_ID
      final match = RegExp(r'v=([^&]+)').firstMatch(videoUrlOrId);
      return match?.group(1);
    }
    // Assume it's already a video ID
    return videoUrlOrId;
  }

  Future<String?> extractAudioUrl(String videoUrlOrId) async {
    try {
      // Extract video ID from URL if needed
      final videoId = _extractVideoId(videoUrlOrId);
      if (videoId == null || videoId.isEmpty) {
        debugPrint('Invalid video ID: $videoId');
        return null;
      }

      debugPrint('Extracting audio for video ID: $videoId');

      // Get video manifest
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      debugPrint('Manifest retrieved: ${manifest.audioOnly.length} audio streams');

      // Get the best audio-only stream
      final audioStream = manifest.audioOnly.withHighestBitrate();

      debugPrint('Audio stream URL: ${audioStream.url}');
      return audioStream.url.toString();
    

    } catch (e) {
      debugPrint('Error extracting audio: $e');
      return null;
    }
  }

  void close() {
    _yt.close();
  }
}
