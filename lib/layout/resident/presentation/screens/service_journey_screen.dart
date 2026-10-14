import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';
import 'emergency_request_screen.dart';
import '../../../../core/di/injection.dart';
import '../cubits/preview_orders_cubit.dart';

/// Screen-only service journey. Values and actions are local prototype state
/// so the complete Figma flow can be reviewed before API integration.
class ServiceJourneyScreen extends StatefulWidget {
  const ServiceJourneyScreen({super.key, this.startOnTracking=false, this.startOnInvoice=false, this.order});
  final bool startOnTracking, startOnInvoice;
  final PreviewOrder? order;
  @override State<ServiceJourneyScreen> createState() => _ServiceJourneyScreenState();
}
enum _Journey { catalog, detail, schedule, providers, review, waiting, tracking, additional, files, invoice, payment, rating, warranty, followup }
class _ServiceJourneyScreenState extends State<ServiceJourneyScreen> {
  late _Journey page=widget.startOnInvoice?_Journey.invoice:widget.startOnTracking?_Journey.tracking:_Journey.catalog, previous=_Journey.catalog;
  String service=AppLocaleKey.plumbing, issueType=AppLocaleKey.notSure;
  String selectedProvider=AppLocaleKey.providerOne, location=AppLocaleKey.myUnit;
  double basePrice=150;
  DateTime? selectedDate;
  TimeOfDay selectedTime=const TimeOfDay(hour:9,minute:0);
  String? orderReference;
  final List<_Journey> _history=[];
  String get _dateLabel => selectedDate == null ? AppLocaleKey.preferredDate.tr()
    : DateFormat.yMMMd(context.locale.toString()).format(selectedDate!);
  String get _timeLabel => selectedTime.format(context);
  String get _amountLabel => (basePrice+(acceptedAdditional?50:0)).toStringAsFixed(2);

