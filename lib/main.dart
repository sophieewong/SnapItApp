import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
                    color: Color(0xff4A4A4A),
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
                    letterSpacing: 2.0,
                    color: Color(0xff4A4A4A),
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
    @override
    Widget build(BuildContext context) {
    // retrieving data from Firebase tutorial - https://www.youtube.com/watch?v=R12ks4yDpMM
    return StreamBuilder(
      stream: Firestore.instance.collection('product').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Text('Your outfit inspirations will be displayed here once they are uploaded.');
        }
        else {
          List<DocumentSnapshot> userInspo = snapshot.data.documents.where((outfitInspo) => outfitInspo['url'] == "").toList();
          if(userInspo.length > 0){
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: userInspo.length,
                itemBuilder: (context, index){
                  DocumentSnapshot myproduct = userInspo[index];
                  return Product(
                    product_id: myproduct.documentID,
                    product_pic_path: '${myproduct['imagePath']}',
                    product_pic: '${myproduct['image']}',
                    product_url: '${myproduct['url']}',
                    product_type: '${myproduct['clothing-item']}',
                    product_colour: '${myproduct['colour']}',
                    product_gender: '${myproduct['gender']}',
                  );
                }
            );
          }
          else {
            return Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffCAE8DC), //                   <--- border color
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      'You currently do not have any clothing snaps. Please upload you clothing inspirations on the camera tab below to find similar products.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          height: 1.5,
                          letterSpacing: 1.0,
                          color: Color(0xff4A4A4A),
                          fontFamily: 'JosefinSans'
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child:Icon(
                            Icons.arrow_downward,
                        size: 100,
                          color: Color(0xffCAE8DC),
                        )
                    )
                  ],
                ),
              )
            );
          }
        }
      },
    );
  }
}

class Product extends StatelessWidget {
  final product_pic;
  final product_pic_path;
  final product_id;
  final product_url;
  final product_type;
  final product_colour;
  final product_gender;

  Product({
    this.product_id,
    this.product_pic_path,
    this.product_pic,
    this.product_url,
    this.product_type,
    this.product_colour,
    this.product_gender
  });

