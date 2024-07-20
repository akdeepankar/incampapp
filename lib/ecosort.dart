import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EcoSort extends StatefulWidget {
  const EcoSort({super.key});

  @override
  State<EcoSort> createState() => _EcoSortState();
}

class _EcoSortState extends State<EcoSort> {

  XFile? pickedImage;
  String mytext = '';
  bool scanning=false;

  final ImagePicker _imagePicker = ImagePicker();
  final apiUrl='https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s';
  final header={
    'Content-Type': 'application/json',
  };

  getImage(ImageSource ourSource) async {
    XFile? result = await _imagePicker.pickImage(source: ourSource);
    if (result != null) {
      setState(() {
        pickedImage = result;
      });
    }
  }

  getdata(image,promptValue)async{
    setState(() {
      scanning=true;
      mytext='';
    });

  try{
    
  List<int> imageBytes = File(image.path).readAsBytesSync();
  String base64File = base64.encode(imageBytes);
  
  final data={
    "contents": [
    {
      "parts": [

        {"text":promptValue},
        
        {
          "inlineData": {
            "mimeType": "image/jpeg",
            "data": base64File,
          }
        }
      ]
    }
  ],
  };

  await http.post(Uri.parse(apiUrl),headers: header,body: jsonEncode(data)).then((response){

    if(response.statusCode==200){

      var result=jsonDecode(response.body);
      mytext=result['candidates'][0]['content']['parts'][0]['text'];
      
    }else{
      mytext='Response status : ${response.statusCode}';
    }

  }).catchError((error){
    print('Error occored ${error}');
  });
  }catch(e){
    print('Error occured ${e}');
  }

  scanning=false;
  setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
                  Text('SORT WASTE EFFORTLESSLY', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                  SizedBox(height: 10),
            pickedImage == null
                ? Container(
                  height: 200,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey[300],),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       IconButton(onPressed: (){
          getImage(ImageSource.gallery);
        }, icon: const Icon(Icons.photo,color: Colors.grey, size: 100,)),const SizedBox(width: 10,),
                      const Text('No Image Selected',style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),),
                    ],
                  ),))
                :
            SizedBox(height:340,child: Center(child: Image.file(File(pickedImage!.path),height: 400,))),              
            const SizedBox(height: 20,),

            ElevatedButton.icon(
            onPressed: () {
              getdata(pickedImage, 'Identify recyclable, compostable, and landfill waste and mention which color dustbin should be used, also give Tips on proper recycling techniques if Applicable');
            },
            icon: const Icon(
              Icons.energy_savings_leaf,
              color: Colors.white,
            ),
            label: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Sort',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // Padding
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          scanning?
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(child: SpinKitThreeBounce(color: Colors.black,size: 20,)),
          ):
          Text(mytext,textAlign: TextAlign.center,style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}