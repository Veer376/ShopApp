import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopapp/product_page.dart';
import 'productList.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String selectedfilter;
  final filters=const ['All', 'Nike','Puma','Adidas'];//List<String>

  final controller=TextEditingController();
  List<Map<String,dynamic>> searched=products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedfilter=filters[0];

  }
  void filter(String text){
    if(text.isEmpty) {
      searched=products;
      setState(() {});
    }
    else{
      searched=products.where((product)=> product["title"].toLowerCase().contains(text.toLowerCase())).toList();
      setState(() {

      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    const border=OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),topLeft: Radius.circular(50))
    );

    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Shoes \nCollection", style: Theme.of(context).textTheme.titleLarge),
              ),
              Expanded(
                child: TextField(
                  onChanged: filter,
                  decoration: const InputDecoration(hintText: "Search", prefixIcon: Icon(Icons.search),
                      enabledBorder: border,
                      focusedBorder: border
                  ),

                ),
              ),
            ],
          ),
          SizedBox(
            height: 120,
            // width: 100
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder:(context, index){
                final filter=filters[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedfilter = filter;
                      });
                    },
                    child: Chip(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                      backgroundColor: selectedfilter==filter? Theme.of(context).colorScheme.primary : Color.fromRGBO(245, 247, 249, 1),
                      // elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      side: const BorderSide(color: Color.fromRGBO(245, 247, 249, 1)),
                      label: Text(filter),
                      labelStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },

            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
                itemCount: searched.isEmpty?  1: searched.length,
                itemBuilder: (context, index){
                  if(searched.isEmpty) {
                    return AnimatedContainer(
                      curve: Curves.easeInCirc,
                      padding: const EdgeInsets.all(10),
                        duration:const Duration(milliseconds: 1000),
                        child: const Text("Abe Saale kya search kar rahe ho",
                          style: TextStyle(color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),));
                  }
                  else {
                    final product=searched[index];
                    return GestureDetector(
                      onTap: (){
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ProductPage(product: product);
                          }),
                        );
                      },
                      child: ProductCard(
                        title: product["title"] as String,
                        image: product["imageURL"] as String,
                        price: product["price"] as double ,
                        Deal: product["Deal"] as String,
                        background: index.isEven? const Color.fromRGBO(216, 240, 253, 1): const Color.fromRGBO(245, 247, 249, 1),
                    ),
                    );
              }
              }
            ),
          )
        ],
      ),
    );
  }
}
class ProductCard extends StatefulWidget {
  final String title;
  final String image;
  final double price;
  final Color background;
  final String Deal;
  const ProductCard({required this.title, required this.image,required this.price,required this.background,required this.Deal});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
    _timer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
      setState(() {
        toggle = !toggle; // Toggle the state every 2 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: widget.background),
      // color: const Color.fromRGBO(216, 240, 253,1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,style: Theme.of(context).textTheme.titleMedium,),
          AnimatedContainer(duration: const Duration(seconds: 2),
            curve: Curves.easeOutCirc,
            height: toggle ? 20 : 20,
              width: toggle?40:90,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)
              ),
              child:Text("  ${widget.Deal}  ",style: const TextStyle(color: Colors.white),),),
          Text("\$${widget.price}",style: Theme.of(context).textTheme.titleMedium,),
          Spacer(),
          Image(image: AssetImage(widget.image), height: 175,),
          Spacer(),
          AnimatedContainer(duration: const Duration(seconds: 4),
            curve: Curves.easeOutCirc,
            height: toggle ? 0:33,
            width: toggle?10:10,
            decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.circular(20)
            ),
            child: const Text(" ",style: TextStyle(color: Colors.white),),),

        ],
      ),


    );
  }
}