  int mode=0, stage=0, stars=0;
  bool acceptedAdditional=false;
  final query=TextEditingController(), issue=TextEditingController(), notes=TextEditingController();
  void go(_Journey next){setState(() { _history.add(page); previous=page; page=next; });}
  void back(){setState(() { page=_history.isEmpty?_Journey.catalog:_history.removeLast(); });}
  Future<void> _pickDate() async {
    final now=DateTime.now();
    final value=await showDatePicker(context:context, initialDate:selectedDate??now.add(const Duration(days:1)),
      firstDate:DateTime(now.year,now.month,now.day),lastDate:now.add(const Duration(days:365)));
    if(value!=null&&mounted)setState(()=>selectedDate=value);
  }
  Future<void> _pickTime() async {
    final value=await showTimePicker(context:context,initialTime:selectedTime);
    if(value!=null&&mounted)setState(()=>selectedTime=value);
  }
  void _continueSchedule(){
    if(mode==0 && selectedDate==null){_toast(AppLocaleKey.checkFields.tr());return;}
    final date=selectedDate??DateTime.now();
    final schedule=mode==1?DateTime.now().add(const Duration(hours:3)):DateTime(date.year,date.month,date.day,selectedTime.hour,selectedTime.minute);
    if(!schedule.isAfter(DateTime.now())){_toast(AppLocaleKey.checkFields.tr());return;}
    go(_Journey.providers);
  }
  void _submitPreview(){
    if(orderReference==null){
      final date=selectedDate??DateTime.now();
      final scheduledAt=mode==1?DateTime.now().add(const Duration(hours:3)):DateTime(date.year,date.month,date.day,selectedTime.hour,selectedTime.minute);
      final order=sl<PreviewOrdersCubit>().create(serviceKey:service,providerKey:selectedProvider,
        scheduledAt:scheduledAt,amount:basePrice,locationKey:location,notes:issue.text.trim());
      orderReference=order.reference;
    }
    go(_Journey.waiting);
  }
  @override void initState(){
    super.initState();
    final order=widget.order;
    if(order!=null){
      service=order.serviceKey;selectedProvider=order.providerKey;basePrice=order.amount;
      selectedDate=order.scheduledAt;selectedTime=TimeOfDay.fromDateTime(order.scheduledAt);
      location=order.locationKey;orderReference=order.reference;issue.text=order.notes;
      if(order.statusKey==AppLocaleKey.serviceComplete)stage=3;
    }
  }
  void _activatePreview(){
    if(orderReference!=null)sl<PreviewOrdersCubit>().update(orderReference!,AppLocaleKey.orderActive);
    go(_Journey.tracking);
  }
  void _advancePreview(){
    setState(()=>stage++);
    if(stage>=3&&orderReference!=null)sl<PreviewOrdersCubit>().update(orderReference!,AppLocaleKey.serviceComplete,
      amount:basePrice+(acceptedAdditional?50:0));
  }
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
    Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:TextField(controller:query,onChanged:(_)=>setState((){}),textAlign:TextAlign.right,
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
      ...choices.where((key)=>key.tr().toLowerCase().contains(query.text.trim().toLowerCase())).map((key)=>TextButton(onPressed:(){
        setState(() { service=key; orderReference=null; acceptedAdditional=false; });
        go(_Journey.detail);
      },
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
        ChoiceChip(label:Text(key.tr()),selected:issueType==key,onSelected:(_)=>setState(()=>issueType=key))).toList()),
    ]),
    _action(AppLocaleKey.addPhotos,Icons.add_a_photo_outlined,()=>go(_Journey.files)),
    _next(AppLocaleKey.nextProviders,(){ if(issue.text.trim().length<5){_toast(AppLocaleKey.requiredField.tr());return;} go(_Journey.schedule); }),
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
    _next(AppLocaleKey.nextProviders,_continueSchedule),
  ]);

  Widget _choice(int value,String key,IconData icon)=>ChoiceChip(
    avatar:Icon(icon,size:17,color:mode==value?AppColors.orange:AppColors.petrol),
    label:Text(key.tr()),selected:mode==value,onSelected:(_){
      if(value==2){
        Navigator.of(context).push(MaterialPageRoute<void>(builder:(_)=>const EmergencyRequestScreen()));
        return;
      }
      setState(()=>mode=value);
    },
    selectedColor:AppColors.mint,backgroundColor:Colors.white);

  Widget _selectPill(String key,IconData icon)=>Padding(padding:const EdgeInsets.only(bottom:8),child:OutlinedButton.icon(
    onPressed:(){
      if(key==AppLocaleKey.preferredDate){_pickDate();return;}
      if(key==AppLocaleKey.morning){_pickTime();return;}
      if(key==AppLocaleKey.myUnit||key==AppLocaleKey.sharedFacilities){setState(()=>location=key);return;}
      _showPicker(key);
    },icon:Icon((key==location)?Icons.check_circle:icon,color:AppColors.petrol),
    label:Text(key==AppLocaleKey.preferredDate?_dateLabel:key==AppLocaleKey.morning?_timeLabel:key.tr()),
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
      const SizedBox(width:8),Expanded(child:FilledButton(onPressed:(){setState((){selectedProvider=name;basePrice=double.parse(price);});go(_Journey.review);},style:FilledButton.styleFrom(backgroundColor:AppColors.orange),child:Text(AppLocaleKey.selectProvider.tr()))),
    ]),
  ]);

  Widget _review()=>_subPage(AppLocaleKey.reviewRequest,[
    _panel([
      Text(service.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(issue.text.isEmpty?AppLocaleKey.problemHint.tr():issue.text,textAlign:TextAlign.right),
      const Divider(height:24),
      _kv(selectedProvider,'$_dateLabel • $_timeLabel'),
      _kv(AppLocaleKey.orderPlace,location.tr()),
      _kv(AppLocaleKey.basePrice,'${basePrice.toStringAsFixed(2)} ${AppLocaleKey.currencySar.tr()}'),
      _kv(AppLocaleKey.total,'$_amountLabel ${AppLocaleKey.currencySar.tr()}'),
    ]),
    _action(AppLocaleKey.serviceSummary,Icons.receipt_long_outlined,()=>_showPicker(AppLocaleKey.serviceSummary)),
    _next(AppLocaleKey.submitRequest,_submitPreview),
  ]);

  Widget _waiting()=>_subPage(AppLocaleKey.waitingProvider,[
    _panel([const Icon(Icons.hourglass_top_rounded,size:42,color:AppColors.orange),
      Text(AppLocaleKey.waitingProvider.tr(),textAlign:TextAlign.center,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(AppLocaleKey.requestSent.tr(),textAlign:TextAlign.center,style:const TextStyle(color:AppColors.muted))]),
    _action(AppLocaleKey.cancel,Icons.close,(){
      if(orderReference!=null)sl<PreviewOrdersCubit>().cancel(orderReference!);
      _toast(AppLocaleKey.requestCancelled.tr());go(_Journey.catalog);
    }),
    _next(AppLocaleKey.providerAccepted,_activatePreview),
  ]);

  Widget _tracking()=>_subPage(stage<2?AppLocaleKey.technicianOnWay:AppLocaleKey.serviceInProgress,[
    _panel([
      Text(AppLocaleKey.orderReference.tr()+' • '+(orderReference??'—'),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white70)),
      Text((stage==0?AppLocaleKey.providerAccepted:stage==1?AppLocaleKey.technicianOnWay:stage==2?AppLocaleKey.serviceInProgress:AppLocaleKey.serviceComplete).tr(),
        textAlign:TextAlign.right,style:const TextStyle(color:Colors.white,fontSize:24,fontWeight:FontWeight.w800)),
      const SizedBox(height:14),
      LinearProgressIndicator(value:(stage+1)/4,color:AppColors.orange,backgroundColor:Colors.white24,minHeight:8),
      const SizedBox(height:10),
      Text(AppLocaleKey.providerTiming.tr(),textAlign:TextAlign.right,style:const TextStyle(color:Colors.white)),
    ],glass:true),
    _panel([Text(selectedProvider.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Row(children:[Expanded(child:_action(AppLocaleKey.chat,Icons.chat_bubble_outline,()=>_showPicker(AppLocaleKey.chat))),
        const SizedBox(width:8),Expanded(child:_action(AppLocaleKey.callTechnician,Icons.call_outlined,()=>_showPicker(AppLocaleKey.callTechnician)))])]),
    _action(AppLocaleKey.serviceFiles,Icons.photo_library_outlined,()=>go(_Journey.files)),
    _action(AppLocaleKey.addWork,Icons.add_circle_outline,()=>go(_Journey.additional)),
    if(stage<3)_next(AppLocaleKey.serviceInProgress,_advancePreview),
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
      Text(AppLocaleKey.orderReference.tr()+' • '+(orderReference??'—'),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted)),
      Text(AppLocaleKey.serviceComplete.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.petrol,fontSize:20,fontWeight:FontWeight.w800)),
      _kv(AppLocaleKey.basePrice,'${basePrice.toStringAsFixed(2)} ${AppLocaleKey.currencySar.tr()}'),
      if(acceptedAdditional)_kv(AppLocaleKey.addWork,'50 '+AppLocaleKey.currencySar.tr()),
      const Divider(),_kv(AppLocaleKey.total,'$_amountLabel ${AppLocaleKey.currencySar.tr()}'),
      Text(AppLocaleKey.warranty.tr(),textAlign:TextAlign.right,style:const TextStyle(color:AppColors.muted)),
    ]),
    _next(AppLocaleKey.confirmReceipt,()=>go(_Journey.rating)),
    _action(AppLocaleKey.payNow,Icons.payments_outlined,()=>go(_Journey.payment)),
    _action(AppLocaleKey.proofOfWork,Icons.description_outlined,()=>go(_Journey.files)),
  ]);

  Widget _payment()=>_subPage(AppLocaleKey.payNow,[
    _panel([Text(AppLocaleKey.invoice.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      _kv(AppLocaleKey.total,'$_amountLabel ${AppLocaleKey.currencySar.tr()}'),
      _action(AppLocaleKey.paymentComplete,Icons.credit_card,()=>setState(()=>page=_Journey.rating))]),
    _next(AppLocaleKey.paymentComplete,()=>go(_Journey.rating)),
  ]);

  Widget _rating()=>_subPage(AppLocaleKey.rateExperience,[
    _panel([
      Text(AppLocaleKey.ratingPrompt.tr(),textAlign:TextAlign.right,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800,color:AppColors.petrol)),
      Text(selectedProvider.tr(),textAlign:TextAlign.right),
      const SizedBox(height:12),
      Row(mainAxisAlignment:MainAxisAlignment.center,children:List.generate(5,(i)=>IconButton(
        onPressed:()=>setState(()=>stars=i+1),icon:Icon(Icons.star_rounded,color:i<stars?AppColors.orange:AppColors.muted,size:33)))),
      TextField(controller:notes,maxLines:3,textAlign:TextAlign.right,decoration:InputDecoration(hintText:AppLocaleKey.ratingNote.tr())),
      const SizedBox(height:8),_action(AppLocaleKey.sendRating,Icons.send_outlined,(){if(stars==0){_toast(AppLocaleKey.requiredField.tr());return;}go(_Journey.warranty);}),
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

