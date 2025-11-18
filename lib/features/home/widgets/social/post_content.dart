import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polygo_mobile/core/utils/string_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../../../../data/models/api_response.dart';
import '../../../../data/models/post/post_model.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/media_repository.dart';
import '../../../../data/repositories/post_repository.dart';
import '../../../../data/services/apis/auth_service.dart';
import '../../../../data/services/apis/media_service.dart';
import '../../../../data/services/apis/post_service.dart';
import '../../../shared/app_error_state.dart';
import 'create_post_image_picker.dart';
import 'post_card.dart';

class PostContent extends StatefulWidget {
  final String searchQuery;
  const PostContent({super.key, this.searchQuery = ''});

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  final TextEditingController _controller = TextEditingController();
  String? selectedImage;
  String? _userAvatar;
  bool _loading = true;
  String? _error;
  List<PostModel> _posts = [];
  late PostRepository _repo;
  List<XFile> _selectedImages = [];
  bool _loadingPost = false;

  @override
  void initState() {
    super.initState();
    _repo = PostRepository(PostService(ApiClient()));
    _loadUserAvatar();
    _loadPosts();
  }

  Future<void> _loadUserAvatar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final repo = AuthRepository(AuthService(ApiClient()));
      final user = await repo.me(token);
      if (!mounted) return;

      setState(() {
        _userAvatar = user.avatarUrl;
      });
    } catch (e) {
      //
    }
  }

  Future<void> _loadPosts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception("Token not found");

      final ApiResponse<PostPaginationResponse> response =
      await _repo.getAllPosts(token: token);

      if (!mounted) return;

      if (response.data != null) {
        setState(() {
          _posts = response.data!.items;
          _loading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? "Lỗi không xác định";
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<PostModel> get _displayedPosts {
    final query = widget.searchQuery.trim();
    if (query.isEmpty) return _posts;

    return _posts.where((e) => e.content.fuzzyContains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: AppErrorState(
          onRetry: _loadPosts,
        ),
      );
    }

    final postsToShow = _displayedPosts;

    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        children: [
          _buildCreatePostBox(context),
          const SizedBox(height: 16),
          Divider(
            color: Colors.grey.withOpacity(0.3),
            thickness: 1,
          ),
          const SizedBox(height: 16),
          ...postsToShow.map((post) {
            return PostCard(
              post: post,
              avatarUrl: post.creator.avatarUrl,
              userName: post.creator.name,
              timeAgo: "${DateTime.now().difference(post.createdAt).inHours} giờ trước",
              contentText: post.content,
              contentImage: post.imageUrls.isNotEmpty ? post.imageUrls.first : null,
              reactCount: post.reactionsCount,
              commentCount: post.commentsCount,
              onPostDeleted: (postId) async {
                await _loadPosts();
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCreatePostBox(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white70 : Colors.black87;
    final Color secondaryText = isDark ? Colors.white54 : Colors.grey[700]!;

    final Gradient cardBackground = isDark
        ? const LinearGradient(
      colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
        : const LinearGradient(colors: [Colors.white, Colors.white]);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hôm nay bạn muốn chia sẻ gì?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey,
                backgroundImage: _userAvatar != null
                    ? NetworkImage(_userAvatar!)
                    : null,
                child: _userAvatar == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Chia sẻ cảm nghĩ của bạn...",
                    hintStyle: TextStyle(color: secondaryText),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              CreatePostImagePickerWrapper(
                selectedImages: _selectedImages,
                onImagesChanged: (images) {
                  setState(() {
                    _selectedImages = images;
                  });
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _loadingPost
                    ? null
                    : () async {
                  final content = _controller.text.trim();
                  if (content.isEmpty && _selectedImages.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vui lòng nhập nội dung hoặc chọn ảnh")),
                    );
                    return;
                  }

                  setState(() {
                    _loadingPost = true;
                  });

                  try {
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token');
                    if (token == null) throw Exception("Token not found");

                    List<String> imageUrls = [];

                    if (_selectedImages.isNotEmpty) {
                      final List<File> files = _selectedImages.map((e) => File(e.path)).toList();
                      final mediaRepo = MediaRepository(MediaService(ApiClient()));
                      final uploadResponse = await mediaRepo.uploadImages(token, files);

                      if (uploadResponse.data != null) {
                        imageUrls = uploadResponse.data!.urls;
                      } else {
                        throw Exception(uploadResponse.message ?? "Upload ảnh thất bại");
                      }
                    }

                    // Tạo post mới
                    final postResponse = await _repo.createPost(
                      token: token,
                      content: content,
                      imageUrls: imageUrls,
                    );

                    if (postResponse.data != null) {
                      // Reload danh sách bài viết từ server để đồng bộ react/comment
                      await _loadPosts();

                      _controller.clear();
                      _selectedImages.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đăng bài thành công")),
                      );
                    } else {
                      throw Exception(postResponse.message ?? "Đăng bài thất bại");
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _loadingPost = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _loadingPost
                    ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Text("Đăng"),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
