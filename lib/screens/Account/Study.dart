import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iis/services/CheckValidatingUserAndPassword/AccountManager.dart';
import 'package:iis/services/CheckValidatingUserAndPassword/user_entity.dart';
import 'package:iis/services/CheckValidatingUserAndPassword/CertificateGroupAnouncements.dart';
import 'package:flutter_spinbox/material.dart';

class StudyPage extends StatefulWidget {
  final List<Certificate> certificate;
  final List<MarkSheet> marksheet;
  const StudyPage({Key? key,required this.certificate,required this.marksheet}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {

  ///
  /// TODO
  /// 1) Ведомостички ето прекол конечна, пока что там пуста ВСЕГДА
  /// 2) Обновить списки после заявок
  /// 3) добавить отмену справки
  /// 4) долги и доты
  ///
  /// +
  ///
  /// тут немного RoflanEbalo по коду (да вот прям под этим комментом)
  ///
  static List<Certificate>? certificates ;
  static List<MarkSheet>? marksheets;

  Future<void> updateCertificates () async
  {
    final newcerts = (await AccountManager.UserCetificate());
   //marksheets = (await AccountManager.UserMarkSheets());
    setState(() {
      certificates = newcerts;
    });
  }

  @override
  void initState() {
   certificates = widget.certificate;
   marksheets = widget.marksheet ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1046,
          leadingWidth: MediaQuery.of(context).size.width * 0.046,
          title: Row(
            children: const [
              Text(
                'Учеба',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'NotoSerif',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.black, // Цвет иконки
          ),
        ),
      body: SingleChildScrollView(
      child: Container(
        child: Column
          (
          children: [
            const SizedBox(height: 40,),
            Column(
              children: [
                const SizedBox(height: 30,),
                Text(
                    'Ведомостички',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 40, 32, 0.9),
                  ),
                ),
                const SizedBox(height: 5,),
                ElevatedButton(
                    onPressed: () {},
                    child: Text('Заказать ведомостичку'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blueAccent.withOpacity(0.5);
                        }
                        return Color.fromRGBO(51, 40, 32, 0.9);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        //physics: NeverScrollableScrollPhysics(),
                          itemCount: marksheets!.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context,index)
                          {
                            return Container(
                              child: Card(
                                color: (marksheets![index].status! == 'напечатана'? Color.fromRGBO(148, 166, 119, 0.9) : Color.fromRGBO(255, 255, 255, 0.9)),
                                elevation: 0.0,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(height: 10,),
                                      Text('Дата Создания ${marksheets![index].createDate!}'),
                                      const SizedBox(height: 5,),
                                      Text('Предмет ${marksheets![index].subject!.abbrev!}'
                                          '(${marksheets![index].subject!.lessonTypeAbbrev!})'
                                          '${marksheets![index].subject!.term} семестр'),
                                      const SizedBox(height: 5,),
                                      Text('Преподаватель ${marksheets![index].employee!.fio!}'),
                                      const SizedBox(height: 5,),
                                      ///
                                      /// TODO
                                      ///
                                      marksheets![index].absentDate != null?
                                      Text(
                                      'Дата пропуска ${marksheets![index].employee!.fio!}'
                                          ): SizedBox(),
                                      const SizedBox(height: 5,),
                                      Text('Статус ${marksheets![index].status!}'),
                                      const SizedBox(height: 5,),
                                      marksheets![index].rejectionReason != null?
                                      Text(
                                          'Причина отказа ${marksheets![index].rejectionReason!}'
                                      ): SizedBox(),
                                      const SizedBox(height: 5,),
                                      marksheets![index].price != null?
                                      Text(
                                          'Цена ${marksheets![index].price}'
                                      ): SizedBox(),
                                    ],
                                  ),
                                ) ,
                              ),
                            );
                          }
                      )
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Column(
              children: [
                Text(
                    'Справки',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    //color: Color.fromRGBO(51, 40, 32, 0.9),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return OrderCertificate();
                                }
                            ).then((_) => updateCertificates());
                    },
                    child: Text('Заказать справку'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.blueAccent.withOpacity(0.5);
                        }
                        return Color.fromRGBO(51, 40, 32, 0.9);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                  height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                  child: ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      itemCount: certificates!.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context,index)
                      {
                        return Container(
                          child: Card(
                            color: (certificates![index].status! == 1? Colors.green : certificates![index].status! == 2? Colors.yellow: Colors.red),
                            elevation: 0.0,
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(height: 10,),
                                   Text('Дата заказа ${certificates![index].dateOrder!}'),
                                   const SizedBox(height: 5,),
                                   Text('Место предъявления ${certificates![index].provisionPlace!}'),
                                   ///
                                  /// хз какие статусы имеются, надо искать докум
                                  ///
                                   const SizedBox(height: 5,),
                                   Text('${certificates![index].rejectionReason != null? 'Причина отказа ${certificates![index].rejectionReason!}' : ''}'),
                                   const SizedBox(height: 5,),
                                  certificates![index].status! == 2? IconButton(onPressed: () async{
                                    AccountManager.RemoveCertificate(certificates![index].id!);
                                    updateCertificates();
                                   }, icon: Icon(Icons.highlight_remove_outlined)):Text('Статус ${certificates![index].status == 1? "Напечатана" : "Отменена"}'),
                                ],
                              ),
                            ) ,
                          ),
                        );
                      }
                  )
              ),
                ),
              ]
            ),
            const SizedBox(height: 30,),
            ///
            /// dva placeholdera
            ///
            Text(
              'Заявки DOT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 40, 32, 0.9),
              ),
            ),
            const SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 100,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
              SizedBox(height: 30,),
              Container(
                child: Text(
                  'Задолженности в библиотеке',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(51, 40, 32, 0.9),
                  ),
                ),
              ),
          ],
        ),
      ),
      ));
  }
}

