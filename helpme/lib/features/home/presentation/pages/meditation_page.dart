import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:helpme/features/home/data/services/youtube_audio_service.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  late AudioPlayer _audioPlayer;
  String? _playing;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isLoading = false;

  final List<Map<String, String>> _meditations = [
    {
      'title': 'Morning Calm',
      'duration': '10 min',
      'icon': '☀️',
      'videoUrl': 'https://open.spotify.com/track/6wyEM66TNjVD0OmfFGZxKL?si=ZoBBmZ5mSY2q8Hdv8E6QAQ',
      'key': 'morning_calm',
    },
    {
      'title': 'Deep Sleep',
      'duration': '2.5 min',
      'icon': '🌙',
      'videoUrl': 'https://open.spotify.com/track/34B2XFpwTgzk4Gv3Ek8KLM?si=C9vVMZ1nRDaSIiETEqLiaw&context=spotify%3Aplaylist%3A37i9dQZF1DWYcDQ1hSjOpY',
      'key': 'deep_sleep',
    },
    {
      'title': 'Stress Relief',
      'duration': '2 min',
      'icon': '🧘',
      'videoUrl': 'https://open.spotify.com/track/4EVU7XGaZHUCM77W9vm6U9?si=PjpOKhpwQua-85IEEKq-8Q',
      'key': 'stress_relief',
    },
    {
      'title': 'Focus',
      'duration': '2.5 min',
      'icon': '⏱️',
      'videoUrl': 'https://open.spotify.com/track/51vxIDnFJOzotXLQTrwV29?si=iiVtgbcFQ5KIbhgOtjViQw&context=spotify%3Aplaylist%3A37i9dQZF1DWZeKCadgRdKQ',
      'key': 'focus',
    },
  ];

  final YoutubeAudioService _youtubeAudioService = YoutubeAudioService();

  String? _getSpotifyEmbedUrl(String url) {
    if (url.contains('open.spotify.com')) {
      return url.replaceFirst('open.spotify.com/', 'open.spotify.com/embed/');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioListeners();
  }

  void _setupAudioListeners() {
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
    _audioPlayer.durationStream.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d ?? Duration.zero;
        });
      }
    });
    _audioPlayer.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  Future<void> _playAudio(String videoUrl, String key) async {
    try {
      if (_playing == key && _isPlaying) {
        if (_getSpotifyEmbedUrl(videoUrl) != null) {
          // For Spotify, stop playing
          setState(() {
            _playing = null;
          });
          return;
        }
        await _audioPlayer.pause();
        return;
      }

      if (_playing != key) {
        setState(() => _isLoading = true);
        
        if (_getSpotifyEmbedUrl(videoUrl) != null) {
          // For Spotify, just set playing state
          setState(() {
            _playing = key;
            _isLoading = false;
          });
          return;
        }
        
        // Extract audio URL from YouTube video
        final audioUrl = await _youtubeAudioService.extractAudioUrl(videoUrl);
        
        if (audioUrl == null) {
          // Fallback: open in browser
          if (await canLaunchUrl(Uri.parse(videoUrl))) {
            await launchUrl(Uri.parse(videoUrl), mode: LaunchMode.externalApplication);
          }
          setState(() => _isLoading = false);
          return;
        }

        await _audioPlayer.setUrl(audioUrl);
      }

      await _audioPlayer.play();
      setState(() {
        _playing = key;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _youtubeAudioService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text(
          'Meditation',
          style: GoogleFonts.outfit(color: const Color(0xFFE65100)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xFFE65100)),
      ),
      body: Column(
        children: [
          if (_playing != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              height: 300, // Fixed height for consistency
              child: _getSpotifyEmbedUrl(_meditations.firstWhere((m) => m['key'] == _playing)['videoUrl'] ?? '') != null
                  ? WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(Uri.parse(_getSpotifyEmbedUrl(_meditations.firstWhere((m) => m['key'] == _playing)['videoUrl'] ?? '')!)),
                    )
                  : Column(
                      children: [
                        Text(
                          _meditations.firstWhere((m) => m['key'] == _playing)['title'] ?? '',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 4,
                            activeTrackColor: const Color(0xFFE65100),
                            inactiveTrackColor: const Color(0xFFE65100).withValues(alpha: 0.2),
                            thumbColor: const Color(0xFFE65100),
                            overlayColor: const Color(0xFFE65100).withValues(alpha: 0.5),
                          ),
                          child: Slider(
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble() > 0
                                ? _duration.inSeconds.toDouble()
                                : 1,
                            onChanged: (value) async {
                              await _audioPlayer.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_position),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _formatDuration(_duration),
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _meditations.length,
                  itemBuilder: (context, index) {
                    final meditation = _meditations[index];
                    final isPlaying = _playing == meditation['key'];
                    return _buildMeditationCard(
                      meditation['title']!,
                      meditation['duration']!,
                      meditation['icon']!,
                      meditation['videoUrl']!,
                      meditation['key']!,
                      isPlaying,
                    );
                  },
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Color(0xFFE65100)),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading audio...',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
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

  Widget _buildMeditationCard(
    String title,
    String duration,
    String icon,
    String videoUrl,
    String key,
    bool isPlaying,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                duration,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            iconSize: 40,
            color: const Color(0xFFE65100),
            icon: Icon(
              isPlaying && _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
            ),
            onPressed: () => _playAudio(videoUrl, key),
          ),
        ],
      ),
    );
  }
}