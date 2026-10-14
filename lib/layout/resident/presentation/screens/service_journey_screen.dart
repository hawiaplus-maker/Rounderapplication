import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';

/// Screen-only service journey. Values and actions are local prototype state
/// so the complete Figma flow can be reviewed before API integration.
class ServiceJourneyScreen extends StatefulWidget {
  const ServiceJourneyScreen({super.key, this.startOnTracking=false});
  final bool startOnTracking;
  @override State<ServiceJourneyScreen> createState() => _ServiceJourneyScreenState();
}
enum _Journey { catalog, detail, schedule, providers, review, waiting, tracking, additional, files, invoice, payment, rating, warranty, followup }
class _ServiceJourneyScreenState extends State<ServiceJourneyScreen> {
  late _Journey page=widget.startOnTracking?_Journey.tracking:_Journey.catalog, previous=_Journey.catalog;
  String service='plumbing';
  int mode=0, stage=0, stars=0;
  bool acceptedAdditional=false;
  final query=TextEditingController(), issue=TextEditingController(), notes=TextEditingController();
  void go(_Journey next){setState(() { previous=page; page=next; });}
  void back(){setState(()=>page=previous);}
  @override void dispose(){query.dispose();issue.dispose();notes.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Container(
    decoration:const BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,
      stops:[0,.25,.52,.72,1],colors:[Color(0xFF073B43),Color(0xFF0F6570),Color(0xFFA8D4CF),Color(0xFFDDF3EE),Color(0xFFFFF9EF)])),
    child:AnimatedSwitcher(duration:const Duration(milliseconds:180),child:switch(page){
      _Journey.catalog=>_catalog(),_Journey.detail=>_detail(),_Journey.schedule=>_schedule(),_Journey.providers=>_providers(),
      _Journey.review=>_review(),_Journey.waiting=>_waiting(),_Journey.tracking=>_tracking(),_Journey.additional=>_additional(),
      _Journey.files=>_files(),_Journey.invoice=>_invoice(),_Journey.payment=>_payment(),_Journey.rating=>_rating(),
      _Journey.warranty=>_warranty(),_Journey.followup=>_followup(),
    }));

  Widget _header(String key,{bool backButton=false})=>Padding(padding:const EdgeInsets.fromLTRB(20,14,20,12),child:Row(children:[
    if(backButton)IconButton(onPressed:back,icon:const Icon(Icons.chevron_left,color:Colors.white))else const SizedBox(width:8),
    const Spacer(),Text(key.tr(),style:const TextStyle(color:Colors.white,fontSize:21,fontWeight:FontWeight.w800)),const SizedBox(width:8),
    if(!backButton)const Icon(Icons.home_repair_service_outlined,color:Colors.white),
  ]));

  Widget _catalog()=>ListView(key:const ValueKey('service-catalog'),padding:EdgeInsets.zero,children:[
    _header(AppLocaleKey.catalogTitle),
    Padding(padding:const EdgeInsets.fromLTRB(20,8,20,12),child:Text(AppLocaleKey.greetingAli.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white,fontSize:27,fontWeight:FontWeight.w800))),
    Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:TextField(controller:query,textAlign:TextAlign.right,
      decoration:InputDecoration(hintText:AppLocaleKey.searchHint.tr(),prefixIcon:const Icon(Icons.search),
        filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(18),borderSide:BorderSide.none)))),
    const SizedBox(height:18),
    Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Row(children:[
      Expanded(child:_category(AppLocaleKey.maintenance,Icons.build_outlined,[AppLocaleKey.plumbing,AppLocaleKey.electrical,AppLocaleKey.airConditioning])),
      const SizedBox(width:12),
      Expanded(child:_category(AppLocaleKey.generalServices,Icons.grid_view_outlined,[AppLocaleKey.cleaning,AppLocaleKey.fixedPriceService])),
    ])),
    const SizedBox(height:12),
    Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Text(AppLocaleKey.prototypeData.tr(),textAlign:TextAlign.center,style:const TextStyle(color:Colors.white70,fontSize:11))),
  ]);

  Widget _category(String title,IconData icon,List<String> choices)=>Container(
    padding:const EdgeInsets.all(15),decoration:BoxDecoration(color:Colors.white.withValues(alpha:.94),borderRadius:BorderRadius.circular(22)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.end,children:[
      Icon(icon,color:AppColors.orange,size:27),const SizedBox(height:12),
      Text(title.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      const Divider(),
      ...choices.map((key)=>TextButton(onPressed:()=>setState(() { service=key; page=_Journey.detail; previous=_Journey.catalog; }),
        child:Align(alignment:Alignment.centerRight,child:Text(key.tr(),style:const TextStyle(color:AppColors.petrol))))),
    ]));

  Widget _detail()=>_subPage(AppLocaleKey.serviceDetails,[
    _panel([
      Row(children:[const CircleAvatar(backgroundColor:AppColors.mint,child:Icon(Icons.support_agent,color:AppColors.petrol)),const SizedBox(width:12),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(AppLocaleKey.greetingAli.tr(),style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),Text(AppLocaleKey.describeProblem.tr(),style:const TextStyle(color:AppColors.muted))]))]),
      const SizedBox(height:10),
      Text(service.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.petrol,fontSize:18,fontWeight:FontWeight.w800)),
      TextField(controller:issue,maxLines:3,textAlign:TextAlign.right,decoration:InputDecoration(hintText:AppLocaleKey.problemHint.tr())),
    ]),
    _panel([
      Text(AppLocaleKey.issueType.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Wrap(spacing:8,runSpacing:6,children:[AppLocaleKey.waterLeak,AppLocaleKey.drainBlock,AppLocaleKey.installation,AppLocaleKey.notSure].map((key)=>
        ChoiceChip(label:Text(key.tr()),selected:service==key,onSelected:(_)=>setState(()=>service=key))).toList()),
    ]),
    _action(AppLocaleKey.addPhotos,Icons.add_a_photo_outlined,()=>go(_Journey.files)),
    _next(AppLocaleKey.nextProviders,()=>go(_Journey.schedule)),
  ]);

  Widget _schedule()=>_subPage(AppLocaleKey.whenService,[
    _panel([
      Text(AppLocaleKey.whereService.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),
      const SizedBox(height:8),_selectPill(AppLocaleKey.myUnit,Icons.apartment_outlined),
      _selectPill(AppLocaleKey.sharedFacilities,Icons.groups_outlined),
    ]),
    _panel([
      Text(AppLocaleKey.whenService.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),
      const SizedBox(height:8),
      Wrap(spacing:6,children:[
        _choice(0,AppLocaleKey.scheduled,Icons.calendar_month_outlined),
        _choice(1,AppLocaleKey.urgent,Icons.schedule),
        _choice(2,AppLocaleKey.emergencyMode,Icons.warning_amber_rounded),
      ]),
      const SizedBox(height:12),
      Row(children:[Expanded(child:_selectPill(AppLocaleKey.preferredDate,Icons.calendar_today)),const SizedBox(width:8),Expanded(child:_selectPill(AppLocaleKey.morning,Icons.access_time))]),
      Text(AppLocaleKey.providerTiming.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted,fontSize:11)),
    ]),
    _next(AppLocaleKey.nextProviders,()=>go(_Journey.providers)),
  ]);

  Widget _choice(int value,String key,IconData icon)=>ChoiceChip(
    avatar:Icon(icon,size:17,color:mode==value?AppColors.orange:AppColors.petrol),
    label:Text(key.tr()),selected:mode==value,onSelected:(_)=>setState(()=>mode=value),
    selectedColor:AppColors.mint,backgroundColor:Colors.white);

  Widget _selectPill(String key,IconData icon)=>Padding(padding:const EdgeInsets.only(bottom:8),child:OutlinedButton.icon(
    onPressed:()=>_showPicker(key),icon:Icon(icon,color:AppColors.petrol),label:Text(key.tr()),
    style:OutlinedButton.styleFrom(foregroundColor:AppColors.petrol,alignment:Alignment.centerRight,side:const BorderSide(color:AppColors.mint))));

  Widget _providers()=>_subPage(AppLocaleKey.availableProviders,[
    _panel([Text(service.tr(),textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(AppLocaleKey.myUnit.tr()+' • '+AppLocaleKey.flatNumber.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted))]),
    _provider(AppLocaleKey.providerOne,AppLocaleKey.providerOneMeta.tr(),'150',Icons.home_repair_service),
    _provider(AppLocaleKey.providerTwo,AppLocaleKey.providerTwoMeta.tr(),'180',Icons.handyman_outlined),
  ]);

  Widget _provider(String name,String rating,String price,IconData icon)=>_panel([
    Row(children:[CircleAvatar(backgroundColor:AppColors.petrol,child:Icon(icon,color:Colors.white)),const Spacer(),
      Column(crossAxisAlignment:CrossAxisAlignment.end,children:[Text(name.tr(),style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:AppColors.petrol)),Text(rating,style:const TextStyle(color:AppColors.muted))])]),
    const SizedBox(height:8),Text(price+' '+AppLocaleKey.currencySar.tr()+' • '+AppLocaleKey.serviceType.tr(),textAlign:TextAlign.right),
    Text(AppLocaleKey.arrivalInThreeHours.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted,fontSize:12)),
    const SizedBox(height:8),
    Row(children:[
      Expanded(child:OutlinedButton(onPressed:()=>_showPicker(AppLocaleKey.companyProfile),child:Text(AppLocaleKey.viewCompany.tr()))),
      const SizedBox(width:8),Expanded(child:FilledButton(onPressed:()=>go(_Journey.review),style:FilledButton.styleFrom(backgroundColor:AppColors.orange),child:Text(AppLocaleKey.selectProvider.tr()))),
    ]),
  ]);

  Widget _review()=>_subPage(AppLocaleKey.reviewRequest,[
    _panel([
      Text(service.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(issue.text.isEmpty?AppLocaleKey.problemHint.tr():issue.text,textAlign:TextAlign.right),
      const Divider(height:24),
      _kv(AppLocaleKey.providerOne,AppLocaleKey.preferredDate.tr()+' • '+AppLocaleKey.morning.tr()),
      _kv(AppLocaleKey.basePrice,'150 '+AppLocaleKey.currencySar.tr()),
      _kv(AppLocaleKey.total,'١٥٠ '+AppLocaleKey.currencySar.tr()),
    ]),
    _action(AppLocaleKey.serviceSummary,Icons.receipt_long_outlined,()=>_showPicker(AppLocaleKey.serviceSummary)),
    _next(AppLocaleKey.submitRequest,()=>go(_Journey.waiting)),
  ]);

  Widget _waiting()=>_subPage(AppLocaleKey.waitingProvider,[
    _panel([const Icon(Icons.hourglass_top_rounded,size:42,color:AppColors.orange),
      Text(AppLocaleKey.waitingProvider.tr(),textAlign:TextAlign.center,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(AppLocaleKey.requestSent.tr(),textAlign:TextAlign.center,style:const TextStyle(color:AppColors.muted))]),
    _action(AppLocaleKey.cancel,Icons.close,()=>_showPicker(AppLocaleKey.requestCancelled)),
    _next(AppLocaleKey.providerAccepted,()=>go(_Journey.tracking)),
  ]);

  Widget _tracking()=>_subPage(stage<2?AppLocaleKey.technicianOnWay:AppLocaleKey.serviceInProgress,[
    _panel([
      Text(AppLocaleKey.orderReference.tr()+' • RD–2048',textAlign:TextAlign.right,style:const TextStyle(color:Colors.white70)),
      Text((stage==0?AppLocaleKey.providerAccepted:stage==1?AppLocaleKey.technicianOnWay:stage==2?AppLocaleKey.serviceInProgress:AppLocaleKey.serviceComplete).tr(),
        textAlign:TextAlign.right,style:const TextStyle(color:Colors.white,fontSize:24,fontWeight:FontWeight.w800)),
      const SizedBox(height:14),
      LinearProgressIndicator(value:(stage+1)/4,color:AppColors.orange,backgroundColor:Colors.white24,minHeight:8),
      const SizedBox(height:10),
      Text(AppLocaleKey.providerTiming.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white)),
    ],glass:true),
    _panel([Text(AppLocaleKey.providerOne.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Row(children:[Expanded(child:_action(AppLocaleKey.chat,Icons.chat_bubble_outline,()=>_showPicker(AppLocaleKey.chat))),
        const SizedBox(width:8),Expanded(child:_action(AppLocaleKey.callTechnician,Icons.call_outlined,()=>_showPicker(AppLocaleKey.callTechnician)))])]),
    _action(AppLocaleKey.serviceFiles,Icons.photo_library_outlined,()=>go(_Journey.files)),
    _action(AppLocaleKey.addWork,Icons.add_circle_outline,()=>go(_Journey.additional)),
    if(stage<3)_next(AppLocaleKey.serviceInProgress,()=>setState(()=>stage++)),
    if(stage>=3)_next(AppLocaleKey.serviceReport,()=>go(_Journey.invoice)),
  ]);

  Widget _additional()=>_subPage(AppLocaleKey.additionalOffer,[
    _panel([Text(AppLocaleKey.additionalOffer.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(AppLocaleKey.serviceReport.tr(),textAlign:TextAlign.right),
      Text('50 '+AppLocaleKey.currencySar.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:21,fontWeight:FontWeight.w800,color:AppColors.orange)),
      TextField(controller:notes,textAlign:TextAlign.right,decoration:InputDecoration(hintText:AppLocaleKey.ratingNote.tr()))]),
    Row(children:[
      Expanded(child:FilledButton(onPressed:(){setState(()=>acceptedAdditional=true);back();},style:FilledButton.styleFrom(backgroundColor:AppColors.orange),child:Text(AppLocaleKey.approveOffer.tr()))),
      const SizedBox(width:8),Expanded(child:OutlinedButton(onPressed:(){setState(()=>acceptedAdditional=false);back();},child:Text(AppLocaleKey.declineOffer.tr()))),
    ]),
  ]);

  Widget _files()=>_subPage(AppLocaleKey.serviceFiles,[
    _panel([Text(AppLocaleKey.uploadHint.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted)),
      const SizedBox(height:12),Container(height:120,decoration:BoxDecoration(color:AppColors.mint,borderRadius:BorderRadius.circular(16)),
        child:const Icon(Icons.image_outlined,size:42,color:AppColors.petrol)),
      Row(children:[Expanded(child:_action(AppLocaleKey.addPhoto,Icons.add_a_photo_outlined,()=>_toast(AppLocaleKey.comingSoon.tr()))),
        const SizedBox(width:8),Expanded(child:_action(AppLocaleKey.addVideo,Icons.videocam_outlined,()=>_toast(AppLocaleKey.comingSoon.tr())))]),
    ]),
    _action(AppLocaleKey.proofOfWork,Icons.fact_check_outlined,()=>go(_Journey.invoice)),
  ]);

  Widget _invoice()=>_subPage(AppLocaleKey.invoice,[
    _panel([
      Text(AppLocaleKey.orderReference.tr()+' • RD–2048',textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted)),
      Text(AppLocaleKey.serviceComplete.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.petrol,fontSize:20,fontWeight:FontWeight.w800)),
      _kv(AppLocaleKey.basePrice,'١٥٠ '+AppLocaleKey.currencySar.tr()),
      if(acceptedAdditional)_kv(AppLocaleKey.addWork,'٥٠ '+AppLocaleKey.currencySar.tr()),
      const Divider(),_kv(AppLocaleKey.total,acceptedAdditional?'200 '+AppLocaleKey.currencySar.tr():'١٥٠ '+AppLocaleKey.currencySar.tr()),
      Text(AppLocaleKey.warranty.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted)),
    ]),
    _next(AppLocaleKey.confirmReceipt,()=>go(_Journey.rating)),
    _action(AppLocaleKey.payNow,Icons.payments_outlined,()=>go(_Journey.payment)),
    _action(AppLocaleKey.proofOfWork,Icons.description_outlined,()=>go(_Journey.files)),
  ]);

  Widget _payment()=>_subPage(AppLocaleKey.payNow,[
    _panel([Text(AppLocaleKey.invoice.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      _kv(AppLocaleKey.total,'١٥٠ '+AppLocaleKey.currencySar.tr()),
      _action(AppLocaleKey.paymentComplete,Icons.credit_card,()=>setState(()=>page=_Journey.rating))]),
    _next(AppLocaleKey.paymentComplete,()=>go(_Journey.rating)),
  ]);

  Widget _rating()=>_subPage(AppLocaleKey.rateExperience,[
    _panel([
      Text(AppLocaleKey.ratingPrompt.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(AppLocaleKey.providerOne.tr(),textAlign:TextAlign.right),
      const SizedBox(height:12),
      Row(mainAxisAlignment:MainAxisAlignment.center,children:List.generate(5,(i)=>IconButton(
        onPressed:()=>setState(()=>stars=i+1),icon:Icon(Icons.star_rounded,color:i<stars?AppColors.orange:AppColors.muted,size:33)))),
      TextField(controller:notes,maxLines:3,textAlign:TextAlign.right,decoration:InputDecoration(hintText:AppLocaleKey.ratingNote.tr())),
      const SizedBox(height:8),_action(AppLocaleKey.sendRating,Icons.send_outlined,()=>go(_Journey.warranty)),
      TextButton(onPressed:()=>go(_Journey.warranty),child:Text(AppLocaleKey.later.tr())),
    ]),
  ]);

  Widget _warranty()=>_subPage(AppLocaleKey.warranty,[
    _panel([const Icon(Icons.verified_user_outlined,size:42,color:AppColors.petrol),
      Text(AppLocaleKey.warranty.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(AppLocaleKey.serviceComplete.tr(),textAlign:TextAlign.right),
      _kv(AppLocaleKey.followUp,AppLocaleKey.days30.tr()),
    ]),
    _action(AppLocaleKey.followUp,Icons.event_available_outlined,()=>go(_Journey.followup)),
    _next(AppLocaleKey.home,()=>setState(()=>page=_Journey.catalog)),
  ]);

  Widget _followup()=>_subPage(AppLocaleKey.followUp,[
    _panel([Text(AppLocaleKey.technicianOnWay.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      _selectPill(AppLocaleKey.preferredDate,Icons.calendar_today),
      _selectPill(AppLocaleKey.morning,Icons.access_time),
    ]),
    _next(AppLocaleKey.requestSent,()=>_toast(AppLocaleKey.requestSent.tr())),
  ]);

  Widget _subPage(String key,List<Widget> children)=>ListView(key:ValueKey(key),padding:EdgeInsets.zero,children:[
    _header(key,backButton:true),
    Padding(padding:const EdgeInsets.fromLTRB(12,4,12,24),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:children)),
  ]);
  Widget _panel(List<Widget> children,{bool glass=false})=>Container(
    margin:const EdgeInsets.fromLTRB(20,8,20,8),padding:const EdgeInsets.all(16),
    decoration:BoxDecoration(color:glass?Colors.white.withValues(alpha:.2):Colors.white.withValues(alpha:.94),
      border:glass?Border.all(color:Colors.white38):null,borderRadius:BorderRadius.circular(22)),
    child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:children));
  Widget _kv(String key,String value)=>Padding(padding:const EdgeInsets.symmetric(vertical:6),child:Row(children:[
    Text(value,style:const TextStyle(fontWeight:FontWeight.w700,color:AppColors.petrol)),const Spacer(),
    Text(key.tr(),style:const TextStyle(color:AppColors.muted)),
  ]));
  Widget _next(String label,VoidCallback onPressed)=>Padding(padding:const EdgeInsets.symmetric(horizontal:20,vertical:8),
    child:SizedBox(height:50,child:FilledButton(onPressed:onPressed,style:FilledButton.styleFrom(backgroundColor:AppColors.orange,foregroundColor:Colors.white),child:Text(label.tr()))));
  Widget _action(String key,IconData icon,VoidCallback action)=>Padding(padding:const EdgeInsets.symmetric(horizontal:20,vertical:5),
    child:FilledButton.tonalIcon(onPressed:action,icon:Icon(icon),label:Text(key.tr()),style:FilledButton.styleFrom(
      backgroundColor:AppColors.mint,foregroundColor:AppColors.petrol,alignment:Alignment.centerRight)));
  void _showPicker(String key)=>showModalBottomSheet<void>(context:context,showDragHandle:true,builder:(ctx)=>SafeArea(
    child:Padding(padding:const EdgeInsets.all(22),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[
      Text(key.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      const SizedBox(height:12),Text(AppLocaleKey.prototypeData.tr(),textAlign:TextAlign.center),
      const SizedBox(height:12),FilledButton(onPressed:()=>Navigator.pop(ctx),child:Text(AppLocaleKey.later.tr())),
    ]))));
  void _toast(String value)=>ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content:Text(value)));
}

