import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_models.dart';
import '../../../app/data/supabase_client_provider.dart';
import '../data/supabase_services_repository.dart';
import '../domain/services_repository.dart';

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  return SupabaseServicesRepository(ref.watch(supabaseClientProvider));
});

@immutable
class ServicesState {
  const ServicesState({
    required this.categories,
    required this.requests,
    this.activeView = ServiceView.main,
    this.searchQuery = '',
    this.housingIssueType = 'services.issue.plumbing',
    this.housingDescription = '',
    this.supportSubject = '',
    this.supportMessage = '',
    this.selectedRequest,
    this.successMessage,
  });

  final List<ServiceCategoryData> categories;
  final List<ServiceRequest> requests;
  final ServiceView activeView;
  final String searchQuery;
  final String housingIssueType;
  final String housingDescription;
  final String supportSubject;
  final String supportMessage;
  final ServiceRequest? selectedRequest;
  final String? successMessage;

  bool get canSubmitHousing => housingDescription.trim().isNotEmpty;

  bool get canSubmitSupport =>
      supportSubject.trim().isNotEmpty && supportMessage.trim().isNotEmpty;

  ServicesState copyWith({
    List<ServiceCategoryData>? categories,
    List<ServiceRequest>? requests,
    ServiceView? activeView,
    String? searchQuery,
    String? housingIssueType,
    String? housingDescription,
    String? supportSubject,
    String? supportMessage,
    ServiceRequest? selectedRequest,
    String? successMessage,
    bool clearSelectedRequest = false,
    bool clearSuccessMessage = false,
  }) {
    return ServicesState(
      categories: categories ?? this.categories,
      requests: requests ?? this.requests,
      activeView: activeView ?? this.activeView,
      searchQuery: searchQuery ?? this.searchQuery,
      housingIssueType: housingIssueType ?? this.housingIssueType,
      housingDescription: housingDescription ?? this.housingDescription,
      supportSubject: supportSubject ?? this.supportSubject,
      supportMessage: supportMessage ?? this.supportMessage,
      selectedRequest: clearSelectedRequest
          ? null
          : (selectedRequest ?? this.selectedRequest),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

final servicesControllerProvider =
    AsyncNotifierProvider<ServicesController, ServicesState>(
      ServicesController.new,
    );

class ServicesController extends AsyncNotifier<ServicesState> {
  Timer? _successTimer;
  ServiceView? _deferredView;

  ServicesRepository get _repository => ref.read(servicesRepositoryProvider);
  ServicesState? get _currentState =>
      state.maybeWhen(data: (value) => value, orElse: () => null);

  @override
  Future<ServicesState> build() async {
    ref.onDispose(() {
      _successTimer?.cancel();
    });

    final categoriesFuture = _repository.fetchCategories();
    final requestsFuture = _repository.fetchRequests();
    final categories = await categoriesFuture;
    final requests = await requestsFuture;
    return ServicesState(
      categories: categories,
      requests: requests,
      activeView: _deferredView ?? ServiceView.main,
    );
  }

  void _update(ServicesState Function(ServicesState current) transform) {
    final current = _currentState;
    if (current == null) {
      return;
    }
    state = AsyncData(transform(current));
  }

  void setView(ServiceView view) {
    _deferredView = view;
    _update(
      (current) => current.copyWith(
        activeView: view,
        clearSelectedRequest: true,
        clearSuccessMessage: true,
      ),
    );
  }

  void setSearchQuery(String value) {
    _update((current) => current.copyWith(searchQuery: value));
  }

  void setHousingIssueType(String value) {
    _update((current) => current.copyWith(housingIssueType: value));
  }

  void setHousingDescription(String value) {
    _update((current) => current.copyWith(housingDescription: value));
  }

  void setSupportSubject(String value) {
    _update((current) => current.copyWith(supportSubject: value));
  }

  void setSupportMessage(String value) {
    _update((current) => current.copyWith(supportMessage: value));
  }

  void applySupportShortcut(String subject) {
    _update((current) => current.copyWith(supportSubject: subject));
  }

  void openRequest(ServiceRequest request) {
    _update((current) => current.copyWith(selectedRequest: request));
  }

  void closeRequest() {
    _update((current) => current.copyWith(clearSelectedRequest: true));
  }

  void clearSuccessMessage() {
    _successTimer?.cancel();
    _update((current) => current.copyWith(clearSuccessMessage: true));
  }

  void resetToMain() {
    _deferredView = ServiceView.main;
    _successTimer?.cancel();
    _update(
      (current) => current.copyWith(
        activeView: ServiceView.main,
        searchQuery: '',
        housingIssueType: 'services.issue.plumbing',
        housingDescription: '',
        supportSubject: '',
        supportMessage: '',
        clearSelectedRequest: true,
        clearSuccessMessage: true,
      ),
    );
  }

  Future<void> requestDocument(String title) async {
    final request = await _repository.requestDocument(title);
    _showSuccess('services.success.documentRequested:$title', request: request);
  }

  Future<void> createPaymentRequest() async {
    final request = await _repository.createPaymentRequest();
    _showSuccess('services.success.paymentInitiated', request: request);
  }

  Future<void> submitHousingRequest() async {
    final current = _currentState;
    if (current == null || !current.canSubmitHousing) {
      return;
    }

    final request = await _repository.submitHousingRequest(
      HousingRequestDraft(
        issueType: current.housingIssueType,
        description: current.housingDescription,
      ),
    );
    _showSuccess(
      'services.success.maintenanceSubmitted',
      request: request,
      transform: (value) => value.copyWith(
        housingIssueType: 'services.issue.plumbing',
        housingDescription: '',
      ),
    );
  }

  Future<void> submitSupportTicket() async {
    final current = _currentState;
    if (current == null || !current.canSubmitSupport) {
      return;
    }

    final request = await _repository.submitSupportTicket(
      SupportTicketDraft(
        subject: current.supportSubject,
        message: current.supportMessage,
      ),
    );
    _showSuccess(
      'services.success.supportCreated',
      request: request,
      transform: (value) =>
          value.copyWith(supportSubject: '', supportMessage: ''),
    );
  }

  void _showSuccess(
    String message, {
    ServiceRequest? request,
    ServicesState Function(ServicesState current)? transform,
  }) {
    _successTimer?.cancel();
    _update((current) {
      final baseState = transform?.call(current) ?? current;
      return baseState.copyWith(
        requests: request == null
            ? baseState.requests
            : [request, ...baseState.requests],
        activeView: ServiceView.main,
        clearSelectedRequest: true,
        successMessage: message,
      );
    });
    _successTimer = Timer(const Duration(seconds: 2), clearSuccessMessage);
  }
}
