import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart' as dioCall;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wagl/discover/discover_controller.dart';
import 'package:wagl/home/home_controller.dart';
import 'package:wagl/home/home_model.dart';
import 'package:wagl/home/home_page.dart';
import 'package:wagl/home/home_wagl_data_callback.dart';
import 'package:wagl/profile/profile_controller.dart';
import '../custom_widget/colorsC.dart';
import '../register/categories_model.dart';
import '../services/remote_services.dart';
import '../util/ApiClient.dart';
import '../util/SizeConfig.dart';
import 'add_product_model.dart';
import 'brand_name_model.dart';
import 'good_tag_model.dart';
import 'dart:convert';

class CreateWaglController extends GetxController {
  bool updatedStatus = false;
  List<XFile> mediaFileList = [];
  List<XFile> mediaFileListThumbnail = [];
  List<XFile> fileImages = [];
  List<XFile> fileVideos = [];
  TextEditingController searchController = TextEditingController();
  bool isAddressSelected = false;
  File? image;
  String selectedAddress = 'Add locations';
  var searchTagController = TextEditingController();
  var searchProductController = TextEditingController();
  var searchBrandController = TextEditingController();
  var searchCategoryController = TextEditingController();
  var descriptionTextController = TextEditingController();
  var productTextController = TextEditingController();
  List<int> categoriesId = [];
  List<int> newCategoriesId = [];
  List<String> selectedGoodTags = [];
  List<String> selectedCategoriesTags = [];
  List<int> tagIds = [];
  List<DataItem> goodTagList = [];
  List<Datum> filterProductList = [];
  List<Datum> filterBrandList = [];
  List<Datam> filterBrandListNew = [];
  List<Datum> productList = [];
  List<Datam> brandList = [];
  List<DataItem> filteredGoodTagList = [];
  var profileController = Get.put(ProfileController());
  final ImagePicker picker = ImagePicker();
  bool descriptionText = false;

  @override
  void onInit() {
    // TODO: implement onInit
    clearData();
    getGoodTag();
    getProducts();
    getBrandNames();
    getCategoryTag();
    super.onInit();
  }

  VideoEditorController? controllerVideo;

