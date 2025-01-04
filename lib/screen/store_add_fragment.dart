import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fl/api/api_service_multipart.dart';
import 'package:fl/api/response/store_save_request.dart';
import 'package:fl/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
import '../database/store_entity.dart';
import '../database/store_type_entity.dart';
import '../utils/app_color.dart';
import '../utils/app_utils.dart';

class StoreAddFragment extends StatefulWidget {
  final VoidCallback onDataChanged;
  final StoreEntity? editStoreObj;
  const StoreAddFragment({super.key, required this.onDataChanged,this.editStoreObj});

  @override
  _StoreAddFragmentState createState() => _StoreAddFragmentState();
}

class _StoreAddFragmentState extends State<StoreAddFragment> {
  final apiService = ApiService(Dio());
  final apiServiceMultipart = ApiServiceMultipart(Dio());

  StoreTypeEntity selectedStoreType = StoreTypeEntity();
  List<StoreTypeEntity> storeTypeL = [];
  List<DropdownMenuItem<StoreTypeEntity>>? dropdownStoreType;

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

    if(widget.editStoreObj != null){
      loadEditData();
    }else{
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
  }

  Future<void> loadEditData() async {
    final typeDtls = await appDatabase.storeTypeDao.getStoreTypeDtls(widget.editStoreObj!.store_type.toString());
    if(typeDtls!=null){
      _loadStoreTypes(defaultTypeId: typeDtls.type_id);
    }
    storeNameController = TextEditingController(text: widget.editStoreObj?.store_name ?? '',);
    storeAddressController = TextEditingController(text: widget.editStoreObj?.store_address ?? '',);
    storePinCodeController = TextEditingController(text: widget.editStoreObj?.store_pincode ?? '',);
    contactNameController = TextEditingController(text: widget.editStoreObj?.store_contact_name ?? '',);
    contactNumberController = TextEditingController(text: widget.editStoreObj?.store_contact_number ?? '',);
    contactAlternateNumberController = TextEditingController(text: widget.editStoreObj?.store_alternet_contact_number ?? '',);
    contactWhatsappNumberController = TextEditingController(text: widget.editStoreObj?.store_whatsapp_number ?? '',);
    contactEmailController = TextEditingController(text: widget.editStoreObj?.store_email ?? '',);
    contactSizeAreaController = TextEditingController(text: widget.editStoreObj?.store_size_area ?? '',);
    contactRemarksController = TextEditingController(text: widget.editStoreObj?.remarks ?? '',);

    _loadStoreLocation().then((data) {
      // Handle the result here
      setState(() {
        _latitude = data.latitude;
        _longitude = data.longitude;
        // Update the UI if needed
        storeAddressController = TextEditingController(text: gpsAddress);
        storePinCodeController = TextEditingController(text: gpsPincode);
        if(widget.editStoreObj?.store_pic_url != ""){
          if(widget.editStoreObj!.store_pic_url.contains("http")){
            createImgForUrl(widget.editStoreObj!.store_pic_url.toString());
          }else{
            _imageFile = File(widget.editStoreObj!.store_pic_url);
          }

        }
      });
    });
  }

