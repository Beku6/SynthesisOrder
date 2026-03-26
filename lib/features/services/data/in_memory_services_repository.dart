import '../../../shared/data/mock_data.dart';
import '../../../shared/data/mock_latency.dart';
import '../../../shared/models/app_models.dart';
import '../domain/services_repository.dart';

class InMemoryServicesRepository implements ServicesRepository {
  List<ServiceRequest> _requests = SynorMockData.requests();

  @override
  Future<ServiceRequest> createPaymentRequest() async {
    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Tuition Fee Payment',
      date: 'Just now',
      status: RequestStatus.processing,
      type: RequestType.payment,
      description: 'Payment of 450,000 в‚ё for Spring Semester 2026.',
    );
    _requests = [request, ..._requests];
    return request;
  }

  @override
  Future<List<ServiceCategoryData>> fetchCategories() async {
    return SynorMockLatency.resolve(
      SynorMockData.serviceCategories,
      duration: SynorMockLatency.services,
    );
  }

  @override
  Future<List<ServiceRequest>> fetchRequests() async =>
      SynorMockLatency.resolve(_requests, duration: SynorMockLatency.services);

  @override
  Future<ServiceRequest> requestDocument(String title) async {
    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      date: 'Just now',
      status: RequestStatus.pending,
      type: RequestType.document,
      description: 'Requested via Synor Services.',
    );
    _requests = [request, ..._requests];
    return request;
  }

  @override
  Future<ServiceRequest> submitHousingRequest(HousingRequestDraft draft) async {
    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Maintenance: ${draft.issueType}',
      date: 'Just now',
      status: RequestStatus.pending,
      type: RequestType.housing,
      description: 'Dormitory #3, Room 412. ${draft.description.trim()}',
    );
    _requests = [request, ..._requests];
    return request;
  }

  @override
  Future<ServiceRequest> submitSupportTicket(SupportTicketDraft draft) async {
    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Support: ${draft.subject.trim()}',
      date: 'Just now',
      status: RequestStatus.open,
      type: RequestType.support,
      description: draft.message.trim(),
    );
    _requests = [request, ..._requests];
    return request;
  }
}