  @override
  Widget build(BuildContext context) {
      return Card(
        child: Hero(
          tag: product_id,
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new SimilarProductsPage(
              product_id: product_id,
              product_pic_path: product_pic_path,
              product_pic: product_pic,
              product_type: product_type,
              product_colour: product_colour,
              product_gender: product_gender,
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

class ImageProperties {
  final path;
  final url;
  const ImageProperties(this.path, this.url);
}

class _CameraState extends State<Camera> {
  ImageProperties _image = null;
  String _similarProductDocumentID;
  String _gender = "female";
  String _clothingItem;
  String _clothingColour;

  Future getImage (bool isCamera) async {
    File image;

    if (isCamera) {
      // catch image from device's camera and store it in variable image
      image = await ImagePicker.pickImage(source: ImageSource.camera);

    } else {
      // pick an image from gallery to store it in variable image
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    // to upload images to Firebase Storage and load them via the network - https://medium.com/flutter-community/loading-image-from-firebase-storage-in-flutter-app-android-ios-web-1951607ec9ef
    await FirebaseStorage.instance.ref().child(image.path).putFile(image).onComplete;

    dynamic imageInTheCloud = await FirebaseStorage.instance.ref().child(image.path).getDownloadURL();

    setState(() {
      _image = new ImageProperties(image.path, imageInTheCloud);
    });
  }

  final formKey = new GlobalKey<FormState>();

  _searchProduct() {
    Firestore.instance.collection('product').document().setData({
      'clothing-item': _clothingItem,
      'colour' : _clothingColour,
      'gender' : _gender.toString(),
      'imagePath': _image.path,
      'image' : _image.url,
      'url' : '',
      'wishlist' : false,
      'product-name' : '',
      'product-price' : ''
    });
  }

  List<String> _clothingItems = <String>['Tops', 'Bottoms', 'Skirts', 'Dresses', 'Coats & Jackets', 'Jumpsuits', 'Sweatshirt & Hoodies'];
  List<String> _clothingColours = <String>['White', 'Black', 'Grey', 'Green', 'Yellow', 'Blue', 'Red', 'Orange', 'Cream', 'Brown', 'Camel', 'Pink', 'Purple', 'Burgundy'];


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
                              letterSpacing: 1.5,
                              color: Color(0xff4A4A4A),
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
                                    color: Color(0xff4A4A4A),
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
                      child: IconButton(icon: Icon(Icons.camera_alt),
                      onPressed: (){
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
                              letterSpacing: 1.0,
                              color: Color(0xff4A4A4A),
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
                                padding: EdgeInsets.only(left: 105),
                                child: Icon(Icons.mood_bad),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 7, 70, 5),
                                child: Text(
                                  "No image available.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 1.0,
                                      color: Color(0xff4A4A4A),
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
                            "Please upload or take a picture to find similar clothing items.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.0,
                                height: 1.75,
                                color: Color(0xff4A4A4A),
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
                      Image.network(_image.url, height: 400.0, width: 400.0,),
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
                                            color: Color(0xff4A4A4A),
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
                                        value: "female",
                                        groupValue: _gender,
                                        activeColor: Color(0xffCAE8DC),
                                        onChanged: (String value) {
                                          setState(() {
                                            _gender = value;
                                            _clothingItems = <String>['Tops', 'Bottoms', 'Skirts', 'Dresses', 'Coats & Jackets', 'Jumpsuits', 'Sweatshirt & Hoodies'];
                                            _clothingItem = _clothingItems[0];
                                          });
                                        }
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 65),
                                      child: Text(
                                        "Womens",
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                          color: Color(0xff4A4A4A),
                                          fontFamily: 'JosefinSans',
                                        ),
                                      ),
                                    ),
                                    Radio(
                                        value: "male",
                                        groupValue: _gender,
                                        activeColor: Color(0xffCAE8DC),
                                        onChanged: (String value) {
                                          setState(() {
                                            _gender = value;
                                            _clothingItems = <String>['Tops', 'Bottoms', 'Coats & Jackets', 'Sweatshirt & Hoodies'];
                                            _clothingItem = _clothingItems[0];
                                          });
                                        }
                                    ),
                                    Text(
                                      "Mens",
                                      style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.0,
                                          color: Color(0xff4A4A4A),
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
                                              color: Color(0xff4A4A4A),
                                              fontFamily: 'JosefinSans'
                                          ),
                                        ),
                                        style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.0,
                                            color: Color(0xff4A4A4A),
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
                              // Clothing colour dropdown
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

                              //
                              // COLOUR dropdown
                              //
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
                                              color: Color(0xff4A4A4A),
                                              fontFamily: 'JosefinSans'
                                          ),
                                        ),
                                        style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 1.0,
                                            color: Color(0xff4A4A4A),
                                            fontFamily: 'JosefinSans'
                                        ),
                                        onChanged: (String selectedColour) {
                                          setState(() {
                                            _clothingColour = selectedColour;
                                          });
                                        },
                                        value: _clothingColour,
                                        items: _clothingColours.map<DropdownMenuItem<String>>((String colour) {
                                          return DropdownMenuItem<String>(
                                            value: colour,
                                            child: Text(colour),
                                          );
                                        }).toList()
                                    ),
                                  ],
                                ),
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
                                  onPressed: () => {
                                    _searchProduct(),
                                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new SimilarProductsPage(
                                      product_id: "",
                                      product_pic: _image.url,
                                      product_pic_path: _image.path,
                                      product_type: _clothingItem,
                                      product_colour: _clothingColour,
                                      product_gender: _gender.toString(),
                                    ),)).then((value) =>
                                      setState(() {
                                        _image = null;
                                        _gender = "female";
                                        _clothingColour = null;
                                        _clothingItem = null;
                                      })
                                    ),
                                  }
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
  final product_pic_path;
  final product_id;
  final product_type;
  final product_colour;
  final product_gender;

  SimilarProductsPage({
    this.product_pic,
    this.product_pic_path,
    this.product_id,
    this.product_type,
    this.product_colour,
    this.product_gender
  });

  @override
  _SimilarProductsPageState createState() => _SimilarProductsPageState();
}

