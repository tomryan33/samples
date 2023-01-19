library libraries;

// Third-Party Libraries
export 'dart:io';
export 'package:flutter/material.dart';
export 'package:animated_splash_screen/animated_splash_screen.dart';
export 'package:page_transition/page_transition.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:provider/provider.dart';
export 'package:flutter/services.dart';
export 'dart:convert';
export 'package:url_launcher/url_launcher.dart';
export 'package:image_picker/image_picker.dart';
export 'package:path_provider/path_provider.dart';

// Amplify
export 'package:amplify_flutter/amplify_flutter.dart';
export 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
export 'package:amplify_datastore/amplify_datastore.dart';
export 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
export 'package:amplify_api/amplify_api.dart';
export 'package:amplify_storage_s3/amplify_storage_s3.dart';

// Server
export 'package:dlt_app/server/auth_service.dart';
export 'package:dlt_app/server/functions.dart';
export 'package:dlt_app/server/database_functions.dart';

// Models
export 'package:dlt_app/models/ModelProvider.dart';
export 'package:dlt_app/models/Users.dart';
export 'package:dlt_app/models/UserDetails.dart';
export 'package:dlt_app/models/UserMeta.dart';
export 'package:dlt_app/models/ContentGroups.dart';
export 'package:dlt_app/models/Content.dart';
export 'package:dlt_app/models/ChatRooms.dart';
export 'package:dlt_app/models/Chats.dart';
export 'package:dlt_app/models/Classes.dart';
export 'package:dlt_app/models/Courses.dart';

// Utilities
export 'package:dlt_app/utils/theme_colors.dart';
export 'package:dlt_app/utils/input.dart';
export 'package:dlt_app/utils/logos.dart';
export 'package:dlt_app/utils/text.dart';
export 'package:dlt_app/utils/buttons.dart';
export 'package:dlt_app/amplifyconfiguration.dart';
export 'package:dlt_app/utils/route_arguments.dart';

export 'package:dlt_app/utils/build_dummy_data.dart';

// Widgets
export 'package:dlt_app/widgets/footer.dart';
export 'package:dlt_app/widgets/nav.dart';
export 'package:dlt_app/widgets/page_wrap.dart';
export 'package:dlt_app/widgets/alert.dart';
export 'package:dlt_app/widgets/dropdown.dart';
export 'package:dlt_app/widgets/chat_bubble.dart';
export 'package:dlt_app/widgets/chat_input.dart';
export 'package:dlt_app/widgets/avatar_image.dart';

// Pages
export 'package:dlt_app/main.dart';
export 'package:dlt_app/login_page.dart';
export 'package:dlt_app/signup_page.dart';
export 'package:dlt_app/password_reset_page.dart';
export 'package:dlt_app/totd_page.dart';
export 'package:dlt_app/contact_us_page.dart';
export 'package:dlt_app/rooms_page.dart';
export 'package:dlt_app/chats_page.dart';
export 'package:dlt_app/profile_page.dart';
export 'package:dlt_app/team_members_page.dart';
export 'package:dlt_app/classes_page.dart';

// Admin Pages
export 'package:dlt_app/admin/admin_page.dart';
export 'package:dlt_app/admin/admin_totd_page.dart';
export 'package:dlt_app/admin/admin_courses_page.dart';
export 'package:dlt_app/admin/admin_classes_page.dart';
export 'package:dlt_app/admin/admin_users_page.dart';
export 'package:dlt_app/admin/admin_nominations_page.dart';
export 'package:dlt_app/admin/admin_nomination_page.dart';
export 'package:dlt_app/admin/admin_rooms_page.dart';