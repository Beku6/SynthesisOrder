import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route_controller.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../core/async/synor_async_state_view.dart';
import '../../../l10n/app_localization_x.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../application/services_controller.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  final TextEditingController _housingDescriptionController =
      TextEditingController();
  final TextEditingController _supportSubjectController =
      TextEditingController();
  final TextEditingController _supportMessageController =
      TextEditingController();

  @override
  void dispose() {
    _housingDescriptionController.dispose();
    _supportSubjectController.dispose();
    _supportMessageController.dispose();
    super.dispose();
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  IconData _serviceIcon(ServiceView view) {
    return switch (view) {
      ServiceView.documents => LucideIcons.file_badge,
      ServiceView.payments => LucideIcons.credit_card,
      ServiceView.housing => LucideIcons.building,
      ServiceView.support => LucideIcons.circle_question_mark,
      ServiceView.main || ServiceView.allRequests => LucideIcons.compass,
    };
  }

  EdgeInsets _contentPadding({double top = 24}) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return EdgeInsets.fromLTRB(24, top, 24, 132 + keyboardInset);
  }

  List<ServiceCategoryData> _localizedFilteredCategories(ServicesState state) {
    final query = state.searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return state.categories;
    }
    return state.categories.where((service) {
      final title = context.l10n.serviceTitle(service.id).toLowerCase();
      final subtitle = context.l10n.serviceSubtitle(service.id).toLowerCase();
      return title.contains(query) || subtitle.contains(query);
    }).toList();
  }

  Widget _buildSubScreen({
    required ServicesState state,
    required String title,
    required Widget child,
  }) {
    final router = ref.read(appRouteControllerProvider);
    return Column(
      key: ValueKey(state.activeView),
      children: [
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              decoration: BoxDecoration(
                color: synorIsDark(context)
                    ? SynorColors.appBlack.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.8),
                border: Border(
                  bottom: BorderSide(
                    color: synorIsDark(context)
                        ? SynorColors.white10
                        : SynorColors.slate200,
                  ),
                ),
              ),
              child: Row(
                children: [
                  SynorIconActionButton(
                    icon: LucideIcons.chevron_left,
                    onTap: () => router.goToTab(ShellTab.services),
                    buttonSize: 40,
                    radius: 999,
                    size: 24,
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    boxShadow: const [],
                    foregroundColor: synorIsDark(context)
                        ? Colors.white
                        : SynorColors.slate900,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildMainView(ServicesState state) {
    final router = ref.read(appRouteControllerProvider);
    final controller = ref.read(servicesControllerProvider.notifier);
    final services = _localizedFilteredCategories(state);

    return ListView(
      key: const ValueKey(ServiceView.main),
      padding: _contentPadding(top: 48),
      children: [
        Text(
          context.l10n.services_title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        SynorSearchField(
          hintText: context.l10n.services_searchPlaceholder,
          prefixIcon: LucideIcons.search,
          onChanged: controller.setSearchQuery,
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            return ServiceCard(
              title: context.l10n.serviceTitle(service.id),
              subtitle: context.l10n.serviceSubtitle(service.id),
              color: service.color,
              icon: _serviceIcon(service.id),
              onTap: () => router.goToServiceView(service.id),
            );
          },
        ),
        if (state.searchQuery.isNotEmpty && services.isEmpty) ...[
          const SizedBox(height: 20),
          Center(
            child: Text(
              context.l10n.services_noResults(state.searchQuery),
              style: TextStyle(color: synorSecondaryText(context)),
            ),
          ),
        ],
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.services_recentRequests,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 12),
            PressableScale(
              onTap: () => router.goToServiceView(ServiceView.allRequests),
              child: Text(
                context.l10n.common_viewAll,
                style: TextStyle(
                  color: synorIsDark(context)
                      ? SynorColors.indigo400
                      : SynorColors.indigo600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...state.requests
            .take(3)
            .map(
              (request) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: RequestTile(
                  request: request,
                  onTap: () => controller.openRequest(request),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildDocumentsView(ServicesState state) {
    final controller = ref.read(servicesControllerProvider.notifier);
    final documents = [
      (
        'request.enrollmentCertificate',
        context.l10n.services_documentEnrollmentCertificate,
        context.l10n.services_documentEnrollmentCertificateSubtitle,
      ),
      (
        'request.officialTranscript',
        context.l10n.services_documentOfficialTranscript,
        context.l10n.services_documentOfficialTranscriptSubtitle,
      ),
      (
        'request.militaryDeferment',
        context.l10n.services_documentMilitaryDeferment,
        context.l10n.services_documentMilitaryDefermentSubtitle,
      ),
    ];

    return _buildSubScreen(
      state: state,
      title: context.l10n.services_documents,
      child: ListView(
        padding: _contentPadding(),
        children: [
          _SectionCaption(label: context.l10n.services_availableToRequest),
          const SizedBox(height: 16),
          ...documents.map(
            (document) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SynorGlassPanel(
                radius: SynorRadii.card,
                padding: const EdgeInsets.all(16),
                backgroundColor: synorIsDark(context)
                    ? SynorColors.white5
                    : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.$2,
                            style: TextStyle(
                              color: synorPrimaryText(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            document.$3,
                            style: TextStyle(
                              color: synorSecondaryText(context),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SynorIconActionButton(
                      icon: LucideIcons.plus,
                      onTap: () => controller.requestDocument(document.$1),
                      buttonSize: 40,
                      radius: 999,
                      size: 20,
                      backgroundColor: synorIsDark(context)
                          ? SynorColors.indigo500.withValues(alpha: 0.1)
                          : SynorColors.indigo50,
                      borderColor: Colors.transparent,
                      boxShadow: const [],
                      foregroundColor: synorIsDark(context)
                          ? SynorColors.indigo400
                          : SynorColors.indigo600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsView(ServicesState state) {
    final controller = ref.read(servicesControllerProvider.notifier);
    return _buildSubScreen(
      state: state,
      title: context.l10n.services_payments,
      child: ListView(
        padding: _contentPadding(),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: SynorGradients.serviceBalance,
              borderRadius: BorderRadius.circular(SynorRadii.sheet),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33059A69),
                  blurRadius: 28,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0x1AFFFFFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.services_currentBalance,
                        style: TextStyle(
                          color: SynorColors.emerald50,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.services_zeroBalanceAmount,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              LucideIcons.circle_check_big,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.l10n.services_allFeesPaid,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _SectionCaption(label: context.l10n.services_upcomingFees),
          const SizedBox(height: 16),
          SynorGlassPanel(
            radius: SynorRadii.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.services_springSemester2026,
                            style: TextStyle(
                              color: synorPrimaryText(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.services_tuitionFee,
                            style: TextStyle(
                              color: synorSecondaryText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      context.l10n.services_tuitionAmount,
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: synorIsDark(context)
                        ? SynorColors.amber500.withValues(alpha: 0.12)
                        : SynorColors.amber50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.alarm_clock,
                        size: 16,
                        color: synorIsDark(context)
                            ? SynorColors.amber400
                            : SynorColors.amber600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.services_dueIn45Days,
                        style: TextStyle(
                          color: synorIsDark(context)
                              ? SynorColors.amber400
                              : SynorColors.amber600,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                PressableScale(
                  onTap: controller.createPaymentRequest,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: synorIsDark(context)
                          ? Colors.white
                          : SynorColors.slate900,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        context.l10n.services_payNow,
                        style: TextStyle(
                          color: synorIsDark(context)
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHousingView(ServicesState state) {
    final controller = ref.read(servicesControllerProvider.notifier);

    return _buildSubScreen(
      state: state,
      title: context.l10n.services_housing,
      child: ListView(
        padding: _contentPadding(),
        children: [
          SynorGlassPanel(
            radius: SynorRadii.card,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: synorIsDark(context)
                        ? SynorColors.amber500.withValues(alpha: 0.12)
                        : SynorColors.amber50,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    LucideIcons.building,
                    color: synorIsDark(context)
                        ? SynorColors.amber400
                        : SynorColors.amber600,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.services_dormitoryTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: synorPrimaryText(context),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.services_dormitoryRoom,
                        style: TextStyle(color: synorSecondaryText(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _SectionCaption(label: context.l10n.services_maintenanceRequest),
          const SizedBox(height: 16),
          SynorGlassPanel(
            radius: SynorRadii.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.services_issueType,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: synorIsDark(context)
                        ? Colors.black.withValues(alpha: 0.2)
                        : SynorColors.slate50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: synorIsDark(context)
                          ? SynorColors.white10
                          : SynorColors.slate200,
                    ),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: state.housingIssueType,
                        isExpanded: true,
                        icon: Icon(
                          LucideIcons.chevron_down,
                          size: 18,
                          color: synorSecondaryText(context),
                        ),
                        dropdownColor: synorIsDark(context)
                            ? SynorColors.deepBlack
                            : Colors.white,
                        style: TextStyle(
                          color: synorPrimaryText(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'services.issue.plumbing',
                            child: Text(
                              context.l10n.services_issueTypePlumbing,
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'services.issue.electrical',
                            child: Text(
                              context.l10n.services_issueTypeElectrical,
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'services.issue.furniture',
                            child: Text(
                              context.l10n.services_issueTypeFurniture,
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'services.issue.other',
                            child: Text(context.l10n.services_issueTypeOther),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          controller.setHousingIssueType(value);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.l10n.services_description,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  type: MaterialType.transparency,
                  child: TextField(
                    controller: _housingDescriptionController,
                    minLines: 3,
                    maxLines: 3,
                    onChanged: controller.setHousingDescription,
                    decoration: InputDecoration(
                      hintText: context.l10n.services_describeIssue,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                PressableScale(
                  onTap: state.canSubmitHousing
                      ? controller.submitHousingRequest
                      : noop,
                  child: Opacity(
                    opacity: state.canSubmitHousing ? 1 : 0.5,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: SynorColors.indigo600,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.send,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              context.l10n.services_submitRequest,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportView(ServicesState state) {
    final controller = ref.read(servicesControllerProvider.notifier);

    return _buildSubScreen(
      state: state,
      title: context.l10n.services_support,
      child: ListView(
        padding: _contentPadding(),
        children: [
          Row(
            children: [
              Expanded(
                child: _SupportShortcut(
                  title: context.l10n.services_itHelpdesk,
                  subtitle: context.l10n.services_itHelpdeskSubtitle,
                  color: SynorColors.indigo500,
                  icon: LucideIcons.circle_question_mark,
                  onTap: () => controller.applySupportShortcut(
                    context.l10n.services_itHelpdeskRequest,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SupportShortcut(
                  title: context.l10n.services_academic,
                  subtitle: context.l10n.services_academicSubtitle,
                  color: SynorColors.rose500,
                  icon: LucideIcons.circle_alert,
                  onTap: () => controller.applySupportShortcut(
                    context.l10n.services_academicAdvisorContact,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _SectionCaption(label: context.l10n.services_newTicket),
          const SizedBox(height: 16),
          SynorGlassPanel(
            radius: SynorRadii.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.services_subject,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  type: MaterialType.transparency,
                  child: TextField(
                    controller: _supportSubjectController,
                    onChanged: controller.setSupportSubject,
                    decoration: InputDecoration(
                      hintText: context.l10n.services_briefSummary,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  context.l10n.services_message,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  type: MaterialType.transparency,
                  child: TextField(
                    controller: _supportMessageController,
                    minLines: 4,
                    maxLines: 4,
                    onChanged: controller.setSupportMessage,
                    decoration: InputDecoration(
                      hintText: context.l10n.services_howCanWeHelp,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                PressableScale(
                  onTap: state.canSubmitSupport
                      ? controller.submitSupportTicket
                      : noop,
                  child: Opacity(
                    opacity: state.canSubmitSupport ? 1 : 0.5,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: synorIsDark(context)
                            ? Colors.white
                            : SynorColors.slate900,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          context.l10n.services_sendMessage,
                          style: TextStyle(
                            color: synorIsDark(context)
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllRequestsView(ServicesState state) {
    final controller = ref.read(servicesControllerProvider.notifier);
    return _buildSubScreen(
      state: state,
      title: context.l10n.services_allRequests,
      child: ListView(
        padding: _contentPadding(),
        children: [
          ...state.requests.map(
            (request) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RequestTile(
                request: request,
                onTap: () => controller.openRequest(request),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ServicesState state) {
    return switch (state.activeView) {
      ServiceView.main => _buildMainView(state),
      ServiceView.documents => _buildDocumentsView(state),
      ServiceView.payments => _buildPaymentsView(state),
      ServiceView.housing => _buildHousingView(state),
      ServiceView.support => _buildSupportView(state),
      ServiceView.allRequests => _buildAllRequestsView(state),
    };
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesControllerProvider);
    final state = servicesAsync.maybeWhen(
      data: (value) => value,
      orElse: () => null,
    );
    if (state != null) {
      _syncController(_housingDescriptionController, state.housingDescription);
      _syncController(_supportSubjectController, state.supportSubject);
      _syncController(_supportMessageController, state.supportMessage);
    }

    return SynorAsyncStateView<ServicesState>(
      value: servicesAsync,
      loadingTitle: context.l10n.services_loadingTitle,
      loadingMessage: context.l10n.services_loadingMessage,
      loadingBuilder: (_) => const SynorServicesLoadingSkeleton(),
      onRetry: () => ref.invalidate(servicesControllerProvider),
      data: (state) => Stack(
        children: [
          AnimatedSwitcher(
            duration: SynorMotion.page,
            reverseDuration: SynorMotion.page,
            layoutBuilder: synorStackedLayoutBuilder(fit: StackFit.expand),
            transitionBuilder: synorFadeSlideTransitionBuilder(
              begin: const Offset(0.024, 0),
            ),
            child: _buildBody(state),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: state.selectedRequest == null,
              child: AnimatedSwitcher(
                duration: SynorMotion.overlay,
                reverseDuration: SynorMotion.overlay,
                layoutBuilder: synorStackedLayoutBuilder(
                  alignment: Alignment.bottomCenter,
                  fit: StackFit.expand,
                ),
                transitionBuilder: synorFadeSlideTransitionBuilder(
                  begin: const Offset(0, 0.045),
                ),
                child: state.selectedRequest != null
                    ? KeyedSubtree(
                        key: ValueKey('request-${state.selectedRequest!.id}'),
                        child: _RequestDetailsSheet(
                          request: state.selectedRequest!,
                          onClose: ref
                              .read(servicesControllerProvider.notifier)
                              .closeRequest,
                        ),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('request-details-hidden'),
                      ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: state.successMessage == null,
              child: AnimatedSwitcher(
                duration: SynorMotion.overlay,
                reverseDuration: SynorMotion.overlay,
                layoutBuilder: synorStackedLayoutBuilder(fit: StackFit.expand),
                transitionBuilder: synorFadeScaleTransitionBuilder(
                  beginScale: 0.97,
                ),
                child: state.successMessage != null
                    ? KeyedSubtree(
                        key: ValueKey(state.successMessage),
                        child: _SuccessModal(
                          message: _resolveServicesMessage(
                            context,
                            state.successMessage!,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('success-modal-hidden'),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: synorIsDark(context)
            ? SynorColors.neutral500
            : SynorColors.slate400,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SupportShortcut extends StatelessWidget {
  const _SupportShortcut({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: synorIsDark(context) ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(SynorRadii.card),
          border: Border.all(
            color: color.withValues(alpha: synorIsDark(context) ? 0.2 : 0.12),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: synorIsDark(context)
                    ? color.withValues(alpha: 0.2)
                    : Colors.white,
                boxShadow: synorIsDark(context) ? null : SynorShadows.soft,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: synorIsDark(context)
                    ? color.withValues(alpha: 0.95)
                    : color.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color.withValues(alpha: 0.72),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestDetailsSheet extends StatelessWidget {
  const _RequestDetailsSheet({required this.request, required this.onClose});

  final ServiceRequest request;
  final VoidCallback onClose;

  IconData get _icon {
    return switch (request.type) {
      RequestType.document => LucideIcons.file_text,
      RequestType.housing => LucideIcons.building,
      RequestType.payment => LucideIcons.credit_card,
      RequestType.support => LucideIcons.circle_question_mark,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: onClose, child: const SynorModalScrim()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: BoxDecoration(
              color: synorIsDark(context)
                  ? SynorColors.deepBlack
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              border: Border(
                top: BorderSide(
                  color: synorIsDark(context)
                      ? SynorColors.white10
                      : SynorColors.slate200,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SynorBottomSheetHandle(),
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: synorIsDark(context)
                            ? SynorColors.white5
                            : SynorColors.slate100,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        _icon,
                        color: synorSecondaryText(context),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.serviceRequestTitleLabel(
                              request.title,
                            ),
                            style: TextStyle(
                              color: synorPrimaryText(context),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.services_requestId(
                              request.id.toString().padLeft(5, '0'),
                            ),
                            style: TextStyle(
                              color: synorSecondaryText(context),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _RequestInfoRow(
                  label: context.l10n.services_status,
                  trailing: RequestStatusBadge(status: request.status),
                ),
                _RequestInfoRow(
                  label: context.l10n.services_date,
                  trailing: Text(
                    context.l10n.serviceRequestDateLabel(request.date),
                    style: TextStyle(
                      color: synorPrimaryText(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.services_description,
                  style: TextStyle(
                    color: synorSecondaryText(context),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.serviceRequestDescriptionLabel(
                    request.description ?? '',
                  ),
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                PressableScale(
                  onTap: onClose,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: synorIsDark(context)
                          ? SynorColors.white10
                          : SynorColors.slate100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        context.l10n.common_close,
                        style: TextStyle(
                          color: synorPrimaryText(context),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestInfoRow extends StatelessWidget {
  const _RequestInfoRow({required this.label, required this.trailing});

  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: synorIsDark(context)
                ? SynorColors.white5
                : SynorColors.slate100,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: synorSecondaryText(context)),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _SuccessModal extends StatelessWidget {
  const _SuccessModal({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          const SynorModalScrim(),
          Center(
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: synorIsDark(context)
                    ? SynorColors.deepBlack
                    : Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: SynorShadows.heavy,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: synorIsDark(context)
                          ? SynorColors.emerald500.withValues(alpha: 0.2)
                          : SynorColors.emerald100,
                    ),
                    child: Icon(
                      LucideIcons.circle_check_big,
                      color: synorIsDark(context)
                          ? SynorColors.emerald400
                          : SynorColors.emerald600,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.common_success,
                    style: TextStyle(
                      color: synorPrimaryText(context),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: synorSecondaryText(context),
                      height: 1.45,
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

String _resolveServicesMessage(BuildContext context, String message) {
  final l10n = context.l10n;
  if (message == 'services.success.paymentInitiated') {
    return l10n.services_successPaymentInitiated;
  }
  if (message == 'services.success.maintenanceSubmitted') {
    return l10n.services_successMaintenanceSubmitted;
  }
  if (message == 'services.success.supportCreated') {
    return l10n.services_successSupportCreated;
  }
  if (message.startsWith('services.success.documentRequested:')) {
    final title = message.replaceFirst(
      'services.success.documentRequested:',
      '',
    );
    return l10n.services_successDocumentRequested(
      l10n.serviceRequestTitleLabel(title),
    );
  }
  return message;
}
