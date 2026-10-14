import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/bookings_cubit.dart';
import '../../data/models/booking_item.dart';
class BookingsScreen extends StatelessWidget {
 const BookingsScreen({super.key});
 @override Widget build(BuildContext context)=>BlocProvider(create:(_)=>sl<BookingsCubit>()..load(),child:const _BookingsBody());
}
class _BookingsBody extends StatelessWidget {
 const _BookingsBody();
 @override Widget build(BuildContext context)=>BlocBuilder<BookingsCubit,BookingsState>(builder:(context,state){
  if(state is BookingsLoading)return const Center(child:CircularProgressIndicator());
  if(state is BookingsFailure)return Center(child:TextButton(onPressed:()=>context.read<BookingsCubit>().load(),child:Text(AppLocaleKey.retry.tr())));
  final items=(state as BookingsReady).items;
  if(items.isEmpty)return Center(child:Text(AppLocaleKey.noBookings.tr()));
  return ListView(padding:const EdgeInsets.all(16),children:[Text(AppLocaleKey.myBookings.tr(),style:const TextStyle(fontSize:21,fontWeight:FontWeight.w800,color:AppColors.petrol)),const SizedBox(height:12),...items.map((item)=>_BookingTile(item:item))]);
 });
}
class _BookingTile extends StatelessWidget{
 const _BookingTile({required this.item});final BookingItem item;
 Future<void> cancel(BuildContext context)async{
  final ok=await showDialog<bool>(context:context,builder:(ctx)=>AlertDialog(title:Text(AppLocaleKey.cancelBooking.tr()),content:Text(AppLocaleKey.cancelConfirm.tr()),actions:[
   TextButton(onPressed:()=>Navigator.pop(ctx,false),child:Text(AppLocaleKey.keepBooking.tr())),
   FilledButton(onPressed:()=>Navigator.pop(ctx,true),child:Text(AppLocaleKey.cancelBooking.tr())),
  ]));
  if(ok!=true||!context.mounted)return;
  try{await context.read<BookingsCubit>().cancel(item,AppLocaleKey.residentCancelled.tr());if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocaleKey.bookingCancelled.tr())));}
  catch(_){if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocaleKey.bookingFailed.tr())));}
 }
 @override Widget build(BuildContext context)=>Card(margin:const EdgeInsets.only(bottom:12),child:Padding(padding:const EdgeInsets.all(15),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Row(children:[const Icon(Icons.home_repair_service_outlined,color:AppColors.petrol),const SizedBox(width:10),Expanded(child:Text(item.serviceName,style:const TextStyle(fontWeight:FontWeight.w700))),Chip(label:Text(item.statusName))]),
  const SizedBox(height:8),Text(item.scheduledAt.replaceFirst('T',' · ')),Text('${item.amount.toStringAsFixed(0)} ${AppLocaleKey.currencyEgp.tr()}'),
  if(item.canCancel)Align(alignment:AlignmentDirectional.centerEnd,child:TextButton.icon(onPressed:()=>cancel(context),icon:const Icon(Icons.close),label:Text(AppLocaleKey.cancelBooking.tr()))),
 ])));
}
