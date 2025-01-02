import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_one/api/store_info_save_req.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../api/api_service.dart';
import '../api/login_type_req.dart';
import '../app_color.dart';
import '../app_utils.dart';
import '../database/store_entity.dart';
import '../database/store_type_dao.dart';
import '../database/store_type_entity.dart';
import '../main.dart';

class StoreAddScreen extends StatefulWidget {
  final VoidCallback onDataChanged;
  final StoreEntity? store; // Pass store for edit mode

  const StoreAddScreen({
    super.key,
    required this.onDataChanged,
    this.store,
  });

  @override
  State<StoreAddScreen> createState() => _StoreAddScreen();
}

class _StoreAddScreen extends State<StoreAddScreen> {
  final dio = Dio();

  String selectedStoreType = '';
  String selectedStoreTypeID = '';
  String storeTypeName = '';
  List<StoreTypeEntity> storeTypeL = [];
  List<DropdownMenuItem<String>>? dropdownItems;

  double _latitude = 0;
  double _longitude = 0;
  String gpsAddress = "";
  String gpsPincode = "";

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Controllers for form fields
  late TextEditingController storeTypeController;
  late TextEditingController storeNameController;
  late TextEditingController storeAddressController;
  late TextEditingController storePinCodeController;
  late TextEditingController contactNameController;
  late TextEditingController contactNumberController;
  late TextEditingController contactAlternateNumberController;
  late TextEditingController contactWhatsappNumberController;
  late TextEditingController contactEmailController;
  late TextEditingController contactSizeAreaController;
  late TextEditingController contactRemarksController;
  late final StoreTypeDao _storeTypeDao;

  @override
  void initState() {
    super.initState();
    _storeTypeDao = appDatabase.storeTypeDao;
    // Initialize controllers
    storeTypeController = TextEditingController(
      text: widget.store?.store_type ?? '',
    );
    storeNameController = TextEditingController(
      text: widget.store?.store_name ?? '',
    );
    storeAddressController = TextEditingController(
      text: widget.store?.store_address ?? '',
    );
    storePinCodeController = TextEditingController(
      text: widget.store?.store_pincode ?? '',
    );
    contactNameController = TextEditingController(
      text: widget.store?.store_contact_name ?? '',
    );
    contactNumberController = TextEditingController(
      text: widget.store?.store_contact_number ?? '',
    );
    contactAlternateNumberController = TextEditingController(
      text: widget.store?.store_alternet_contact_number ?? '',
    );
    contactWhatsappNumberController = TextEditingController(
      text: widget.store?.store_whatsapp_number ?? '',
    );
    contactEmailController = TextEditingController(
      text: widget.store?.store_email ?? '',
    );
    contactSizeAreaController = TextEditingController(
      text: widget.store?.store_size_area ?? '',
    );
    contactRemarksController = TextEditingController(
      text: widget.store?.remarks ?? '',
    );

    if (widget.store != null) {
      // Edit mode: load existing data
      selectedStoreType = widget.store!.store_type!;
      selectedStoreTypeID = widget.store!.store_type!;
      _latitude = double.tryParse(widget.store!.store_lat ?? '0') ?? 0;
      _longitude = double.tryParse(widget.store!.store_long ?? '0') ?? 0;
      _fetchStoreTypeName(selectedStoreTypeID);
    } else {
      // Add mode: fetch current location
      _loadStoreLocation().then((data) {
        setState(() {
          _latitude = data.latitude;
          _longitude = data.longitude;
          storeAddressController = TextEditingController(text: gpsAddress);
          storePinCodeController = TextEditingController(text: gpsPincode);
        });
      });
    }

    _loadStoreTypes();
  }