  Future videoInit(widgetFile) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerVideo = VideoEditorController.file(
        widgetFile,
        minDuration: const Duration(seconds: 1),
        maxDuration: const Duration(seconds: 30),
      );
      update();
    });
    /* controllerVideo = VideoEditorController.file(
    widgetFile,
    minDuration: const Duration(seconds: 1),
    maxDuration: const Duration(seconds: 30),
  );
  update();*/
  }

  var dataValue;

  pauseVideo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controllerVideo != null) {
        controllerVideo!.video.pause();
      }
      update(); // Notify listeners after the frame is rendered
    });
  }

  var uploadProgress = 0.0;

  Future<void> createWaglDio(Function(double) onProgress) async {
    List<int> CategoriesId = getSelectedCategoryIdsAsArray();
    List<int> goodTagIndexId = getSelectedGoodTagsIdsAsArray();
    print("Here is product is $selectedProductId");
    uploadProgress = 0.0;
    dioCall.Dio dio = dioCall.Dio();

    if (!isAddressSelected) {
      selectedAddress = "";
    }

    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
    };
    print("here is the description::${descriptionTextController.text} ");
    String formattedText = jsonEncode(descriptionTextController.text);
    dioCall.FormData formData = dioCall.FormData.fromMap({
      'data':
          '{  "description": $formattedText,  "isActive": true,  "user_id": ${ApiClient.box.read('userId')},"location":" $selectedAddress", "interested_categories": {    "disconnect": [], "connect": $CategoriesId  },"product_id": ${newProductId == null ? selectedProductId : newProductId},"good_tags": {    "disconnect": [],    "connect": $goodTagIndexId }}',
    });
    print("here is the formdata ${formData.fields}");
    print("here is the fileImages ${fileImages.length}");
    print("here is the fileVideo ${fileVideos.length}");

    print("here is the fileImages $fileImages");
    // Add image files
    for (int i = 0; i < fileImages.length; i++) {
      print("here is the issueee 11");
      XFile file = fileImages[i];
      print("here is the issueee 22");
      if (fileImages[i].path.endsWith('.mp4') ||
          fileImages[0].path.endsWith('.mov') ||
          fileImages[0].path.endsWith('.hevc')) {
        print("here is the file of Videos");

        XFile file = fileImages[i];
        print("here is the file of Videos${i}_${file.name}");

        formData.files.add(MapEntry(
          'files.media',
          await dioCall.MultipartFile.fromFile(file.path,
              filename: "${i}_${file.name}",
              contentType: dioCall.DioMediaType(
                  'video', p.extension(file.name).toLowerCase().substring(1))),
        ));
      } else {
        print("here is the file of Images");
        print("here is the file of Images ${i}_${file.name}");
        formData.files.add(MapEntry(
          'files.media',
          await dioCall.MultipartFile.fromFile(file.path,
              filename: "${i}_${file.name}",
              contentType: dioCall.DioMediaType(
                  'image', p.extension(file.name).toLowerCase().substring(1))),
        ));
      }

      print("here is the issueee 33");
    }
    print("Here is product is $selectedProductId");
    // Add thumbnail if the first file is a video
    if (fileImages[0].path.endsWith('.mp4') ||
        fileImages[0].path.endsWith('.mov') ||
        fileImages[0].path.endsWith('.hevc')) {
      XFile file = mediaFileList[0];
      formData.files.add(MapEntry(
        'files.thumbnail',
        await dioCall.MultipartFile.fromFile(file.path,
            filename: file.name,
            contentType: dioCall.DioMediaType(
                'image', p.extension(file.name).toLowerCase().substring(1))),
      ));
    }
    print("Before::::");
    try {
      // Make the POST request
      var response = await dio.post(
        '${RemoteServices.baseUrl}api/wagls',
        // 'http://192.168.1.42:1337/api/checkfiledata',
        data: formData,
        options: dioCall.Options(headers: headers),
        onSendProgress: (int sent, int total) {
          print("Here is sent total :: ${(sent)}   total:: ${(total)}");
          onProgress(sent / total);
          // uploadProgress=;
          updateProgressBar((sent / total) * 100);
          /*  print("Here is uploadProgress :: $uploadProgress");
          print("Here is progress :: ${(sent / total)}");*/
        },
      );

      if (response.statusCode == 200) {
        print("After:::");
        // profileController.personProfileDetails!.totalWagls=profileController.personProfileDetails!.totalWagls+1;
        profileController.getProfileDetails(0);
        print("Upload Successful");
      } else {
        print("Upload Failed: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error: $e");
    }

    // Update home controller after the upload is done
    update();
  }

  updateProgressBar(value) {
    uploadProgress = value;
    update();
  }

  File? productImage;

  Future getProductImage(ImageSource source) async {
    productImage = null;
    var img = await ImagePicker().pickImage(source: source); // moto x4
    // var image = await ImagePicker.pickImage( imageQuality: 90, source: ImageSource.camera, );
    if (img != null) {
      print("here is the product Image");
      var cropped = await ImageCropper().cropImage(
          sourcePath: img.path,
          // compressQuality: 100,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            // CropAspectRatioPreset.ratio5x3,
            //  CropAspectRatioPreset.ratio3x2,
            // CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,

            // /*   CropAspectRatioPreset.ratio5x3,
            // CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: colorPrimary,
              toolbarTitle: "Wagl",
              statusBarColor: colorPrimary,
              backgroundColor: Colors.white,
            )
          ]);

      // final bytes = (await img.readAsBytes()).lengthInBytes;
      productImage = File(cropped!.path);
      emptyProductImgError = "";
    }

    // print(" print == ::: $image");
    print("Here is the msg :: ${productImage}");
    update();
  }

  filterTags(String searchTerm) {
    if (searchTerm.isEmpty) {
      filteredGoodTagList = goodTagList;
    } else {
      filteredGoodTagList = goodTagList
          .where((tags) => tags.attributes.name
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
      print("object ${filteredGoodTagList}");
    }
    update();
  }

  void filterCategories(String searchTerm) {
    if (searchTerm.isEmpty) {
      filteredCategoriesList = categoriesList;
      print("asdasd");
    } else {
      print("asdasd $searchTerm");
      filteredCategoriesList = categoriesList
          .where((name) => name.attributes.categoryName
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
      print(
          "object here is the search ${filteredCategoriesList[0].attributes.categoryName}");
    }
    update();
  }

  void filterProducts(String searchTerm) {
    if (searchTerm.isEmpty) {
      filterProductList = productList;
      print("asdasd");
    } else {
      print("asdasd $searchTerm");
      filterProductList = productList
          .where((name) => name.attributes!.name!
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
      print(
          "object here is the search ${filterProductList[0].attributes!.name}");
    }
    update();
  }

  void filterBrandName(String searchTerm) {
    if (searchTerm.isEmpty) {
      filterBrandListNew = brandList;
      print("asdasd");
    } else {
      print("asdasd $searchTerm");
      filterBrandListNew = brandList
          .where((name) => name.attributes!.brandName!
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
    }
    update();
  }


  int? newProductId;

  Future addProduct() async {
    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read("authToken")}'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${RemoteServices.baseUrl}api/products'));
    request.fields.addAll({
      'data':
          '{\n        "brand_id":$createBrandId,\n       "name": "${productTextController.text.toString()}"\n}'
    });
    request.files.add(await http.MultipartFile.fromPath(
        'files.product_pic', '${productImage!.path}'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("jerer");
      String responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);
      newProductId = jsonResponse['data']['id'];
      print("Product ID: $newProductId");
      selectedProductId = newProductId;
    } else {
      print(response.reasonPhrase);
    }
    getProducts();
    update();
  }

  int? newBrandId;

  Future addBrand(String brandName) async {
    var map = {
      "data": {
        "brandName": brandName,
      }
    };
    var getDetails =
        await RemoteServices.postMethodWithToken('api/brand-names', map);
    if (getDetails.statusCode == 200) {
      print("Here is${getDetails.data}");
      print("Here is${getDetails.statusCode}");
      // String responseBody = await data();
      var jsonResponse = jsonDecode(getDetails.data);
      newBrandId = jsonResponse['data']['id'];
      print("newBrandId ID: $newBrandId");
      emptyBrandError = "";
      selectedBrandName = brandName;
      createBrandId = newBrandId;
    } else {
      print(
          "Failed to fetch data. Status code:Setting ${getDetails.statusCode}  ${getDetails.errorMessage} ${getDetails.data}");
    }

    update();
  }

  updateAddress() {
    print(
        "Here is the searchController Address ${searchController.text.toString()}\n\n");
    print("Here is the selected Address ${selectedAddress}\n\n");
    selectedAddress = searchController.text.toString();
    print("Here is the selectedAddress  ${selectedAddress}");
    if (selectedAddress == "Add locations") {
      isAddressSelected = false;
    } else {
      isAddressSelected = true;
    }
    update();
  }

  List<CategoryList> categoriesList = [];
  List<CategoryList> filteredCategoriesList = [];
  List<CategoryList> selectedCategoryList = [];

/*  List<DataItem> goodTagList = [];
  List<DataItem> filteredGoodTagList = [];*/

  LatLng latlng = LatLng(18.579442, 73.482968);
  double? lat, lng;
  late DataModel categories;
  bool updateEditWagl = false;
  int editWaglId = 0;
  List<String> mediaListEdit = [];
  List<int> mediaIds = [];

  List sortedMediaHome = [];
  List sortedMediaId = [];

  Future getEditWaglDataHome(HomeWaglDataClass waglData) async {
    mediaListEdit = [];
    addEditedMedia = [];
    // mediaListFile = [];
    sortedMediaHome = [];
    sortedMediaHome = waglData.sortedMedia;
    // print("here is the url :${waglData.mediaUrls!.length}");
    print("here is the length :${waglData.sortedMedia!.length}");
    for (int i = 0; i < waglData.sortedMedia!.length; i++) {
      print("here is the length :${waglData.sortedMedia[i]!.name}");
      sortedEditFileName.add(waglData.sortedMedia[i].name);
      sortedMediaId.add(waglData.sortedMedia[i].id);
      if (isVideo(waglData.sortedMedia[i].name)) {
        var videoThumnail =
            await generateVideoThumbnail(waglData.sortedMedia![i].url);
        mediaListEdit.add(videoThumnail!.path);
        print("here is the url $mediaListEdit");
      } else {
        print("here is $i and the mediaId link ${waglData.sortedMedia![i].id}");
        // mediaIds.add(waglData.mediaId![i]);
        mediaListEdit.add(waglData.sortedMedia![i].url);
      }
    }
    editWaglId = waglData.waglId ?? 0;
    descriptionTextController.text = waglData.description ?? "";
    isProductSelected = true;
    productImageUrl = waglData.productId?.productPic?.url ?? "";
    selectedProductName = waglData.productId?.name ?? "";
    selectedBrandNameList = waglData.productId?.brandId?.brandName ?? "";
    selectedAddress =
        waglData.location == " " ? "Add Location" : waglData.location!;
    selectedProductId = waglData.productId?.id;

    // for(int i=0;i<productList.length)
    for (int i = 0; i < waglData.categoryData.length; i++) {
      selectedCategoryIds.add(waglData.categoryData[i].id!);
    }
    for (int i = 0; i < waglData.goodTagData.length; i++) {
      selectedGoodTagIds.add(waglData.goodTagData[i].id!);
    }
    addEditedMedia = [...mediaListEdit];
    update();
  }
  Future getEditWaglData(PersonStories waglData) async {
    sortedEditFileName = [];
    mediaListEdit = [];
    addEditedMedia = [];
    mediaListFile = [];
    sortedMediaId = [];
    iDListWagl = waglData.sortedMedia;
    for (int i = 0; i < waglData.media!.length; i++) {
      sortedEditFileName.add(waglData.sortedMedia[i].attributesMedia!.name);
      sortedMediaId.add(waglData.sortedMedia[i].id!);
      if (isVideo(waglData.sortedMedia[i].attributesMedia!.name)) {
        var videoThumnail = await generateVideoThumbnail(waglData.media![i]);
        mediaListEdit.add(videoThumnail!.path);
      } else {
        print("here is $i and the media link ${waglData.media![i]}");
        print("here is $i and the mediaId link ${waglData.mediaId![i]}");
        print("here is $i and the name of the file ${waglData.mediaName![i]}");
        mediaListEdit.add(waglData.media![i]);
      }
    }
    print(
        "object here the last file name ${int.tryParse(sortedEditFileName.last.split('_')[0]) ?? 10}::::::${sortedEditFileName.last}");

    editWaglId = waglData.waglId ?? 0;

    descriptionTextController.text = waglData.description ?? "";
    isProductSelected = true;
    productImageUrl = waglData
        .productId?.data?.attributes?.productPic?.data?.attributes?.url ??
        "";
    selectedProductName = waglData.productId?.data?.attributes?.name ?? "";
    selectedBrandNameList = waglData.productId?.data?.attributes?.brandId?.data
        ?.attributes?.brandName ??
        "";
    selectedAddress =
    waglData.location == " " ? "Add Location" : waglData.location!;
    selectedProductId = waglData.productId?.data?.id;
    for (int i = 0; i < waglData.categoryData.length; i++) {
      selectedCategoryIds.add(waglData.categoryData[i].id!);
      print("here is the category Data  $selectedCategoryIds");
    }
    for (int i = 0; i < waglData.goodTagData.length; i++) {
      selectedGoodTagIds.add(waglData.goodTagData[i].id!);
      print("here is the selectedGoodTagIds  $selectedGoodTagIds");
    }
    addEditedMedia = [...mediaListEdit];
    update();
  }
  List<String> sortedEditFileName = [];
  Future updateEditWaglMethod(waglId, Function(double) onProgress) async {
    List<int> CategoriesId = getSelectedCategoryIdsAsArray();
    List<int> goodTagIndexId = getSelectedGoodTagsIdsAsArray();
    List<int> CategoriesDisconnectId = getDeSelectedCategoryIdsAsArray();
    List<int> goodTagDisconnectId = getDeSelectedGoodTagsIdsAsArray();

    uploadProgress = 0.0;
    dioCall.Dio dio = dioCall.Dio();

    if (!isAddressSelected) {
      selectedAddress = "";
    }

    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
    };

    String formattedText = jsonEncode(descriptionTextController.text);
    dioCall.FormData formData = dioCall.FormData.fromMap({
      'data':
          '{  "description": $formattedText,  "isActive": true,  "user_id": ${ApiClient.box.read('userId')},"location":" $selectedAddress", "interested_categories": {    "disconnect": $CategoriesDisconnectId, "connect": $CategoriesId  },"product_id": ${selectedProductId ?? null},"mediaIds":"${[]}","good_tags": {    "disconnect": $goodTagDisconnectId,    "connect": $goodTagIndexId }}',
    });
    print("here is the formdata ${formData.fields}");
    int index = int.tryParse(sortedEditFileName.last.split('_')[0]) ?? 10;
    print(
        "edit index ${int.tryParse(sortedEditFileName.last.split('_')[0])} ::: index  $index");
    print("here is the fileImages length 11${fileImages.length}");
    for (int i = 0; i < fileImages.length; i++) {
      index++;
      print("here is the issueee 11");
      XFile file = fileImages[i];
      print("here is the issueee 22");
      if (fileImages[i].path.endsWith('.mp4') ||
          fileImages[i].path.endsWith('.mov') ||
          fileImages[i].path.endsWith('.hevc')) {
        print("here is the file of Videos");

        XFile file = fileImages[i];
        print("here is the file of Videos${index}_${file.name}");

        formData.files.add(MapEntry(
          'files.media',
          await dioCall.MultipartFile.fromFile(file.path,
              filename: "${index}_${file.name}",
              contentType: dioCall.DioMediaType(
                  'video', p.extension(file.name).toLowerCase().substring(1))),
        ));
      } else {
        print("here is the file of Images");
        print("here is the file of Images ${index}_${file.name}");
        formData.files.add(MapEntry(
          'files.media',
          await dioCall.MultipartFile.fromFile(file.path,
              filename: "${index}_${file.name}",
              contentType: dioCall.DioMediaType(
                  'image', p.extension(file.name).toLowerCase().substring(1))),
        ));
      }

      print("here is the issueee 33");
    }



    print("here is the url  ${RemoteServices.baseUrl}api/wagls/$waglId");
    var response;
    try {
      // Make the POST request
      response = await dio.put(
        '${RemoteServices.baseUrl}api/wagls/$waglId',
        // 'http://192.168.1.42:1337/api/checkfiledata',
        data: formData,
        options: dioCall.Options(headers: headers),
        onSendProgress: (int sent, int total) {
          print("Here is sent total :: ${(sent)}   total:: ${(total)}");
          onProgress(sent / total);
          updateProgressBar((sent / total) * 100);
        },
      );

      if (response.statusCode == 200) {
        print("Upload response  ${response.data}");
        profileController.getUsersWagl(0);
      } else {
        print("Upload Failed: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error: Response:::: $response  $e");
    }

    // Update home controller after the upload is done
    update();
  }

  Future updateEditMediaWagl(waglMediaId) async {
    print("here is the media Id ::$waglMediaId");
    List<int> CategoriesId = getSelectedCategoryIdsAsArray();
    List<int> goodTagIndexId = getSelectedGoodTagsIdsAsArray();
    List<int> CategoriesDisconnectId = getDeSelectedCategoryIdsAsArray();
    List<int> goodTagDisconnectId = getDeSelectedGoodTagsIdsAsArray();

    uploadProgress = 0.0;
    dioCall.Dio dio = dioCall.Dio();

    if (!isAddressSelected) {
      selectedAddress = "";
    }

    var headers = {
      'Authorization': 'Bearer ${ApiClient.box.read('authToken')}'
    };
    print(
        "here is the description:Bearer ${ApiClient.box.read('authToken')}:${descriptionTextController.text} ");
    print("here is the description:Bearer ${goodTagIndexId}/nn/n\n\n");
    print(
        "here is the selectedProductId:Bearer ${CategoriesId};;;;;;;;;;;;;;;;;;;;;;|");

    // String formattedText = descriptionTextController.text.replaceAll('\n', '\\n');
    String formattedText = jsonEncode(descriptionTextController.text);
    dioCall.FormData formData = dioCall.FormData.fromMap({
      'data':
          '{  "description": $formattedText,  "isActive": true,  "user_id": ${ApiClient.box.read('userId')},"location":" $selectedAddress", "interested_categories": {    "disconnect": $CategoriesDisconnectId, "connect": $CategoriesId  },"product_id": ${selectedProductId ?? null},"mediaIds":${[
        waglMediaId
      ]},"good_tags": {    "disconnect": $goodTagDisconnectId,    "connect": $goodTagIndexId }}',
    });
    print("here is the formdata ${formData.fields}");
    print("Before::::");
    print("here is the url  ${RemoteServices.baseUrl}api/wagls/$editWaglId");
    var response;
    try {
      // Make the POST request
      response = await dio.put(
        '${RemoteServices.baseUrl}api/wagls/$editWaglId',
        // 'http://192.168.1.42:1337/api/checkfiledata',
        data: formData,
        options: dioCall.Options(headers: headers),
        onSendProgress: (int sent, int total) {
          print("Here is sent total :: ${(sent)}   total:: ${(total)}");

          updateProgressBar((sent / total) * 100);
        },
      );

      if (response.statusCode == 200) {
        print("Upload response here is the media Id ::$waglMediaId");
        print("Upload response  ${response.data}");
        profileController.getUsersWagl(0);
      } else {
        print("Upload Failed: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error: Response:::: $response  $e");
    }

    // Update home controller after the upload is done
    homeController.getHomeFeedWagl();
    update();
  }

  Future getGoodTag() async {
    var getDetails =
        await RemoteServices.fetchGetData('api/good-tags?populate=*');
    if (getDetails.statusCode == 200) {
      var apiDetails = goodTagModelFromJson(getDetails.body);
      goodTagList = apiDetails.data;
      filteredGoodTagList = goodTagList;
      for (int i = 0; i < goodTagList.length; i++) {
        deSelectedGoodTagIds.add(goodTagList[i].id);
      }
    } else {
      print("Failed to fetch data. Status code: ${getDetails.statusCode}");
    }
    update();
  }

  Future getProducts() async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/products?populate=*&pagination[pageSize]=100&pagination[page]=1');
    if (getDetails.statusCode == 200) {
      var apiDetails = productModelClassFromJson(getDetails.body);
      productList = apiDetails.data!;
      if (productList.isNotEmpty) {}
      filterProductList = productList;
    } else {
      print("Failed to fetch data. Status code: ${getDetails.statusCode}");
    }
    update();
  }

  Future getBrandNames() async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/brand-names?populate=*&pagination[pageSize]=1000&pagination[page]=1');
    if (getDetails.statusCode == 200) {
      var apiDetails = brandNameClassFromJson(getDetails.body);
      brandList = apiDetails.data!;
      if (brandList.isNotEmpty) {}
      filterBrandListNew = brandList;
      print(
          "here is the braname nae length getBrandNames  ${filterBrandListNew.length}");
    } else {
      print(
          "Failed to fetch data. Status code:getBrandNames  ${getDetails.statusCode}");
    }
    update();
  }

  Set<int> selectedCategoryIds = {};
  Set<int> selectedGoodTagIds = {};
  Set<int> deSelectedCategoryIds = {};
  Set<int> deSelectedGoodTagIds = {};
  Set<int> selectedProductIds = {};

  Future getCategoryTag() async {
    var getDetails = await RemoteServices.fetchGetData(
        'api/interested-categories?fields[0]=categoryName&populate[categoryImage][fields][0]=*&sort[0]=categoryName');
    if (getDetails.statusCode == 200) {
      var apiDetails = getCategoriesModelFromJson(getDetails.body);
      categoriesList = apiDetails.data;
      filteredCategoriesList = categoriesList;
      if (categoriesList.isNotEmpty) {
        for (int i = 0; i < categoriesList.length; i++) {
          deSelectedCategoryIds.add(categoriesList[i].id);
        }
      }
      print(
          "object::== ${apiDetails.data[0].attributes.categoryImage!.data.attributes.url}\n\n Length ${categoriesList.length}");
    } else {
      print("Failed to fetch data. Status code: ${getDetails.statusCode}");
    }
    update();
  }

  ///////////////////////////////////////////////////////////////////////
  void toggleSelection(CategoryList category) {
    if (selectedCategoryIds.contains(category.id)) {
      selectedCategoryIds.remove(category.id); // Deselect if already selected
    } else {
      selectedCategoryIds.add(category.id); // Select if not selected
    }
    update(); // Update UI after selection change
  }

  void deselectCategory(CategoryList category) {
    selectedCategoryIds.remove(category.id); // Remove from selected set
    update(); // Update UI
  }

  bool isSelected(CategoryList category) {
    return selectedCategoryIds.contains(category.id);
  }

  List<CategoryList> get selectedCategories {
    return categoriesList
        .where((category) => selectedCategoryIds.contains(category.id))
        .toList();
  }

  void toggleSelectionProduct(Datum product) {
    if (selectedProductIds.contains(product.id)) {
      selectedProductIds.remove(product.id); // Deselect if already selected
    } else {
      selectedProductIds.add(product.id!); // Select if not selected
    }
    update(); // Update UI after selection change
  }

  late Datum selectedProduct;
  String selectedProductName = "";
  int? selectedProductId;

  String selectedBrandNameList = "";
  String productImageUrl = "";
  bool isProductSelected = false;

  getSelectedProduct(Datum product) {
    selectedProduct = product;
    isProductSelected = true;
    selectedProductName = product.attributes!.name!;
    selectedProductId = product.id!;

    selectedBrandNameList =
        product.attributes!.brandId!.data!.attributes!.brandName!;
    if (product.attributes!.productPic!.data != null) {
      productImageUrl = product.attributes!.productPic!.data!.attributes!.url!;
    } else {
      productImageUrl = "";
    }
    print("Here is tje product${product.attributes!.name} ");
    print(
        "Here is tje product${product.attributes!.brandId!.data!.attributes!.brandName} ");
    update();
  }

  ///////////////////////////////////////////////////////////////////////
  void toggleSelectionGoodTag(DataItem goodTag) {
    if (selectedGoodTagIds.contains(goodTag.id)) {
      selectedGoodTagIds.remove(goodTag.id); // Deselect if already selected
    } else {
      selectedGoodTagIds.add(goodTag.id); // Select if not selected
    }
    update(); // Update UI after selection change
  }

  void deselectGoodTag(DataItem goodTag) {
    selectedGoodTagIds.remove(goodTag.id); // Remove from selected set
    update(); // Update UI
  }

  bool isSelectedGoodTag(DataItem goodTag) {
    return selectedGoodTagIds.contains(goodTag.id);
  }

  List<DataItem> get selectedGoodTag {
    return goodTagList
        .where((goodTag) => selectedGoodTagIds.contains(goodTag.id))
        .toList();
  }

