import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/synor_design_tokens.dart';
import '../../l10n/app_localization_x.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/synor_widgets.dart';

class SynorAsyncStateView<T> extends StatelessWidget {
  const SynorAsyncStateView({
    super.key,
    required this.value,
    required this.data,
    this.loadingTitle,
    this.loadingMessage,
    this.errorTitle,
    this.loadingBuilder,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final String? loadingTitle;
  final String? loadingMessage;
  final String? errorTitle;
  final WidgetBuilder? loadingBuilder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return value.when(
      data: data,
      loading: () =>
          loadingBuilder?.call(context) ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SynorInlineStateCard(
                icon: LucideIcons.loader_circle,
                title: loadingTitle ?? l10n.async_loadingTitle,
                message: loadingMessage ?? l10n.async_loadingMessage,
                accentColor: SynorColors.indigo500,
              ),
            ),
          ),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SynorInlineStateCard(
                icon: LucideIcons.circle_alert,
                title: errorTitle ?? l10n.async_errorTitle,
                message: l10n.appErrorLabel('$error'),
                accentColor: SynorColors.rose500,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: SynorPrimaryButton(
                    label: l10n.common_tryAgain,
                    icon: LucideIcons.refresh_cw,
                    onTap: onRetry!,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
