# Blog Screen with TipTap Renderer - Navigation Guide

## Route Information

**Route Name:** `AppRoutes.blogScreen`  
**Route Path:** `/blog-screen`  
**Screen:** `BlogScreen`

## How to Navigate to Blog Screen with TipTap Content

### Method 1: Using the Helper Class (Recommended)

```dart
import 'package:bandhucare_new/presentation/blog_screen/data/blog_screen_navigation_example.dart';

// Simple one-line navigation with sample data
BlogScreenNavigationExample.navigateWithTiptapContent();
```

### Method 2: Direct Navigation

```dart
import 'package:bandhucare_new/presentation/blog_screen/data/sample_tiptap_data.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:get/get.dart';

Get.toNamed(
  AppRoutes.blogScreen,
  arguments: {
    'title': 'Getting Started with TipTap',
    'author': 'TipTap Team',
    'date': 'Nov 09, 2025',
    'tiptapContent': SampleTiptapData.sampleDocument,
    'tags': ['Tutorial', 'Documentation', 'Getting Started'],
  },
);
```

### Method 3: From Any Screen

Add this button/widget to any screen:

```dart
ElevatedButton(
  onPressed: () {
    BlogScreenNavigationExample.navigateWithTiptapContent();
  },
  child: Text('View TipTap Blog'),
)
```

## Testing Locations

You can add a test button in these existing screens:

1. **Home Screen** (`lib/presentation/home_screen/home_screen.dart`)
2. **CareHub Home Screen** (`lib/presentation/carehub_home_screen/carehub_home_screen.dart`)
3. **Content Type Home Screen** (`lib/presentation/content_type_home_screen/content_type_home_screen.dart`)

## Quick Test Button Code

Add this anywhere in your app for quick testing:

```dart
import 'package:bandhucare_new/presentation/blog_screen/data/blog_screen_navigation_example.dart';

// In your widget's build method:
FloatingActionButton(
  onPressed: BlogScreenNavigationExample.navigateWithTiptapContent,
  child: Icon(Icons.article),
  tooltip: 'Test TipTap Blog',
)
```

