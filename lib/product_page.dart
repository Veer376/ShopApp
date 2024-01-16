import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/CartProvider.dart';
import  'package:delightful_toast/delight_toast.dart';
import 'package:shopapp/cart_page.dart';
import 'dart:async';


class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key,required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
 int selectedSize=0;
 Color selectedColor=Colors.white;
 Timer? _timer;
 bool toggle = false;

 List<Color> colorOptions=[
   Colors.redAccent,
   Colors.lightGreenAccent,
   Colors.lightBlueAccent,
   Colors.greenAccent,
   Colors.black26,
   Colors.white
 ];


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
   _timer = Timer.periodic(Duration(milliseconds: 1200), (timer) {
     setState(() {
       toggle = !toggle; // Toggle the state every 2 seconds
     });
   });
 }


 @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Details"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(widget.product["title"] as String, style: Theme.of(context).textTheme.titleLarge,),
            ),//product title
            AnimatedContainer(
              margin: const EdgeInsets.only(left: 15),
                padding: const EdgeInsets.only(left: 2),
                duration: const Duration(seconds: 2),
                curve: Curves.bounceIn,
                height: toggle == true ? 20 : 20,
                width: toggle == true ? 45 : 90,
                decoration: BoxDecoration(
                  color: toggle? Colors.red: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(widget.product["Deal"] as String,style: TextStyle(color: Colors.white),)
            ),
            const Spacer(
              flex: 5,
            ),
            ColorFiltered(
                colorFilter: ColorFilter.mode(selectedColor, BlendMode.modulate),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      toggle=false;
                    });
                    _timer?.cancel();
                  },
                    child: Image.asset(widget.product["imageURL"] as String))),
            // const Spacer(),
            const Spacer(
              flex: 1,
            ),
            AnimatedContainer(
                margin: const EdgeInsets.only(left: 15),
                padding: const EdgeInsets.only(left: 2),
                duration: const Duration(milliseconds:4000),
                curve: Curves.fastEaseInToSlowEaseOut,
                height: toggle == true ? 0:80,
                // width: toggle == true ? 45 : 90,
                decoration: const BoxDecoration(
                  // color: Colors.red,
                ),
                child: const Text("-",style: TextStyle(color: Colors.white),)
            ),
           // const Padding(
           //   padding: EdgeInsets.only(left: 10),
           //   child: Icon(Icons.invert_colors_on ,size: 25,),
           // ),
           Padding(
             padding: const EdgeInsets.only(left: 10,bottom: 8),
             child: SizedBox(
               height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: colorOptions.length,
                    itemBuilder: (context,index){
                    final color=colorOptions[index];
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedColor=color;
                        });
                      },
                      child: Container(
                        width: 27,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0
                          )
                        ),
                      ),
                    );
                    }
                ),
              ),
           ),
            Container(
             height: 230,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 247,  249, 1),
                borderRadius: BorderRadius.circular(40)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("\$ ${widget.product["price"]}",style: Theme.of(context).textTheme.titleLarge,),
                 const SizedBox(height: 8,),
                 const Text("Size Uk/India",style: TextStyle(fontFamily: "Quicksand",fontSize: 15,fontWeight: FontWeight.w500),),
                  const SizedBox(height: 8,),
                  SizedBox(

                    height: 50,
                    width: 250,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: (widget.product["Size"] as List<int>).length,
                        itemBuilder: (context, index){
                        final size=(widget.product["Size"] as List<int>)[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 15,bottom: 10,top: 5),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedSize==0?selectedSize=size:selectedSize=0;
                              });
                            },
                            child: Chip(
                              shape: StadiumBorder(),
                              backgroundColor: selectedSize==size? Theme.of(context).primaryColor :Colors.white,
                              label: Text(size.toString()),
                            ),
                          ),
                        );
                        }
                        ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,bottom: 8,top: 8),
                    child: ElevatedButton.icon(
                        onPressed: (){
                          if(selectedSize!=0){ //condition of size
                          Provider.of<CartProvider> (context,listen: false).addProduct({
                            "id":widget.product["id"],
                            "company": widget.product["company"],
                            "title": widget.product["title"],
                            'Size': selectedSize,
                            'price': widget.product["price"],
                            'imageURL': widget.product["imageURL"],
                            'Deal': widget.product["Deal"]
                          });
                          DelightToastBar(
                            autoDismiss: true,
                            snackbarDuration: const Duration(seconds: 2),
                            builder: (context) =>  ToastCard(
                              trailing: FloatingActionButton(
                                backgroundColor: Colors.transparent,
                                shape: StadiumBorder(),
                                elevation: 0,
                                onPressed: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartPage()));
                                },
                                child:Image.asset("assets/images/icons8-buying.gif"),
                              ),
                              leading: Image.asset(widget.product["imageURL"]),
                              title: const Text(
                                "Product Added to Cart ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ).show(context);
                          } else {
                            DelightToastBar(
                              autoDismiss: true,
                              snackbarDuration: const Duration(seconds: 1),
                              builder: (context) =>
                              ToastCard(
                                leading: Stack(
                                  children: [
                                    Image.asset(widget.product["imageURL"],color: Colors.black,),
                                    Icon(Icons.not_interested,size: 35,color: Colors.red,)
                                  ],
                                ),
                                title: const Text(
                                  "Abe Saale! Size to Select kar",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ).show(context);
                          }

                          },
                        icon: const Icon(Icons.shopping_cart, color: Colors.black,),
                        label:const Text("Add to Cart", style: TextStyle(color: Colors.black, fontSize: 18),),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        ),
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}


