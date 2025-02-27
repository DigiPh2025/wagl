import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import 'all_wagl_model.dart';

class PersonStories {
  final String username;
  final String? profileImage;
  final String? description;
  final String? location;
  final List<StoryItem> stories;
  final List<CategoriesMedia> categoryData;
  final List<TagData> goodTagData;
  final ProductId? productId;
  int likes ;
  int? totalComments ;
  int? views ;
  int? totalSaved ;
  final int? userId;
  final int? waglId;
  bool saved=false;
  bool liked=false;
  List<String>? media;
  List<String>? mediaName;
  List<String>? mediaExt;
  List<int> mediaId;
  List sortedMedia;
  StoryController controller=StoryController();
  bool isFollows=false;



  PersonStories({
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
    required this.productId ,
    required this.isFollows ,
    required this.totalSaved ,
    required this.categoryData ,
    required this.goodTagData,
    required this.sortedMedia,
    required liked,
    required this.media,
    required this.mediaName,
    required this.mediaExt,
    required this.mediaId,
    required saved, required StoryController controller,
  });
}
