// lib/feature/college/screen/add_tiffin_center_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_color.dart';
import '../../../core/widget/flutter_toast.dart';

class AddTiffinCenterScreen extends StatefulWidget {
  const AddTiffinCenterScreen({super.key});

  @override
  State<AddTiffinCenterScreen> createState() => _AddTiffinCenterScreenState();
}

class _AddTiffinCenterScreenState extends State<AddTiffinCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Room Form Controllers
  final GlobalKey<FormState> _roomFormKey = GlobalKey<FormState>();
  final TextEditingController _roomTitleController = TextEditingController();
  final TextEditingController _roomDescriptionController = TextEditingController();
  final TextEditingController _roomPriceController = TextEditingController();
  final TextEditingController _roomContactController = TextEditingController();
  final TextEditingController _roomNearCollegeController = TextEditingController();
  final TextEditingController _roomAddressController = TextEditingController();
  final TextEditingController _roomBedroomsController = TextEditingController();
  final TextEditingController _roomBathroomsController = TextEditingController();
  final TextEditingController _roomAreaController = TextEditingController();
  String _selectedRoomType = 'PG';
  String _selectedFurnishing = 'Fully Furnished';
  String _selectedGender = 'Both';
  bool _isRoomBooking = false;

  // Tiffin Form Controllers
  final GlobalKey<FormState> _tiffinFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _nearCollegeController = TextEditingController();
  String _selectedVegType = 'Veg';
  String _selectedNonVegType = 'Non-Veg';
  bool _isBooking = false;
  bool _isLoading = false;

  // Options for Room
  final List<String> _roomTypes = ['PG', 'Flat', 'Hostel', 'Apartment', 'Villa'];
  final List<String> _furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished'
  ];
  final List<String> _genderOptions = ['Both', 'Male Only', 'Female Only'];

  // Options for Tiffin
  final List<String> _vegOptions = ['Veg', 'Non-Veg', 'Both'];
  final List<String> _nonVegOptions = ['Non-Veg', 'Veg', 'Both'];

  final List<String> _collegeList = [
    'Jabalpur Engineering College',
    'Netaji Subhash Medical College',
    'Rani Durgavati University',
    'Shri Ram Institute of Technology',
    'Global Institute of Technology',
  ];

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
    _roomBedroomsController.dispose();
    _roomBathroomsController.dispose();
    _roomAreaController.dispose();
    // Tiffin controllers
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _contactController.dispose();
    _nearCollegeController.dispose();
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
          // Room Form (First)
          _buildRoomForm(),
          // Tiffin Form (Second)
          _buildTiffinForm(),
        ],
      ),
    );
  }

  // ==================== ROOM FORM (FIRST) ====================
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

            // Room Title
            _buildTextField(
              controller: _roomTitleController,
              label: 'Room/PG Name',
              hint: 'Enter room or PG name',
              icon: Icons.storefront_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter room name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _roomDescriptionController,
              label: 'Description',
              hint: 'Enter description (e.g., amenities, rules)',
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
              label: 'Full Address',
              hint: 'Enter complete address',
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
              hint: 'Enter monthly rent',
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

            // Bedrooms & Bathrooms in Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _roomBedroomsController,
                    label: 'Bedrooms',
                    hint: 'e.g., 1, 2, 3',
                    icon: Icons.bed_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _roomBathroomsController,
                    label: 'Bathrooms',
                    hint: 'e.g., 1, 2',
                    icon: Icons.bathroom_rounded,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Area (sq ft)
            _buildTextField(
              controller: _roomAreaController,
              label: 'Area (sq ft)',
              hint: 'Enter area in square feet',
              icon: Icons.square_foot_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter area';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Near College
            _buildDropdownField(
              label: 'Near College',
              hint: 'Select nearby college',
              icon: Icons.school_rounded,
              value: _roomNearCollegeController.text.isEmpty
                  ? null
                  : _roomNearCollegeController.text,
              items: _collegeList.map((college) {
                return DropdownMenuItem<String>(
                  value: college,
                  child: Text(college),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _roomNearCollegeController.text = value ?? '';
                });
              },
              validator: (value) {
                if (_roomNearCollegeController.text.isEmpty) {
                  return 'Please select a nearby college';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Contact Number
            _buildTextField(
              controller: _roomContactController,
              label: 'Contact Number',
              hint: 'Enter contact number',
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

            // Furnishing Dropdown
            _buildDropdownField(
              label: 'Furnishing',
              hint: 'Select furnishing type',
              icon: Icons.chair_rounded,
              value: _selectedFurnishing,
              items: _furnishingOptions.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFurnishing = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Gender Preference
            _buildDropdownField(
              label: 'Gender Preference',
              hint: 'Select gender preference',
              icon: Icons.people_rounded,
              value: _selectedGender,
              items: _genderOptions.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
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

  // ==================== TIFFIN FORM (SECOND) ====================
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

            // Title Field
            _buildTextField(
              controller: _titleController,
              label: 'Tiffin Center Name',
              hint: 'Enter tiffin center name',
              icon: Icons.storefront_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter tiffin center name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter description (e.g., cuisine type, specialties)',
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

            // Price Field
            _buildTextField(
              controller: _priceController,
              label: 'Price (per meal)',
              hint: 'Enter price',
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

            // Contact Number Field
            _buildTextField(
              controller: _contactController,
              label: 'Contact Number',
              hint: 'Enter contact number',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contact number';
                }
                if (value.length < 10) {
                  return 'Please enter a valid 10-digit number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Near College Field with Dropdown
            _buildDropdownField(
              label: 'Near College',
              hint: 'Select nearby college',
              icon: Icons.school_rounded,
              value: _nearCollegeController.text.isEmpty
                  ? null
                  : _nearCollegeController.text,
              items: _collegeList.map((college) {
                return DropdownMenuItem<String>(
                  value: college,
                  child: Text(college),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _nearCollegeController.text = value ?? '';
                });
              },
              validator: (value) {
                if (_nearCollegeController.text.isEmpty) {
                  return 'Please select a nearby college';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Veg Type Dropdown
            _buildDropdownField(
              label: 'Veg Type',
              hint: 'Select veg type',
              icon: Icons.restaurant_rounded,
              value: _selectedVegType,
              items: _vegOptions.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
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
              label: 'Non-Veg Type',
              hint: 'Select non-veg type',
              icon: Icons.restaurant_menu_rounded,
              value: _selectedNonVegType,
              items: _nonVegOptions.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedNonVegType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Booking Toggle
            _buildSwitchTile(
              icon: Icons.book_online_rounded,
              title: 'Available for Booking',
              value: _isBooking,
              onChanged: (value) {
                setState(() {
                  _isBooking = value;
                });
              },
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

  // ==================== COMMON WIDGETS ====================

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
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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

  // ==================== SUBMIT METHODS ====================

  void _submitRoomForm() {
    if (_roomFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> roomData = {
        'type': 'room',
        'room_type': _selectedRoomType,
        'title': _roomTitleController.text.trim(),
        'description': _roomDescriptionController.text.trim(),
        'address': _roomAddressController.text.trim(),
        'price': _roomPriceController.text.trim(),
        'bedrooms': int.tryParse(_roomBedroomsController.text.trim()) ?? 0,
        'bathrooms': int.tryParse(_roomBathroomsController.text.trim()) ?? 0,
        'area': _roomAreaController.text.trim(),
        'near_college': _roomNearCollegeController.text.trim(),
        'contact_number': _roomContactController.text.trim(),
        'furnishing': _selectedFurnishing,
        'gender_preference': _selectedGender,
        'is_booking': _isRoomBooking,
      };

      print('📦 Room Data: $roomData');

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        FlutterToast.success('Room added successfully!');
        Navigator.pop(context);
      });
    }
  }

  void _submitTiffinForm() {
    if (_tiffinFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, dynamic> tiffinData = {
        'type': 'tiffin',
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': _priceController.text.trim(),
        'contact_number': _contactController.text.trim(),
        'near_college': _nearCollegeController.text.trim(),
        'is_veg': _selectedVegType == 'Veg' || _selectedVegType == 'Both',
        'is_nonveg': _selectedNonVegType == 'Non-Veg' || _selectedNonVegType == 'Both',
        'is_booking': _isBooking,
      };

      print('📦 Tiffin Data: $tiffinData');

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        FlutterToast.success('Tiffin center added successfully!');
        Navigator.pop(context);
      });
    }
  }
}