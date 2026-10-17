import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/services_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/screen/bookings_screen.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_option_model.dart';
class ServicesScreen extends StatelessWidget {
 const ServicesScreen({super.key});
 @override Widget build(BuildContext context)=>BlocProvider(create:(_)=>sl<ServicesCubit>()..load(),child:const _ServicesBody());
}
class _ServicesBody extends StatelessWidget {
 const _ServicesBody();
 @override Widget build(BuildContext context)=>BlocBuilder<ServicesCubit,ServicesState>(builder:(context,state){
  if(state is ServicesLoading)return const Center(child:CircularProgressIndicator());
  if(state is ServicesFailure)return Center(child:Column(mainAxisSize:MainAxisSize.min,children:[Text(state.key.tr()),TextButton(onPressed:()=>context.read<ServicesCubit>().load(),child:Text(AppLocaleKey.retry.tr()))]));
  final services=(state as ServicesReady).services;
  if(services.isEmpty)return Center(child:Text(AppLocaleKey.noServices.tr()));
  return ListView(padding:const EdgeInsets.all(16),children:[Row(children:[Expanded(child:Text(AppLocaleKey.serviceCatalog.tr(),style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800,color:AppColors.petrol))),TextButton(onPressed:()=>Navigator.of(context).push(MaterialPageRoute<void>(builder:(_)=>const BookingsScreen())),child:Text(AppLocaleKey.myBookings.tr()))]),const SizedBox(height:14),
   ...services.map((service)=>_ServiceCard(service:service))]);
 });
}
class _ServiceCard extends StatelessWidget {
 const _ServiceCard({required this.service});final ServiceOption service;
 Future<void> book(BuildContext context) async {
  final dashboard=context.read<ResidentDashboardCubit>().state;
  if(dashboard is! DashboardReady||dashboard.data.homeId==null){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocaleKey.linkHomeFirst.tr())));return;}
  final date=await showDatePicker(context:context,initialDate:DateTime.now().add(const Duration(days:1)),firstDate:DateTime.now(),lastDate:DateTime.now().add(const Duration(days:365)));
  if(date==null||!context.mounted)return;
  try{await context.read<ServicesCubit>().book(homeId:dashboard.data.homeId!,serviceId:service.id,date:DateTime(date.year,date.month,date.day,12));if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocaleKey.bookingCreated.tr())));}
  catch(_){if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocaleKey.bookingFailed.tr())));}
 }
 @override Widget build(BuildContext context)=>Card(margin:const EdgeInsets.only(bottom:12),child:ListTile(
  contentPadding:const EdgeInsets.all(14),leading:const CircleAvatar(backgroundColor:AppColors.mint,child:Icon(Icons.home_repair_service_outlined,color:AppColors.petrol)),
  title:Text(service.name,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text('${service.categoryName}\n${service.price.toStringAsFixed(0)} ${AppLocaleKey.currencyEgp.tr()}'),
  isThreeLine:true,trailing:IconButton(onPressed:()=>book(context),icon:const Icon(Icons.add_circle_outline,color:AppColors.orange),tooltip:AppLocaleKey.bookNow.tr())));
}
