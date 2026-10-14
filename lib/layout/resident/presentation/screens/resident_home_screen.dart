import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/auth/presentation/auth_cubit.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/resident_dashboard_cubit.dart';
import 'link_home_screen.dart';
import 'services_screen.dart';

class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});
  @override State<ResidentHomeScreen> createState()=>_ResidentHomeScreenState();
}
class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  int tab=0;
  Future<void> chooseLanguage() async {
    final locale=await showModalBottomSheet<Locale>(context:context,showDragHandle:true,builder:(context)=>SafeArea(child:Column(mainAxisSize:MainAxisSize.min,children:[
      ListTile(title:Text(AppLocaleKey.arabic.tr()),onTap:()=>Navigator.pop(context,const Locale('ar'))),
      ListTile(title:Text(AppLocaleKey.english.tr()),onTap:()=>Navigator.pop(context,const Locale('en'))),
      ListTile(title:Text(AppLocaleKey.urdu.tr()),onTap:()=>Navigator.pop(context,const Locale('ur'))),
    ])));
    if(locale!=null&&mounted) context.setLocale(locale);
  }
  @override Widget build(BuildContext context){
    final labels=[AppLocaleKey.home,AppLocaleKey.services,AppLocaleKey.community,AppLocaleKey.account];
    return Scaffold(
      appBar:AppBar(title:const Text('rounder',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900,color:AppColors.petrol)),actions:[IconButton(onPressed:chooseLanguage,tooltip:AppLocaleKey.language.tr(),icon:const Icon(Icons.language))]),
      body:tab==0?dashboard():tab==1?const ServicesScreen():tab==3?accountPanel():Center(child:Text(labels[tab].tr(),style:Theme.of(context).textTheme.headlineSmall)),
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:[
        NavigationDestination(icon:const Icon(Icons.home_outlined),selectedIcon:const Icon(Icons.home),label:AppLocaleKey.home.tr()),
        NavigationDestination(icon:const Icon(Icons.grid_view_outlined),label:AppLocaleKey.services.tr()),
        NavigationDestination(icon:const Icon(Icons.groups_outlined),label:AppLocaleKey.community.tr()),
        NavigationDestination(icon:const Icon(Icons.person_outline),label:AppLocaleKey.account.tr()),
      ]),
    );
  }
  Widget accountPanel()=>Center(child:Column(mainAxisSize:MainAxisSize.min,children:[
    const CircleAvatar(radius:34,backgroundColor:AppColors.mint,child:Icon(Icons.person_outline,color:AppColors.petrol,size:34)),
    const SizedBox(height:16),Text(AppLocaleKey.account.tr(),style:const TextStyle(fontSize:20,fontWeight:FontWeight.w700)),
    const SizedBox(height:16),OutlinedButton.icon(onPressed:()=>context.read<AuthCubit>().signOut(),icon:const Icon(Icons.logout),label:Text(AppLocaleKey.signOut.tr())),
  ]));
  Widget dashboard()=>BlocBuilder<ResidentDashboardCubit,ResidentDashboardState>(builder:(context,state){
    if(state is DashboardLoading)return const Center(child:CircularProgressIndicator());
    if(state is DashboardFailed)return Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisSize:MainAxisSize.min,children:[
      const Icon(Icons.cloud_off_outlined,size:48,color:AppColors.muted),const SizedBox(height:16),Text(state.key.tr(),textAlign:TextAlign.center),const SizedBox(height:12),
      FilledButton(onPressed:()=>context.read<ResidentDashboardCubit>().load(),child:Text(AppLocaleKey.retry.tr())),
    ])));
    final d=(state as DashboardReady).data;
          if(!d.hasHome)return const LinkHomeScreen();
    return RefreshIndicator(onRefresh:()=>context.read<ResidentDashboardCubit>().load(),child:ListView(padding:const EdgeInsets.fromLTRB(20,8,20,28),children:[
      Text(AppLocaleKey.hello.tr(namedArgs:{'name':d.residentName}),style:const TextStyle(fontSize:24,fontWeight:FontWeight.w800,color:AppColors.ink)),
      const SizedBox(height:5),Text(AppLocaleKey.homeOverview.tr(),style:const TextStyle(color:AppColors.muted)),
      const SizedBox(height:20),homeCard(d.homeName),const SizedBox(height:22),
      Text(AppLocaleKey.quickActions.tr(),style:const TextStyle(fontSize:18,fontWeight:FontWeight.w700)),const SizedBox(height:12),
      Row(children:[Expanded(child:action(Icons.handyman_outlined,AppLocaleKey.bookService.tr(),AppColors.mint,()=>setState(()=>tab=1))),const SizedBox(width:10),Expanded(child:action(Icons.campaign_outlined,AppLocaleKey.emergency.tr(),const Color(0xFFFFEEE5),()=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(AppLocaleKey.emergency.tr())))))]),
      const SizedBox(height:22),Text(AppLocaleKey.association.tr(),style:const TextStyle(fontSize:18,fontWeight:FontWeight.w700)),const SizedBox(height:12),
      Row(children:[Expanded(child:metric(AppLocaleKey.associationBalance.tr(),'${d.associationBalance.toStringAsFixed(0)} ${AppLocaleKey.currencyEgp.tr()}',Icons.account_balance_wallet_outlined)),const SizedBox(width:10),Expanded(child:metric(AppLocaleKey.propertyHealth.tr(),'${d.propertyHealthPercent}%',Icons.health_and_safety_outlined))]),
      const SizedBox(height:18),info(AppLocaleKey.upcomingService.tr(),d.upcomingService?.title??AppLocaleKey.noUpcomingService.tr(),d.upcomingService?.subtitle??'',Icons.calendar_month_outlined),
      const SizedBox(height:10),info(AppLocaleKey.recentActivity.tr(),d.recentActivity?.title??AppLocaleKey.noActivity.tr(),d.recentActivity?.subtitle??'',Icons.history),
    ]));
  });
  Widget homeCard(String home)=>Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(gradient:const LinearGradient(colors:[AppColors.petrol,Color(0xFF0A6264)]),borderRadius:BorderRadius.circular(24)),child:Row(children:[
    const CircleAvatar(backgroundColor:Colors.white24,child:Icon(Icons.apartment,color:Colors.white)),const SizedBox(width:14),
    Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(AppLocaleKey.myHome.tr(),style:const TextStyle(color:Colors.white70)),const SizedBox(height:4),Text(home.isEmpty?'—':home,style:const TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.w700))])),
    const Icon(Icons.chevron_right,color:Colors.white),
  ]));
  Widget action(IconData icon,String text,Color color,VoidCallback onTap)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(18),child:Container(height:105,padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:color,borderRadius:BorderRadius.circular(18)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Icon(icon,color:AppColors.petrol),Text(text,style:const TextStyle(fontWeight:FontWeight.w700))])));
  Widget metric(String label,String value,IconData icon)=>Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon,color:AppColors.orange),const SizedBox(height:12),Text(label,style:const TextStyle(fontSize:12,color:AppColors.muted)),const SizedBox(height:6),Text(value,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800))])));
  Widget info(String title,String value,String subtitle,IconData icon)=>Card(child:ListTile(leading:CircleAvatar(backgroundColor:AppColors.mint,child:Icon(icon,color:AppColors.petrol)),title:Text(title),subtitle:Text(subtitle.isEmpty?value:'$value\n$subtitle'),isThreeLine:subtitle.isNotEmpty,trailing:const Icon(Icons.chevron_right)));
}
