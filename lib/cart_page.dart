import 'dart:async';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/main.dart';
import 'CartProvider.dart';
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool toggle = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {
        toggle = !toggle; // Toggle the state every 2 seconds
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context).cart;
    return Scaffold(
      body: SafeArea(
        child: Column(//mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Text(
            "               Total Cart Value ${cart.fold(0.0, (previousValue, element) => previousValue + (element['price']))}",
              style: const TextStyle(fontSize: 25,fontFamily:'Quicksand',fontWeight: FontWeight.bold ),textAlign: TextAlign.center,),
            const SizedBox(height: 20,),
            cart.isEmpty? const Text("\n\n                Your Cart is Empty!",style: const TextStyle(fontSize: 25,fontFamily:'Quicksand',fontWeight: FontWeight.bold ),textAlign: TextAlign.center,)
            :Flexible(
              child: ListView.builder(
                  itemCount: cart.length,
                    itemBuilder: (context,index){
                    final cartitem=cart[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        child: ListTile(
                          shape: const StadiumBorder(),
                          tileColor: index.isEven? const Color.fromRGBO(216, 240, 253, 1): const Color.fromRGBO(245, 247, 249, 1),
                          leading: Card(
                            // elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50))
                            ),

                            child: Image(
                              image: AssetImage(cartitem["imageURL"]),
                              height:200,
                              width: 80,
                              fit: BoxFit.fitHeight ,
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(cartitem["title"] as String,maxLines: 1,
                            style: Theme.of(context).textTheme.titleMedium,),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Size: ${cartitem["Size"]}"),
                              const SizedBox(height: 5,),
                              AnimatedContainer(
                                duration: const Duration(seconds: 3),
                                curve: Curves.easeInCirc,
                                  height: toggle == true ? 20 : 23,
                                  width: toggle == true ? 45 : 90,
                                decoration: BoxDecoration(
                                  color: toggle? Colors.red: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child:Text("  ${cartitem["Deal"]}  ",style: const TextStyle(color: Colors.white),)
                              ),
                              // const SizedBox(height: 5,),
                              Text("\$${cartitem["price"]}",style: Theme.of(context).textTheme.titleMedium,)
                            ],
                          ),
                          trailing: IconButton(
                            color: Colors.purple,
                            splashColor: Colors.red,
                            splashRadius: 50,
                            onPressed: (){
                            // showDialog(context: context, builder: (context){
                            //   return Container(
                            //     child: AlertDialog(
                            //       actionsAlignment: MainAxisAlignment.center,
                            //       shape: const StadiumBorder(),
                            //       title: const Text('Delete Product',textAlign: TextAlign.center,style: TextStyle(fontFamily: "Quicksand",fontWeight: FontWeight.bold),),
                            //       content: const Text("Are you sure?",textAlign: TextAlign.center,style: TextStyle(fontFamily: "Quicksand",fontWeight: FontWeight.bold),),
                            //       actions: [ //buttons
                            //         TextButton(onPressed: (){
                            //           Navigator.of(context).pop();
                            //         },
                            //             child: const Text("NO",style: TextStyle(color: Colors.blueAccent),)),
                            //         TextButton(onPressed: (){
                            //           Provider.of<CartProvider>(context,listen: false).removeProduct(cartitem);
                            //           Navigator.of(context).pop();
                            //         },
                            //             child: const Text("YES",style: TextStyle(color: Colors.red,fontFamily: "Quicksand",fontWeight: FontWeight.bold),))
                            //       ],
                            //
                            //     ),
                            //   );
                            // }
                            // );
                               DelightToastBar(
                                 autoDismiss: true,
                                  snackbarDuration:const Duration(seconds: 5),
                                  builder: (context)=>ToastCard(
                                    trailing: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20) ,
                                        color: Colors.red,
                                      ),
                                      child:IconButton(
                                        color: Colors.purple,
                                        splashColor: Colors.red,
                                        splashRadius: 50,
                                        icon: Icon(Icons.delete_outline_outlined,color: Colors.white,),
                                        onPressed: (){
                                          Provider.of<CartProvider>(context,listen: false).removeProduct(cartitem);
                                          // DelightToastBar(
                                          //   builder: (context){
                                          //     return ToastCard(
                                          //         title:  const Text("Undo Your Bad Actions",style: TextStyle(
                                          //           fontWeight: FontWeight.bold,
                                          //           fontSize: 16,
                                          //           fontFamily: "Quicksand",
                                          //         ),),
                                          //     leading: Image(image: AssetImage(cartitem["imageURL"]),),
                                          //       trailing: FloatingActionButton(
                                          //         backgroundColor: Colors.amberAccent,
                                          //         shape: const StadiumBorder(),
                                          //         elevation: 0,
                                          //         onPressed: (){
                                          //           Provider.of<CartProvider>(context).cart.contains(cartitem)?Navigator.of(context).pop():Provider.of<CartProvider>(context,listen: false).addProduct(cartitem);
                                          //         },
                                          //         child: const Icon(Icons.undo),
                                          //       ),
                                          //     );
                                          //   }
                                          // ).show(context);

                                        },
                                      )
                                    ),
                                    leading: Image(image: AssetImage(cartitem["imageURL"]),),
                                      title: const Text("Are You Sure? You want to delete.",style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: "Quicksand",
                                      ),),


                                    )
                              ).show(context);
                          },
                            icon: Container(
                              height: double.infinity,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20) ,
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.delete_outline_outlined, color: Colors.redAccent,size: 25,)),
                        )
                        ),
                      ),
                    );
                    }),
            ),
          ],
        ),
      ),

    );
  }
}
