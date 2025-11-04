# Authentication System (UI Only)

## 📁 Module Structure

```
lib/modules/auth/
├── view/
│   ├── welcome_view.dart          # Welcome screen with login/signup options
│   ├── login_view.dart            # Login screen
│   ├── signup_view.dart           # Signup/registration screen
│   ├── forgot_password_view.dart  # Password reset screen
│   └── widgets/
│       └── custom_text_field.dart # Reusable input field widget
├── viewmodel/
│   └── auth_viewmodel.dart        # Auth logic and state management
└── binding/
    └── auth_binding.dart          # Dependency injection for auth module
```

## 🎨 Screens Overview

### 1. Welcome Screen (`/welcome`)
- **Features:**
  - App logo with gradient shadow effect
  - App name and tagline
  - "Sign In" button (primary)
  - "Create Account" button (outlined)
  - "Continue as Guest" option
- **Navigation:**
  - Sign In → Login Screen
  - Create Account → Signup Screen
  - Guest Mode → Main App (demo mode)

### 2. Login Screen (`/login`)
- **Features:**
  - Email input field
  - Password input field with visibility toggle
  - "Remember me" checkbox
  - "Forgot Password?" link
  - Primary "Sign In" button with loading state
  - Social login options (Google, Apple)
  - "Don't have an account? Sign Up" link
- **Dark Mode:** ✅ Full support
- **Validation:** ✅ Basic form validation

### 3. Signup Screen (`/signup`)
- **Features:**
  - Full name input field
  - Email input field
  - Password input field with visibility toggle
  - Confirm password input field with visibility toggle
  - Terms & Conditions and Privacy Policy links
  - Primary "Sign Up" button with loading state
  - Social signup options (Google, Apple)
  - "Already have an account? Sign In" link
- **Dark Mode:** ✅ Full support
- **Validation:** ✅ Password match validation

### 4. Forgot Password Screen (`/forgot-password`)
- **Features:**
  - Large lock reset icon
  - Descriptive subtitle
  - Email input field
  - "Send Reset Link" button with loading state
  - "Back to Sign In" link
- **Dark Mode:** ✅ Full support
- **Validation:** ✅ Email validation

## 🎯 Current State (UI Only)

All authentication methods are currently **UI only** and simulate API calls with:
- 2-second delay to mimic network requests
- Success/error snackbar notifications
- Navigation to main app on success
- Form validation before submission

### Methods Ready for Backend Integration:
```dart
// In AuthViewModel
Future<void> login()
Future<void> signup()
Future<void> forgotPassword()
Future<void> loginWithGoogle()
Future<void> loginWithApple()
```

## 🎨 Design Features

### Custom Text Field Widget
- Rounded corners (12px border radius)
- Prefix icons for context
- Optional suffix icons (e.g., password visibility toggle)
- Full dark mode support
- Focus states with primary color
- Error states with red color
- Smooth transitions

### Button Styles
- **Primary Button:** Solid primary color, white text, 56px height
- **Outlined Button:** Border with primary color, transparent background
- **Text Button:** Minimal style for secondary actions
- **Loading State:** Circular progress indicator replaces button text

### Color Scheme
- **Light Mode:** Grey backgrounds, black text, primary color accents
- **Dark Mode:** Dark backgrounds (#1E1E1E, #2A2A2A), white/grey text
- **Primary Color:** Theme-based (customizable)

## 📱 User Flow

```
Splash Screen
    ↓
Onboarding (first time only)
    ↓
Welcome Screen
    ├─→ Login Screen
    │       ├─→ Forgot Password
    │       ├─→ Main App (on success)
    │       └─→ Signup Screen
    └─→ Signup Screen
            ├─→ Main App (on success)
            └─→ Login Screen
```

## 🔧 Integration Points

### Routes Added:
- `/welcome` - Welcome screen
- `/login` - Login screen
- `/signup` - Signup screen
- `/forgot-password` - Password reset screen

### Updated Navigation:
- Onboarding now routes to Welcome screen
- Splash screen can route to Welcome if not authenticated

## 🚀 Next Steps (Backend Integration)

1. **Firebase Authentication:**
   ```dart
   // Replace in AuthViewModel
   await FirebaseAuth.instance.signInWithEmailAndPassword(
     email: loginEmailController.text,
     password: loginPasswordController.text,
   );
   ```

2. **Google Sign-In:**
   ```dart
   // Add google_sign_in package
   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
   ```

3. **Apple Sign-In:**
   ```dart
   // Add sign_in_with_apple package
   final credential = await SignInWithApple.getAppleIDCredential(...);
   ```

4. **Form Validation:**
   - Add email format validation
   - Add password strength requirements
   - Add proper error messages

5. **State Persistence:**
   - Save auth token
   - Remember me functionality
   - Auto-login on app restart

## ✨ Features

- ✅ Modern, clean UI design
- ✅ Full dark mode support
- ✅ Smooth animations and transitions
- ✅ Loading states on all buttons
- ✅ Form validation
- ✅ Password visibility toggles
- ✅ Social login buttons (UI ready)
- ✅ Responsive layout
- ✅ Material 3 design principles
- ✅ GetX state management
- ✅ Error handling with snackbars

## 🎨 UI Highlights

- **Gradient Logo:** Primary color gradient with shadow
- **Custom Input Fields:** Consistent styling across all forms
- **Social Login:** Google and Apple buttons ready
- **Guest Mode:** Quick access for demo purposes
- **Forgot Password:** Dedicated flow for password recovery
- **Terms & Privacy:** Links ready for legal documents

## 📝 Notes

- All UI elements are fully functional
- Backend integration points are clearly marked
- Forms include basic validation
- Loading states prevent double submissions
- Navigation flows are complete
- Dark mode tested and working
- Ready for Firebase integration