  Future<void> _fetchStoreTypeName(String storeTypeID) async {
    storeTypeName = (await _storeTypeDao.getStoreTypeById(storeTypeID))!;
    if (storeTypeName != null) {
      setState(() {
        storeTypeController.text = storeTypeName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.store != null;
    final store = widget.store;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColor.colorToolbar,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          isEditMode ? 'Edit Store' : 'Add Store',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _imageFile != null
                          ? FileImage(_imageFile!)
                          : AssetImage('assets/images/store_dummy.jpg') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -35,
                  left: MediaQuery.of(context).size.width / 2 - 35,
                  child: GestureDetector(
                    onTap: () {
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
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  buildInputField('assets/images/ic_store_color.jpg', 'Store type', storeTypeController, TextInputType.text, 100, isDropdown: true),
                  buildInputField('assets/images/ic_store_color.jpg', 'Store Name', storeNameController, TextInputType.text, 100),
                  buildInputField('assets/images/ic_location.png', 'Address', storeAddressController, TextInputType.text, 500),
                  buildInputField('assets/images/ic_location.png', 'Pincode', storePinCodeController, TextInputType.number, 10),
                  buildInputField('assets/images/ic_user_color.png', 'Contact Name', contactNameController, TextInputType.text, 100),
                  buildInputField('assets/images/ic_phone.png', 'Contact Number', contactNumberController, TextInputType.number, 10),
                  buildInputField('assets/images/ic_phone.png', 'Alternet Contact Number', contactAlternateNumberController, TextInputType.number, 10),
                  buildInputField('assets/images/ic_whatsapp.png', 'Whatsapp Number', contactWhatsappNumberController, TextInputType.number, 10),
                  buildInputField('assets/images/ic_mail.png', 'Email', contactEmailController, TextInputType.text, 100),
                  buildInputField('assets/images/ic_measurement.png', 'Size/Area', contactSizeAreaController, TextInputType.text, 100),
                  buildInputField('assets/images/ic_remarks.png', 'Remarks', contactRemarksController, TextInputType.text, 100),

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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        backgroundColor: AppColor.colorButton,
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (isEditMode) {
                          await _updateStore();
                        } else {
                          await _saveNewStore();
                        }
                      },
                      child: Text(
                        isEditMode ? 'Update' : 'Save',
                        style: TextStyle(color: AppColor.colorWhite),
                      ),
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

  Future<void> _captureAndCropImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
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
                //selectedStoreType.isNotEmpty ? selectedStoreType : hint,
                selectedStoreType.isNotEmpty ? storeTypeName : hint,
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

  Future<void> _saveNewStore() async {

    /*    try {
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
    }*/

    DateTime currentDateTime = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);
    final storeID = pref.getString('user_id')! +
        formattedDate.replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");

    // Create StoreEntity object
    final storeEntity = StoreEntity(
      store_id: storeID,
      store_name: storeNameController.text,
      store_address: storeAddressController.text,
      store_pincode: storePinCodeController.text,
      store_lat: '', // Or provide relevant values
      store_long: '',
      store_contact_name: contactNameController.text,
      store_contact_number: contactNumberController.text,
      store_alternet_contact_number: contactAlternateNumberController.text,
      store_whatsapp_number: contactWhatsappNumberController.text,
      store_email: contactEmailController.text,
      store_type: "1",
      store_size_area: contactSizeAreaController.text,
      store_state_id: '1', // Assuming this value
      remarks: contactRemarksController.text,
      create_date_time: DateTime.now().toString(),
      /*store_pic_url: '', // If you have any image URL*/
     /* isUploaded: false, // Assuming not uploaded yet*/
    );

    // Create StoreInfoSaveReq object
    final storeData = StoreInfoSaveReq(
      user_id: /*pref.getString('user_id')!*/ "11707",
      store_list: [storeEntity], // Wrap in a list as `store_list` expects a list
    );
    print('storeData: $storeData');

    // Call your API to save the store data
    try {
      final apiService = ApiService(dio);
      final response = await apiService.saveStoreInfo(storeData);

      if (response.status == "200") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Store added successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save store")));

      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      print('Erroraddstore: $e');
    }
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

  Future<List<StoreTypeEntity>> getStoreTypes() async {
    final storeTypeDao = appDatabase.storeTypeDao;
    storeTypeL = await storeTypeDao.getAll();
    return storeTypeL;
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

  Future<void> _updateStore() async {
    try {
      // Create the updated StoreEntity with the existing store_id
      final updatedStore = StoreEntity(
        store_id: widget.store!.store_id,  // Keep the same store_id for updating
        store_name: storeNameController.text,
        store_address: storeAddressController.text,
        store_pincode: storePinCodeController.text,
        store_lat: _latitude.toString(),
        store_long: _longitude.toString(),
        store_contact_name: contactNameController.text,
        store_contact_number: contactNumberController.text,
        store_alternet_contact_number: contactAlternateNumberController.text,
        store_whatsapp_number: contactWhatsappNumberController.text,
        store_email: contactEmailController.text,
        store_type: selectedStoreTypeID,
        store_size_area: contactSizeAreaController.text,
        remarks: contactRemarksController.text,
        create_date_time: widget.store!.create_date_time,
        store_state_id: widget.store!.store_state_id,
/*
        store_pic_url: widget.store!.store_pic_url,
*/
/*
        isUploaded: widget.store!.isUploaded,
*/
      );
      // Call the updateStore method from StoreDao
      await appDatabase.storeDao.updateStore(updatedStore);
      widget.onDataChanged();  // Notify the parent widget of the update
      Navigator.of(context).pop();  // Go back to the previous screen
    } catch (e) {
      print("Error while updating store: $e");
    }
  }
}
