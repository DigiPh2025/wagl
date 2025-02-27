import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_editor/video_editor.dart';
import 'package:wagl/custom_widget/colorsC.dart';
import 'package:wagl/custom_widget/cust_text.dart';
import 'package:wagl/home/home_controller.dart';
import 'package:wagl/util/SizeConfig.dart';
import '../../create_wagl/create_wagl_controller.dart';
import 'export_result.dart';
import 'export_service.dart';

class VideoEditor extends StatefulWidget {
  const VideoEditor({super.key, required this.file,required this.index});
  final File file;
  final int index;


  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;


/*  late final VideoEditorController _controller = VideoEditorController.file(
    widget.file,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 30),
  );*/

  get index => widget.index;


  final CreateWaglController createWaglController =
  Get.put(CreateWaglController());
  @override
  void initState() {

    super.initState();

    delay();
    Future.delayed(const Duration(seconds: 3), () async {
     await _exportCover();
      // createWaglController.videoInit(widget.file);
      createWaglController.controllerVideo!
          .initialize()
          .then((_) => setState(() {}))
          .catchError((error) {
        // handle minumum duration bigger than video duration error
        Navigator.pop(context);
      }, test: (e) => e is VideoMinDurationError);
     createWaglController.controllerVideo!.video.pause();
    });

  }

  delay(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await createWaglController.videoInit(widget.file);
    });
  }

  @override
  void dispose() async {
    _exportingProgress.dispose();
    createWaglController.pauseVideo();

    _isExporting.dispose();
    // createWaglController.controllerVideo!.dispose();
    ExportService.dispose();
    createWaglController.pauseVideo();
    super.dispose();
  }

  void _showErrorSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:  CustText(name: message,size: 1.5,fontWeightName: FontWeight.w600,colors: colorWhite,),


          duration: const Duration(seconds: 1),
        ),
      );
