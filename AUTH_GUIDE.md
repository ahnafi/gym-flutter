# Authentication Implementation Guide

## Overview
This authentication system uses **BLoC (Business Logic Component)** pattern with **Repository pattern** to handle login and register functionality. Users can only access protected resources after successful authentication.

## Architecture

```
├── lib/
│   ├── app/
│   │   ├── core/
│   │   │   └── services/
│   │   │       └── user_info.dart          # Session management (SharedPreferences)
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user.dart               # User model
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart    # API calls & data transformation
│   │   │   └── providers/
│   │   │       └── api_routes.dart         # API endpoint constants
│   │   └── modules/
│   │       ├── auth/
│   │       │   ├── bloc/
│   │       │   │   ├── auth_bloc.dart      # Business logic
│   │       │   │   ├── auth_event.dart     # User actions
│   │       │   │   └── auth_state.dart     # UI states
│   │       │   └── screens/
│   │       │       ├── login_page.dart     # Login UI
│   │       │       └── register_page.dart  # Register UI
│   │       └── home/
│   │           └── screens/
│   │               └── home_page.dart      # Protected home screen
│   └── main.dart                           # App entry & auth wrapper
```

## How It Works

### 1. **App Startup** (`main.dart`)
```dart
void main() {
  runApp(const MyApp());
}
```

- App starts with `AuthCheckRequested` event
- BLoC checks if user has saved token in SharedPreferences
- If token exists → fetch profile → navigate to HomePage
- If no token → navigate to LoginPage

### 2. **Login Flow**

**User Action:**
```
User enters email & password → Taps Login button
```

**BLoC Flow:**
```
LoginPage → AuthLoginRequested event
         ↓
    AuthBloc receives event
         ↓
    Emits AuthLoading state
         ↓
    Calls AuthRepository.login()
         ↓
    Repository makes API call
         ↓
    On success: Save token & user ID
         ↓
    Emits AuthAuthenticated state
         ↓
    AuthWrapper detects state change
         ↓
    Navigates to HomePage
```

### 3. **Register Flow**

**User Action:**
```
User fills form → Taps Register button
```

**BLoC Flow:**
```
RegisterPage → AuthRegisterRequested event
           ↓
      AuthBloc receives event
           ↓
      Emits AuthLoading state
           ↓
      Calls AuthRepository.register()
           ↓
      Repository makes API call
           ↓
      On success: Save token & user ID
           ↓
      Emits AuthAuthenticated state
           ↓
      Pop back to LoginPage
           ↓
      AuthWrapper navigates to HomePage
```

### 4. **Logout Flow**

**User Action:**
```
User taps Logout → Confirms dialog
```

**BLoC Flow:**
```
HomePage → AuthLogoutRequested event
       ↓
  AuthBloc receives event
       ↓
  Calls AuthRepository.logout()
       ↓
  Clear token from SharedPreferences
       ↓
  Make logout API call (optional)
       ↓
  Emits AuthUnauthenticated state
       ↓
  AuthWrapper navigates to LoginPage
```

### 5. **Protected Resources**

All pages after login are **protected** because:

1. **AuthWrapper** in `main.dart` checks authentication state
2. If `AuthUnauthenticated` → shows LoginPage
3. If `AuthAuthenticated` → shows HomePage
4. All API calls use token from SharedPreferences

**Example protected API call:**
```dart
Future<Data> getData() async {
  final token = await UserInfo().getToken();
  
  final response = await http.get(
    Uri.parse(ApiUrl.someEndpoint),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  
  return Data.fromJson(json.decode(response.body));
}
```

## Key Components

### **User Model** (`user.dart`)
Maps Laravel User model to Dart with all fields:
- Basic info: id, name, email, phone
- Role: member, trainer, admin
- Membership status & dates
- Profile image & bio
- Email verification status

