import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';

/// Association and resident-community prototype. Uses local UI sample values;
/// API integration is intentionally deferred.
class UnionScreen extends StatefulWidget {
  const UnionScreen({super.key});
  @override State<UnionScreen> createState() => _UnionScreenState();
}

enum _Section { overview, finances, dues, facilities, visits, news, community, initiative }

class _UnionScreenState extends State<UnionScreen> {
  _Section section = _Section.overview;
  final message = TextEditingController();
  int likes = 14;
  void open(_Section value) => setState(() => section=value);
  void back() => open(_Section.overview);

  @override
  void dispose() { message.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      stops: [0, .25, .52, .72, 1],
      colors: [Color(0xFF073B43), Color(0xFF0F6570), Color(0xFFA8D4CF), Color(0xFFDDF3EE), Color(0xFFFFF9EF)],
    )),
    child: AnimatedSwitcher(duration: const Duration(milliseconds: 180), child: switch(section) {
      _Section.overview => _overview(),
      _Section.finances => _finances(),
      _Section.dues => _dues(),
      _Section.facilities => _facilities(),
      _Section.visits => _visits(),
      _Section.news => _news(),
      _Section.community => _community(),
      _Section.initiative => _initiative(),
    }),
  );

  Widget _header(String key, {bool showBack=false}) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
    child: Row(children: [
      if(showBack) IconButton(onPressed:back,icon:const Icon(Icons.chevron_left,color:Colors.white))
      else const SizedBox(width:8),
      const Spacer(),
      Text(key.tr(),style:const TextStyle(color:Colors.white,fontSize:21,fontWeight:FontWeight.w800)),
      const SizedBox(width:8),
      if(!showBack) const Icon(Icons.apartment,color:Colors.white),
    ]),
  );

  Widget _overview() => ListView(key:const ValueKey('union-overview'),padding:EdgeInsets.zero,children:[
    _header(AppLocaleKey.unionTitle),
    Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Text(AppLocaleKey.unitTitle.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white70))),
    _panel([
      Row(children:[const Icon(Icons.account_balance_wallet_outlined,color:Colors.white),const Spacer(),Text(AppLocaleKey.availableBalance.tr(),style:const TextStyle(color:Colors.white70))]),
      const SizedBox(height:12),
      Text('25,000 ' + AppLocaleKey.currencySar.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white,fontSize:28,fontWeight:FontWeight.w800)),
      const Divider(color:Colors.white54),
      TextButton.icon(onPressed:()=>open(_Section.finances),icon:const Icon(Icons.chevron_left,color:Colors.white),label:Text(AppLocaleKey.financialDetails.tr(),style:const TextStyle(color:Colors.white))),
    ],glass:true),
    InkWell(onTap:()=>open(_Section.dues),child:_panel([
      Row(children:[const Icon(Icons.receipt_long_outlined,color:AppColors.petrol),const Spacer(),Text(AppLocaleKey.dueAmount.tr(),style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol))]),
      const SizedBox(height:8),
      Row(children:[
        FilledButton(onPressed:()=>open(_Section.dues),style:FilledButton.styleFrom(backgroundColor:AppColors.orange,foregroundColor:Colors.white),child:Text(AppLocaleKey.pay.tr())),
        const Spacer(),
        Column(crossAxisAlignment:CrossAxisAlignment.end,children:[
          Text('300 ' + AppLocaleKey.currencySar.tr(),style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
          Text(AppLocaleKey.dueDate.tr(),style:const TextStyle(color:AppColors.muted,fontSize:12)),
        ]),
      ]),
    ])),
    _panel([
      Text(AppLocaleKey.workTogether.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.petrol,fontSize:20,fontWeight:FontWeight.w800)),
      const SizedBox(height:8),
      ListTile(
        tileColor: Colors.white,
        contentPadding:EdgeInsets.zero,leading:const Icon(Icons.meeting_room_outlined,color:AppColors.orange),
        title:Text(AppLocaleKey.improveEntrance.tr(),textAlign:TextAlign.right),
        subtitle:Text(AppLocaleKey.residentsJoined.tr(),textAlign:TextAlign.right),
        trailing:TextButton(onPressed:()=>open(_Section.initiative),child:Text(AppLocaleKey.shareIdea.tr()))),
      ClipRRect(borderRadius:BorderRadius.circular(8),child:const LinearProgressIndicator(value:.7,minHeight:7,color:AppColors.petrol,backgroundColor:AppColors.mint)),
    ]),
    _panel([
      _navRow(AppLocaleKey.associationFinance,Icons.pie_chart_outline,_Section.finances),
      _navRow(AppLocaleKey.myDues,Icons.receipt_long_outlined,_Section.dues),
      _navRow(AppLocaleKey.facilitiesReports,Icons.handyman_outlined,_Section.facilities),
      _navRow(AppLocaleKey.unionVisits,Icons.calendar_month_outlined,_Section.visits),
      _navRow(AppLocaleKey.unionNews,Icons.article_outlined,_Section.news),
      _navRow(AppLocaleKey.associationCommunity,Icons.groups_outlined,_Section.community),
      _navRow(AppLocaleKey.initiatives,Icons.lightbulb_outline,_Section.initiative),
    ]),
    Padding(padding:const EdgeInsets.fromLTRB(22,4,22,14),child:Text(AppLocaleKey.prototypeData.tr(),textAlign:TextAlign.center,style:const TextStyle(color:AppColors.muted,fontSize:11))),
  ]);

  Widget _finances() => _subPage(AppLocaleKey.associationFinance,[
    _panel([
      Text(AppLocaleKey.availableBalance.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white70)),
      Text('25,000 ' + AppLocaleKey.currencySar.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white,fontSize:28,fontWeight:FontWeight.w800)),
      const SizedBox(height:8),
      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
        _stat(AppLocaleKey.cleaning,'1,000',AppColors.petrol),_stat(AppLocaleKey.maintenance,'2,500',AppColors.orange),_stat(AppLocaleKey.utilities,'2,500',AppColors.mint),
      ]),
    ],glass:true),
    _panel([
      Text(AppLocaleKey.expenses.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      const SizedBox(height:8),
      const LinearProgressIndicator(value:.7,minHeight:12,color:AppColors.petrol,backgroundColor:AppColors.mint),
      const SizedBox(height:12),
      _line(AppLocaleKey.cleaning,'3,500 ' + AppLocaleKey.currencySar.tr()),
      _line(AppLocaleKey.maintenance,'2,500 ' + AppLocaleKey.currencySar.tr()),
      _line(AppLocaleKey.utilities,'1,000 ' + AppLocaleKey.currencySar.tr()),
    ]),
    _panel([Text(AppLocaleKey.paymentHistory.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),_line(AppLocaleKey.cleaning,AppLocaleKey.pastCleaningPayment.tr())]),
    Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:FilledButton(onPressed:()=>_toast(AppLocaleKey.comingSoon.tr()),style:FilledButton.styleFrom(backgroundColor:AppColors.orange),child:Text(AppLocaleKey.financialDetails.tr()))),
  ]);

  Widget _dues() => _subPage(AppLocaleKey.myDues,[
    _panel([
      Text(AppLocaleKey.dueAmount.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white70)),
      Text('300 ' + AppLocaleKey.currencySar.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white,fontSize:30,fontWeight:FontWeight.w800)),
      Text(AppLocaleKey.dueDate.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white70)),
    ],glass:true),
    SegmentedButton<bool>(segments:[
      ButtonSegment(value:false,label:Text(AppLocaleKey.paid.tr())),
      ButtonSegment(value:true,label:Text(AppLocaleKey.pending.tr())),
    ],selected:{true},onSelectionChanged:(_){ }),
    const SizedBox(height:12),
    _panel([_line(AppLocaleKey.unitTitle,'300 ' + AppLocaleKey.currencySar.tr()),Text(AppLocaleKey.currentUnit.tr() + ' • ' + AppLocaleKey.septemberDues.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted))]),
    Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:FilledButton(onPressed:()=>_toast(AppLocaleKey.comingSoon.tr()),style:FilledButton.styleFrom(backgroundColor:AppColors.orange),child:Text(AppLocaleKey.pay.tr()))),
    Padding(padding:const EdgeInsets.all(20),child:Text(AppLocaleKey.prototypeData.tr(),textAlign:TextAlign.center,style:const TextStyle(color:AppColors.muted,fontSize:11))),
  ]);

  Widget _facilities() => _subPage(AppLocaleKey.facilitiesReports,[
    GridView.count(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),crossAxisCount:2,mainAxisSpacing:10,crossAxisSpacing:10,childAspectRatio:1.35,children:[
      _tile(AppLocaleKey.cleaning,AppLocaleKey.goodCondition.tr(),Icons.cleaning_services_outlined),
      _tile(AppLocaleKey.maintenance,AppLocaleKey.actionRequired.tr(),Icons.elevator_outlined),
      _tile(AppLocaleKey.utilities,AppLocaleKey.goodCondition.tr(),Icons.lightbulb_outline),
      _tile(AppLocaleKey.visitUpcoming,AppLocaleKey.pending.tr(),Icons.water_drop_outlined),
    ]),
    _panel([Text(AppLocaleKey.openReports.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      _line(AppLocaleKey.maintenance,AppLocaleKey.elevatorFollowup.tr()),
      _action(AppLocaleKey.shareIdea,Icons.add_circle_outline,()=>_toast(AppLocaleKey.comingSoon.tr())),
      Text(AppLocaleKey.noReports.tr(),textAlign:TextAlign.center,style:const TextStyle(color:AppColors.muted))]),
  ]);

  Widget _visits() => _subPage(AppLocaleKey.unionVisits,[
    _panel([Text(AppLocaleKey.visitUpcoming.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      const SizedBox(height:8),Text(AppLocaleKey.cleaning.tr(),textAlign:TextAlign.right),
      Text(AppLocaleKey.visitDateTime.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted)),
      const SizedBox(height:14),const CircularProgressIndicator(value:.7,strokeWidth:8,color:AppColors.petrol),
      const SizedBox(height:8),_action(AppLocaleKey.visitUpcoming,Icons.calendar_today_outlined,()=>_toast(AppLocaleKey.comingSoon.tr()))]),
    _panel([Text(AppLocaleKey.visitCompleted.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),
      _line(AppLocaleKey.facilitiesReports,AppLocaleKey.completedDate.tr())]),
  ]);

  Widget _news() => _subPage(AppLocaleKey.unionNews,[
    _panel([Text(AppLocaleKey.announcement.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      const SizedBox(height:8),Text(AppLocaleKey.cleaning.tr() + ' • ' + AppLocaleKey.announcementDate.tr(),textAlign:TextAlign.right),
      Text(AppLocaleKey.visitUpcoming.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted)),
      TextButton(onPressed:()=>_toast(AppLocaleKey.comingSoon.tr()),child:Text(AppLocaleKey.reviewNow.tr()))]),
    _panel([Text(AppLocaleKey.documents.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),
      _line(AppLocaleKey.financialDetails,AppLocaleKey.financialPdf.tr()),
      _line(AppLocaleKey.facilitiesReports,AppLocaleKey.cleaningPdf.tr())]),
  ]);

  Widget _community() => _subPage(AppLocaleKey.associationCommunity,[
    _panel([Text(AppLocaleKey.unitTitle.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.petrol,fontWeight:FontWeight.w800)),
      Text(AppLocaleKey.residentsJoined.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted))]),
    _panel([
      _line(AppLocaleKey.resident.tr(),AppLocaleKey.neighborMessageOne.tr()),
      Align(alignment:Alignment.centerLeft,child:TextButton.icon(onPressed:()=>setState(()=>likes++),icon:const Icon(Icons.favorite_border),label:Text(likes.toString()))),
      _line(AppLocaleKey.resident.tr(),AppLocaleKey.neighborMessageTwo.tr()),
      _line(AppLocaleKey.unitTitle.tr(),AppLocaleKey.associationReply.tr()),
    ]),
    _panel([
      TextField(controller:message,textAlign:TextAlign.right,decoration:InputDecoration(hintText:AppLocaleKey.messageHint.tr())),
      Align(alignment:Alignment.centerLeft,child:FilledButton(onPressed:(){
        if(message.text.trim().isEmpty)return;
        setState(()=>message.clear());
        _toast(AppLocaleKey.comingSoon.tr());
      },child:Text(AppLocaleKey.sendMessage.tr()))),
    ]),
  ]);

  Widget _initiative() => _subPage(AppLocaleKey.initiatives,[
    _panel([Text(AppLocaleKey.improveEntrance.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      const SizedBox(height:8),Text(AppLocaleKey.residentsJoined.tr(),textAlign:TextAlign.right),
      const SizedBox(height:10),const LinearProgressIndicator(value:.7,color:AppColors.petrol,backgroundColor:AppColors.mint),
      Align(alignment:Alignment.centerLeft,child:TextButton(onPressed:()=>setState(()=>likes++),child:Text(AppLocaleKey.shareIdea.tr()+'  •  '+likes.toString())))]),
    _panel([Text(AppLocaleKey.initiatives.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),
      _line(AppLocaleKey.cleaning,AppLocaleKey.cleaningCampaign.tr()),
      _action(AppLocaleKey.suggestInitiative,Icons.add_circle_outline,()=>_toast(AppLocaleKey.comingSoon.tr()))]),
    Padding(padding:const EdgeInsets.all(20),child:Text(AppLocaleKey.prototypeData.tr(),textAlign:TextAlign.center,style:const TextStyle(color:AppColors.muted,fontSize:11))),
  ]);

  Widget _subPage(String key,List<Widget> children)=>ListView(key:ValueKey(key),padding:EdgeInsets.zero,children:[
    _header(key,showBack:true),
    Padding(padding:const EdgeInsets.fromLTRB(12,4,12,24),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:children)),
  ]);

  Widget _panel(List<Widget> children,{bool glass=false})=>Container(
    margin:const EdgeInsets.fromLTRB(20,8,20,8),padding:const EdgeInsets.all(16),
    decoration:BoxDecoration(color:glass?Colors.white.withValues(alpha:.2):Colors.white.withValues(alpha:.93),border:glass?Border.all(color:Colors.white38):null,borderRadius:BorderRadius.circular(22)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:children));

  Widget _navRow(String key,IconData icon,_Section target)=>ListTile(
    tileColor: Colors.white,
    contentPadding:EdgeInsets.zero,leading:CircleAvatar(backgroundColor:AppColors.mint,child:Icon(icon,color:AppColors.petrol)),
    title:Text(key.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w700,color:AppColors.petrol)),
    trailing:const Icon(Icons.chevron_left),onTap:()=>open(target));

  Widget _line(String key,String value)=>ListTile(
    tileColor: Colors.white,
    contentPadding:EdgeInsets.zero,title:Text(key.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w700,color:AppColors.petrol)),
    subtitle:Text(value,textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted)));

  Widget _stat(String key,String value,Color dot)=>Column(children:[
    Icon(Icons.circle,size:9,color:dot),const SizedBox(height:5),Text(key.tr(),style:const TextStyle(color:Colors.white70,fontSize:11)),
    Text(value,style:const TextStyle(color:Colors.white,fontWeight:FontWeight.w700))]);

  Widget _tile(String title,String status,IconData icon)=>Container(
    decoration:BoxDecoration(color:Colors.white.withValues(alpha:.92),borderRadius:BorderRadius.circular(20)),
    padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.end,mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
      Icon(icon,color:AppColors.petrol),Text(title.tr(),style:const TextStyle(color:AppColors.petrol,fontWeight:FontWeight.w800)),
      Text(status,style:const TextStyle(color:AppColors.muted,fontSize:12)),
    ]));

  Widget _action(String title,IconData icon,VoidCallback onTap)=>FilledButton.tonalIcon(
    onPressed:onTap,icon:Icon(icon),label:Text(title.tr()),
    style:FilledButton.styleFrom(backgroundColor:AppColors.mint,foregroundColor:AppColors.petrol,alignment:Alignment.centerRight));

  void _toast(String value)=>ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()..showSnackBar(SnackBar(content:Text(value)));
}