int indexPosition=0;
  void _exportVideo(index) async {
    indexPosition=index;
    _exportingProgress.value = 0;
    _isExporting.value = true;

    final config = VideoFFmpegVideoEditorConfig(
      createWaglController.controllerVideo!,
      // format: VideoExportFormat.gif,
      // commandBuilder: (config, videoPath, outputPath) {
      //   final List<String> filters = config.getExportFilters();
      //   filters.add('hflip'); // add horizontal flip

      //   return '-i $videoPath ${config.filtersCmd(filters)} -preset ultrafast $outputPath';
      // },
    );

    await ExportService.runFFmpegCommand(
      await config.getExecuteConfig(),
      onProgress: (stats) {
        _exportingProgress.value =
            config.getFFmpegProgress(stats.getTime().toInt());
      },
      onError: (e, s) => _showErrorSnackBar("Error on export video :("),
      onCompleted: (filePath) async {
        _isExporting.value = false;
        if (!mounted) return;

        var homeController = Get.put(HomeController());
        await homeController.updateImage(index,filePath);


      /*  showDialog(
          context: context,
          builder: (_) => VideoResultPopup(video: File(filePath)),
        );*/
      },
    );
  }

   _exportCover() async {
    final config = CoverFFmpegVideoEditorConfig(createWaglController.controllerVideo!);
    final execute = await config.getExecuteConfig();

    if (execute == null) {
      _showErrorSnackBar("Error on cover exportation initialization.");
      return;
    }

    await ExportService.runFFmpegCommand(
      execute,
      onError: (e, s) => _showErrorSnackBar("Error on cover exportation"),
      onCompleted: (coverPath) async {

        var homeController = Get.put(HomeController());
        var createWaglController = Get.put(CreateWaglController());
        await createWaglController
            .getChangedMedia(homeController.changedThumnails());
        await homeController.updateThumbnailImage(coverPath,index);
        homeController.update();

        if (!mounted) return;
        // var homeController = Get.put(HomeController());
        // await homeController.updateThumbnailImage(coverPath,index);
        // await homeController.updateImage(index,coverPath);
         // showModalBottomSheet(context: context, builder: (context) => Image.file(File(coverPath),));

      /*  showDialog(
          context: context,
          builder: (_) => CoverResultPopup(cover: File(cover)),
        );*/
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return GetBuilder<CreateWaglController>(

      builder: (createWaglController) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: createWaglController.controllerVideo!=null&&createWaglController.controllerVideo!.initialized
              ? Stack(
                  children: [
                    Column(
                      children: [
                        // _topNavBar(),
                        Expanded(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                Container(
                                  height: 63 * SizeConfig.heightMultiplier,
                                  width: 100 * SizeConfig.widthMultiplier,
                                  child: TabBarView(
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CropGridViewer.preview(
                                              controller: createWaglController.controllerVideo!),
                                          AnimatedBuilder(
                                            animation: createWaglController.controllerVideo!.video,
                                            builder: (_, __) => AnimatedOpacity(
                                              opacity:
                                                  createWaglController.controllerVideo!.isPlaying ? 0 : 1,
                                              duration: kThemeAnimationDuration,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (createWaglController.controllerVideo!.isPlaying) {
                                                    createWaglController.controllerVideo!.video.pause();
                                                  } else {
                                                    createWaglController.controllerVideo!.video.play;
                                                  }
                                                },
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: createWaglController.controllerVideo!.isPlaying
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            print("playing");
                                                            createWaglController.controllerVideo!.video.pause;
                                                          },
                                                          child: const Icon(
                                                            Icons.pause,
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            print("playing");
                                                            createWaglController.controllerVideo!.video
                                                                .play();
                                                          },
                                                          child: const Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.black,
                                                          )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CoverViewer(controller: createWaglController.controllerVideo!)
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 20 * SizeConfig.heightMultiplier,
                                  margin: const EdgeInsets.only(top: 11),
                                  child: Column(
                                    children: [
                                      /*    Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(Icons.content_cut)),
                                            Text('Trim')
                                          ]),*/
                                      Column(
                                        children: _trimSlider(),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [

                                          Padding(

                                            padding:  EdgeInsets.only(right: 2.0*SizeConfig.widthMultiplier),
                                            child: GestureDetector(
                                              onTap: (){
                                                _exportVideo(index);
                                                _exportCover();
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: colorPrimary,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                      1.5 *
                                                          SizeConfig
                                                              .imageSizeMultiplier,
                                                    ),
                                                  ),
                                                  shape: BoxShape.rectangle,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: CustText(
                                                    name: "Save Changes",
                                                    size: 1.4,
                                                    colors: colorBlack,
                                                    fontWeightName: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: ValueListenableBuilder(
                        valueListenable: _isExporting,
                        builder: (_, bool export, Widget? child) =>
                            AnimatedSize(
                              duration: kThemeAnimationDuration,
                              child: export ? child : null,
                            ),
                        child: AlertDialog(
                          title: ValueListenableBuilder(
                            valueListenable: _exportingProgress,
                            builder: (_, double value, __) => Text(
                              "Exporting video ${(value * 100).ceil()}%",
                              style: TextStyle(fontSize: 12/scaleFactor),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        );
      }
    );
  }


  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: Listenable.merge([
          createWaglController.controllerVideo!,
          createWaglController.controllerVideo!.video,
        ]),
        builder: (_, __) {
          final int duration = createWaglController.controllerVideo!.videoDuration.inSeconds;
          final double pos = createWaglController.controllerVideo!.trimPosition * duration;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: height / 4),
            child: Row(children: [
              CustText(name:  formatter(Duration(seconds: pos.toInt())),size: 1.5,fontWeightName: FontWeight.w600,colors: colorWhite,),
              const Expanded(child: SizedBox()),
              AnimatedOpacity(
                opacity: createWaglController.controllerVideo!.isTrimming ? 1 : 0,
                duration: kThemeAnimationDuration,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  CustText(name: formatter(createWaglController.controllerVideo!.startTrim),size: 1.5,fontWeightName: FontWeight.w600,colors: colorWhite,),

                  const SizedBox(width: 10),
                  CustText(name: formatter(createWaglController.controllerVideo!.endTrim),size: 1.5,fontWeightName: FontWeight.w600,colors: colorWhite,),

                ]),
              ),
            ]),
          );
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: height / 4),
        child: TrimSlider(
          controller: createWaglController.controllerVideo!,
          height: height,
          horizontalMargin: height / 4,
          child: TrimTimeline(
            controller: createWaglController.controllerVideo!,
            padding: const EdgeInsets.only(top: 10),
          ),
        ),
      )
    ];
  }


}
