import '../../../shared/data/mock_latency.dart';
import '../../../shared/models/app_models.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../domain/services_repository.dart';

class InMemoryServicesRepository implements ServicesRepository {
  List<ServiceRequest> _requests = const [
    ServiceRequest(
      id: 1,
      title: 'request.enrollmentCertificate',
      date: 'date.oct12',
      status: RequestStatus.ready,
      type: RequestType.document,
      description: 'request.description.visaApplication',
    ),
    ServiceRequest(
      id: 2,
      title: 'request.dormitoryRepair',
      date: 'date.oct10',
      status: RequestStatus.inProgress,
      type: RequestType.housing,
      description: 'request.description.leakingPipe',
    ),
  ];

  @override
  Future<ServiceRequest> createPaymentRequest() async {
    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'request.tuitionFeePayment',
      date: 'date.justNow',
      status: RequestStatus.processing,
      type: RequestType.payment,
      description: 'request.description.paymentSpring2026',
    );
    _requests = [request, ..._requests];
    return request;
  }

  @override
  Future<List<ServiceCategoryData>> fetchCategories() async {
    return SynorMockLatency.resolve(const [
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
    ], duration: SynorMockLatency.services);
  }

  @override
  Future<List<ServiceRequest>> fetchRequests() async =>
      SynorMockLatency.resolve(_requests, duration: SynorMockLatency.services);

  @override
  Future<ServiceRequest> requestDocument(String title) async {
    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      date: 'date.justNow',
      status: RequestStatus.pending,
      type: RequestType.document,
      description: 'request.description.viaSynorServices',
    );
    _requests = [request, ..._requests];
    return request;
  }

  @override
  Future<ServiceRequest> submitHousingRequest(HousingRequestDraft draft) async {
    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'request.maintenance:${draft.issueType}',
      date: 'date.justNow',
      status: RequestStatus.pending,
      type: RequestType.housing,
      description: 'request.dormitoryRoom412:${draft.description.trim()}',
    );
    _requests = [request, ..._requests];
    return request;
  }

  @override
  Future<ServiceRequest> submitSupportTicket(SupportTicketDraft draft) async {
    final request = ServiceRequest(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'request.support:${draft.subject.trim()}',
      date: 'date.justNow',
      status: RequestStatus.open,
      type: RequestType.support,
      description: draft.message.trim(),
    );
    _requests = [request, ..._requests];
    return request;
  }
}
