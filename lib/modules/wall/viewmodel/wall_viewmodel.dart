import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/wall_repository.dart';
import '../../../core/services/firebase_service.dart';

class WallViewModel extends GetxController {
  late final WallRepository _wallRepository;
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  RxList<PostModel> posts = <PostModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    loadPosts();
  }

  void _initializeRepository() {
    try {
      _wallRepository = Get.put(WallRepository());
    } catch (e) {
      print('⚠️ Repository initialization failed, using demo mode');
      isDemoMode.value = true;
    }
  }

  void loadPosts() {
    if (isDemoMode.value || !_firebaseService.isInitialized) {
      _loadDemoData();
      return;
    }

    try {
      _wallRepository.getAllPosts().listen(
        (postsList) {
          posts.value = postsList;
          isLoading.value = false;
        },
        onError: (error) {
          print('Error loading posts: $error');
          _loadDemoData();
        },
      );
    } catch (e) {
      print('Error in loadPosts: $e');
      _loadDemoData();
    }
  }

  void _loadDemoData() {
    posts.value = [
      PostModel(
        id: '1',
        userId: '1',
        userName: 'Ahmed',
        text: 'Missing my family back home! Can\'t wait to visit soon. 🏠❤️',
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
        likes: ['2', '3'],
        likeCount: 2,
      ),
      PostModel(
        id: '2',
        userId: '2',
        userName: 'Fatima',
        text:
            'Just finished preparing lunch. Wish we could all eat together! 🍽️',
        createdAt: DateTime.now().subtract(Duration(hours: 5)),
        likes: ['1', '3', '4'],
        likeCount: 3,
      ),
      PostModel(
        id: '3',
        userId: '3',
        userName: 'Omar',
        text: 'Beautiful weather today in Cairo! 🌞',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        likes: ['1', '2'],
        likeCount: 2,
      ),
    ];
    isLoading.value = false;
    isDemoMode.value = true;
  }

  Future<void> createPost(
    String userId,
    String userName,
    String? userPhotoUrl,
    String text,
  ) async {
    if (isDemoMode.value) {
      print('Demo mode: Cannot create posts');
      return;
    }
    await _wallRepository.createPost(
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      text: text,
    );
  }

  Future<void> toggleLike(String postId, String userId) async {
    if (isDemoMode.value) {
      print('Demo mode: Cannot toggle likes');
      return;
    }
    await _wallRepository.toggleLike(postId, userId);
  }

  Future<void> deletePost(String postId, String userId) async {
    if (isDemoMode.value) {
      print('Demo mode: Cannot delete posts');
      return;
    }
    await _wallRepository.deletePost(postId, userId);
  }
}
