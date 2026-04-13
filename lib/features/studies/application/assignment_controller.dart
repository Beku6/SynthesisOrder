import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/supabase_studies_repository.dart';
import '../domain/studies_repository.dart';
import 'studies_controller.dart';

class AssignmentController extends StateNotifier<AsyncValue<void>> {
  AssignmentController(this._repository, this.ref) : super(const AsyncData(null));

  final StudiesRepository _repository;
  final Ref ref;

  Future<void> createAssignment({
    required int lessonId,
    required String title,
    String? description,
    required DateTime deadline,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.createAssignment(
        lessonId: lessonId,
        title: title,
        description: description,
        deadline: deadline,
      );
      // Invalidate assignments to refresh the student/teacher view
      ref.invalidate(assignmentsProvider);
    });
  }

  Future<void> deleteAssignment(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteAssignment(id);
      ref.invalidate(assignmentsProvider);
    });
  }
}

final assignmentControllerProvider =
    StateNotifierProvider<AssignmentController, AsyncValue<void>>((ref) {
  return AssignmentController(ref.watch(studiesRepositoryProvider), ref);
});
