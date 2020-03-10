import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

        home:DefaultTabController(
          length: 3,
          child: new Scaffold(
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


///           ////
/// HOME PAGE ////
///           ////

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
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new SimilarProductsPage(
                product_id: product_id,
                product_pic: product_pic,
              ))),
              child: GridTile(
                child: Image.network(product_pic, fit: BoxFit.cover),
              ),
            ),
          )),
    );
  }
}


///             ////
/// CAMERA PAGE ////
///             ////

//tutorial from - https://www.youtube.com/watch?v=LAhiqRzbx8M
class Camera extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CameraState();
  }
}

enum Gender {female, male}

class _CameraState extends State<Camera> {
  File _image;
  Gender _gender = Gender.female;
  String _clothingItem;

  bool whiteVal = false;
  bool blackVal = false;
  bool greyVal = false;
  bool blueVal = false;
  bool redVal = false;
  bool greenVal = false;
  bool orangeVal = false;
  bool yellowVal = false;

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

//  Future uploadInspoOutfit(BuildContext context) async{
//    String filName=basename(_image.path);
//    StorageReference firebaseStorageRef=firebaseStorage.instance.ref().child(filName);
//    StorageUploadTask uploadTask=firebaseStorageRef.putFile(_image);
//    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//    setState(() {
//      //TODO: goes to similar product page
//    });
//  }

  final formKey = new GlobalKey<FormState>();

