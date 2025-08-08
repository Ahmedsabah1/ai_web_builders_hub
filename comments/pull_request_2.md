تم العثور على بعض مشاكل في كود Flutter أثناء تشغيل flutter analyze. إليك الملخص والحلول المقترحة:

## المشاكل الرئيسية:

### 1. Warning: استيراد غير مستخدم
- **الملف:** `lib/data/repositories/auth_repository.dart`
- **المشكلة:** `Unused import: 'package:supabase_flutter/supabase_flutter.dart'`
- **الحل:** احذف السطر غير المستخدم

### 2. Deprecated API Usage
- **الملف:** `lib/core/themes/app_theme.dart` (السطران 32 و 126)
- **المشكلة:** استخدام `background` المهجور
- **الحل:** استبدل `background` بـ `surface`

### 3. Context Usage Across Async Gaps
- **الملفات:** 
  - `lib/presentation/screens/categories/category_tools_screen.dart`
  - `lib/presentation/screens/favorites/favorites_screen.dart`
  - `lib/presentation/screens/tools/tools_grid_screen.dart`
- **الحل:** احفظ البيانات المطلوبة قبل العمليات غير المتزامنة

### 4. Performance Issues
- مشاكل متعددة مع `prefer_const_constructors`
- **الحل:** أضف `const` للـ constructors حيثما أمكن

هل تريد مني إصلاح هذه المشاكل في pull request منفصل؟