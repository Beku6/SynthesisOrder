import '../../../shared/models/app_models.dart';

class HousingRequestDraft {
  const HousingRequestDraft({
    required this.issueType,
    required this.description,
  });

  final String issueType;
  final String description;
}

class SupportTicketDraft {
  const SupportTicketDraft({required this.subject, required this.message});

  final String subject;
  final String message;
}

abstract class ServicesRepository {
  Future<List<ServiceCategoryData>> fetchCategories();

  Future<List<ServiceRequest>> fetchRequests();

  Future<ServiceRequest> requestDocument(String title);

  Future<ServiceRequest> createPaymentRequest();

  Future<ServiceRequest> submitHousingRequest(HousingRequestDraft draft);

  Future<ServiceRequest> submitSupportTicket(SupportTicketDraft draft);
}
