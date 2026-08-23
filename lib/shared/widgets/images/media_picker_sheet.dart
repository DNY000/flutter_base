/*
 * ==============================================================================
 * [MediaPickerSheet] - Bottom Sheet Chọn & Chụp Ảnh / Video (Shared Widget)
 * 
 * 🇻🇳 TIẾNG VIỆT:
 * - Chức năng: Widget hiển thị BottomSheet tiện lợi cho phép người dùng:
 *   1. Chụp ảnh từ Camera
 *   2. Chọn ảnh từ Thư viện (Gallery / Photo Library)
 *   3. Quay video hoặc Chọn video từ Thư viện
 * 
 * 🇬🇧 ENGLISH:
 * - Purpose: Modal bottom sheet widget for picking and capturing images and videos.
 * ==============================================================================
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerSheet extends StatelessWidget {
  final bool enableVideo;
  final Function(File file)? onMediaPicked;
  final ImagePicker _picker = ImagePicker();

  MediaPickerSheet({
    super.key,
    this.enableVideo = false,
    this.onMediaPicked,
  });

  /// Hàm tiện ích hiển thị BottomSheet
  static Future<File?> show(
    BuildContext context, {
    bool enableVideo = false,
  }) {
    return showModalBottomSheet<File?>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => MediaPickerSheet(
        enableVideo: enableVideo,
        onMediaPicked: (file) => Navigator.of(ctx).pop(file),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null) {
        final file = File(picked.path);
        onMediaPicked?.call(file);
      }
    } catch (_) {}
  }

  Future<void> _pickVideo(BuildContext context, ImageSource source) async {
    try {
      final picked = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );
      if (picked != null) {
        final file = File(picked.path);
        onMediaPicked?.call(file);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: Colors.blueAccent),
              title: const Text('Chụp ảnh từ Camera'),
              onTap: () => _pickImage(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Colors.green),
              title: const Text('Chọn ảnh từ Thư viện'),
              onTap: () => _pickImage(context, ImageSource.gallery),
            ),
            if (enableVideo) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.videocam_outlined, color: Colors.deepOrange),
                title: const Text('Quay video mới'),
                onTap: () => _pickVideo(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.video_library_outlined, color: Colors.purple),
                title: const Text('Chọn video từ Thư viện'),
                onTap: () => _pickVideo(context, ImageSource.gallery),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
