import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
class LinkHomeScreen extends StatefulWidget {const LinkHomeScreen({super.key});@override State<LinkHomeScreen> createState()=>_LinkHomeScreenState();}
class _LinkHomeScreenState extends State<LinkHomeScreen>{
 final form=GlobalKey<FormState>();final code=TextEditingController(),unit=TextEditingController();bool busy=false;
 @override void dispose(){code.dispose();unit.dispose();super.dispose();}
 Future<void> submit()async{if(!form.currentState!.validate())return;setState(()=>busy=true);try{
 if(context.read<ResidentDashboardCubit>().isPreview){
  context.read<ResidentDashboardCubit>().previewHome(code.text.trim()+' • '+unit.text.trim());
  if(mounted)Navigator.maybePop(context);
  return;
 }
 await sl<ResidentRepository>().linkHome(propertyCode:code.text.trim(),unitLabel:unit.text.trim());if(mounted)await context.read<ResidentDashboardCubit>().load();}catch(_){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocaleKey.homeLinkFailed.tr())));}finally{if(mounted)setState(()=>busy=false);}}
 @override Widget build(BuildContext context)=>Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:440),child:Form(key:form,child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
 const CircleAvatar(radius:36,backgroundColor:AppColors.mint,child:Icon(Icons.apartment,color:AppColors.petrol,size:38)),const SizedBox(height:22),
 Text(AppLocaleKey.linkYourHome.tr(),textAlign:TextAlign.center,style:const TextStyle(fontSize:24,fontWeight:FontWeight.w800,color:AppColors.petrol)),
 const SizedBox(height:8),Text(AppLocaleKey.linkHomeHelp.tr(),textAlign:TextAlign.center,style:const TextStyle(color:AppColors.muted)),
 const SizedBox(height:24),TextFormField(controller:code,textCapitalization:TextCapitalization.characters,decoration:InputDecoration(labelText:AppLocaleKey.propertyCode.tr(),border:const OutlineInputBorder()),validator:(v)=>v==null||v.trim().length<5?AppLocaleKey.requiredField.tr():null),
 const SizedBox(height:14),TextFormField(controller:unit,decoration:InputDecoration(labelText:AppLocaleKey.unitNumber.tr(),border:const OutlineInputBorder()),validator:(v)=>v==null||v.trim().isEmpty?AppLocaleKey.requiredField.tr():null),
 const SizedBox(height:20),FilledButton(onPressed:busy?null:submit,child:busy?const SizedBox(height:18,width:18,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)):Text(AppLocaleKey.linkHome.tr())),
 ])))));
}