  Future<void> createImgForUrl(String imgUrl) async {
    try {
      final response = await http.get(Uri.parse(imgUrl));
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/downloaded_image.jpg';
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      setState(() {
        _imageFile = file;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color of the screen to white
      appBar: _buildAppBar(context),
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
                  height: 120,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _imageFile != null ? FileImage(_imageFile!) : AssetImage('assets/images/store_dummy.jpg') as ImageProvider,
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
                      //_captureImage();
                      _captureAndCropImage();
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColor.colorToolbar,
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
                      'Alternate Contact Number',
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
                    width: MediaQuery.of(context).size.width,
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
                        if(widget.editStoreObj == null){
                          validation();
                        }else{
                          validationEdit();
                        }
                      },
                      child: Text(
                          widget.editStoreObj != null ? "Edit" : "Add",
                          style: const TextStyle(color: AppColor.colorWhite)),
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.colorSmokeWhite,
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
        color: AppColor.colorWhite,
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
            child: isDropdown ? DropdownButton<StoreTypeEntity>(
              isExpanded: true,
              underline: SizedBox(),
              value: selectedStoreType.type_name.isEmpty ? null : selectedStoreType, // Default value
              hint: Text(
                selectedStoreType.type_name.isEmpty ? "Select Store Type" : selectedStoreType.type_name,
                style: TextStyle(color: Colors.grey[700]),
              ),
              items: dropdownStoreType,
              onChanged: (value) {
                setState(() {
                  try {
                    selectedStoreType = value!;
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

  Future<void> _captureAndCropImage() async {
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _imageFile = File(croppedFile.path);
          });
        }
      }
    } catch (e) {
      print("Error capturing or cropping image: $e");
    }
  }

  Future<List<StoreTypeEntity>> getStoreTypes() async {
    final storeTypeDao = appDatabase.storeTypeDao;
    storeTypeL = await storeTypeDao.getAll();
    return storeTypeL;
  }

  Future<void> _loadStoreTypes({int? defaultTypeId}) async {
    List<StoreTypeEntity> storeTypes = await getStoreTypes();
    setState(() {
      dropdownStoreType = storeTypes.map((storeType) {
        return DropdownMenuItem<StoreTypeEntity>(
          value: storeType,
          child: Text(storeType.type_name),
        );
      }).toList();
      // Set the default selection if `defaultTypeId` is provided
      if (defaultTypeId != null) {
        selectedStoreType = storeTypes.firstWhere((storeType) => storeType.type_id == defaultTypeId
        );
      }
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

      String imagePath = "";
      if(_imageFile != null){
        imagePath = _imageFile!.path;
      }


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
            store_type: selectedStoreType.type_id,
            store_size_area: areaSize,
            store_state_id: stateID,
            remarks: remarks,
            create_date_time: formattedDate,
            store_pic_url: imagePath,
            isUploaded: false);

        final storeDao = appDatabase.storeDao;
        await storeDao.insertStore(storeObj);

        //api call
        final storeSaveRequest = StoreSaveRequest(user_id: pref.getString('user_id')!,
        store_list: [storeObj]);
        try {
          final response = await apiService.saveStoreInfo(storeSaveRequest);
          if (response.status == "200") {
            if(_imageFile == null){
              showMsg("Store saved successfully.");
            }else{
             uploadImageApi(storeObj.store_id.toString());
            }
          } else {
            showMsg("Failed to save store.");
          }
        } catch (e) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong.")));
          print('Erroraddstore: $e');
        }
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<void> validationEdit() async {
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

      String imagePath = "";
      if(_imageFile != null){
        imagePath = _imageFile!.path;
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
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);
        final storeObj = StoreEntity(
            store_id: widget.editStoreObj!.store_id,
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
            store_type: selectedStoreType.type_id,
            store_size_area: areaSize,
            store_state_id: stateID,
            remarks: remarks,
            create_date_time: formattedDate,
            store_pic_url: imagePath,
            isUploaded: false);

        final storeDao = appDatabase.storeDao;
        await storeDao.insertStore(storeObj);

        //api call
        final storeSaveRequest = StoreSaveRequest(user_id: pref.getString('user_id')!,
            store_list: [storeObj]);
        try {
          final response = await apiService.editStoreInfo(storeSaveRequest);
          if (response.status == "200") {
            showMsg("Store edited successfully.");
          } else {
            showMsg("Failed to edit store.");
          }
        } catch (e) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong.")));
          print('Erroraddstore: $e');
        }
      }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<void> uploadImageApi(String storeID) async {
    try {
      final jsonData = '{"store_id":"$storeID","user_id":"${pref.getString('user_id')!}"}';
      final imageFile = _imageFile;
      final response = await apiServiceMultipart.uploadImage(jsonData,imageFile!);
      if(response.status == "200"){
        showMsg("Store saved successfully.");
          }
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong.")));
    }
  }

  void showMsg(String msg){
    Navigator.of(context).pop();
    AppUtils().showCustomDialog(context,"Hi ${pref.getString('user_name') ?? ""}",msg,(){
      widget.onDataChanged();
      Navigator.of(context).pop();
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          widget.editStoreObj != null ? "Edit Store" : "Add Store",
          style: TextStyle(color: AppColor.colorWhite, fontSize: 20),
        ),
      ),
      backgroundColor: AppColor.colorToolbar,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        // Back button on the left
        onPressed: () {
          Navigator.pop(context); // Navigate back
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.home, color: Colors.white), // Home icon on the right
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ],
    );
  }

}
