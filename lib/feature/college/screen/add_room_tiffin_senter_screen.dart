// lib/feature/college/screen/add_tiffin_center_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/widget/flutter_toast.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/room_controller.dart';
import '../controller/tiffin_controller.dart';

class AddRoomTiffinCenterScreen extends StatefulWidget {
  const AddRoomTiffinCenterScreen({super.key});

  @override
  State<AddRoomTiffinCenterScreen> createState() =>
      _AddRoomTiffinCenterScreenState();
}

class _AddRoomTiffinCenterScreenState extends State<AddRoomTiffinCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ============================================================
  // ROOM FORM CONTROLLERS
  // ============================================================
  final GlobalKey<FormState> _roomFormKey = GlobalKey<FormState>();
  final TextEditingController _roomTitleController = TextEditingController();
  final TextEditingController _roomDescriptionController =
  TextEditingController();
  final TextEditingController _roomPriceController = TextEditingController();
  final TextEditingController _roomContactController = TextEditingController();
  final TextEditingController _roomNearCollegeController =
  TextEditingController();
  final TextEditingController _roomAddressController = TextEditingController();

  // Amenities Controllers (using TextEditingController for checkbox values)
  final TextEditingController _roomWifiController = TextEditingController();
  final TextEditingController _roomAcController = TextEditingController();
  final TextEditingController _roomParkingController = TextEditingController();
  final TextEditingController _roomSecurityController = TextEditingController();
  final TextEditingController _roomLaundryController = TextEditingController();
  final TextEditingController _roomWaterController = TextEditingController();

  String _selectedRoomType = '3BHK';
  bool _isRoomBooking = false;
  List<File> _roomImages = [];

  // Room options
  final List<String> _roomTypes = [
    '1BHK',
    '2BHK',
    '3BHK',
    '4BHK',
    'PG',
    'Hostel',
    'Apartment',
    'Villa'
  ];

  // ============================================================
  // TIFFIN FORM CONTROLLERS
  // ============================================================
  final GlobalKey<FormState> _tiffinFormKey = GlobalKey<FormState>();
  final TextEditingController _tiffinTitleController = TextEditingController();
  final TextEditingController _tiffinDescriptionController =
  TextEditingController();
  final TextEditingController _tiffinPriceController = TextEditingController();
  final TextEditingController _tiffinContactController =
  TextEditingController();
  final TextEditingController _tiffinNearCollegeController =
  TextEditingController();

  String _selectedVegType = 'true';
  String _selectedNonVegType = 'true';
  bool _isTiffinBooking = false;
  List<File> _tiffinImages = [];

  // Tiffin options
  final List<String> _vegOptions = [
    'true',
    'false',
  ];
  final List<String> _nonVegOptions = [
    'true',
    'false',
  ];

  // ============================================================
  // COMMON
  // ============================================================
  bool _isLoading = false;
  final AuthController authController = Get.find<AuthController>();
  final RoomController roomController = Get.put(RoomController());
  final TiffinController tiffinController = Get.put(TiffinController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Room controllers
    _roomTitleController.dispose();
    _roomDescriptionController.dispose();
    _roomPriceController.dispose();
    _roomContactController.dispose();
    _roomNearCollegeController.dispose();
    _roomAddressController.dispose();
    _roomWifiController.dispose();
    _roomAcController.dispose();
    _roomParkingController.dispose();
    _roomSecurityController.dispose();
    _roomLaundryController.dispose();
    _roomWaterController.dispose();
    // Tiffin controllers
    _tiffinTitleController.dispose();
    _tiffinDescriptionController.dispose();
    _tiffinPriceController.dispose();
    _tiffinContactController.dispose();
    _tiffinNearCollegeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Add Listing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.bed_rounded),
              text: 'Room',
            ),
            Tab(
              icon: Icon(Icons.restaurant_rounded),
              text: 'Tiffin',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRoomForm(),
          _buildTiffinForm(),
        ],
      ),
    );
  }

  // ============================================================
  // ROOM FORM
  // ============================================================
  Widget _buildRoomForm() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _roomFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.bed_rounded,
              title: 'Room Details',
              subtitle: 'Fill in the details to add a new room/PG',
            ),
            const SizedBox(height: 24),

            // Room Type Dropdown
            _buildDropdownField(
              label: 'Room Type',
              hint: 'Select room type',
              icon: Icons.house_rounded,
              value: _selectedRoomType,
              items: _roomTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoomType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Title
            _buildTextField(
              controller: _roomTitleController,
              label: 'Title',
              hint: 'Enter room title (e.g., Room 3BHK)',
              icon: Icons.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _roomDescriptionController,
              label: 'Description',
              hint:
              'Enter description (e.g., Room 3BHK Near Takshashila College...)',
              icon: Icons.description_rounded,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Address
            _buildTextField(
              controller: _roomAddressController,
              label: 'Address',
              hint: 'Enter complete address (e.g., Jabalpur MP)',
              icon: Icons.location_on_rounded,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Price
            _buildTextField(
              controller: _roomPriceController,
              label: 'Price (per month)',
              hint: 'Enter monthly rent (e.g., 9500)',
              icon: Icons.currency_rupee_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Contact Number
            _buildTextField(
              controller: _roomContactController,
              label: 'Contact Number',
              hint: 'Enter contact number (e.g., 8989233770)',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact number';
                }
                if (value.length < 10) {
                  return 'Enter valid 10-digit number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Near College
            _buildTextField(
              controller: _roomNearCollegeController,
              label: 'Near College',
              hint: 'Enter nearby college name',
              icon: Icons.school_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter nearby college';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Amenities Section
            _buildAmenitiesSection(),
            const SizedBox(height: 16),

            // Booking Toggle
            _buildSwitchTile(
              icon: Icons.book_online_rounded,
              title: 'Available for Booking',
              value: _isRoomBooking,
              onChanged: (value) {
                setState(() {
                  _isRoomBooking = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Image Upload
            _buildImageUploadSection(
              images: _roomImages,
              onImagesSelected: (images) {
                setState(() {
                  _roomImages = images;
                });
              },
              label: 'Room Images',
            ),
            const SizedBox(height: 24),

            // Submit Button
            _buildSubmitButton(
              onPressed: _isLoading ? null : _submitRoomForm,
              label: 'Add Room',
            ),
            const SizedBox(height: 8),
            _buildRequiredText(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // AMENITIES SECTION
  // ============================================================
  Widget _buildAmenitiesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cleaning_services, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Amenities',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Amenities Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 4,
            children: [
              _buildAmenityCheckbox(
                label: 'WiFi',
                controller: _roomWifiController,
                icon: Icons.wifi,
              ),
              _buildAmenityCheckbox(
                label: 'AC',
                controller: _roomAcController,
                icon: Icons.ac_unit,
              ),
              _buildAmenityCheckbox(
                label: 'Parking',
                controller: _roomParkingController,
                icon: Icons.local_parking,
              ),
              _buildAmenityCheckbox(
                label: 'Security',
                controller: _roomSecurityController,
                icon: Icons.security,
              ),
              _buildAmenityCheckbox(
                label: 'Laundry',
                controller: _roomLaundryController,
                icon: Icons.local_laundry_service,
              ),
              _buildAmenityCheckbox(
                label: 'Water',
                controller: _roomWaterController,
                icon: Icons.water_drop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityCheckbox({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Row(
      children: [
        Checkbox(
          value: controller.text.toLowerCase() == 'true',
          onChanged: (value) {
            setState(() {
              controller.text = value == true ? 'true' : 'false';
            });
          },
          activeColor: AppColors.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TIFFIN FORM
  // ============================================================
  Widget _buildTiffinForm() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _tiffinFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              icon: Icons.restaurant_rounded,
              title: 'Tiffin Center Details',
              subtitle: 'Fill in the details to add a new tiffin center',
            ),
            const SizedBox(height: 24),

            // Title
            _buildTextField(
              controller: _tiffinTitleController,
              label: 'Title',
              hint: 'Enter tiffin center name (e.g., Sonu Tiffin Center)',
              icon: Icons.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter tiffin center name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _tiffinDescriptionController,
              label: 'Description',
              hint: 'Enter description (e.g., Best food provider...)',
              icon: Icons.description_rounded,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Price
            _buildTextField(
              controller: _tiffinPriceController,
              label: 'Price (per month)',
              hint: 'Enter price (e.g., 3000)',
              icon: Icons.currency_rupee_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Near College
            _buildTextField(
              controller: _tiffinNearCollegeController,
              label: 'Near College',
              hint:
              'Enter nearby college (e.g., Jabalpur Engineering College)',
              icon: Icons.school_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter nearby college';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Veg Type Dropdown
            _buildDropdownField(
              label: 'Is Veg',
              hint: 'Select veg availability',
              icon: Icons.eco,
              value: _selectedVegType,
              items: _vegOptions.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type == 'true' ? 'Yes' : 'No'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVegType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Non-Veg Type Dropdown
            _buildDropdownField(
              label: 'Is Non-Veg',
              hint: 'Select non-veg availability',
              icon: Icons.restaurant_menu,
              value: _selectedNonVegType,
              items: _nonVegOptions.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type == 'true' ? 'Yes' : 'No'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedNonVegType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Contact Number
            _buildTextField(
              controller: _tiffinContactController,
              label: 'Contact Number',
              hint: 'Enter contact number (e.g., 8989207770)',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact number';
                }
                if (value.length < 10) {
                  return 'Enter valid 10-digit number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Booking Toggle
            _buildSwitchTile(
              icon: Icons.book_online_rounded,
              title: 'Available for Booking',
              value: _isTiffinBooking,
              onChanged: (value) {
                setState(() {
                  _isTiffinBooking = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Image Upload
            _buildImageUploadSection(
              images: _tiffinImages,
              onImagesSelected: (images) {
                setState(() {
                  _tiffinImages = images;
                });
              },
              label: 'Tiffin Images',
            ),
            const SizedBox(height: 24),

            // Submit Button
            _buildSubmitButton(
              onPressed: _isLoading ? null : _submitTiffinForm,
              label: 'Add Tiffin Center',
            ),
            const SizedBox(height: 8),
            _buildRequiredText(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // IMAGE UPLOAD SECTION
  // ============================================================
  Widget _buildImageUploadSection({
    required List<File> images,
    required Function(List<File>) onImagesSelected,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Image preview
          if (images.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              images.removeAt(index);
                              onImagesSelected(images);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          const SizedBox(height: 8),
          // Upload button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _pickImages(onImagesSelected),
              icon: const Icon(Icons.upload_file),
              label: Text(images.isEmpty ? 'Upload Images' : 'Add More Images'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (images.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Upload at least one image (JPEG, PNG)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImages(Function(List<File>) onImagesSelected) async {
    try {
      final picker = ImagePicker();
      final List<XFile> pickedImages = await picker.pickMultiImage();

      if (pickedImages.isNotEmpty) {
        List<File> files = [];
        for (var image in pickedImages) {
          files.add(File(image.path));
        }
        onImagesSelected(files);
      }
    } catch (e) {
      FlutterToast.error('Error picking images: $e');
    }
  }

  // ============================================================
  // COMMON WIDGETS
  // ============================================================
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required dynamic value,
    required List<DropdownMenuItem<dynamic>> items,
    required void Function(dynamic)? onChanged,
    String? Function(dynamic)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<dynamic>(
        value: value,
        hint: Text(hint),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
        dropdownColor: Colors.white,
        isExpanded: true,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton({
    required VoidCallback? onPressed,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRequiredText() {
    return Center(
      child: Text(
        'All fields are required',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  // ============================================================
  // SUBMIT METHODS - USING EXISTING CONTROLLER METHODS
  // ============================================================

  void _submitRoomForm() {
    if (_roomFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userId = authController.getUserId.toString();
      List<String> imagePaths = [];
      for (var file in _roomImages) {
        imagePaths.add(file.path);
      }
      // Call existing roomController.createRoom method
      roomController
          .createRoom(
        userId: userId,
        title: _roomTitleController.text.trim(),
        description: _roomDescriptionController.text.trim(),
        address: _roomAddressController.text.trim(),
        price: _roomPriceController.text.trim(),
        roomType: _selectedRoomType,
        contactNumber: _roomContactController.text.trim(),
        wifi: _roomWifiController.text.toLowerCase() == 'true',
        ac: _roomAcController.text.toLowerCase() == 'true',
        parking: _roomParkingController.text.toLowerCase() == 'true',
        security: _roomSecurityController.text.toLowerCase() == 'true',
        laundry: _roomLaundryController.text.toLowerCase() == 'true',
        water: _roomWaterController.text.toLowerCase() == 'true',
        nearCollege: _roomNearCollegeController.text.trim(),
        imagePaths:imagePaths,
      )
          .then((success) {
        setState(() {
          _isLoading = false;
        });
        if (success) {
          Navigator.pop(context);
        }
      })
          .catchError((error) {
        setState(() {
          _isLoading = false;
        });
        FlutterToast.error('Error: $error');
      });
    }
  }

  void _submitTiffinForm() {
    if (_tiffinFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userId = authController.getUserId.toString();

      // Call existing tiffinController.createTiffin method
      tiffinController
          .createTiffin(
        title: _tiffinTitleController.text.trim(),
        description: _tiffinDescriptionController.text.trim(),
        price: _tiffinPriceController.text.trim(),
        nearCollege: _tiffinNearCollegeController.text.trim(),
        isVeg: _selectedVegType,
        isNonveg: _selectedNonVegType,
        contactNumber: _tiffinContactController.text.trim(),
        userId: userId,
        images: _tiffinImages,
      )
          .then((success) {
        setState(() {
          _isLoading = false;
        });
        if (success) {
          Navigator.pop(context);
        }
      })
          .catchError((error) {
        setState(() {
          _isLoading = false;
        });
        FlutterToast.error('Error: $error');
      });
    }
  }
}