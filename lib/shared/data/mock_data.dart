import 'package:flutter_lucide/flutter_lucide.dart';

import '../../app/assets/synor_assets.dart';
import '../../app/theme/synor_design_tokens.dart';
import '../models/app_models.dart';

abstract final class SynorMockData {
  static List<Lesson> lessons() {
    return const [
      Lesson(
        id: 4,
        title: 'Physics Lab',
        time: '13:00-14:50',
        location: 'Main Building, Room 201',
        teacher: 'Prof. Ivanov',
        countdown: '00:00:00',
        colorVariant: LessonColorVariant.indigo,
      ),
      Lesson(
        id: 1,
        title: 'Web Programming and Python',
        time: '15:00-15:50',
        location: 'Tole bi №86',
        teacher: 'Urazimbetov M.',
        countdown: '00:04:12',
        colorVariant: LessonColorVariant.rose,
      ),
      Lesson(
        id: 2,
        title: 'Algoritm and Matemathics',
        time: '17:00-19:50',
        location: 'Tole bi №86',
        teacher: 'Alexandr S.',
        countdown: '26:15:12',
        colorVariant: LessonColorVariant.emerald,
      ),
      Lesson(
        id: 3,
        title: 'Database Management Systems',
        time: '10:00-11:50',
        location: 'Kazybek bi №30',
        teacher: 'Nurlan K.',
        countdown: '12:45:00',
        colorVariant: LessonColorVariant.indigo,
      ),
    ];
  }

  static const stories = [
    StoryItem(
      name: 'You Stories',
      borderColor: SynorColors.slate100,
      icon: LucideIcons.user,
      isAddStory: true,
    ),
    StoryItem(
      name: 'Nurali Askar',
      borderColor: SynorColors.purple600,
      avatarAsset: SynorAssets.nuraliAvatar,
    ),
    StoryItem(
      name: 'Moer',
      borderColor: SynorColors.yellow400,
      icon: LucideIcons.user,
    ),
    StoryItem(
      name: 'Aruzhan',
      borderColor: SynorColors.rose500,
      avatarAsset: SynorAssets.aruzhanAvatar,
    ),
    StoryItem(
      name: 'Dias',
      borderColor: SynorColors.emerald500,
      avatarAsset: SynorAssets.diasAvatar,
    ),
    StoryItem(
      name: 'Madina',
      borderColor: SynorColors.cyan500,
      avatarAsset: SynorAssets.madinaAvatar,
    ),
  ];

  static const homeFilters = ['lessons', 'all', 'missed', 'tomorrow'];

  static const scheduleDays = [
    ('Mon', '12', false),
    ('Tue', '13', true),
    ('Wed', '14', false),
    ('Thu', '15', false),
    ('Fri', '16', false),
    ('Sat', '17', false),
  ];

  static const serviceCategories = [
    ServiceCategoryData(
      id: ServiceView.documents,
      title: 'Documents',
      subtitle: 'Certificates & references',
      color: SynorColors.indigo500,
    ),
    ServiceCategoryData(
      id: ServiceView.payments,
      title: 'Payments',
      subtitle: 'Tuition & dormitory',
      color: SynorColors.emerald500,
    ),
    ServiceCategoryData(
      id: ServiceView.housing,
      title: 'Housing',
      subtitle: 'Dormitory requests',
      color: SynorColors.amber500,
    ),
    ServiceCategoryData(
      id: ServiceView.support,
      title: 'Support',
      subtitle: 'IT & Academic help',
      color: SynorColors.rose500,
    ),
  ];

  static List<ServiceRequest> requests() {
    return const [
      ServiceRequest(
        id: 1,
        title: 'Enrollment Certificate',
        date: 'Oct 12',
        status: RequestStatus.ready,
        type: RequestType.document,
        description: 'Requested for visa application.',
      ),
      ServiceRequest(
        id: 2,
        title: 'Dormitory Repair',
        date: 'Oct 10',
        status: RequestStatus.inProgress,
        type: RequestType.housing,
        description: 'Leaking pipe in bathroom.',
      ),
    ];
  }

  static const quickAlertPresets = [
    '5 min before',
    '10 min before',
    '20 min before',
    '30 min before',
    '1 hour before',
    'Leave on time',
    'Wake up before class',
  ];

  static const coverTemplates = [
    CoverTemplate(title: 'Campus', assetPath: SynorAssets.campusCover),
    CoverTemplate(title: 'Library', assetPath: SynorAssets.libraryCover),
    CoverTemplate(title: 'Graduation', assetPath: SynorAssets.graduationCover),
    CoverTemplate(
      title: 'Architecture',
      assetPath: SynorAssets.architectureCover,
    ),
    CoverTemplate(
      title: 'Abstract Tech',
      assetPath: SynorAssets.abstractTechCover,
    ),
    CoverTemplate(title: 'Science', assetPath: SynorAssets.scienceCover),
  ];

  static const profile = ProfileData(
    name: 'Nurlan K.',
    username: '@nurlan_k',
    university: 'KazNPU',
    bio:
        'Passionate about Frontend, AI, and building things. Always up for a hackathon!',
    program: 'Software Engineering',
    yearLabel: '2nd Year',
    groupLabel: 'SE-31',
    coverAsset: SynorAssets.campusCover,
    avatarAsset: SynorAssets.studentAvatar,
  );

  static const messages = [
    MessagePreview(
      name: 'Nurali Askar',
      preview: 'Hey, are we still meeting for the project?',
      timestamp: '10:42 AM',
      avatarAsset: SynorAssets.nuraliAvatar,
    ),
    MessagePreview(
      name: 'Aruzhan',
      preview: 'Thanks for the notes!',
      timestamp: 'Yesterday',
      avatarAsset: SynorAssets.aruzhanAvatar,
    ),
    MessagePreview(
      name: 'University Admin',
      preview: 'Your schedule has been updated.',
      timestamp: 'Mon',
      fallbackIcon: LucideIcons.user,
    ),
  ];
}
