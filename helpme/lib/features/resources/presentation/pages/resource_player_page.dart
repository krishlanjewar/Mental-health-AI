import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:helpme/features/home/data/services/youtube_audio_service.dart';

class ResourcePlayerPage extends StatefulWidget {
  final String title;
  final String type;
  final String link;

  const ResourcePlayerPage({
    super.key,
    required this.title,
    required this.type,
    required this.link,
  });

  @override
  State<ResourcePlayerPage> createState() => _ResourcePlayerPageState();
}

class _ResourcePlayerPageState extends State<ResourcePlayerPage> {
  late YoutubePlayerController _youtubeController;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isLoading = false;
  final YoutubeAudioService _youtubeAudioService = YoutubeAudioService();

  String? _getSpotifyEmbedUrl(String url) {
    if (url.contains('open.spotify.com')) {
      // Replace /episode/ or /track/ with /embed/episode/ or /embed/track/
      return url.replaceFirst('open.spotify.com/', 'open.spotify.com/embed/');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupControllers();
  }

  void _setupControllers() {
    if (widget.type == 'Video') {
      final videoId = YoutubePlayerController.convertUrlToId(widget.link);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(showFullscreenButton: true),
        );
      }
    } else if (widget.type == 'Audio') {
      _setupAudioPlayer();
    } else if (widget.type == 'Exercise') {
      _setupAudioPlayer();
    } else if (widget.type == 'Article') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openArticleExternally();
      });
    }
  }

  void _setupAudioPlayer() {
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

  Future<void> _playAudio() async {
    try {
      setState(() => _isLoading = true);

      String urlToPlay = widget.link;

      // If it's a YouTube link, extract the audio
      if (widget.link.contains('youtu')) {
        final audioUrl = await _youtubeAudioService.extractAudioUrl(widget.link);
        if (audioUrl == null) {
          // Fallback: open in browser
          if (await canLaunchUrl(Uri.parse(widget.link))) {
            await launchUrl(Uri.parse(widget.link), mode: LaunchMode.externalApplication);
          }
          setState(() => _isLoading = false);
          return;
        }
        urlToPlay = audioUrl;
      }

      await _audioPlayer.setUrl(urlToPlay);
      await _audioPlayer.play();
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading audio: $e')),
        );
      }
    }
  }

  Future<void> _openArticleExternally() async {
    final Uri url = Uri.parse(widget.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open article')),
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
    if (widget.type == 'Video') {
      _youtubeController.close();
    }
    _audioPlayer.dispose();
    _youtubeAudioService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: widget.type == 'Video'
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 500, // kept same height
                      width: 750, // breadth increased by 1.5x
                      margin: const EdgeInsets.all(16.0),
                      child: YoutubePlayer(
                        controller: _youtubeController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : widget.type == 'Audio' || widget.type == 'Exercise'
              ? _getSpotifyEmbedUrl(widget.link) != null
                  ? WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(Uri.parse(_getSpotifyEmbedUrl(widget.link)!)),
                    )
                  : Stack(
                      children: [
                        Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.type == 'Audio'
                                      ? Icons.graphic_eq_outlined
                                      : Icons.spa_outlined,
                                  size: 100,
                                  color: const Color(0xFF8DBDBA),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  widget.title,
                                  style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Column(
                                    children: [
                                      SliderTheme(
                                        data: SliderThemeData(
                                          trackHeight: 4,
                                          activeTrackColor: const Color(0xFF8DBDBA),
                                          inactiveTrackColor:
                                              const Color(0xFF8DBDBA).withOpacity(0.2),
                                          thumbColor: const Color(0xFF8DBDBA),
                                          overlayColor: const Color(0xFF8DBDBA)
                                              .withOpacity(0.5),
                                        ),
                                        child: Slider(
                                          value: _position.inSeconds.toDouble(),
                                          max: _duration.inSeconds.toDouble() > 0
                                              ? _duration.inSeconds.toDouble()
                                              : 1,
                                          onChanged: (value) async {
                                            await _audioPlayer.seek(
                                                Duration(seconds: value.toInt()));
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed:
                                      _isPlaying ? () => _audioPlayer.pause() : _playAudio,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8DBDBA),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isLoading)
                          Container(
                            color: Colors.black.withOpacity(0.3),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Color(0xFF8DBDBA)),
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
                    )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.open_in_browser,
                        size: 80,
                        color: const Color(0xFF8DBDBA),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Opening article in browser...',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    );
  }
}