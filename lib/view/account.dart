import 'package:colour/colour.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:relief_app/model/userData.dart';
import 'package:relief_app/view/widgets/SideBar.dart';
import 'package:relief_app/view/widgets/animatedBarGrapgh.dart';
import 'package:relief_app/view/editAccountDetails.dart';
import 'package:relief_app/viewmodel/provider.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var formatter =
  NumberFormat.currency(locale: "en_UK", decimalDigits: 2, symbol: "£");
  String firstname ="-";
  String lastname ="-";
  String targetText ="";
  String email ="-";
  late ReliefUser? user ;


  setUser() async{
    final provider = Provider.of<AppProvider>(context, listen: false);
    user = await provider.fetchUser(context);
    if(user!= null){
      if(mounted){
        setState(() {
          firstname = user!.firstname;
          lastname = user!.lastname;
          if(user!.target != null){
            targetText = user!.target!;
          }
          else{
            targetText = "No target set";
          }
          email = user!.email;
        });
      }

    }


  }
    @override
  Widget build(BuildContext context) {
    setUser();
        return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0), // Adjust the height as needed
          child: Container(
            color: Colors.grey, // Set your desired border color
            height: 1.0,         // Set your desired border thickness
          ),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          ListTile(
            title: Text("Email", style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(email),
            onTap: () {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EditAccount(detail: "Email")));
            },
          ),

          ListTile(
            title: Text("First Name", style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(firstname),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditAccount(detail: "First Name", value: firstname, )));
            },
            trailing: Icon(Icons.chevron_right, color: Colors.grey,),

          ),
          ListTile(
            title: Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(lastname),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditAccount(detail: "Last Name", value: lastname,)));
            },
            trailing: Icon(Icons.chevron_right, color: Colors.grey,),
          ),

          ListTile(
            title: Text("Target", style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(targetText),
            onTap: () {
              // Navigate to target setting page
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditAccount(detail: "Monthly Target", value: user!.target,)));
            },
            trailing: Icon(Icons.chevron_right, color: Colors.grey,),

          ),

        ],
          ),
        ),
                  ),
      ),
    );
  }
}
