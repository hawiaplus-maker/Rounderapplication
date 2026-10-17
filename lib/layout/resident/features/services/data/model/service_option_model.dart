class ServiceOption {
 const ServiceOption({required this.id,required this.code,required this.name,required this.price,required this.categoryName,this.description});
 final int id; final String code,name,categoryName; final double price; final String? description;
 factory ServiceOption.fromJson(Map<String,dynamic> j)=>ServiceOption(id:int.tryParse('${j['id']}')??0,code:j['code']?.toString()??'',name:j['name']?.toString()??'',price:double.tryParse('${j['price']??0}')??0,categoryName:(j['category'] as Map?)?['name']?.toString()??'',description:j['description']?.toString());
}
