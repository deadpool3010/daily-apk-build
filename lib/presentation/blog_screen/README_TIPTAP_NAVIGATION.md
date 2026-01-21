# 📖 TipTap Blog Screen - Navigation Instructions

## 🎯 Quick Start

### Route Information
- **Route Constant:** `AppRoutes.blogScreen`
- **Route Path:** `/blog-screen`
- **Screen Class:** `BlogScreen`

---

## 🚀 Method 1: Quick Test Button (Easiest)

Add this button to any screen:

```dart
import 'package:bandhucare_new/presentation/blog_screen/widgets/test_tiptap_button.dart';

// In your widget tree:
TestTiptapButton()
```

Or use the helper method:

```dart
import 'package:bandhucare_new/presentation/blog_screen/data/blog_screen_navigation_example.dart';

// In onPressed:
BlogScreenNavigationExample.navigateWithTiptapContent();
```

---

## 🚀 Method 2: Direct Navigation with Sample Data

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
    'tags': ['Tutorial', 'Documentation'],
  },
);
```

---

## 🚀 Method 3: Custom TipTap Content

```dart
import 'package:bandhucare_new/presentation/blog_screen/data/blog_screen_navigation_example.dart';

BlogScreenNavigationExample.navigateWithCustomTiptapContent(
  title: 'My Custom Article',
  author: 'John Doe',
  date: 'Nov 10, 2025',
  tiptapDocument: {
    "type": "doc",
    "content": [
      {
        "type": "heading",
        "attrs": {"level": 1},
        "content": [{"type": "text", "text": "My Title"}]
      },
      // ... more content
    ]
  },
  tags: ['Custom', 'Article'],
);
```

---

## 🚀 Method 4: From JSON String (API Response)

```dart
import 'package:bandhucare_new/presentation/blog_screen/data/blog_screen_navigation_example.dart';

BlogScreenNavigationExample.navigateWithTiptapJsonString(
  title: 'Article from API',
  author: 'API Author',
  date: 'Nov 09, 2025',
  tiptapJsonString: '{"type":"doc","content":[...]}',
  tags: ['API', 'Article'],
);
```

---

## 📍 Where to Add Test Button

### Option A: Home Screen
**File:** `lib/presentation/home_screen/home_screen.dart`

Add this in the build method:

```dart
import 'package:bandhucare_new/presentation/blog_screen/widgets/test_tiptap_button.dart';

// Add anywhere in your widget tree:
TestTiptapButton()
```

### Option B: CareHub Home Screen
**File:** `lib/presentation/carehub_home_screen/carehub_home_screen.dart`

Same as above - just add `TestTiptapButton()` widget.

### Option C: Floating Action Button (Anywhere)

```dart
import 'package:bandhucare_new/presentation/blog_screen/data/blog_screen_navigation_example.dart';

Scaffold(
  floatingActionButton: FloatingActionButton(
    onPressed: BlogScreenNavigationExample.navigateWithTiptapContent,
    child: Icon(Icons.article),
    tooltip: 'Test TipTap Blog',
  ),
  // ... rest of your scaffold
)
```

---

## ✅ What You'll See

When you navigate to the blog screen with TipTap content, you'll see:

- ✅ **Headings** (H1, H2, etc.) with proper styling
- ✅ **Paragraphs** with text alignment
- ✅ **Bold, Italic, Strike** text formatting
- ✅ **Highlighted** text (yellow/blue backgrounds)
- ✅ **Links** (tappable, opens in browser)
- ✅ **Code blocks** with monospace font
- ✅ **Blockquotes** with left border
- ✅ **Bullet lists** with proper indentation
- ✅ **Task lists** with checkboxes
- ✅ **Horizontal rules** (dividers)
- ✅ **Superscript/Subscript** text

---

## 🔧 Testing Checklist

- [ ] Navigate to blog screen using any method above
- [ ] Verify all headings render correctly
- [ ] Check text formatting (bold, italic, etc.)
- [ ] Test links (tap to open in browser)
- [ ] Verify code blocks display properly
- [ ] Check bullet lists render correctly
- [ ] Verify task lists show checkboxes
- [ ] Test blockquotes display with border
- [ ] Check horizontal rules appear

---

## 📝 Notes

- The blog screen automatically detects TipTap JSON in `tiptapContent` or `content` fields
- If no TipTap content is provided, it falls back to static text view
- All renderers are registered automatically when `BlogScreenController` initializes
- Unknown node types are handled gracefully (rendered as empty widgets)

---

## 🆘 Troubleshooting

**Issue:** Blog screen shows static text instead of TipTap content
- **Solution:** Make sure you're passing `tiptapContent` in the arguments map

**Issue:** Some nodes not rendering
- **Solution:** Check that the node type is registered in `tiptap_renderer_registration.dart`

**Issue:** Links not working
- **Solution:** Ensure `url_launcher` package is properly configured in `pubspec.yaml`

