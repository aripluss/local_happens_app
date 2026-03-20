enum EventStatus {
  pending,
  approved,
  rejected;

  String get name {
    switch (this) {
      case EventStatus.pending:
        return 'pending';
      case EventStatus.approved:
        return 'approved';
      case EventStatus.rejected:
        return 'rejected';
    }
  }

  static EventStatus fromString(String name) {
    switch (name) {
      case 'pending':
        return EventStatus.pending;
      case 'approved':
        return EventStatus.approved;
      case 'rejected':
        return EventStatus.rejected;
      default:
        return EventStatus.pending;
    }
  }
}