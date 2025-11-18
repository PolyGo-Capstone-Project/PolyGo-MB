import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostImagePickerWrapper extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function(List<XFile>) onImagesChanged;

  const CreatePostImagePickerWrapper({
    super.key,
    required this.selectedImages,
    required this.onImagesChanged,
  });

  void _pickImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      onImagesChanged([...selectedImages, ...images]);
    }
  }

  void _showSelectedImages(BuildContext context) {
    if (selectedImages.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) {
        // Tạo bản sao ảnh để thao tác bên trong dialog
        List<XFile> dialogImages = [...selectedImages];

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black.withOpacity(0.8),
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: dialogImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Center(
                            child: Image.file(
                              File(dialogImages[index].path),
                              fit: BoxFit.contain,
                            ),
                          ),
                          // Nút xóa ở dưới góc phải
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                              onPressed: () {
                                setState(() {
                                  dialogImages.removeAt(index);
                                });
                                onImagesChanged(dialogImages);
                                if (dialogImages.isEmpty) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // Nút đóng dialog
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white70 : Colors.black87;

    return Row(
      children: [
        // Nút chọn ảnh
        InkWell(
          onTap: () => _pickImages(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.image_outlined,
                    color: isDark ? Colors.white70 : Colors.grey[800]),
                const SizedBox(width: 6),
                Text("Chọn ảnh", style: TextStyle(color: textColor)),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Nút xem ảnh đã chọn (chỉ hiện khi có ảnh)
        if (selectedImages.isNotEmpty)
          InkWell(
            onTap: () => _showSelectedImages(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${selectedImages.length} ảnh đã chọn",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
