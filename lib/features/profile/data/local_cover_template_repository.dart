import '../../../app/assets/synor_assets.dart';
import '../../../shared/models/app_models.dart';
import '../domain/cover_template_repository.dart';

class LocalCoverTemplateRepository implements CoverTemplateRepository {
  const LocalCoverTemplateRepository();

  static const _templates = [
    CoverTemplate(title: 'cover.campus', assetPath: SynorAssets.campusCover),
    CoverTemplate(title: 'cover.library', assetPath: SynorAssets.libraryCover),
    CoverTemplate(
      title: 'cover.graduation',
      assetPath: SynorAssets.graduationCover,
    ),
    CoverTemplate(
      title: 'cover.architecture',
      assetPath: SynorAssets.architectureCover,
    ),
    CoverTemplate(
      title: 'cover.abstractTech',
      assetPath: SynorAssets.abstractTechCover,
    ),
    CoverTemplate(title: 'cover.science', assetPath: SynorAssets.scienceCover),
  ];

  @override
  List<CoverTemplate> fetchTemplates() => _templates;
}
