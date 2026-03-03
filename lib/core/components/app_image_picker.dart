import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<File>> pickImages(BuildContext context) async {
    final source = await _showPickerSheet(context);
    if (source == null || !context.mounted) return [];

    if (source == ImageSource.gallery) {
      final picked = await _picker.pickMultiImage();
      return picked.map((e) => File(e.path)).toList();
    } else {
      final picked = await _picker.pickImage(source: source);
      return picked != null ? [File(picked.path)] : [];
    }
  }

  static Future<File?> pickImage(BuildContext context, {int? quality}) async {
    final source = await _showPickerSheet(context);
    if (source == null || !context.mounted) return null;
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: quality,
    );
    return picked != null ? File(picked.path) : null;
  }

  static Future<ImageSource?> _showPickerSheet(BuildContext context) async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => const _ImageSourceBottomSheet(),
    );
  }
}

class _ImageSourceBottomSheet extends StatelessWidget {
  const _ImageSourceBottomSheet();

  @override
  Widget build(BuildContext context) {
    final bootomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 30, bottom: bootomPadding + 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _OptionButton(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            _OptionButton(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
