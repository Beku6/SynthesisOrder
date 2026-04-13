import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../../../app/router/app_route_controller.dart';

class GlobalSearchOverlay extends ConsumerStatefulWidget {
  const GlobalSearchOverlay({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  ConsumerState<GlobalSearchOverlay> createState() => _GlobalSearchOverlayState();
}

class _GlobalSearchOverlayState extends ConsumerState<GlobalSearchOverlay> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: widget.onClose,
            child: SynorModalScrim(opacity: synorIsDark(context) ? 0.8 : 0.4),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Search Bar
                  SynorGlassPanel(
                    radius: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(LucideIcons.search, size: 20, color: SynorColors.indigo500),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            onChanged: (v) => setState(() => _query = v.trim()),
                            decoration: const InputDecoration(
                              hintText: 'Search for anything...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SynorIconActionButton(
                          icon: LucideIcons.x,
                          onTap: widget.onClose,
                          buttonSize: 32,
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_query.isNotEmpty)
                    Expanded(
                      child: SynorGlassPanel(
                        radius: 24,
                        padding: const EdgeInsets.all(12),
                        child: ListView(
                          children: [
                            _SearchSection(
                              title: 'Academics',
                              items: [
                                _SearchResultTile(
                                  title: 'Advanced Mathematics',
                                  subtitle: 'Room 402 • 10:00 AM',
                                  icon: LucideIcons.book_marked,
                                  onTap: widget.onClose,
                                ),
                              ],
                            ),
                            _SearchSection(
                              title: 'People',
                              items: [
                                _SearchResultTile(
                                  title: 'Prof. Sarah Wilson',
                                  subtitle: 'Department of Science',
                                  icon: LucideIcons.user,
                                  onTap: widget.onClose,
                                ),
                              ],
                            ),
                            _SearchSection(
                              title: 'Resources',
                              items: [
                                _SearchResultTile(
                                  title: 'Lab Report Template',
                                  subtitle: 'PDF Document • 2.4 MB',
                                  icon: LucideIcons.file_text,
                                  onTap: widget.onClose,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchSection extends StatelessWidget {
  const _SearchSection({required this.title, required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: synorSecondaryText(context),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: SynorColors.indigo500.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: SynorColors.indigo500, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: synorPrimaryText(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: synorSecondaryText(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevron_right, size: 16, color: SynorColors.white20),
          ],
        ),
      ),
    );
  }
}
