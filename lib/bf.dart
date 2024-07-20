import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Bf extends StatefulWidget {
  const Bf({super.key});

  @override
  State<Bf> createState() => _BfState();
}

class _BfState extends State<Bf> {

  final String apiKey = 'AIzaSyCA25KPArcjrC0AbT8n8SweiV5ktE_ta0s';
  String _selectedOption1 = '';
  String _selectedOption2 = '';
  bool _isLoading = false;

  XFile? pickedImage;
  String mytext = '';
  bool scanning=false;

  TextEditingController prompt=TextEditingController();

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

        // ignore: prefer_interpolation_to_compose_strings
        {"text":'${'My Budget is' + promptValue}What food item do you suggest for $_selectedOption1 and should be for $_selectedOption2 ?'},
        
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

  Widget _buildOption(String option, String label, String selectedOption, void Function()? onTap) {
    bool isSelected = option == selectedOption;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? Colors.blue : Colors.grey[200],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
        
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
                        const Text('Upload Food Menu',style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),),
                      ],
                    ),))
                  :
              SizedBox(height:340,child: Center(child: Image.file(File(pickedImage!.path),height: 400,))),
                          
              const SizedBox(height: 20,),
              
              TextField(
                      controller: prompt,
                      decoration: InputDecoration(
                        hintText: '350',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: 'Budget per Person In INR',
                        labelStyle: TextStyle(color: Colors.blue),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                    ),
              SizedBox(height: 20,),
              Text('I want to have', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildOption('Breakfast', 'Breakfast', _selectedOption1, () {
                          setState(() {
                            _selectedOption1 = 'Breakfast';
                          });
                        }),
                        _buildOption('Lunch', 'Lunch', _selectedOption1, () {
                          setState(() {
                            _selectedOption1 = 'Lunch';
                          });
                        }),
                        _buildOption('Dinner', 'Dinner', _selectedOption1, () {
                          setState(() {
                            _selectedOption1 = 'Dinner';
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('Other Info', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _buildOption('Vegetarian', 'Vegetarian', _selectedOption2, () {
                          setState(() {
                            _selectedOption2 = 'Vegetarian';
                          });
                        }),
                        _buildOption('Non Veg', 'Non Veg', _selectedOption2, () {
                          setState(() {
                            _selectedOption2 = 'Non Veg';
                          });
                        }),
                        _buildOption('Fever / Cold', 'Fever / Cold', _selectedOption2, () {
                          setState(() {
                            _selectedOption2 = 'Fever / Cold';
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 20),
        
              ElevatedButton.icon(
                onPressed: (){
                    getdata(pickedImage,prompt.text);
                }, 
                icon: Icon(Icons.local_pizza,color: Colors.white,), 
                label: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text('Suggest me Food',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, 
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),))
                ,
        
             SizedBox(height: 30),
        
            scanning?
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(child: SpinKitThreeBounce(color: Colors.black,size: 20,)),
            ):
            Text(mytext,textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      
      ),
    );

  }
}