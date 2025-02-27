import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:wagl/home/video_editor/preview.dart';

class TrimmerView extends StatefulWidget {
  final File file;

  const TrimmerView(this.file, {Key? key}) : super(key: key);
  @override
  State<TrimmerView> createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
    print("here is the video initState trimmer");
    super.initState();
    _loadVideo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_trimmer.videoPlayerController != null) {
        final int duration = _trimmer.videoPlayerController!.value.duration.inSeconds;
        if (duration > 30) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Video too long, consider trimming it shorter.")),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    print("here is the video Disposed trimmer");
    print("here is the video Disposed trimmer");
    _trimmer.videoPlayerController?.dispose(); // Release VideoPlayer resources
    _trimmer.dispose(); // Release Trimmer resources
    super.dispose();
  }
  void _loadVideo() {
    debugPrint("Error loading video: ");
    try {
      _trimmer.loadVideo(videoFile: widget.file);
    } catch (e) {
      debugPrint("Error loading video: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load video. Please try again.")),
      );
    }
  }

  _saveVideo() {
    setState(() {
      _progressVisibility = true;
    });

    _trimmer.saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      videoFileName: DateTime.now().microsecondsSinceEpoch.toString(),

      onSave: (outputPath) {
        setState(() {
          _progressVisibility = false;
        });
        debugPrint('OUTPUT PATH: $outputPath');
        print('\n\n Here is the Path OUTPUT PATH: $outputPath \n\n');
        debugPrint('OUTPUT PATH: $outputPath');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Preview(outputPath),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Video Trimmer"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: const LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: _progressVisibility ? null : () => _saveVideo(),
                  child: const Text("SAVE"),
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TrimViewer(
                      showDuration: true,
                      type: ViewerType.auto,
                      trimmer: _trimmer,
                      viewerHeight: 40.0,
                      viewerWidth: MediaQuery.of(context).size.width,

                      durationStyle: DurationStyle.FORMAT_MM_SS,
                      maxVideoLength: Duration(seconds: _trimmer.videoPlayerController!.value.duration.inSeconds),
                      // maxVideoLength: Duration(seconds: 30),
                      editorProperties: TrimEditorProperties(
                        borderPaintColor: Colors.yellow,
                        borderWidth: 4,
                        borderRadius: 5,
                        circlePaintColor: Colors.yellow.shade800,
                      ),
                      areaProperties: TrimAreaProperties.edgeBlur(
                        thumbnailQuality: 5,
                      ),
                      onChangeStart: (value) => _startValue = value,
                      onChangeEnd: (value) => _endValue = value,
                      onChangePlaybackState: (value) =>
                          setState(() => _isPlaying = value),
                    ),
                  ),
                ),
                TextButton(
                  child: _isPlaying
                      ? const Icon(
                          Icons.pause,
                          size: 80.0,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videoPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() => _isPlaying = playbackState);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
