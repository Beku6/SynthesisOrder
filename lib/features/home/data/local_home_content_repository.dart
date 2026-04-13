import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../app/assets/synor_assets.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/models/app_models.dart';
import '../domain/home_content_repository.dart';

class LocalHomeContentRepository implements HomeContentRepository {
  const LocalHomeContentRepository();

  static const _stories = [
    StoryItem(
      name: 'You Stories',
      borderColor: SynorColors.slate100,
      icon: LucideIcons.user,
      isAddStory: true,
    ),
    StoryItem(
      name: 'Nurali Askar',
      borderColor: SynorColors.purple600,
      avatarAsset: SynorAssets.nuraliAvatar,
    ),
    StoryItem(
      name: 'Moer',
      borderColor: SynorColors.yellow400,
      icon: LucideIcons.user,
    ),
    StoryItem(
      name: 'Aruzhan',
      borderColor: SynorColors.rose500,
      avatarAsset: SynorAssets.aruzhanAvatar,
    ),
    StoryItem(
      name: 'Dias',
      borderColor: SynorColors.emerald500,
      avatarAsset: SynorAssets.diasAvatar,
    ),
    StoryItem(
      name: 'Madina',
      borderColor: SynorColors.cyan500,
      avatarAsset: SynorAssets.madinaAvatar,
    ),
  ];

  static const _filters = ['lessons', 'all', 'missed', 'tomorrow'];

  @override
  HomeContent fetchContent() {
    return const HomeContent(stories: _stories, filters: _filters);
  }
}
