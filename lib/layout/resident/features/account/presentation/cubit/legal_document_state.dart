part of 'legal_document_cubit.dart';

sealed class LegalDocumentState {
  const LegalDocumentState();
}

class LegalDocumentLoading extends LegalDocumentState {
  const LegalDocumentLoading();
}

class LegalDocumentReady extends LegalDocumentState {
  const LegalDocumentReady(this.document);
  final LegalDocument document;
}

class LegalDocumentFailure extends LegalDocumentState {
  const LegalDocumentFailure(this.message);
  final String message;
}
