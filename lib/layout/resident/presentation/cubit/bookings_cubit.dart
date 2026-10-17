import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/resident/data/models/booking_item.dart';
import 'package:rounder_application/layout/resident/data/repositories/bookings_repository.dart';
sealed class BookingsState{}
class BookingsLoading extends BookingsState{}
class BookingsReady extends BookingsState{BookingsReady(this.items);final List<BookingItem> items;}
class BookingsFailure extends BookingsState{}
class BookingsCubit extends Cubit<BookingsState>{
 BookingsCubit(this.repo):super(BookingsLoading());final BookingsRepository repo;
 Future<void> load()async{emit(BookingsLoading());try{emit(BookingsReady(await repo.list()));}catch(_){emit(BookingsFailure());}}
 Future<void> cancel(BookingItem booking,String reason)async{await repo.cancel(booking.id,reason);await load();}
}
