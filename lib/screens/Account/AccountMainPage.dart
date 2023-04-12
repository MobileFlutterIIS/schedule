import 'package:flutter/material.dart';
import 'package:iis/services/CheckValidatingUserAndPassword/AccountManager.dart';
import 'package:iis/services/CheckValidatingUserAndPassword/user_entity.dart';
import 'package:iis/services/CheckValidatingUserAndPassword/CertificateGroupAnouncements.dart';

class MainPage extends StatelessWidget {
  final UserEntity user;
  const MainPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return Column(
        children: <Widget>[
          SizedBox(
            height: 240,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: CustomShape(),
                  child: Container(
                    height: 150,
                    color: const Color.fromRGBO(251, 150, 158, 0.9),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 8,
                          ),
                        ),
                        child: ClipOval(
                          child: UserIcon(url :user.photoUrl!),
                          clipBehavior: Clip.antiAlias,
                        ),),
                      const SizedBox(height: 10),
                      Text(
                        user.lastName! + ' ' + user.firstName! + ' ' + user.middleName!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.course!.toString()+', '+user.faculty!+', '+user.speciality!+', '+user.studentGroup!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 20),
          // Container(
          //   height: 400,
          //   width: MediaQuery.of(context).size.width - 40,
          //   decoration: BoxDecoration(
          //     color: const Color.fromRGBO(254, 243, 244, 0.9),
          //     //color: Colors.white,
          //     borderRadius: BorderRadius.circular(10),
          //     // boxShadow: [
          //     //   BoxShadow(
          //     //     color: Colors.grey.withOpacity(0.5),
          //     //     spreadRadius: 2,
          //     //     blurRadius: 7,
          //     //     offset: const Offset(0, 3),
          //     //   ),
          //     // ],
          //     // gradient: LinearGradient(
          //     //   begin: Alignment.bottomCenter,
          //     //   end: Alignment.topCenter,
          //     //   colors: [
          //     //     Colors.white.withOpacity(0),
          //     //     Colors.white.withOpacity(0.5),
          //     //     Colors.white.withOpacity(0.8),
          //     //     Colors.white.withOpacity(0.9),
          //     //     Colors.white.withOpacity(0.95),
          //     //   ],
          //     // ),
          //   ),
          // ),


        ],
      );
    }

  }

  class UserIcon extends StatefulWidget {
  String url ;
  UserIcon({Key? key, required this.url}) : super(key: key);

    @override
    State<UserIcon> createState() => _UserIconState();
  }

  class _UserIconState extends State<UserIcon> {


    @override
    Widget build(BuildContext context) {
        return IconButton(
          icon: (widget.url != null ? Image.network(widget.url!) : Icon(Icons.person)) ,
          onPressed: () async{
            final ans = await AccountManager.SetUserImage();
            logger.d(ans);
            if (ans != null)
            setState(() {
              widget.url = ans!;
            });
          },
        );
      }
  }



 ///
/// старая иконка которую делал не я


// (user.photoUrl != null
// ? Image.network(
// user.photoUrl!,
// width: 150,
// height: 150,
// fit: BoxFit.cover,
// )
//     : Icon( //-----------------------ИСПРАВИТЬ--(выглядит фу)
// Icons.person,
// size: 100,
// color: Colors.grey,
// ),
// ),

///
///

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width/2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


