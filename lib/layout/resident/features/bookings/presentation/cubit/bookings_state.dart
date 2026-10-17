part of 'bookings_cubit.dart';

sealed class BookingsState{}
class BookingsLoading extends BookingsState{}
class BookingsReady extends BookingsState{BookingsReady(this.items);final List<BookingItem> items;}
class BookingsFailure extends BookingsState{}
