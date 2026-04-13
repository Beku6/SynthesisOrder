import '../../../shared/models/app_models.dart';

class HomeContent {
  const HomeContent({required this.stories, required this.filters});

  final List<StoryItem> stories;
  final List<String> filters;
}

abstract class HomeContentRepository {
  Future<HomeContent> fetchContent();
  Future<void> uploadStory({
    required String filePath,
    required StoryMediaType type,
    String? caption,
  });
}
