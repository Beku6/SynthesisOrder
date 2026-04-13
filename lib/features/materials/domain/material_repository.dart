import '../../users/domain/user_models.dart';
import 'material_models.dart';

abstract class MaterialRepository {
  Future<List<LessonMaterial>> fetchMaterialsForUser(SynorUser user);

  Future<LessonMaterial> uploadMaterial({
    required SynorUser actor,
    required MaterialUploadDraft draft,
  });
}
