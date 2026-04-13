import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/data/supabase_client_provider.dart';
import '../../users/application/current_user_controller.dart';
import '../data/supabase_studies_repository.dart';
import '../domain/studies_models.dart';
import '../domain/studies_repository.dart';

final studiesRepositoryProvider = Provider<StudiesRepository>((ref) {
  return SupabaseStudiesRepository(ref.watch(supabaseClientProvider));
});

final assignmentsProvider = FutureProvider<List<Assignment>>((ref) async {
  await ref.watch(currentUserControllerProvider.future);
  return ref.read(studiesRepositoryProvider).fetchAssignments();
});

final examsProvider = FutureProvider<List<Exam>>((ref) async {
  await ref.watch(currentUserControllerProvider.future);
  return ref.read(studiesRepositoryProvider).fetchExams();
});
