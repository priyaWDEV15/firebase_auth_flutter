import 'dart:async';
import 'package:firebase_auth_flutter/services/info_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_flutter/authenticate/auth_service.dart';
import 'package:firebase_auth_flutter/services/user_details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _pincode = TextEditingController();

  bool loading = true;
  var userData;
  bool alert = true;
  String uid = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      uid = context.read<Authenticate>().getUid();
    });
    print('Home uid:$uid');
    UserDetails user = UserDetails();
    user.getUserDataFromUid(uid).then((value) {
      setState(() {
        userData = value;
        alert = userData['alert'] == 'true';
      });
    });
    Future.delayed(Duration(seconds: 4, milliseconds: 400), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: (userData != null)
          ? Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                            radius: 40,
                            child: ClipRRect(
                              child: Image.asset(userData['gender'] == 'Male'
                                  ? 'images/boy.png'
                                  : 'images/girl.png'),
                              borderRadius: BorderRadius.circular(50.0),
                            )),
                        SizedBox(height: 10),
                        Text("${userData['name']}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Update Details'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UpdateDetails(updateDrawer: (newData) {
                                    setState(() {
                                      userData = newData;
                                    });
                                  })));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: Text('About'),
                    onTap: () {
                      // TODO: Modify About
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutPage()));
                    },
                  ),
                ],
              ),
            )
          : SizedBox(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: () async {
                                await context.read<Authenticate>().signOut();
                                Navigator.of(context).pop();
                              },
                              child: Text("Yes")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("No")),
                        ],
                        title: Text('Are you sure you want to logout?'),
                      ));
            },
            icon: Icon(Icons.person, color: Colors.black),
          )
        ],
        title: Text(
          "Food Delivery App",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Center(child: Text('Welcome !!')),
        padding: EdgeInsets.fromLTRB(2, 5, 2, 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
    );
  }
}