class _SimilarProductsPageState extends State<SimilarProductsPage> {
  // url launcher taken from flutter docs - https://pub.dev/packages/url_launcher#-readme-tab-
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _deleteUpload() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(
                "Delete uploaded image?",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0,
                    color: Color(0xff000000),
                    fontFamily: 'JosefinSans'
                )),
            content: new Text(
                "This image will be permanently deleted. This cannot be recovered once deleted.",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.0,
                    color: Color(0xff000000),
                    fontFamily: 'JosefinSans'
                )),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog

              new FlatButton(
                child: new Text(
                    "Cancel",
                  style: TextStyle(
                    color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.0,
                      fontFamily: 'JosefinSans',
                  ),
                ),
                onPressed: () => {
                  Navigator.of(context, rootNavigator: true).pop('dialog')
                },
              ),
              new Container(
                color: Colors.red,
                child: new FlatButton(
                  child: new Text(
                    "Delete",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.0,
                      fontFamily: 'JosefinSans',
                      color: Colors.white,
                    ),),
                  onPressed: () => {
                    FirebaseStorage.instance.ref().child(widget.product_pic_path).delete(),
                    Firestore.instance.collection('product').where("imagePath", isEqualTo: widget.product_pic_path).snapshots().listen((data) => {
                      data.documents.forEach((doc) => Firestore.instance.collection('product').document(doc.documentID).delete()),
                      Navigator.of(context, rootNavigator: true).pop('dialog')
                    })
                  },
                ),
              ),
            ],
          );
  });}


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
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.grey,
                      size: 32,
                    ),
                    onPressed: () => {
                      _deleteUpload()
                    })
              ]
          )),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 250,
            child: GridTile(
                child: Container(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  color: Colors.white,
                  child: Image.network(widget.product_pic)
                )
            ),
          ),

          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            transform: Matrix4.rotationZ(-0.065),
            child: Text(
              " Now snap up! ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 2.0,
                  color: Color(0xff4A4A4A),
                  fontFamily: 'Pacifico',
                  backgroundColor: Color(0xffFCF6E6)
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Text(
              "Similar Products",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  //fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Color(0xff4A4A4A),
                  fontFamily: 'JosefinSans'
              ),
            ),
          ),

          Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('product').snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Text('No similar products are currently available, but please do check back with us soon.');
                  }
                  else {
                    List<DocumentSnapshot> similarProducts = snapshot.data.documents.where(
                    (similarProduct) => similarProduct['url'] != ""
                    && similarProduct['clothing-item'] == widget.product_type
                    && similarProduct['colour'] == widget.product_colour
                    && similarProduct['gender'] == widget.product_gender).toList();

                    // to create custom height of GridView widget - https://stackoverflow.com/questions/48405123/how-to-set-custom-height-for-widget-in-gridview-in-flutter
                    var size = MediaQuery.of(context).size;

                    /*24 is for notification bar on Android*/
                    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
                    final double itemWidth = size.width / 2;

                    if ( similarProducts.length > 0){
                      return SizedBox(
                          height: 450,
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: (itemWidth / itemHeight)),
                              itemCount: similarProducts.length,
                              itemBuilder: (context, index){
                                DocumentSnapshot myproduct = similarProducts[index];
                                return similarProduct(
                                    product: myproduct,
                                    similar_product_pic: '${myproduct['image']}',
                                    similar_product_pic_path: '${myproduct['imagePath']}',
                                    similar_product_url: '${myproduct['url']}',
                                    similar_product_name:'${myproduct['product-name']}',
                                    similar_product_price:'${myproduct['product-price']}',
                                    similar_product_fav: '${myproduct['wishlist']}'
                                );
                              }
                          )
                      );
                    }
                    else {
                      return Padding(
                          padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(30.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffCAE8DC),
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Unfortunately, there arent any similar products currently available, but please do check up on us every now & then!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      height: 1.5,
                                      letterSpacing: 1.0,
                                      color: Color(0xff4A4A4A),
                                      fontFamily: 'JosefinSans'
                                  ),
                                )
                              ],
                            ),
                          )
                      );
                    }
                  }
                },
              )
          )
        ],
      ),
    );
  }
}

