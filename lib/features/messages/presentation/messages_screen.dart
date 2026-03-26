import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/synor_widgets.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: synorIsDark(context)
                    ? const Color(0x1AFFFFFF)
                    : const Color(0xFFE2E8F0),
              ),
            ),
          ),
          child: Row(
            children: [
              SynorIconActionButton(
                icon: LucideIcons.chevron_left,
                onTap: onBack,
                buttonSize: 40,
                radius: 999,
                size: 24,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                boxShadow: const [],
                foregroundColor: synorIsDark(context)
                    ? Colors.white
                    : const Color(0xFF0F172A),
              ),
              const SizedBox(width: 16),
              Text(
                'Messages',
                style: TextStyle(
                  color: synorPrimaryText(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            itemCount: SynorMockData.messages.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return MessageTile(preview: SynorMockData.messages[index]);
            },
          ),
        ),
      ],
    );
  }
}