  _searchProduct() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        //_similarProductResult = _product; // _product to be an object of product details
      });
    }
  }

  //
  // COLOUR CHECKBOX WIDGET
  //
  Widget checkbox (bool boolValue, String colour) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: boolValue,
          activeColor: Color(0xffCAE8DC),
          onChanged: (bool value) {
            setState(() {
              switch (colour) {
                case "White":
                  whiteVal = value;
                  break;
                case "Black":
                  blackVal = value;
                  break;
                case "Grey":
                  greyVal = value;
                  break;
                case "Blue":
                  blueVal = value;
                  break;
                case "Red":
                  redVal = value;
                  break;
                case "Green":
                  greenVal = value;
                  break;
                case "Orange":
                  orangeVal = value;
                  break;
                case "Yellow":
                  yellowVal = value;
                  break;
              }
            });
          },
        ),
        Text(
            colour,
          style: TextStyle(
              fontSize: 16,
              letterSpacing: 1.0,
              color: Color(0xff878787),
              fontFamily: 'JosefinSans'
          ),)
      ],
    );
  }

  List<String> _clothingItems = <String>['Tops', 'Bottoms', 'Skirts', 'Dresses', 'Coats & Jackets', 'Jumpsuits'];


    @override
    Widget build (BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          padding: EdgeInsets.fromLTRB(75, 10, 75, 100),
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
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    children: <Widget>[
                      Image.file(_image, height: 400.0, width: 400.0,),
                      Form(
                        key: formKey,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 30, 0, 15),
                                      child: Text(
                                        "Describe Your Outfit",
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
                                  ],
                                ),
                              ),

                              //
                              // Gender Radio Buttons
                              //
                              Padding(
                                padding: EdgeInsets.fromLTRB(75, 30, 0, 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Gender",
                                      style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                          color: Color(0xff000000),
                                          fontFamily: 'JosefinSans'
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Radio(
                                        value: Gender.female,
                                        groupValue: _gender,
                                        activeColor: Color(0xffCAE8DC),
                                        onChanged: (Gender value) {
                                          setState(() {
                                            _gender = value;

                                            _clothingItems = <String>['Tops', 'Bottoms', 'Skirts', 'Dresses', 'Coats & Jackets', 'Jumpsuits'];
                                            _clothingItem = _clothingItems[0];
                                          });
                                        }
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 65),
                                      child: Text(
                                        "Female",
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                          color: Color(0xff878787),
                                          fontFamily: 'JosefinSans',
                                        ),
                                      ),
                                    ),

                                    Radio(
                                        value: Gender.male,
                                        groupValue: _gender,
                                        activeColor: Color(0xffCAE8DC),
                                        onChanged: (Gender value) {
                                          setState(() {
                                            _gender = value;

                                            _clothingItems = <String>['Tops', 'Bottoms', 'Coats & Jackets'];

                                            //Potenital
                                            //If _clothingItem is in _clothingItems don't do anything
                                            //If not sett _clothingitem to _clothingItems[0]

                                            _clothingItem = _clothingItems[0];
                                          });
                                        }
                                    ),

                                    Text(
                                      "Male",
                                      style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                          color: Color(0xff878787),
                                          fontFamily: 'JosefinSans'
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //
                              // Clothing dropdown Button
                              //
                              Padding(
                                padding: EdgeInsets.fromLTRB(75, 30, 0, 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Clothing Item",
                                      style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                          color: Color(0xff000000),
                                          fontFamily: 'JosefinSans'
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //Drop Down List referred from - https://api.flutter.dev/flutter/material/DropdownButton-class.html
                              Padding(
                                padding: EdgeInsets.fromLTRB(90, 0, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    DropdownButton<String>(
                                        hint: Text(
                                          "Select....",
                                          style: TextStyle(
                                              fontSize: 16,
                                              letterSpacing: 1.0,
                                              color: Color(0xff878787),
                                              fontFamily: 'JosefinSans'
                                          ),
                                        ),
                                        style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.0,
                                            color: Color(0xff878787),
                                            fontFamily: 'JosefinSans'
                                        ),
                                        onChanged: (String value) {
                                          setState(() {
                                            _clothingItem = value;
                                          });
                                        },
                                        value: _clothingItem,

                                        items: _clothingItems.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList()
                                    ),
                                  ],
                                ),
                              ),

                              //
                              // Clothing colour checkbox
                              //
                              Padding(
                                padding: EdgeInsets.fromLTRB(75, 30, 0, 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Colour",
                                      style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                          color: Color(0xff000000),
                                          fontFamily: 'JosefinSans'
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // checkbox tutorial taken from - https://medium.com/@azpm95/dynamic-checkbox-widgets-in-flutter-29973504c410
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      checkbox(whiteVal, "White"),
                                      checkbox(blueVal, "Blue"),
                                      checkbox(redVal, "Red"),
                                      checkbox(blackVal, "Black"),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      checkbox(greenVal, "Green"),
                                      checkbox(orangeVal, "Orange"),
                                      checkbox(yellowVal, "Yellow"),
                                      checkbox(greyVal, "Grey"),
                                    ],
                                  ),
                                ],
                              ),

                              Container(
                                padding: EdgeInsets.all(40),

                                child: RaisedButton(
                                  child: Text('Search',
                                  style: TextStyle(
                                      fontSize: 24,
                                      letterSpacing: 1.0,
                                      color: Color(0xff000000),
                                      fontFamily: 'JosefinSans'
                                  ),),
                                  color: Color(0xffCAE8DC),
                                  padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
                                  onPressed: () {
                                    //uploadInspoOutfit(context);
                                    _searchProduct;
                                    },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      );
    }
  }

///                       ////
/// SIMILAR PRODUCT PAGE ////
///                     ////

// Product Page widget following tutorial from Santos Enoque - https://www.youtube.com/watch?v=4DxEgh39aHg&list=PLmnT6naTGy2SC82FMSCrvZNogg5T1H7iF&index=16
class SimilarProductsPage extends StatefulWidget {
  final product_pic;
  final product_id;

  SimilarProductsPage({
    this.product_pic,
    this.product_id
  });

  @override
  _SimilarProductsPageState createState() => _SimilarProductsPageState();
}

class _SimilarProductsPageState extends State<SimilarProductsPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: new IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 32,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  }),
              title: new Text(
                "Snap It!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: Color(0xff000000),
                    fontFamily: 'Pacifico'
                ),
              )
          )),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300,
            child: GridTile(
                child: Container(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  color: Colors.white,
                  child: Image.network(widget.product_pic)
                )
            ),
          ),
        ],
      ),
    );
  }
}

///                 ////
///  WISHLIST PAGE ////
///                ////

// taken from Flutter tutorial Grid View - https://www.youtube.com/watch?v=W6CbCklJFi4
class wishlistProducts extends StatefulWidget {
  @override
  _wishlistProductsState createState() => _wishlistProductsState();
}

