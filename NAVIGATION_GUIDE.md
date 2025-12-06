# Navigation & Routes Setup

## Structure Overview

The app now uses a **route-based navigation system** with a **bottom navigation bar** for authenticated users.

## Route Configuration

### File: `app/config/routes/app_routes.dart`

All routes are centrally defined:

```dart
class AppRoutes {
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';

  // Main Routes (Protected)
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String gymClasses = '/gym-classes';
  static const String membership = '/membership';
  static const String profile = '/profile';
}
```

### Navigation Helpers

Use the helper methods for navigation:

```dart
// Navigate to register
AppRoutes.navigateToRegister(context);

// Navigate to profile
AppRoutes.navigateToProfile(context);
```

## Bottom Navigation

### File: `app/widgets/main_navigation.dart`

The `MainNavigation` widget manages the bottom navigation bar with 4 tabs:

1. **Dashboard** - Main landing page after login
2. **Classes** - Gym classes listing
3. **Membership** - Membership packages and status
4. **Profile** - User profile and settings

### Usage

After successful authentication, users are automatically directed to `MainNavigation` which shows:
- Dashboard page by default
- Bottom navigation bar to switch between pages
- Each page persists its state using `IndexedStack`

## Authentication Flow

```
App Start
   ↓
Check Token
   ↓
┌──────────────┬─────────────┐
│ Has Token    │ No Token    │
↓              ↓             
MainNavigation LoginPage
(Dashboard)    
   ↓              ↓
Bottom Nav     Register
```

## Pages

### Dashboard Page
**File:** `app/modules/dashboard/screens/dashboard_page.dart`

Features:
- Welcome card with user info
- Quick stats (Workouts, Calories, Hours, Streak)
- Membership status card
- Quick action buttons

### Gym Classes Page
**File:** `app/modules/gym_classes/screens/gym_classes_page.dart`

Status: Placeholder (Coming Soon)

### Membership Page
**File:** `app/modules/membership/screens/membership_page.dart`

Status: Placeholder (Coming Soon)

### Profile Page
**File:** `app/modules/profile/screens/profile_page.dart`

Features:
- User avatar and basic info
- Account details (phone, membership, email verification)
- Action buttons (Edit Profile, Change Password, Settings)
- Logout button in app bar

## Running on Chrome

To run the app on Chrome with disabled web security (for API calls):

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

Or use the regular command:

```bash
flutter run -d chrome
```

## Adding New Pages

1. Create the page in appropriate module folder:
   ```
   lib/app/modules/your_module/screens/your_page.dart
   ```

2. Add route constant in `app_routes.dart`:
   ```dart
   static const String yourPage = '/your-page';
   ```

3. Add route case in `generateRoute`:
   ```dart
   case yourPage:
     return MaterialPageRoute(builder: (_) => const YourPage());
   ```

4. Add navigation helper:
   ```dart
   static void navigateToYourPage(BuildContext context) {
     Navigator.pushNamed(context, yourPage);
   }
   ```

## Adding to Bottom Navigation

To add a new tab to the bottom navigation:

1. Add the page to `_pages` list in `main_navigation.dart`
2. Add a new `BottomNavigationBarItem` to the `items` list
3. The navigation will automatically work with the index

## State Management

- **AuthBloc** manages authentication state globally
- Bottom navigation preserves page state using `IndexedStack`
- Each page can access user data via `BlocBuilder<AuthBloc, AuthState>`

## Example: Accessing User Data

```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthAuthenticated) {
      final user = state.user;
      return Text('Welcome, ${user.name}');
    }
    return CircularProgressIndicator();
  },
)
```

## Folder Structure

```
lib/
├── app/
│   ├── config/
│   │   └── routes/
│   │       └── app_routes.dart
│   ├── modules/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── gym_classes/
│   │   ├── membership/
│   │   └── profile/
│   └── widgets/
│       └── main_navigation.dart
└── main.dart
```
