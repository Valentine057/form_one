import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.setupYourProfile,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50], // Light Gray background
        colorScheme: ColorScheme.light(
          primary: Colors.lightBlue, // Sky Blue primary
          secondary: const Color(0xFFFFD700), // Gold
          surface: Colors.white,
          onSurface: Colors.grey[900]!,
        ),
        useMaterial3: true,
        // Override input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.lightBlue)),
        ),
      ),
      home: const ProfileSetupPage(),
    );
  }
}

class AppStrings {
  static const String setupYourProfile = "Setup Your Profile";
  static const String username = "Username";
  static const String usernameDesc = "Choose a unique username that represents you. It must start with a letter or underscore.";
  static const String educationalRank = "Educational Rank *";
  static const String educationalRankDesc = "Select your current educational status to connect with the right community.";
  static const String institutionName = "Institution name *";
  static const String institutionNameDesc = "Add your school or university to find classmates and campus activities.";
  static const String addPhoto = "Add photo";
  static const String addPhotoDesc = "Add profile and cover photos to personalize your profile. Photos upload instantly!";
  static const String completeProfileMessage = "Complete your profile to unlock all features and connect with your campus community.";
  static const String student = "Student";
  static const String institutionNotFound = "Institution not found? Add it!";
  static const String courseOfStudy = "Course of study *";
  static const String currentYear = "Current year (Level)";
  static const String save = "Save";
  static const String profileTips = "Profile Tips";
  static const String chooseWisely = "Choose Wisely";
  static const String chooseWiselyDesc = "Your username is permanent and identifies you across the platform.";
  static const String beAuthentic = "Be Authentic";
  static const String beAuthenticDesc = "Use your real educational details to connect with genuine peers.";
  static const String qualityPhotos = "Quality Photos";
  static const String qualityPhotosDesc = "Upload clear photos for better recognition within your campus.";
  static const String profileBenefits = "Profile Benefits";
  static const String connectWithPeers = "Connect with peers";
  static const String joinCampusEvents = "Join campus events";
  static const String accessDiscussions = "Access discussions";
  static const String unlockPremiumFeatures = "Unlock premium features";
  static const String proTip = "Pro Tip";
  static const String proTipDesc = "Complete all fields to maximize your profile visibility and get the most out of AllCampus!";
}

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  int _selectedIndex = 1;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  void _onStepSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _addPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _addText() {
    // Logic to add text would go here. For UI demo:
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add Text (Blue Icon) Clicked")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1000) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: LeftPanel(
                      selectedIndex: _selectedIndex,
                      onStepSelected: _onStepSelected,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: CenterPanel(
                      onAddPhoto: _addPhoto,
                      onAddText: _addText,
                      profileImage: _profileImage,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                const Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: RightPanel(),
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    LeftPanel(
                      selectedIndex: _selectedIndex,
                      onStepSelected: _onStepSelected,
                    ),
                    const SizedBox(height: 24),
                    CenterPanel(
                      onAddPhoto: _addPhoto,
                      onAddText: _addText,
                      profileImage: _profileImage,
                    ),
                    const SizedBox(height: 24),
                    const RightPanel(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class LeftPanel extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onStepSelected;

  const LeftPanel({
    super.key,
    required this.selectedIndex,
    required this.onStepSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.setupYourProfile, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[800])),
        const SizedBox(height: 16),
        _buildStepItem(context, 0, Icons.person, AppStrings.username, AppStrings.usernameDesc),
        _buildStepItem(context, 1, Icons.school, AppStrings.educationalRank, AppStrings.educationalRankDesc),
        _buildStepItem(context, 2, Icons.account_balance, AppStrings.institutionName, AppStrings.institutionNameDesc),
        _buildStepItem(context, 3, Icons.image, AppStrings.addPhoto, AppStrings.addPhotoDesc),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD700).withOpacity(0.1), // Gold tint
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFD700)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFFDAA520), size: 20), // Darker gold
              const SizedBox(width: 8),
              Expanded(child: Text(AppStrings.completeProfileMessage, style: TextStyle(fontSize: 12, color: Colors.grey[700]))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem(BuildContext context, int index, IconData icon, String title, String desc) {
    final bool isActive = index == selectedIndex;
    return GestureDetector(
      onTap: () => onStepSelected(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? Colors.lightBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? Border.all(color: Colors.lightBlue) : Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isActive ? Colors.lightBlue : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey[800]))),
                      if (isActive)
                         const Padding(
                           padding: EdgeInsets.only(left: 8.0),
                           child: Icon(Icons.check_circle, color: Colors.lightBlue, size: 16),
                         ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CenterPanel extends StatelessWidget {
  final VoidCallback onAddPhoto;
  final VoidCallback onAddText;
  final File? profileImage;

  const CenterPanel({
    super.key,
    required this.onAddPhoto,
    required this.onAddText,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[300], // Placeholder for cover
            ),
            GestureDetector(
              onTap: onAddPhoto,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                child: profileImage == null 
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_a_photo, color: Colors.grey, size: 24),
                        const SizedBox(height: 4),
                        const Text(AppStrings.addPhoto, style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    )
                  : null,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: GestureDetector(
                onTap: onAddText, // Blue icon with pen allows adding text
                child: CircleAvatar(radius: 16, backgroundColor: Colors.lightBlue, child: const Icon(Icons.edit, size: 16, color: Colors.white)),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: onAddText,
                child: CircleAvatar(radius: 16, backgroundColor: Colors.lightBlue, child: const Icon(Icons.edit, size: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildTextField(AppStrings.username, prefixIcon: Icons.alternate_email, hasError: true),
        const SizedBox(height: 16),
        _buildDropdown(AppStrings.student, Icons.settings),
        const SizedBox(height: 16),
        _buildTextField(AppStrings.institutionName, prefixIcon: Icons.account_balance, suffixIcon: Icons.search),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () {}, child: Text(AppStrings.institutionNotFound, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic))),
        ),
        _buildTextField(AppStrings.courseOfStudy, prefixIcon: Icons.school),
        const SizedBox(height: 16),
        _buildDropdown(AppStrings.currentYear, Icons.person_outline),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue, // Sky Blue button
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text(AppStrings.save),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, {IconData? prefixIcon, IconData? suffixIcon, bool hasError = false}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : (hasError ? const Icon(Icons.circle, color: Colors.red, size: 8) : null),
      ),
    );
  }

  Widget _buildDropdown(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[800]))),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.profileTips, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[800])),
        const SizedBox(height: 16),
        _buildTipItem(AppStrings.chooseWisely, AppStrings.chooseWiselyDesc, Icons.check_circle_outline, Colors.lightBlue),
        _buildTipItem(AppStrings.beAuthentic, AppStrings.beAuthenticDesc, Icons.verified_user_outlined, const Color(0xFFDAA520)), // Darker Gold
        _buildTipItem(AppStrings.qualityPhotos, AppStrings.qualityPhotosDesc, Icons.camera_alt_outlined, Colors.grey),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppStrings.profileBenefits, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[900])),
              const SizedBox(height: 16),
              _buildBenefitItem(AppStrings.connectWithPeers, Icons.people, Colors.lightBlue),
              _buildBenefitItem(AppStrings.joinCampusEvents, Icons.calendar_today, Colors.lightBlue),
              _buildBenefitItem(AppStrings.accessDiscussions, Icons.chat, Colors.lightBlue),
              _buildBenefitItem(AppStrings.unlockPremiumFeatures, Icons.star, const Color(0xFFFFD700)), // Gold
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFDAA520), Color(0xFFFFD700)]), // Gold gradient
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              const Icon(Icons.lightbulb_outline, size: 32, color: Colors.white),
              const SizedBox(height: 8),
              Text(AppStrings.proTip, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text(AppStrings.proTipDesc, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String title, String desc, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900])),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