class _wishlistProductsState extends State<wishlistProducts> {
  final wishlist_item = [
    {"id": "1", "productName": "product title 1 product title 1 product title 1 product title 1product title 1 product title 1", "price":"£150.00", "link":"https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"},
    {"id": "2", "productName": "Gianni Feraud Tailored coat-Blue - ASOS Outlet", "price":"£250.00", "link":"https://media.thereformation.com/image/upload/q_auto:eco/c_scale,w_auto:breakpoints_100_1920_9_20:544/v1/prod/media/W1siZiIsIjIwMjAvMDIvMTkvMTMvMjkvMzgvYjlmMWY3N2UtOTVhOC00OTNmLWI0YWYtY2IwMTk2YjhmOWMzL0dSQU5UX0RSRVNTX09MWU1QSUEuanBnIl1d/GRANT_DRESS_OLYMPIA.jpg",},
    {"id": "3", "productName": "product title 3", "price":"£300.00", "link":"https://res.cloudinary.com/fashionasalifestyle/image/upload/f_auto/v1527700782/casual%20summer%20outfits.jpg"},
    {"id": "4", "productName": "product title 4", "price":"£750.00", "link":"https://d28m5bx785ox17.cloudfront.net/v1/img/QbP3xMAG6xMILW8msRI29Cg8u1mw97z8SYfdYhn86Fg=/sc/600x600?spatialTags=0.341035:0.592721"},
    {"id": "5", "productName": "product title 5", "price":"£450.00", "link":"https://cdn.cliqueinc.com/posts/259064/easy-90s-outfits-259064-1527621668761-main.700x0c.jpg"},
    {"id": "6", "productName": "product title 6", "price":"£550.00", "link":"https://cdd72c8b8a55fc5d1857-2b8f511b412f8d2bfde37b6dde2e2425.lmsin.net/Max/MX2/Pre%20Landing%20Page/menPLDESKTOP.jpg"},
    {"id": "7", "productName": "product title 7", "price":"£50.00", "link":"https://cdn.cliqueinc.com/posts/282188/london-autumn-fashion-trends-282188-1567115968335-image.700x0c.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: wishlist_item.length,
    itemBuilder: (BuildContext context, int index){
      return wishlistProduct(
        wishlist_product_id: wishlist_item[index]['id'],
        wishlist_product_name: wishlist_item[index]['productName'].toString(),
        wishlist_product_price: wishlist_item[index]['price'].toString(),
        wishlist_product_pic: wishlist_item[index]['link'],
        wishlist_product_link: wishlist_item[index]['link'],
      );
    });
  }
}

class wishlistProduct extends StatelessWidget {
  final wishlist_product_id;
  final wishlist_product_name;
  final wishlist_product_price;
  final wishlist_product_pic;
  final wishlist_product_link;

  wishlistProduct({this.wishlist_product_id, this.wishlist_product_name, this.wishlist_product_price, this.wishlist_product_pic, this.wishlist_product_link});

// url launcher taken from flutter docs - https://pub.dev/packages/url_launcher#-readme-tab-
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

// Product List inspired by - https://github.com/IshanFx/flutter-listview/blob/master/lib/main.dart
  @override
  Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
    child: Card (
      elevation: 5,
      child: Center(
        child: Container(
            height: 150,
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Container(
                    height: 150,
                    width: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          topLeft: Radius.circular(5)
                      ),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(wishlist_product_pic)
                      ),
                    ),
                  ),
                  onTap: () => _launchURL(wishlist_product_link),
                ),
                InkWell(
                  child: Container(
                    height: 150,
                    width: 170,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              wishlist_product_name,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                color: Color(0xff000000),
                                fontFamily: 'JosefinSans'
                              ),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 3),
                            child: Container(
                              width: 150,
                              child: Text(
                                  wishlist_product_price,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                      color: Color(0xff898989),
                                      fontFamily: 'JosefinSans'
                                  ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () => _launchURL(wishlist_product_link),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                              Icons.favorite,
                          color: Colors.redAccent,
                          size: 32),
                          onPressed: (){}
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    ),
  );
  }
}

class Wishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 45, 0, 5),
              child: Text(
                "Wishlist",
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
          ),
          Expanded(child: wishlistProducts())
        ],
      ),
      );
  }
}
