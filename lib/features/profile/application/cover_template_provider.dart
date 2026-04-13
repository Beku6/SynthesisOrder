import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_models.dart';
import '../data/local_cover_template_repository.dart';
import '../domain/cover_template_repository.dart';

final coverTemplateRepositoryProvider = Provider<CoverTemplateRepository>((
  ref,
) {
  return const LocalCoverTemplateRepository();
});

final coverTemplatesProvider = Provider<List<CoverTemplate>>((ref) {
  return ref.watch(coverTemplateRepositoryProvider).fetchTemplates();
});
