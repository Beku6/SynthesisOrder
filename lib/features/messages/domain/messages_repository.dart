import '../../../shared/models/app_models.dart';

abstract class MessagesRepository {
  Future<List<MessagePreview>> fetchMessages();
}
