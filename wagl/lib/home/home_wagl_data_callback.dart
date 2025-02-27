
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:wagl/home/home_wagl_model.dart';


class HomeWaglDataClass {
  final String username;
  final String? profileImage;
  final String? description;
  List<String>? mediaUrls;
  List<String>? mediaExt;
  List<String>? mediaName;
  List<int>? mediaId;
  final String? location;
  final List<StoryItem> stories;
  final List<InterestedCategory> categoryData;
  final List<GoodTag> goodTagData;
  final ProductId? productId;
  int likes ;
  int? totalComments ;
  int? views ;
  int? totalSaved ;
  final int? userId;
  final int? waglId;
  bool saved=false;
  bool liked=false;
  List sortedMedia;
  StoryController controller=StoryController();
  bool isFollows;



  HomeWaglDataClass({
    required this.username,
    required this.profileImage,
    required this.description,
    required this.location,
    required this.stories,
    required this.likes ,
    required this.totalComments,
    required this.views ,
    required this.userId,
    required this.waglId,
    required this.sortedMedia,
    required this.mediaName,
    required this.isFollows ,
    required this.mediaUrls,
    required this.mediaId,
    required this.mediaExt,
    required this.totalSaved ,
    required this.productId ,
    required this.categoryData ,
    required this.goodTagData,
    required this.liked,
    required this.saved, required StoryController controller,
  });
}