### **UserInfo Service** (`user_info.dart`)
Session management using SharedPreferences:
- `setToken(String)` - Save auth token
- `getToken()` - Retrieve auth token
- `setUserID(int)` - Save user ID
- `getUserID()` - Retrieve user ID
- `logout()` - Clear all session data

### **AuthRepository** (`auth_repository.dart`)
Handles all authentication API calls:
- `login()` - Login with email/password
- `register()` - Create new account
- `logout()` - Logout user
- `getProfile()` - Fetch user profile
- `isLoggedIn()` - Check auth status

### **AuthBloc** (`auth_bloc.dart`)
Manages authentication business logic:
- Receives events from UI
- Calls repository methods
- Emits states to UI
- Handles success/error cases

### **AuthState** (`auth_state.dart`)
Possible UI states:
- `AuthInitial` - App just started
- `AuthLoading` - Processing request
- `AuthAuthenticated` - User logged in
- `AuthUnauthenticated` - User not logged in
- `AuthError` - Error occurred

### **AuthEvent** (`auth_event.dart`)
User actions:
- `AuthLoginRequested` - Login attempt
- `AuthRegisterRequested` - Register attempt
- `AuthLogoutRequested` - Logout request
- `AuthCheckRequested` - Check if logged in

## API Integration

### Base URL Configuration
Update in `api_routes.dart`:
```dart
static const String baseUrl = 'https://your-api-domain.com/api/v1';
```

### Expected API Response Format

**Login/Register Success:**
```json
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "token": "Bearer_token_here",
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      ...
    }
  }
}
```

**Error Response:**
```json
{
  "status": "error",
  "message": "Invalid credentials",
  "errors": {
    "email": ["The email field is required."]
  }
}
```

## Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter_bloc: ^8.1.6      # State management
  equatable: ^2.0.5         # Value comparison for events/states
  http: ^1.1.0              # HTTP requests
  shared_preferences: ^2.0.11  # Local storage
```

## Usage Example

### Creating a Protected Page

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/modules/auth/bloc/auth_bloc.dart';

class MyProtectedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          
          return Scaffold(
            appBar: AppBar(title: Text('Welcome ${user.name}')),
            body: Center(
              child: Text('This is protected content'),
            ),
          );
        }
        
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
```

### Making Authenticated API Calls

```dart
// In your repository
Future<List<Membership>> getMemberships() async {
  final token = await UserInfo().getToken();
  
  final response = await http.get(
    Uri.parse(ApiUrl.myMemberships),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['data'] as List)
        .map((json) => Membership.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load memberships');
  }
}
```

## Testing

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Register a new account:**
   - Fill in name, email, and password
   - Tap Register button
   - Should automatically login and navigate to HomePage

3. **Logout:**
   - Tap logout icon in HomePage
   - Should navigate back to LoginPage

4. **Login:**
   - Enter email and password
   - Tap Login button
   - Should navigate to HomePage

## Error Handling

The system handles:
- Network errors (No internet)
- Validation errors (from API)
- Authentication errors (Invalid credentials)
- Session expiration

All errors are displayed using SnackBar.

## Security Notes

1. **Token Storage**: Stored in SharedPreferences (consider using flutter_secure_storage for production)
2. **Password**: Never stored locally, only sent during login/register
3. **HTTPS**: Ensure your API uses HTTPS in production
4. **Token Expiration**: Implement token refresh logic for better UX

## Next Steps

To add more features:
1. **Forgot Password**: Add reset password flow
2. **Email Verification**: Add email verification screen
3. **Profile Update**: Add edit profile page
4. **Token Refresh**: Implement automatic token refresh
5. **Biometric Auth**: Add fingerprint/face login

## Troubleshooting

**"No internet connection" error:**
- Check your API base URL
- Ensure device has internet
- Check if API server is running

**"Invalid credentials" error:**
- Verify email/password are correct
- Check API is returning proper response format

**App stuck on loading:**
- Check console for errors
- Verify API endpoints are correct
- Clear app data and try again
