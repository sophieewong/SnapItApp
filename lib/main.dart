import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

        home:DefaultTabController(
          length: 3,
          child: new Scaffold(
//            appBar: AppBar(
//              title: Text("Bottom Nav Example"),
//              centerTitle: true,
//              backgroundColor: Colors.green,
//            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Home(),
                Camera(),
                Wishlist(),
              ],
            ),
            //Bottom Navigation
            bottomNavigationBar: new TabBar(

              labelColor: Colors.black87,
                unselectedLabelColor: Colors.grey[300],
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.all(5.0),
                indicatorColor: Colors.white,
              tabs:[
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.camera_alt),
                  text: 'Snap It!',
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: 'Wishlist',
                ),
              ],
            ),
          ),
        )
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Positioned (
              top: 4.0,
              child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/SnapIt-logo.png',
                  height: 125,
                  width: 125,
                ),
              ),
            ),),


            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
              transform: Matrix4.rotationZ(-0.065),
              child: Text(
                " Snap it to snap up! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 2.0,
                    color: Color(0xff878787),
                    fontFamily: 'Pacifico',
                    backgroundColor: Color(0xffFCF6E6)
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Text(
                "My Fashion Snaps",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Color(0xff878787),
                    fontFamily: 'JosefinSans'
                ),
              ),
            ),

            Expanded(child: Products()),

          ],
        ),
        ),
      );
  }
}

// taken from Flutter tutorial Grid View - https://www.youtube.com/watch?v=W6CbCklJFi4
class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final list_item = [
    {"id": "1", "link":"https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"},
    {"id": "2", "link":"https://media.thereformation.com/image/upload/q_auto:eco/c_scale,w_auto:breakpoints_100_1920_9_20:544/v1/prod/media/W1siZiIsIjIwMjAvMDIvMTkvMTMvMjkvMzgvYjlmMWY3N2UtOTVhOC00OTNmLWI0YWYtY2IwMTk2YjhmOWMzL0dSQU5UX0RSRVNTX09MWU1QSUEuanBnIl1d/GRANT_DRESS_OLYMPIA.jpg",},
    {"id": "3", "link":"https://res.cloudinary.com/fashionasalifestyle/image/upload/f_auto/v1527700782/casual%20summer%20outfits.jpg"},
    {"id": "4", "link":"https://d28m5bx785ox17.cloudfront.net/v1/img/QbP3xMAG6xMILW8msRI29Cg8u1mw97z8SYfdYhn86Fg=/sc/600x600?spatialTags=0.341035:0.592721"},
    {"id": "5", "link":"https://cdn.cliqueinc.com/posts/259064/easy-90s-outfits-259064-1527621668761-main.700x0c.jpg"},
    {"id": "6", "link":"https://cdd72c8b8a55fc5d1857-2b8f511b412f8d2bfde37b6dde2e2425.lmsin.net/Max/MX2/Pre%20Landing%20Page/menPLDESKTOP.jpg"},
    {"id": "7", "link":"https://cdn.cliqueinc.com/posts/282188/london-autumn-fashion-trends-282188-1567115968335-image.700x0c.jpg"},
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: list_item.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index){
          return Product(
            product_id: list_item[index]['id'],
            product_pic: list_item[index]['link'],
          );
        });
  }
}

class Product extends StatelessWidget {
  final product_pic;
  final product_id;

  Product({this.product_id, this.product_pic});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: product_id,
          child: Material(
            child: InkWell(
              onTap: (){},
              child: GridTile(
                child: Image.network(product_pic, fit: BoxFit.cover),
              ),
            ),
          )),
    );
  }
}

//tutorial from - https://www.youtube.com/watch?v=LAhiqRzbx8M
class Camera extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CameraState();
  }
}

class _CameraState extends State<Camera> {
  File _image;

  Future getImage (bool isCamera) async {
    File image;

    if (isCamera) {
      // catch image from device's camera and store it in variable image
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      // pick an image from gallery to store it in variable image
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;
    });
  }

    @override
    Widget build (BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 15, 30, 5),
                      child: Text(
                        "Snap It!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: Color(0xff000000),
                            fontFamily: 'Pacifico'
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(57, 10, 57, 15),
                        child: Text(
                          "Snap a picture of the outfit!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              //fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Color(0xff878787),
                              fontFamily: 'JosefinSans'
                          ),
                        ),),
                    ],
                  ),
                ),

                Row (
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 70),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(width: 1, color: Colors.black87)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: IconButton(icon: Icon(Icons.add_photo_alternate),
                              onPressed: () {
                                getImage(false);
                              },
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 30, 5),
                            child: GestureDetector (
                              child: Text(
                                "Upload",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1.0,
                                    color: Color(0xff878787),
                                    fontFamily: 'JosefinSans'
                                ),
                              ),
                              onTap: () {
                                getImage(false);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                      child: IconButton(icon: Icon(Icons.camera_alt), onPressed: (){
                        getImage(true);
                      },
                    ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 10, 5),

                      child: GestureDetector (
                        child: Text(
                          "Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              //fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: Color(0xff878787),
                              fontFamily: 'JosefinSans'
                          ),
                        ),
                        onTap: () {
                          getImage(true);
                        },
                      ),
                    ),
                  ],
                ),
                _image == null ? Container(
                  child: Align(
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 100),

                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 80),
                                child: IconButton(icon: Icon(Icons.mood_bad),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 7, 70, 5),
                                child: Text(
                                  "No image available.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 1.0,
                                      color: Color(0xff878787),
                                      fontFamily: 'JosefinSans'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(75, 10, 75, 5),
                          child: Text(
                            "Please upload or take a picture.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.0,
                                color: Color(0xff878787),
                                fontFamily: 'JosefinSans'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ) : Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Image.file(_image, height: 400.0, width: 400.0,),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Snap it!"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}

class Wishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Text("Wishlist Page"),
      ),
    );
  }
}