///////////////////////////////////////////////////////////////////////////////////////

  updateLatlng(plat, plng) {
    print("position.longitude === 2");
    latlng = LatLng(double.parse(plat), double.parse(plng));
    lat = double.parse(plat);
    lng = double.parse(plng);
    update();
  }

/*  Future getImages(mediaImages) async {
    mediaFileList = mediaImages;
    update();
  }*/

  Future getChangedImages(List<String> mediaImages) async {
    for (int i = 0; i < mediaImages.length; i++) {
      fileImages.add(XFile(mediaImages[i]));
      print(("\n\nfileImages ${fileImages[i]}"));
      print(("\n\nfileImages ${fileImages[i]}"));
    }
    update();
  }

  Future getChangedMedia(List<String> mediaImages) async {
    for (int i = 0; i < mediaImages.length; i++) {
      mediaFileList.add(XFile(mediaImages[i]));
/*      if (mediaFileList[j].path.endsWith('.mp4') ||
          //           mediaFileList[j].path.endsWith('.mov') ||
          //           mediaFileList[j].path.endsWith('.mov') ||
          //           mediaFileList[j].path.endsWith('.hevc')) {
      mediaListFile=[...mediaFileList];*/
      print(("\n\n All images path $i == ${mediaFileList[i].path}"));
      print(("\n\n All images mediaImages path $i == ${mediaImages[i]}"));
    }
    update();
  }
  Future getChangedThumbnails(List<String> mediaImages) async {
    mediaFileListThumbnail=[];
    for (int i = 0; i < mediaImages.length; i++) {
      mediaFileListThumbnail.add(XFile(mediaImages[i]));
      print(("\n\n All images path $i == ${mediaFileListThumbnail[i].path}"));
      print(("\n\n All images path All images path $i == ${mediaImages[i]}"));
    }
    update();
  }

  List<int> getSelectedCategoryIdsAsArray() {
    return selectedCategoryIds
        .map((id) => int.parse(id.toString()))
        .toList(); // Casts each element to int
  }

  List<int> getSelectedGoodTagsIdsAsArray() {
    return selectedGoodTagIds
        .map((id) => int.parse(id.toString()))
        .toList(); // Casts each element to intf
  }

  List<int> getDeSelectedCategoryIdsAsArray() {
    return deSelectedCategoryIds
        .map((id) => int.parse(id.toString()))
        .toList(); // Casts each element to int
  }

  List<int> getDeSelectedGoodTagsIdsAsArray() {
    return deSelectedGoodTagIds
        .map((id) => int.parse(id.toString()))
        .toList(); // Casts each element to intf
  }

  String categoryValidation = "";
  String goodTagValidation = "";

  clearData() {
    print("here is the clear function calling ");
    print("here is the clear mediaListEdit 1:: $mediaListEdit ");

    descriptionTextController.clear();
    searchController.clear();
    selectedCategoryList.clear();
    selectedGoodTags.clear();
    goodTagList.clear();
    selectedAddress = 'Add locations';
    newCategoriesId.clear();
    fileImages.clear();
    fileVideos.clear();
    mediaFileListThumbnail.clear();
    viewConfirmButtonTag = true;
    descriptionText = false;
    selectedGoodTag.clear();
    categoriesList.clear();
    selectedGoodTagIds.clear();
    selectedCategoryIds.clear();
    selectedBrandName = "";
    productTextController.clear();
    isProductSelected = false;
    productImage = null;
    categoryValidation = "";
    goodTagValidation = "";
    print("here is the clear mediaListEdit 2:: $mediaListEdit ");
    update();
    print("here is the clear mediaListEdit 3:: $mediaListEdit ");
    mediaFileList.clear();
  }

  clearFiles() {
    mediaFileList.clear();
    update();
  }

  bool viewConfirmButtonTag = true;
  bool viewConfirmButtonCategories = true;

  void updateConfirmTagButton(bool flag) {
    if (flag) {
      viewConfirmButtonTag = true;
    } else {
      viewConfirmButtonTag = false;
    }
    update();
  }

  void updateConfirmCategoryButton(bool flag) {
    if (flag) {
      viewConfirmButtonCategories = true;
    } else {
      viewConfirmButtonCategories = false;
    }
    update();
  }

  getChangedVideos(List<String> changedVideos) {
    for (int i = 0; i < changedVideos.length; i++) {
      fileVideos.add(XFile(changedVideos[i]));
    }

    print(
        "Here is the path Video::: ${fileVideos.length}\n\n Here is the Length /*${fileVideos.length}*/");
    // print("Here is the path Video::: ${fileVideos[0].toString()}\n\n Here is the Length /*${fileVideos.length}*/");
    update();
  }

  void updateDescription(bool flag) {
    List<int> CategoriesId = getSelectedCategoryIdsAsArray();
    List<int> goodTagIndexId = getSelectedGoodTagsIdsAsArray();
    if (descriptionTextController.text == "") {
      descriptionText = true;
      print("here is the value ");
    } else {
      descriptionText = false;
    }
    categoryValidation = "";
    goodTagValidation = "";
    if (CategoriesId.isEmpty) {
      categoryValidation = "Please select atleast one category";
    }
    if (goodTagIndexId.isEmpty) {
      goodTagValidation = "Please select at least one good-tag";
    }
    update();
  }

  clearList() {
    productImage = null;
    print("here is th ${productImage}");
    update();
  }

  String selectedBrandName = "";
  int? createBrandId;

  getBrandName(Datam filterBrandList) {
    createBrandId = filterBrandList.id;
    print("createBrandId ${createBrandId}");
    selectedBrandName = filterBrandList.attributes?.brandName ?? "";
    print("selectedBrandName ${selectedBrandName}");
    emptyBrandError = "";
    update();
  }

  clearBrandName() {
    searchBrandController.clear();
    productTextController.clear();
    selectedBrandName = "";
    selectedBrandNameList = "";
    selectedProductName = "";
    selectedBrandNameList = "";
    productImageUrl = "";
    isProductSelected = false;
    createBrandId = null;
    newProductId = null;

    getProducts();
    filterBrandList = productList;
    update();
  }

  String emptyProductImgError = "";
  String emptyBrandError = "";
  String emptyProductError = "";

  clearWarning() {
    productImage = null;
    selectedBrandName = "";
    emptyProductImgError = "";
    emptyBrandError = "";
    emptyProductError = "";
    productTextController.clear();
    update();
  }

  bool checkProductFields() {
    if (productImage == null) {
      print(
          "11111. productTextController.text.isEmpty  == ${productTextController.text.isEmpty}");
      emptyProductImgError = "Please select the image .";
      update();
      return false;
    } else if (selectedBrandName == "") {
      print(
          "222. productTextController.text.isEmpty  == ${productTextController.text.isEmpty}");
      emptyBrandError = "Please add name";
      update();
      return false;
    } else if (productTextController.text.isEmpty) {
      print(
          "333.productTextController.text.isEmpty  == ${productTextController.text.isEmpty}");
      emptyProductError = "Please add name";
      update();
      return false;
    } else {
      return true;
    }
  }

  Future removeMediaWagl(waglMediaId, index) async {
    print("her is the index :: $index");

    mediaListEdit.removeAt(index);
    addEditedMedia.removeAt(index);
    sortedMediaId.removeAt(index);
    for (int i = 0; i < addEditedMedia.length; i++) {
      print("her is the index :: ${addEditedMedia[i]}");
    }
    var result = await updateEditMediaWagl(waglMediaId);

    update();
  }

  List<File?> thumbnails = [];

  bool isVideo(String url) {
    return url.endsWith(".mp4") ||
        url.endsWith(".mov") ||
        url.endsWith(".hevc") ||
        url.endsWith(".avi");
  }

  Future<File?> generateVideoThumbnail(String videoUrl) async {
    try {
      // Generate the thumbnail file path
      String? thumbnailFilePath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 100,
        maxWidth: 100,
        // Specify the height of the thumbnail
        quality: 100,
      );

      // Check if the thumbnail file path is not null and return a File object
      if (thumbnailFilePath != null) {
        print("her is the generated${thumbnailFilePath}");
        return File(thumbnailFilePath);
      } else {
        // Handle null case (e.g., thumbnail generation failed)
        print("Thumbnail generation returned a null path.");
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during thumbnail generation
      print("Error generating thumbnail: $e");
      return null;
    }
  }

  List iDListWagl = [];
  VideoPlayerController? videoPlayerController;
  Future<void> getID(index) async {
    print("length :   ${iDListWagl.runtimeType} :: $index");
    print("length :   ${iDListWagl.length} :: $index");
    print("length :   ${sortedMediaId.length} :: $index");
    print("mediaListEdit :   ${sortedMediaId[index]} :: ");
    var result = await removeMediaWagl(sortedMediaId[index], index);
    //  print("getID :   ${jsonEncode(iDListWagl[0][0]['id'])}");
    var id;
    // for (int i = 0; i < iDListWagl.length; i++) {
/*    for (int i = 0; i < sortedMediaId.length; i++) {

    print("sortedMediaIdID :   ${sortedMediaId[i]} :: $index");

*/ /*      if (index == i) {
        // print("ID === : ${iDListWagl[i].id}");


        id = iDListWagl[i].id;

        break;
      }*/ /*
    }*/
  }

  Future<void> getIDFile(path) async {
    print("length :   ${iDListWagl.runtimeType} :: $path");
    print("length :   ${iDListWagl.length} :: $path");
    //  print("getID :   ${jsonEncode(iDListWagl[0][0]['id'])}");
    var id;
    for (int i = 0; i < iDListWagl.length; i++) {
      if (path == i) {
        // print("ID === : ${iDListWagl[i].id}");

        id = iDListWagl[i].id;
        removeMediaWagl(id, path);
        break;
      }
    }
  }

  List<dynamic> addEditedMedia = [];
  List<XFile> mediaListFile = [];

  addNewImages(List<String> mediaImages) {
    videoPlayerController?.dispose();
    controllerVideo?.dispose();
    // Initialize the new video controller

    print("here is the AddNew Images Called");
/*    for (int i = 0; i < mediaImages.length; i++) {
      if (mediaImages.length > 1) {
        if (mediaImages[i] != mediaImages[i - 1]) {
          mediaListFile.add(XFile(mediaImages[i]));
          print(("\n\n All images path $i == ${mediaListFile[i].path}"));
        }
      }
    }*/
    for (var items in mediaImages) {
      print("here is the items: mediaImages ${items}");
    }
      print("here is the length mediaListFile ${mediaListFile.length}");
      print("here is the length fileImages${fileImages.length}");
      print("here is the length mediaImages ${mediaImages.length}");
      print("here is the length mediaFileList ${mediaFileList.length}");
    // mediaListFile=[...mediaFileList];

    for(int i=0;i<mediaImages.length;i++){
      if (mediaFileList[i].path.endsWith('.mp4') ||
          mediaFileList[i].path.endsWith('.mov') ||
          mediaFileList[i].path.endsWith('.mov') ||
          mediaFileList[i].path.endsWith('.hevc')) {
        print("here is the length mediaListFile ${mediaListFile.length}");
        print("here is the length mediaFileListThumbnail${fileImages.length}");
        print("Image path ${mediaFileListThumbnail[i].path}");
        videoPlayerController = VideoPlayerController.file(File(mediaFileList[i].path))
          ..setLooping(true)
          ..initialize().then((_) {
            // Notify the UI to update
            videoPlayerController?.pause();
            update();

            // videoPlayerController?.setVolume(0.0);
          });
        mediaListFile.add(mediaFileListThumbnail[i]);
      }
      else{
        print("Image path ${mediaFileList[i].path}");
        print("here is the length fileImages${fileImages.length}");
        mediaListFile.add(mediaFileList[i]);
      }
    }
    addEditedMedia = [...mediaListEdit, ...mediaListFile];
    print("here is the file total length ${mediaListFile.length}");
    for (var items in mediaImages) {
      print("here is the items: mediaListEdit ${mediaImages.runtimeType}");
      print(
          "here is the length:${mediaImages.length}items: mediaListEdit index:: ${mediaImages} \n\n");
    }
    for (var items in mediaListEdit) {
      print("here is the items: mediaListEdit ${items}");
    }
    for (var items in mediaListFile) {
      print("here is the items: mediaListFile ${items.path}");
    }
    for (var items in fileImages) {
      print("here is the fileImages ${items.runtimeType}");
    }



    mediaFileList=[];
    update();
    // mediaListEdit.add(i);
  }


  void togglePlayPause() {
    if (videoPlayerController != null) {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController?.pause();
      } else {
        videoPlayerController?.play();
      }
      update(); // Notify the UI to update play/pause state
    }
  }
    @override
    void onClose() {
   controllerVideo?.dispose();
      videoPlayerController?.dispose();
      controllerVideo?.dispose();
      super.onClose();
    }
}
