import '../../../app/assets/synor_assets.dart';
import '../../../shared/models/app_models.dart';
import '../domain/messages_repository.dart';

class LocalMessagesRepository implements MessagesRepository {
  const LocalMessagesRepository();

  static const _messages = [
    MessagePreview(
      roomId: 'room-1',
      name: 'Nurali Askar',
      preview: 'message.preview.projectMeeting',
      timestamp: 'message.time.1042',
      avatarAsset: SynorAssets.nuraliAvatar,
    ),
    MessagePreview(
      roomId: 'room-2',
      name: 'Aruzhan',
      preview: 'message.preview.thanksNotes',
      timestamp: 'message.time.yesterday',
      avatarAsset: SynorAssets.aruzhanAvatar,
    ),
    MessagePreview(
      roomId: 'room-3',
      name: 'message.sender.universityAdmin',
      preview: 'message.preview.scheduleUpdated',
      timestamp: 'message.time.monday',
    ),
  ];

  @override
  Future<List<MessagePreview>> fetchMessages() async {
    return _messages;
  }
}
