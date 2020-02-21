import 'package:flutter/material.dart';

void main() => runApp(MyApp());

//final list_item = [
//  {"id": "1", "link":"https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"},
//  {"id": "2", "link":"https://media.thereformation.com/image/upload/q_auto:eco/c_scale,w_auto:breakpoints_100_1920_9_20:544/v1/prod/media/W1siZiIsIjIwMjAvMDIvMTkvMTMvMjkvMzgvYjlmMWY3N2UtOTVhOC00OTNmLWI0YWYtY2IwMTk2YjhmOWMzL0dSQU5UX0RSRVNTX09MWU1QSUEuanBnIl1d/GRANT_DRESS_OLYMPIA.jpg",},
//  {"id": "3", "link":"https://res.cloudinary.com/fashionasalifestyle/image/upload/f_auto/v1527700782/casual%20summer%20outfits.jpg"},
//  {"id": "4", "link":"https://cdn.cliqueinc.com/posts/282188/london-autumn-fashion-trends-282188-1567115968335-image.700x0c.jpg"},
//  {"id": "5", "link":"https://cdn.cliqueinc.com/posts/282188/london-autumn-fashion-trends-282188-1567115968335-image.700x0c.jpg"},
//  {"id": "6", "link":"https://cdn.cliqueinc.com/posts/282188/london-autumn-fashion-trends-282188-1567115968335-image.700x0c.jpg"}
//];

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
          Padding(
          padding: EdgeInsets.all(20.0),
          child: Image.asset(
            'assets/SnapIt-logo.png',
            height: 125,
            width: 125,
          ),
        ),


            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 35),
              transform: Matrix4.rotationZ(-0.065),
              child: Text(
                " Snap it to snap up! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    //fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: Color(0xff878787),
                    fontFamily: 'Pacifico',
                    backgroundColor: Color(0xffFCF6E6)
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 35),
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

//          Container(
////            padding: EdgeInsets.fromLTRB(10, 10, 10, 35),
//            color: Color(0xffDFD8C8),
//            alignment: Alignment.center,
//            margin: new EdgeInsets.only(
//                top: 50.0
//            ),
//          ),

//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  color: Color(0xffDFD8C8),
//                  padding: EdgeInsets.all(30.0),
//                  child: Text('inside container'),
//                  //alignment: AlignmentDirectional(0.0, 0.0),
//                  alignment: Alignment.center,
//                ),
//
//              ],
//            ),


                          Expanded( child: Products()),

          ],
        ),

        ),
      );
  }
}

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final list_item = [
    {"id": "1", "link":"https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"},
    {"id": "2", "link":"https://media.thereformation.com/image/upload/q_auto:eco/c_scale,w_auto:breakpoints_100_1920_9_20:544/v1/prod/media/W1siZiIsIjIwMjAvMDIvMTkvMTMvMjkvMzgvYjlmMWY3N2UtOTVhOC00OTNmLWI0YWYtY2IwMTk2YjhmOWMzL0dSQU5UX0RSRVNTX09MWU1QSUEuanBnIl1d/GRANT_DRESS_OLYMPIA.jpg",},
    {"id": "3", "link":"https://res.cloudinary.com/fashionasalifestyle/image/upload/f_auto/v1527700782/casual%20summer%20outfits.jpg"},
    {"id": "4", "link":"https://cdn.cliqueinc.com/posts/282188/london-autumn-fashion-trends-282188-1567115968335-image.700x0c.jpg"},
    {"id": "5", "link":"https://cdn.cliqueinc.com/posts/282188/london-autumn-fashion-trends-282188-1567115968335-image.700x0c.jpg"},
    {"id": "6", "link":"https://cdn.cliqueinc.com/posts/282188/london-autumn-fashion-trends-282188-1567115968335-image.700x0c.jpg"}
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

class Camera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Camera Page"),
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
      //body:
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
