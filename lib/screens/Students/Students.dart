import 'package:flutter/material.dart';
import 'package:iis/services/RatingApi/RatingManager.dart';
import 'package:iis/services/RatingApi/ratingapi.dart';
import 'package:iis/services/DIsciplinesApi/disciplineapi.dart';
import 'package:iis/services/DIsciplinesApi/DisciplineManager.dart';
import 'package:iis/services/StudentsApi/StudentsManager.dart';
import 'package:iis/services/StudentsApi/studentsapi.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:logger/logger.dart';
import 'package:iis/screens/Students/StudentsList.dart';

final logger = Logger();


///
/// Если тут делать дизайн, гуглить это
/// https://pub.dev/packages/multi_select_flutter
///
class Students extends StatefulWidget{
  Students({super.key});

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {

  static List<Skill>? Skills;
  static List<Speciality>? Faculties;
  static List<int> Courses =[1,2,3,4,5,6];

  static bool searchjob = false;
  static String? Secondname;
  static List<int> SelectedFaculties =[];
  static List<Skill> SelectedSkills = [];
  static List<int> SelectedCourses = [];

  Future<bool> initialize() async
  {
    if (Faculties == null || Faculties!.isEmpty)
      Faculties = await RatingManager.GetFaculty();
    Skills = await StudentManager.GetSkills("");
    logger.d(Faculties);
    return true;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1046,
        leadingWidth: MediaQuery.of(context).size.width * 0.046,
        title: Row(
          children: [
            SizedBox(
              child: IconButton(
                icon: const Icon(Icons.person),
                iconSize: MediaQuery.of(context).size.width * 0.06,
                onPressed: () {
                  // Действия при нажатии на кнопку
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.031,
            ),
            const Text(
              'Студенты',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'NotoSerif',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.34,
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black, // Цвет иконки
        ),
      ),
    body: FutureBuilder(
      future: initialize(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData && snapshot != null)
          return CircularProgressIndicator();
        return SafeArea(
          child:
          Column
            (
            children: [
              Row(
                children: [
                  Checkbox(
                      value: searchjob,
                      onChanged: (bol){setState(() {
                    searchjob = bol!;
                  });},
                    checkColor: Colors.white, // Color of the checkmark when the checkbox is selected
                    activeColor: Colors.black,
                  ),
                  const Text(
                      "В поисках работы",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'NotoSerif',
                    ),
                  ),
                ],
              ),
                TextField(
                onSubmitted: (String value) async {
                  setState(() {
                    Secondname = value;
                  });
                }
                ),
              MultiSelectDialogField<int>(
                buttonText: const Text(
                    'Факультеты',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'NotoSerif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                searchable: true,
                title: const Text(
                    'Факультеты',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'NotoSerif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                items: Faculties!.map((e) => MultiSelectItem(e.id!, e.text!)).toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (values) {
                  SelectedFaculties = values;
                },
                chipDisplay: MultiSelectChipDisplay(
                  items: Faculties!.map((e) => MultiSelectItem(e.id!, e.text!)).toList(),
                 // onTap: (value) {
                 //     SelectedFaculties!.remove(value);
                 // },
                ),
              ),
              MultiSelectDialogField<int>(
                buttonText: const Text(
                    'Курсы',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'NotoSerif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                searchable: true,
                title: const Text(
                    'Курсы',
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'NotoSerif',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                items: Courses.map((e) => MultiSelectItem(e, e.toString())).toList(),
                listType: MultiSelectListType.CHIP,
                onConfirm: (values) {
                  SelectedFaculties = values;
                },
                chipDisplay: MultiSelectChipDisplay(
                  items: Courses.map((e) => MultiSelectItem(e, e.toString())).toList(),
                  // onTap: (value) {
                  //     SelectedFaculties!.remove(value);
                  // },
                ),
              ),
             Container(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Autocomplete<Skill>(
                       displayStringForOption: (Skill option) => option.name!,
                       optionsBuilder:(TextEditingValue textEditingValue) async
                       {
                         List<Skill>? list = await StudentManager.GetSkills(textEditingValue.text);
                         return list!;
                       },
                      onSelected: (Skill a)
                      {
                           setState(() {
                             SelectedSkills.add(a);
                           });
                      },
                   ),
                   MultiSelectChipDisplay(
                     items: SelectedSkills.map((e) => MultiSelectItem(e, e.name!)).toList(),
                     onTap: (value)
                     {
                       setState(() {
                         SelectedSkills.remove(value);
                       });
                     },
                   ),
                 ],
               ),
             ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton(onPressed:
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StudentsList(searchjob: searchjob,
                      Secondname: Secondname, SelectedFaculties:
                      SelectedFaculties, SelectedSkills: SelectedSkills.map((e) => e.id!).toList(),
                      SelectedCourses: SelectedCourses)),);
              },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as desired
                ),
                backgroundColor: Colors.white, // Change the color to your desired color
                foregroundColor: Colors.black, // Change the icon color to black
                child: const Icon(Icons.search),
              ),
            ],
          ),
        );
      },
    )
  );
}

