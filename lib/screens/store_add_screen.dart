import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_one/app_utils.dart';
import 'package:flutter_demo_one/database/store_entity.dart';
import 'package:flutter_demo_one/database/store_type_entity.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../api/store_type_response.dart';
import '../app_color.dart';
import '../main.dart';

class StoreAddScreen extends StatefulWidget {
  //const StoreAddScreen({super.key});

  final VoidCallback onDataChanged;
  // Constructor to accept onDataChanged
  const StoreAddScreen({super.key, required this.onDataChanged});

  State<StoreAddScreen> createState() => _StoreAddScreen();
}

class _StoreAddScreen extends State<StoreAddScreen> {


  String selectedStoreType = '';
  String selectedStoreTypeID = '';
  List<StoreTypeEntity> storeTypeL = [];
  List<DropdownMenuItem<String>>? dropdownItems;

  double _latitude = 0;
  double _longitude = 0;
  String gpsAddress = "";
  String gpsPincode = "";

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController storeTypeController = TextEditingController();
  late TextEditingController storeNameController = TextEditingController();
  late TextEditingController storeAddressController = TextEditingController();
  late TextEditingController storePinCodeController = TextEditingController();
  late TextEditingController contactNameController = TextEditingController();
  late TextEditingController contactNumberController = TextEditingController();
  late TextEditingController contactAlternateNumberController =
      TextEditingController();
  late TextEditingController contactWhatsappNumberController =
      TextEditingController();
  late TextEditingController contactEmailController = TextEditingController();
  late TextEditingController contactSizeAreaController =
      TextEditingController();
  late TextEditingController contactRemarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStoreTypes();
    _loadStoreLocation().then((data) {
      // Handle the result here
      setState(() {
        _latitude = data.latitude;
        _longitude = data.longitude;
        // Update the UI if needed
        storeAddressController = TextEditingController(text: gpsAddress);
        storePinCodeController = TextEditingController(text: gpsPincode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Form'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with an image and a circular camera icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner Image
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/store_dummy.jpg'),
                      // Replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Camera Icon
                Positioned(
                  bottom: -35,
                  left: MediaQuery.of(context).size.width / 2 - 35,
                  child: GestureDetector(
                    onTap: () {
                      // Handle camera click here
                      // For example, navigate to camera screen or open image picker
                      _captureImage();
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.teal,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50), // Space to avoid overlap

            // Input Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  buildInputField(
                      'assets/images/ic_store_color.jpg',
                      'Store type',
                      storeTypeController,
                      TextInputType.text,
                      100,
                      isDropdown: true),
                  buildInputField(
                      'assets/images/ic_store_color.jpg',
                      'Store Name',
                      storeNameController,
                      TextInputType.text,
                      100),
                  buildInputField('assets/images/ic_location.png', 'Address',
                      storeAddressController, TextInputType.text, 500),
                  buildInputField('assets/images/ic_location.png', 'Pincode',
                      storePinCodeController, TextInputType.number, 10),
                  buildInputField(
                      'assets/images/ic_user_color.png',
                      'Contact Name',
                      contactNameController,
                      TextInputType.text,
                      100),
                  buildInputField(
                      'assets/images/ic_phone.png',
                      'Contact Number',
                      contactNumberController,
                      TextInputType.number,
                      10),
                  buildInputField(
                      'assets/images/ic_phone.png',
                      'Alternet Contact Number',
                      contactAlternateNumberController,
                      TextInputType.number,
                      10),
                  buildInputField(
                      'assets/images/ic_whatsapp.png',
                      'Whatsapp Number',
                      contactWhatsappNumberController,
                      TextInputType.number,
                      10),
                  buildInputField('assets/images/ic_mail.png', 'Email',
                      contactEmailController, TextInputType.text, 100),
                  buildInputField(
                      'assets/images/ic_measurement.png',
                      'Size/Area',
                      contactSizeAreaController,
                      TextInputType.text,
                      100),
                  buildInputField('assets/images/ic_remarks.png', 'remarks',
                      contactRemarksController, TextInputType.text, 100),

                  //  Button
                  SizedBox(height: 20.0),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black87,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: const BorderSide(color: Colors.black26, width: 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: AppColor.colorButton,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        validation();
                      },
                      child: const Text('Save',
                          style: TextStyle(color: AppColor.colorWhite)),
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
      String iconPath,
      String hint,
      TextEditingController controller,
      TextInputType textInputType,
      int maxLength,
      {bool isDropdown = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 0),
      constraints: BoxConstraints(
        minHeight: 55.0, // Minimum height of the container
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 1, // Spread the shadow
            blurRadius: 2, // Blur effect for the shadow
            offset: Offset(0, 3), // Shadow position (x, y)
          ),
        ],
      ),
      child: Row(
        children: [
          // Custom image for dropdown block
          if (isDropdown)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Image.asset(
                iconPath, // Path to your custom image
                width: 24, // Adjust width
                height: 24, // Adjust height
                fit: BoxFit.contain,
              ),
            ),
          Expanded(
            child: isDropdown
                ? DropdownButton<String>(
                    isExpanded: true,
                    underline: SizedBox(),
                    hint: Text(
                      selectedStoreType.isNotEmpty ? selectedStoreType : hint,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    items: dropdownItems,
                    /*[
                      DropdownMenuItem(value: 'Typ0', child: Text('Type1')),
                      DropdownMenuItem(value: 'Typ1', child: Text('Type2')),
                    ],*/
                    onChanged: (value) {
                      setState(() {
                        try {
                          StoreTypeEntity selectedStoreTypeEntity =
                              storeTypeL.firstWhere(
                            (storeType) =>
                                storeType.type_id.toString() == value,
                          );
                          controller.text = selectedStoreTypeEntity.type_name!;
                          selectedStoreType =
                              selectedStoreTypeEntity.type_name!;
                          selectedStoreTypeID = value!;
                        } catch (e) {
                          print(e);
                        }
                      });
                    },
                  )
                : TextField(
                    controller: controller,
                    maxLines: null,
                    // Allows TextField to grow vertically
                    minLines: 1,
                    keyboardType: textInputType,
                    // Set keyboard type to number
                    maxLength: maxLength,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        // Padding for the custom image
                        child: Image.asset(
                          iconPath, // Path to your custom icon image
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: TextStyle(color: Colors.grey[700]),
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      counterText: "",
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<List<StoreTypeEntity>> getStoreTypes() async {
    final storeTypeDao = appDatabase.storeTypeDao;
    storeTypeL = await storeTypeDao.getAll();
    return storeTypeL;
  }

  Future<void> _loadStoreTypes() async {
    // Fetch data from the database
    List<StoreTypeEntity> storeTypes = await getStoreTypes();

    // Create dropdown items
    setState(() {
      dropdownItems = storeTypes.map((storeType) {
        return DropdownMenuItem<String>(
          value: storeType.type_id.toString(),
          child: Text(storeType.type_name),
        );
      }).toList();
    });
  }

  Future<Position> _loadStoreLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    gpsAddress =
        await AppUtils().getAddress(position.latitude, position.longitude);
    gpsPincode =
        await AppUtils().getPincode(position.latitude, position.longitude);
    return position;
  }

  Future<void> validation() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      String storeName = storeNameController.text;
      String storeAddress = storeAddressController.text;
      String storePinCode = storePinCodeController.text;
      String contactName = contactNameController.text;
      String contactNumber = contactNumberController.text;
      String contactNumberAlternate = contactAlternateNumberController.text;
      String contactWhatsapp = contactWhatsappNumberController.text;
      String contactEmail = contactEmailController.text;
      String areaSize = contactSizeAreaController.text;
      String remarks = contactRemarksController.text;

      final statePinDao = appDatabase.statePinDao;
      int? stateID = await statePinDao.getStateIDByPincode(storePinCode);
      if (stateID == null) {
        stateID = 0;
      }

      if (selectedStoreType == "") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please select Store type')));
      } else if (storeName == "") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please enter Store Name')));
      } else if (storeAddress == "") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please enter Address')));
      } else if (storePinCode == "") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please enter Pincode')));
      } else if (contactName == "") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please enter Contact Name')));
      } else if (contactNumber == "") {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter Contact Number')));
      } else {
        DateTime currentDateTime = DateTime.now();
        String formattedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);
        final storeID = pref.getString('user_id')! +
            formattedDate
                .replaceAll(" ", "")
                .replaceAll("-", "")
                .replaceAll(":", "");
        final storeObj = StoreEntity(
            store_id: storeID,
            store_name: storeName,
            store_address: storeAddress,
            store_pincode: storePinCode,
            store_lat: _latitude.toString(),
            store_long: _longitude.toString(),
            store_contact_name: contactName,
            store_contact_number: contactNumber,
            store_alternet_contact_number: contactNumberAlternate,
            store_whatsapp_number: contactWhatsapp,
            store_email: contactEmail,
            store_type: selectedStoreTypeID,
            store_size_area: areaSize,
            store_state_id: stateID.toString(),
            remarks: remarks,
            create_date_time: formattedDate,
            store_pic_url: "",
            isUploaded: false);

        final storeDao = appDatabase.storeDao;
        await storeDao.insertStore(storeObj);
        Navigator.of(context).pop();
        AppUtils().showCustomDialog(context,"Hi ${pref.getString('user_name') ?? ""}","Store saved successfully.",(){
          widget.onDataChanged();
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<void> _captureImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        print("Image Path: ${pickedFile.path}"); // Save or use the path as needed
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

}