///
///
///  ЗАКАЗ СПРАВКИ
///
///
class OrderCertificate extends StatefulWidget {
  const OrderCertificate({Key? key}) : super(key: key);

  @override
  State<OrderCertificate> createState() => _OrderCertificateState();
}

class _OrderCertificateState extends State<OrderCertificate> {

  List<String> types = ['обычная','гербовая'];
  String? Typevalue = 'обычная';
  TextEditingController Commentcontroller = TextEditingController();
  int spinvalue = 1;
  //String? Comentvalue = '';
  static List<PlaceType>? places;
  Place? Placevalue;

  Future<bool> initplaces ( ) async
  {
    if ( places == null || places!.isEmpty )
   places = await AccountManager.GetPlaces();
   logger.d(places);
   return true;
  }

  /// return null
  /// TODO
  ///

  List<DropdownMenuItem<Place>> createlistplaces ()
  {
   List<DropdownMenuItem<Place>> list = [];
    var remba = "";
    places!.forEach((element) {
      if (element.type != remba) {
        remba = element!.type!;
        list.add(DropdownMenuItem<Place>(child: Row(children:
        [Text(element!.type!,style: TextStyle(fontSize: 10),),Expanded(child: Divider(color: Colors.black,))]),
            enabled: false, value: null));
      }
      element!.places!.forEach((ele) {
        list.add(DropdownMenuItem<Place>(child: Text(ele!.name!), value: ele,));
      });
    });
    return list;
  }

  @override
  void initState() {
    initplaces ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
        future: initplaces ( ),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData && snapshot != null)
            return CircularProgressIndicator();
          bool enabled;
          if (Placevalue !=null && Placevalue!.type! ==0) {
            enabled = true;
            Typevalue = 'обычная';
            Commentcontroller.clear();
          }
          else {
            enabled = false;
            Typevalue = 'гербовая';
            Commentcontroller.clear();
          }
          return AlertDialog(
            //backgroundColor: Colors.grey[900],
            scrollable: true,
            content:
            Column
              (
              children: <Widget>[
                Text('Тип печати'),
                DropdownButton<String>(
                    hint: Text(
                      'Тип печати',
                      // style: TextStyle(
                      //   color: widget.primarycolor,
                      // ),
                    ),
                    items: types.map<DropdownMenuItem<String>>((
                        String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: Typevalue,
                    onChanged: enabled? (value) {
                      setState(() {
                        Typevalue = value;
                      });
                    }: null,),
                RichText(text: TextSpan (text: 'Место предъявления',style: TextStyle(color: Colors.black),children:
                [
                  TextSpan(text: '*',style: TextStyle(color: Colors.red)),
                ])),
                DropdownButton<Place>(
                  isExpanded: true,
                    hint: Text(
                      'Вебырите место',
                      // style: TextStyle(
                      //   color: widget.primarycolor,
                      // ),
                    ),
                    items: createlistplaces(),
                    value: Placevalue,
                    onChanged: (value) {
                      setState(() {
                        Placevalue = value;
                      });
                    }),
               Text('Комментарий'),
               TextField(enabled: enabled,decoration: new InputDecoration.collapsed(
                   hintText: 'Оставьте комментарий'
               ),controller: Commentcontroller,),
               Text('Количество справок'),
                SpinBox(
                  min: 1,
                  max: 20,
                  value: 1,
                  onChanged: (value) =>  setState(() {
                    spinvalue = value.toInt();
                  }),
                ),
                ///
                /// TODO
                /// Аккуратнее со стилями текста тут
                ///
                RichText(text: TextSpan(text: 'Правила заказа\n',
                    style: TextStyle(fontSize: 20,color: Colors.black),
                  children: [
                    TextSpan(text: '1. Если Вы не знаете, какой тип печати нужен на справке, или Вам не нужна '
                        'гербовая печать, выбирайте тип печати ',style: TextStyle(fontSize: 15)),
                    TextSpan(text: '«обычная».\n', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    TextSpan(text: '2. Место предъявления ',style: TextStyle(fontSize: 15)),
                    TextSpan(text: '«иное» ', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    TextSpan(text: 'выбирайте только в том случае, если подходящий по смыслу вариант отсутствует в списке предложенных. '
                        'При этом в комментарии обязательно укажите нужное Вам место предъявления. '
                        'Справки «по месту требования» не выдаются – ',style: TextStyle(fontSize: 15)),
                    TextSpan(text: 'указывайте конкретное место.', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  ]
                ),),
                ElevatedButton(
                    onPressed: Placevalue != null ? () async{
                 var str = await AccountManager.SentCertificateRequest(spinvalue, Typevalue!, Placevalue!.name!, Commentcontroller.value.text);
                 logger.d(str);
                }
                : null,
                    child: Text('Заказать'),
                ),
              ],
            ),
          );
        }
      );
    }

}
