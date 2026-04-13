import '../../../shared/models/app_models.dart';

abstract class CoverTemplateRepository {
  List<CoverTemplate> fetchTemplates();
}
