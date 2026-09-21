# شرح تعديلات MediaQuery

`MediaQuery.sizeOf(context)` يعطينا أبعاد نافذة التطبيق بوحدات Flutter المنطقية، ويعيد بناء الواجهة عند تغير أبعادها.
المصدر: https://api.flutter.dev/flutter/widgets/MediaQuery/sizeOf.html

## المعادلة
أضفت `responsiveWidth` إلى `lib/core/extensions/screen_context_extension.dart`:

```dart
double responsiveWidth(double designWidth) =>
    designWidth * (screenSize.shortestSide / 375).clamp(0.0, 1.2);
```

375 عرض مرجعي اخترته للحساب، وليس قياسًا مؤكدًا من ملف التصميم. عند عرض 375 يبقى المقاس الأصلي؛ وعند عرض 320 يصبح عرض صورة 344 نحو 293.5؛ وعلى التابلت لا يتجاوز 412.8. `clamp` يمنع التكبير المفرط. استخدمت أقصر ضلع حتى لا تكبر العناصر فجأة عند تدوير الهاتف.

## جميع الملفات والتعديلات
المسارات أدناه داخل lib، باستثناء الاختبارات.

| الملف | التعديل |
| --- | --- |
| core/extensions/screen_context_extension.dart | إضافة دالة القياس المشتركة المعتمدة على MediaQuery؛ الإبقاء على screenSize وtheme. |
| features/auth/presentation/views/widgets/auth_illustration.dart | عنصر مشترك جديد: عرض متجاوب، مع LayoutBuilder لتحديد عرض الأب، وAspectRatio لحفظ نسبة الصورة إلى ارتفاعها الأصلي 256. |
| features/auth/presentation/views/congratulations_view.dart | استبدال صندوق الصورة 344×256 بـ AuthIllustration. |
| features/auth/presentation/views/create_new_password_view.dart | استبدال صندوق الصورة 345×256 بالعنصر نفسه. |
| features/auth/presentation/views/forgot_password_view.dart | استبدال صندوق الصورة 229×256 بالعنصر نفسه. |
| features/auth/presentation/views/verification_code_view.dart | استبدال صندوق الصورة 249×256 بالعنصر نفسه. |
| features/auth/presentation/views/widgets/otp_code_field.dart | حساب حجم خلايا الرمز من الشاشة والمساحة المتاحة وعدد الخانات؛ حجز 8 وحدات بين الخلايا. |
| features/profile/presentation/views/widgets/profile_header.dart | جعل الصورة 123×123 وارتفاع الترويسة ومواضع الصورة والاسم وارتفاع المدارات ومواقع النقاط تتغير مع معامل القياس. |
| features/profile/presentation/views/widgets/profile_menu_tile.dart | تعديل صف القائمة وصف التبديل: استبدال ارتفاع 52 الثابت بحد أدنى محسوب، لا يقل عن 48 ولا يزيد عن 64؛ يمكن للصف أن يصبح أطول حسب النص. |
| features/cart/presentation/views/widgets/cart_product_card.dart | جعل صورة المنتج 108×112 تتغير بالمعامل نفسه لحفظ نسبتها. |
| features/product_details/presentation/views/widgets/product_image_gallery.dart | حساب ارتفاع الصورة الرئيسية بدل تثبيته عند 285. |
| features/product_details/presentation/views/widgets/product_purchase_bar.dart | حساب عرض منطقة السعر بدل تثبيته عند 112. |
| features/home/presentation/views/widgets/home_collection_card.dart | حساب عرض بطاقة القسم/العلامة بدل تثبيته عند 112. |
| features/home/presentation/views/widgets/home_message.dart | حساب عرض زر الإجراء بدل تثبيته عند 160. |
| test/responsive_layout_test.dart | اختبار نسبة الصورة ضمن أب ضيق بأحجام شاشات مختلفة، واختبار نص كبير متعدد الأسطر في صف الملف الشخصي. |

`quantity_selector.dart` المذكور في المراجعة غير موجود في النسخة الحالية، لذلك لم أُنشئ محدد كمية جديدًا. موضع السعر الحالي في ProductPurchaseBar عُدّل كما هو موضح.

## لماذا لم أغيّر كل الأرقام؟
MediaQuery تعطي حجم النافذة؛ LayoutBuilder يعطي مساحة العنصر داخل الأب بعد القيود والحشوات. الجمع بينهما مهم لأن الشاشة قد تكون واسعة والعنصر داخل عمود ضيق.
الأيقونات والحدود والمسافات الصغيرة وأهداف اللمس لا تحتاج كلها إلى التكبير بنسبة الشاشة. أبقيت هذه القيم، وكذلك المواضع التي تستخدم بالفعل تخطيطًا مرنًا مثل AuthLogo. هذه التعديلات لا تعني أن جميع شاشات التطبيق أصبحت مضمونة لكل عرض أو لكل إعداد تكبير خط؛ يلزم فحص بصري على الأجهزة المستهدفة.

أزلت const فقط حيث أصبح القياس يُحسب أثناء التشغيل. لم أغير منطق تسجيل الدخول أو طلبات الشبكة.
