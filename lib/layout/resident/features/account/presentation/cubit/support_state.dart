part of 'support_cubit.dart';

sealed class SupportState {
  const SupportState();
}

class SupportLoading extends SupportState {
  const SupportLoading();
}

class SupportReady extends SupportState {
  const SupportReady(
    this.info, {
    this.sending = false,
    this.error = '',
    this.lastTicket,
  });

  final SupportInfo info;

  /// A ticket request is in flight.
  final bool sending;

  /// The server's text of the last rejected ticket.
  final String error;

  /// The last accepted ticket, if any.
  final SupportTicket? lastTicket;

  SupportReady copyWith({
    SupportInfo? info,
    bool? sending,
    String? error,
    SupportTicket? lastTicket,
  }) => SupportReady(
    info ?? this.info,
    sending: sending ?? this.sending,
    error: error ?? this.error,
    lastTicket: lastTicket ?? this.lastTicket,
  );
}

class SupportFailure extends SupportState {
  const SupportFailure(this.message);

  final String message;
}
