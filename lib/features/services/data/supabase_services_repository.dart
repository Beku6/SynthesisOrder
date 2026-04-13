import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/models/app_models.dart';
import '../domain/services_repository.dart';

class SupabaseServicesRepository implements ServicesRepository {
  const SupabaseServicesRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<ServiceCategoryData>> fetchCategories() async {
    // These are static for now as they represent the UI sections, 
    // but they could be moved to DB if needed.
    return [
      ServiceCategoryData(
        id: ServiceView.documents,
        title: 'services.documents',
        subtitle: 'services.documentsSubtitle',
        color: SynorColors.indigo500,
      ),
      ServiceCategoryData(
        id: ServiceView.payments,
        title: 'services.payments',
        subtitle: 'services.paymentsSubtitle',
        color: SynorColors.emerald500,
      ),
      ServiceCategoryData(
        id: ServiceView.housing,
        title: 'services.housing',
        subtitle: 'services.housingSubtitle',
        color: SynorColors.amber500,
      ),
      ServiceCategoryData(
        id: ServiceView.support,
        title: 'services.support',
        subtitle: 'services.supportSubtitle',
        color: SynorColors.rose500,
      ),
    ];
  }

  @override
  Future<List<ServiceRequest>> fetchRequests() async {
    try {
      final rows = await _client
          .from('service_requests')
          .select('*')
          .order('created_at', ascending: false);

      return rows.map(_mapRequest).toList();
    } catch (e) {
      // If table doesn't exist or other DB error, return empty list for stability
      return [];
    }
  }

  @override
  Future<ServiceRequest> requestDocument(String title) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client
        .from('service_requests')
        .insert({
          'user_id': userId,
          'type': 'document',
          'title': title,
          'description': 'request.description.viaSynorServices',
          'status': 'pending',
        })
        .select()
        .single();

    return _mapRequest(response);
  }

  @override
  Future<ServiceRequest> createPaymentRequest() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client
        .from('service_requests')
        .insert({
          'user_id': userId,
          'type': 'payment',
          'title': 'request.tuitionFeePayment',
          'description': 'request.description.paymentSpring2026',
          'status': 'processing',
        })
        .select()
        .single();

    return _mapRequest(response);
  }

  @override
  Future<ServiceRequest> submitHousingRequest(HousingRequestDraft draft) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client
        .from('service_requests')
        .insert({
          'user_id': userId,
          'type': 'housing',
          'title': 'request.maintenance:${draft.issueType}',
          'description': 'request.dormitoryRoom412:${draft.description.trim()}',
          'status': 'pending',
        })
        .select()
        .single();

    return _mapRequest(response);
  }

  @override
  Future<ServiceRequest> submitSupportTicket(SupportTicketDraft draft) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('User not authenticated');

    final response = await _client
        .from('service_requests')
        .insert({
          'user_id': userId,
          'type': 'support',
          'title': 'request.support:${draft.subject.trim()}',
          'description': draft.message.trim(),
          'status': 'open',
        })
        .select()
        .single();

    return _mapRequest(response);
  }

  ServiceRequest _mapRequest(Map<String, dynamic> row) {
    return ServiceRequest(
      id: row['id'].hashCode, // App expects int ID for now, DB is UUID. Using hashCode as shim.
      title: row['title'] as String,
      date: _formatDate(row['created_at'] as String),
      status: _mapStatus(row['status'] as String),
      type: _mapType(row['type'] as String),
      description: row['description'] as String?,
      room: row['room'] as String? ?? 'N/A',
      teacherName: row['teacher_name'] as String? ?? 'Unknown',
      imageUrl: row['image_url'] as String?,
    );
  }

  String _formatDate(String iso) {
    // Simplistic formatting for preview, should ideally use a date util
    final date = DateTime.parse(iso).toLocal();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return 'date.${months[date.month - 1].toLowerCase()}${date.day}';
  }

  RequestStatus _mapStatus(String status) {
    return switch (status) {
      'ready' => RequestStatus.ready,
      'pending' => RequestStatus.pending,
      'processing' => RequestStatus.processing,
      'open' => RequestStatus.open,
      'inProgress' => RequestStatus.inProgress,
      _ => RequestStatus.pending,
    };
  }

  RequestType _mapType(String type) {
    return switch (type) {
      'document' => RequestType.document,
      'payment' => RequestType.payment,
      'housing' => RequestType.housing,
      'support' => RequestType.support,
      _ => RequestType.document,
    };
  }
}
