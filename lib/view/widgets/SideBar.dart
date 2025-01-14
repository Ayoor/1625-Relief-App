import 'package:flutter/material.dart';


class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back,
                      size: 25, color: Colors.purple),
                ),
                Center(
                  child: Image.asset(
                    "lib/assets/1625_logo.png",
                    width: 150,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search, color: Colors.purple,),
            title: const Text('IMEI Search'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const ImeiSearch()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.mobile_screen_share_rounded, color: Colors.purple,),
            title: const Text('Device Search'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const DeviceNameSearch()));
            },
          ),

          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text("Useful Documents", style: TextStyle(fontSize: 22, color: Colors.grey[600]),),
          ),
            const SizedBox(height: 10,),

          ListTile(
            leading: const Icon(Icons.library_books, color: Colors.purple,),
            title: const Text('Guide for Android'),
            onTap: () {
              Navigator.pop(context);

              String doc = 'lib/Assets/Documents/Android_guide.pdf';
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>  Documents(doc: doc)));
            },
          ),

          ListTile(
            leading: const Icon(Icons.library_books, color: Colors.purple,),
            title: const Text('Guide for IOS'),
            onTap: () {
              Navigator.pop(context);

              String doc = 'lib/Assets/Documents/IOS_guide.pdf';
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>  Documents(doc: doc)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books, color: Colors.purple,),
            title: const Text('Cyber Glossary'),
            onTap: () {
              Navigator.pop(context);

              String doc ='lib/Assets/Documents/Cyber.pdf';
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>  Documents(doc: doc)));
            },
          ),
                   const Spacer(),
          const Center(
            child: Text(
              "Developed by Ayodele Oduola", textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.pinkAccent, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),  SizedBox(height: 30,) ,       // Pushes the version number to the bottom
          Center(
            child: Text(
              "Version: 1.0.0",
              style: TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 70,)
        ],
      ),
    );
  }
}
