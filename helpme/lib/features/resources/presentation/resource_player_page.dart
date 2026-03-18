import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter_html/flutter_html.dart';

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

  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.type == 'Video' ||
        widget.type == 'Audio' ||
        widget.type == 'Exercise') {

      final videoId = YoutubePlayerController.convertUrlToId(widget.link);

      _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );

      _controller!.loadVideoById(videoId: videoId!);
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: widget.type == 'Article'
            ? SingleChildScrollView(
                child: Html(
                  data: """
                  <h2>${widget.title}</h2>
                  <p>
                  Anxiety is a natural human response to stress. It can help us
                  stay alert and focused, but excessive anxiety can interfere
                  with daily life. Understanding anxiety helps individuals
                  recognize triggers and develop coping strategies.
                  </p>

                  <p>
                  Common techniques to manage anxiety include breathing
                  exercises, mindfulness, regular physical activity,
                  and healthy sleep habits.
                  </p>

                  <p>
                  If anxiety becomes overwhelming, seeking professional
                  support from counselors or mental health professionals
                  can be helpful.
                  </p>
                  """,
                ),
              )

            : YoutubePlayer(
                controller: _controller!,
                aspectRatio: 16 / 9,
              ),
      ),
    );
  }
}