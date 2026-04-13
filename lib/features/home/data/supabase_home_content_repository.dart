import 'dart:io';
import 'dart:ui';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/models/app_models.dart';
import '../domain/home_content_repository.dart';

class SupabaseHomeContentRepository implements HomeContentRepository {
  const SupabaseHomeContentRepository(this._client);

  final SupabaseClient _client;

  static const _filters = ['lessons', 'all', 'missed', 'tomorrow'];

  @override
  Future<HomeContent> fetchContent() async {
    try {
      final rows = await _client
          .from('user_stories')
          .select(
            'id, border_color, media_url, media_type, caption, user_id, author:users(name)',
          )
          .gte('expires_at', DateTime.now().toUtc().toIso8601String())
          .order('created_at', ascending: true);

      final groupedStories = <String, List<StoryMedia>>{};
      final userMeta = <String, Map<String, dynamic>>{};

      for (final row in rows) {
        final userId = row['user_id'] as String;
        final author = row['author'] as Map<String, dynamic>?;

        final media = StoryMedia(
          id: row['id'] as String,
          url: row['media_url'] as String,
          type: row['media_type'] == 'video'
              ? StoryMediaType.video
              : StoryMediaType.image,
          caption: row['caption'] as String?,
        );

        if (!groupedStories.containsKey(userId)) {
          groupedStories[userId] = [];
          userMeta[userId] = {
            'name': author?['name'] as String? ?? 'User',
            'borderColor': _mapColor(row['border_color'] as String?),
          };
        }
        groupedStories[userId]!.add(media);
      }

      final stories = <StoryItem>[
        const StoryItem(
          userId: 'current',
          name: 'You Stories',
          borderColor: SynorColors.slate100,
          icon: LucideIcons.user,
          isAddStory: true,
        ),
      ];

      for (final userId in groupedStories.keys) {
        final meta = userMeta[userId]!;
        stories.add(
          StoryItem(
            userId: userId,
            name: meta['name'] as String,
            borderColor: meta['borderColor'] as Color,
            stories: groupedStories[userId]!,
            hasUnviewed: true, // TODO: Check viewed status from local/remote
          ),
        );
      }

      return HomeContent(stories: stories, filters: _filters);
    } catch (_) {
      return const HomeContent(
        stories: [
          StoryItem(
            userId: 'current',
            name: 'You Stories',
            borderColor: SynorColors.slate100,
            icon: LucideIcons.user,
            isAddStory: true,
          ),
        ],
        filters: _filters,
      );
    }
  }

  Color _mapColor(String? colorStr) {
    if (colorStr == null) return SynorColors.purple600;
    if (colorStr.contains('purple')) return SynorColors.purple600;
    if (colorStr.contains('rose')) return SynorColors.rose500;
    if (colorStr.contains('emerald')) return SynorColors.emerald500;
    if (colorStr.contains('cyan')) return SynorColors.cyan500;
    if (colorStr.contains('yellow')) return SynorColors.yellow400;
    return SynorColors.indigo600;
  }

  @override
  Future<void> uploadStory({
    required String filePath,
    required StoryMediaType type,
    String? caption,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${filePath.split('/').last}';
    final path = 'stories/${user.id}/$fileName';

    final file = File(filePath);
    await _client.storage.from('stories').upload(path, file);
    final publicUrl = _client.storage.from('stories').getPublicUrl(path);

    await _client.from('user_stories').insert({
      'user_id': user.id,
      'media_url': publicUrl,
      'media_type': type == StoryMediaType.video ? 'video' : 'image',
      'caption': caption,
      'expires_at': DateTime.now()
          .add(const Duration(hours: 24))
          .toUtc()
          .toIso8601String(),
    });
  }
}