class similarProduct extends StatelessWidget {
  final product;
  final similar_product_pic;
  final similar_product_url;
  final similar_product_name;
  final similar_product_price;
  final similar_product_fav;
  final similar_product_pic_path;

  similarProduct({this.product, this.similar_product_name, this.similar_product_price, this.similar_product_pic, this.similar_product_url, this.similar_product_fav, this.similar_product_pic_path});

// url launcher taken from flutter docs - https://pub.dev/packages/url_launcher#-readme-tab-
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

@override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
          child: InkWell(
            child: GridTile(
              child: Image.network(similar_product_pic, fit: BoxFit.cover),
              footer: Container(
                color: Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                      similar_product_name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.0,
                          color: Color(0xff000000),
                          fontFamily: 'JosefinSans'
                      )),
                  subtitle: Text(
                    '£' + similar_product_price,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                        color: Color(0xff898989),
                        fontFamily: 'JosefinSans'
                    ),
                  ),
                  trailing:
                  similar_product_fav == "true" ?
                  IconButton(
                      icon: Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                          size: 32),
                      onPressed: () => {
                        // updating wishlist using tutorial from - https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#10
                        Firestore.instance.collection('product').document(product.documentID).updateData({'wishlist': false})
                      }
                  ) :
                  IconButton(
                      icon: Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                          size: 32),
                      onPressed: () => {
                        Firestore.instance.collection('product').document(product.documentID)
                            .updateData({'wishlist': true})
                      }
                  ),
                ),
              ),
            ),
            onTap: () => _launchURL(similar_product_url),
          ),
      )
    );
  }
}





///                 ////
///  WISHLIST PAGE ////
///                ////
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
                    color: Color(0xff4A4A4A),
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

// taken from Flutter tutorial Grid View - https://www.youtube.com/watch?v=W6CbCklJFi4
class wishlistProducts extends StatefulWidget {
  @override
  _wishlistProductsState createState() => _wishlistProductsState();
}

class _wishlistProductsState extends State<wishlistProducts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('product').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Text('Your wishlist items will be displayed here.');
        }
        else {
          List<DocumentSnapshot> userWishlist = snapshot.data.documents.where((similarProduct) => similarProduct['wishlist'] == true && similarProduct['url'] != "").toList();

          if (userWishlist.length > 0) {
            return ListView.builder(
                itemCount: userWishlist.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot myproduct = userWishlist[index];
                  return wishlistProduct(
                    product: myproduct,
                    wishlist_product_name: '${myproduct['product-name']}'
                        .toString(),
                    wishlist_product_price: '${myproduct['product-price']}',
                    wishlist_product_pic: '${myproduct['image']}',
                    wishlist_product_pic_path: '${myproduct['imagePath']}',
                    wishlist_product_link: '${myproduct['url']}',
                  );
                }
            );
          }
          else{
            return

              Padding(
                  padding: EdgeInsets.fromLTRB(50, 100, 50, 250),
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffCAE8DC),
                        width: 2.0,
                      ),
                    ),
                    child: Text(
                      'You currently do not have anything in your wishlist. Tap the heart on similar products to add your favourite products to your wishlist.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          height: 1.5,
                          letterSpacing: 1.0,
                          color: Color(0xff4A4A4A),
                          fontFamily: 'JosefinSans'
                      ),
                    )
                  )
              );
          }
        }
      },
    );
  }
}

class wishlistProduct extends StatelessWidget {
  final product;
  final wishlist_product_name;
  final wishlist_product_price;
  final wishlist_product_pic;
  final wishlist_product_pic_path;
  final wishlist_product_link;

  wishlistProduct({this.product, this.wishlist_product_name, this.wishlist_product_price, this.wishlist_product_pic, this.wishlist_product_link, this.wishlist_product_pic_path});

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
                                "£" + wishlist_product_price,
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
                        onPressed: () => {
                        Firestore.instance.collection('product').document(product.documentID).updateData({'wishlist': false})}
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


