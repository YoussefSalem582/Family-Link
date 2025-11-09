import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/repositories/wall_repository.dart';
import '../../../core/services/firebase_service.dart';

class WallViewModel extends GetxController {
  late final WallRepository _wallRepository;
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final _storage = GetStorage();

  RxList<PostModel> posts = <PostModel>[].obs;
  RxMap<String, List<CommentModel>> comments =
      <String, List<CommentModel>>{}.obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    _loadSavedData();
    loadPosts();
  }

  void _loadSavedData() {
    // Load saved posts from storage
    final savedPosts = _storage.read<List>('wall_posts');
    if (savedPosts != null) {
      posts.value = savedPosts
          .map((p) => _postFromStorage(Map<String, dynamic>.from(p)))
          .toList();
      print('✅ Loaded ${posts.length} saved posts from storage');
    } else {
      print('ℹ️ No saved posts found in storage');
    }

    // Load saved comments from storage
    final savedComments = _storage.read<Map>('wall_comments');
    if (savedComments != null) {
      savedComments.forEach((postId, commentsList) {
        if (commentsList is List) {
          comments[postId] = commentsList
              .map((c) => _commentFromStorage(Map<String, dynamic>.from(c)))
              .toList();
        }
      });
      print('✅ Loaded comments for ${comments.length} posts from storage');
    } else {
      print('ℹ️ No saved comments found in storage');
    }
  }

  void _savePosts() {
    _storage.write('wall_posts', posts.map((p) => _postToStorage(p)).toList());
    print('💾 Saved ${posts.length} posts to storage');
  }

  void _saveComments() {
    final commentsMap = <String, dynamic>{};
    comments.forEach((postId, commentsList) {
      commentsMap[postId] = commentsList
          .map((c) => _commentToStorage(c))
          .toList();
    });
    _storage.write('wall_comments', commentsMap);
    print('💾 Saved comments for ${comments.length} posts to storage');
  }

  // Storage serialization helpers
  Map<String, dynamic> _postToStorage(PostModel post) {
    return {
      'id': post.id,
      'userId': post.userId,
      'userName': post.userName,
      'userPhotoUrl': post.userPhotoUrl,
      'text': post.text,
      'imageUrl': post.imageUrl,
      'voiceUrl': post.voiceUrl,
      'createdAt': post.createdAt.toIso8601String(),
      'likes': post.likes,
      'likeCount': post.likeCount,
      'commentCount': post.commentCount,
      'category': post.category,
      'duration': post.duration,
      'title': post.title,
    };
  }

  PostModel _postFromStorage(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhotoUrl: json['userPhotoUrl'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      likes: List<String>.from(json['likes'] ?? []),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      category: json['category'],
      duration: json['duration'],
      title: json['title'],
    );
  }

  Map<String, dynamic> _commentToStorage(CommentModel comment) {
    return {
      'id': comment.id,
      'postId': comment.postId,
      'userId': comment.userId,
      'userName': comment.userName,
      'userPhotoUrl': comment.userPhotoUrl,
      'text': comment.text,
      'createdAt': comment.createdAt.toIso8601String(),
    };
  }

  CommentModel _commentFromStorage(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhotoUrl: json['userPhotoUrl'],
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
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
      // In demo mode, just refresh the UI with current data
      // Don't reload demo data if we already have posts
      if (posts.isEmpty) {
        _loadDemoData();
      } else {
        isLoading.value = false;
      }
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
          if (posts.isEmpty) {
            _loadDemoData();
          } else {
            isLoading.value = false;
          }
        },
      );
    } catch (e) {
      print('Error in loadPosts: $e');
      if (posts.isEmpty) {
        _loadDemoData();
      } else {
        isLoading.value = false;
      }
    }
  }

  void _loadDemoData() {
    // Only load initial demo data if no saved data exists
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
    print('ℹ️ Loaded initial demo data (first time only)');
  }

  Future<void> createPost(
    String userId,
    String userName,
    String? userPhotoUrl,
    String text,
  ) async {
    if (isDemoMode.value) {
      // In demo mode, add post locally
      final newPost = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        text: text,
        createdAt: DateTime.now(),
        likes: [],
        likeCount: 0,
        commentCount: 0,
      );
      posts.insert(0, newPost);
      _savePosts(); // Save to storage
      Get.snackbar(
        'success'.tr,
        'wall_post_created'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    try {
      final success = await _wallRepository.createPost(
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        text: text,
      );

      if (success) {
        Get.snackbar(
          'success'.tr,
          'wall_post_created'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to create post',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    if (isDemoMode.value) {
      // In demo mode, toggle likes locally
      final postIndex = posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        final post = posts[postIndex];
        List<String> updatedLikes = List.from(post.likes);

        if (updatedLikes.contains(userId)) {
          updatedLikes.remove(userId);
          Get.snackbar(
            'success'.tr,
            'wall_unliked'.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 1),
          );
        } else {
          updatedLikes.add(userId);
          Get.snackbar(
            'success'.tr,
            'wall_liked'.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 1),
          );
        }

        posts[postIndex] = post.copyWith(
          likes: updatedLikes,
          likeCount: updatedLikes.length,
        );
        posts.refresh();
        _savePosts(); // Save to storage
      }
      return;
    }

    await _wallRepository.toggleLike(postId, userId);
  }

  Future<void> deletePost(String postId, String userId) async {
    if (isDemoMode.value) {
      // In demo mode, delete post locally
      posts.removeWhere((p) => p.id == postId);
      comments.remove(postId); // Remove associated comments
      _savePosts(); // Save to storage
      _saveComments(); // Save comments to storage
      Get.snackbar(
        'success'.tr,
        'wall_post_deleted'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    try {
      final success = await _wallRepository.deletePost(postId, userId);
      if (success) {
        Get.snackbar(
          'success'.tr,
          'wall_post_deleted'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to delete post',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  // Add comment to a post
  Future<void> addComment(
    String postId,
    String userId,
    String userName,
    String? userPhotoUrl,
    String text,
  ) async {
    final comment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      text: text,
      createdAt: DateTime.now(),
    );

    if (isDemoMode.value) {
      // Add comment locally
      if (!comments.containsKey(postId)) {
        comments[postId] = [];
      }
      comments[postId]!.add(comment);

      // Update comment count on post
      final postIndex = posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        posts[postIndex] = posts[postIndex].copyWith(
          commentCount: comments[postId]!.length,
        );
      }

      _saveComments(); // Save to storage
      _savePosts(); // Save updated post

      Get.snackbar(
        'success'.tr,
        'Comment added',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
      return;
    }

    // Firebase implementation would go here
  }

  // Get comments for a post
  List<CommentModel> getComments(String postId) {
    return comments[postId] ?? [];
  }

  // Get voice notes (posts with voiceUrl)
  List<PostModel> getVoiceNotes() {
    return posts
        .where((post) => post.voiceUrl != null && post.voiceUrl!.isNotEmpty)
        .toList();
  }

  // Create voice note
  Future<void> createVoiceNote(
    String userId,
    String userName,
    String? userPhotoUrl,
    String title,
    String category,
    String duration,
    String audioPath,
  ) async {
    if (isDemoMode.value) {
      // In demo mode, add voice note locally
      final newPost = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        text: title, // Use title as text
        voiceUrl: audioPath, // In production, this would be uploaded URL
        createdAt: DateTime.now(),
        likes: [],
        likeCount: 0,
        commentCount: 0,
        category: category,
        duration: duration,
      );
      posts.insert(0, newPost);
      _savePosts(); // Save to storage
      Get.snackbar(
        'success'.tr,
        'voice_notes_created'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // Firebase implementation would go here
      // Upload audio file and create post with voiceUrl
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to create voice note',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
