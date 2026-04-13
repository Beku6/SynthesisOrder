import 'user_models.dart';

abstract class UserRepository {
  Future<SynorUser?> fetchCurrentUser();

  Future<SynorUser?> fetchUserById(String userId);

  Future<List<GroupData>> fetchGroups();

  Future<List<SynorUser>> fetchUsersByGroup(int groupId);
}
