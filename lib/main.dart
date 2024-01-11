
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/home.dart';
import 'package:shopapp/login.dart';
import 'CartProvider.dart';
import 'cart_page.dart';
void main() async{
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var currentpage=0;

  List<Widget> pages=[const Home(), const CartPage(), LoginPage()];


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
          home: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentpage,
                onTap: (value){
                  setState(() {
                    currentpage=value;
                  });
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
                  BottomNavigationBarItem(icon: Icon(Icons.perm_identity), label: "Login/SignUp"),
                ],
              ),
              // body: AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 250),
              //   child: pages[currentpage],
              //   transitionBuilder: (child, animation) {
              //     return FadeTransition(
              //       opacity: animation,
              //       child: SlideTransition(
              //         position: Tween<Offset>(
              //           begin: const Offset(0.0, 0.5),
              //           end: Offset.zero,
              //         ).animate(animation),
              //         child: child,
              //       ),
              //     );
              //   },
              // ),
            body: IndexedStack(
              index: currentpage,
              children: [
                Home(),
                CartPage(),
                LoginPage(),
              ],
            ),

          ),
          theme: ThemeData(
            appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontSize: 20,color: Colors.black,fontFamily: "Quicksand",fontWeight: FontWeight.bold)),
            // fontFamily: "Quicksand",
                colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color.fromRGBO(254, 206, 1, 1),
                  primary: const Color.fromRGBO(254, 206, 1, 1)
                ),

            inputDecorationTheme: const InputDecorationTheme(hintStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),
            prefixIconColor: Color.fromRGBO(119, 119, 119, 1),

            ),
            textTheme: const TextTheme(
                titleMedium: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontFamily: "Quicksand"),
                bodySmall: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                titleLarge: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, fontFamily: "Quicksand")
            ),

               useMaterial3: true
          ),
          debugShowCheckedModeBanner: false,

      ),
    );
  }
}



