import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';
  EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlControler = TextEditingController();
  final _imageurlFocus = FocusNode();

  @override
  void initState() {
    _imageurlFocus.addListener(_updateImageUrl);
    super.initState();
  }

// it will auto update and create new State
  void _updateImageUrl() {
    if (!_imageurlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageurlFocus.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlControler.dispose();
    _imageurlFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_descriptionNode),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                focusNode: _descriptionNode,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlControler.text.isEmpty
                          ? Text(
                              "Enter a Url",
                              textAlign: TextAlign.center,
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlControler.text,
                                fit: BoxFit.cover,
                              ),
                            )),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlControler,
                      focusNode: _imageurlFocus,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
