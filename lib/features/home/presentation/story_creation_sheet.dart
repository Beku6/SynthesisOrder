import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../application/home_content_provider.dart';

class StoryCreationSheet extends ConsumerStatefulWidget {
  const StoryCreationSheet({super.key});

  @override
  ConsumerState<StoryCreationSheet> createState() => _StoryCreationSheetState();
}

class _StoryCreationSheetState extends ConsumerState<StoryCreationSheet> {
  File? _selectedFile;
  StoryMediaType? _mediaType;
  bool _isUploading = false;
  final _captionController = TextEditingController();

  Future<void> _pickMedia(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source); // For MVP picking image, video support can be added

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _mediaType = StoryMediaType.image;
      });
    }
  }

  Future<void> _upload() async {
    if (_selectedFile == null || _mediaType == null) return;

    setState(() => _isUploading = true);
    
    try {
      await ref.read(homeContentRepositoryProvider).uploadStory(
        filePath: _selectedFile!.path,
        type: _mediaType!,
        caption: _captionController.text,
      );
      
      if (mounted) {
        Navigator.pop(context);
        ref.invalidate(homeContentProvider);
        showSynorToast(
          context,
          message: 'Story posted!',
          icon: LucideIcons.circle_check,
          accentColor: SynorColors.emerald500,
        );
      }
    } catch (e) {
      if (mounted) {
        showSynorToast(
          context,
          message: 'Upload failed',
          icon: LucideIcons.circle_alert,
          accentColor: Colors.red,
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: synorIsDark(context) ? SynorColors.panelBlack : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: SynorColors.slate300.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Create Story',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 32),
          if (_selectedFile == null)
            Row(
              children: [
                Expanded(
                  child: _buildSourceCard(
                    icon: LucideIcons.camera,
                    label: 'Camera',
                    onTap: () => _pickMedia(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSourceCard(
                    icon: LucideIcons.image,
                    label: 'Gallery',
                    onTap: () => _pickMedia(ImageSource.gallery),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.file(_selectedFile!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 24),
                SynorSearchField(
                  hintText: 'Add a caption...',
                  controller: _captionController,
                  prefixIcon: LucideIcons.type,
                ),
                const SizedBox(height: 24),
                SynorPrimaryButton(
                  label: _isUploading ? 'Posting...' : 'Post Story',
                  onTap: _isUploading ? () {} : _upload,
                  icon: _isUploading ? null : LucideIcons.send,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _selectedFile = null),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSourceCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return PressableScale(
      onTap: onTap,
      child: SynorGlassPanel(
        padding: const EdgeInsets.symmetric(vertical: 32),
        radius: 24,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SynorColors.indigo500.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: SynorColors.indigo500, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
