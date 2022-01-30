<!--
 * @Descripttion: 
 * @version: 
 * @Author: xiaoshuyui
 * @email: guchengxi1994@qq.com
 * @Date: 2022-01-30 21:46:56
 * @LastEditors: xiaoshuyui
 * @LastEditTime: 2022-01-30 23:04:16
-->
# codind

## 我想做一个交流沟通用的论坛，以技术为主。这是前端部分。

## 我自己 flutter 写的并不好，没有系统地学过，只是觉得和java很像，学的很囫囵。算是一边学一边写，代码里边应该存在一些问题。

## 前端采用flutter,一套代码多端运行，但是移动端与其他客户端（网页、windows等）有展示方面的差异。

## 1.运行

### 大部分测试是在web上完成的。

    flutter run -d chrome --web-renderer html

### 这里如果没有“--web-renderer html”这个参数，渲染起来很容易出问题。

### 我使用的dart sdk版本是2.15。状态管理使用的是bloc（因为bloc是基于provider实现的，所以有些状态管理功能是直接使用provider写的，我也看过getx,但是因为bloc用的比较多，provider也有在用，就没打算用getx了），其他的包大致都是一些通用的，比如fluttertoast，dio，flutter_markdown，url_launcher，shared_preferences等，一些样式上或者功能上有些实现难度或者别人代码完成程度已经比较高的包flutter_colorpicker和loading_overlay。

## 2.实现的部分功能

### 2.1 基于flutter_i18n以及provider的本地化

```dart
/// 1. 下载 flutter_i18n 并在 assets 下创建对应的文件夹以及文件
///    这里不知道为什么 这个版本的 flutter_i18n 会去加载所有可能
///    的文件，像是 zh_CN.json,zh_CN.toml 或者 zh_CN.xml，但是
///    我已经有了使用 yaml 格式的文件

/// 2. 在 main 文件 的 main函数 写入如下代码，声明 flutter_i18n

final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'zh_CN',
        basePath: 'assets/i18n',
        forcedLocale: const Locale('zh_CN')),
  );
  WidgetsFlutterBinding.ensureInitialized();

/// 3. 在 MaterialApp 中使用 flutter_i18n

final FlutterI18nDelegate flutterI18nDelegate;
...
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: ...,
      theme: ...,
      debugShowCheckedModeBanner: false,
      builder: FlutterI18n.rootAppBuilder(),
      home: ...,
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }

/// 4. 声明 provider 以及 ChangeNotifier

class LanguageController extends ChangeNotifier {
  BuildContext _context;
  LanguageController(this._context);

  String _currentlang = "zh_CN";
  String get currentLang => _currentlang;

  getContext() => _context;
  setContext(BuildContext context) => _context = context;
  changeLanguage(String lang) async {
    _currentlang = lang;
    await FlutterI18n.refresh(_context, Locale(lang));
    notifyListeners();
  }
}

ChangeNotifierProvider(
            create: (_) => LanguageController(context),
),

/// 5.修改语言

if (lang != context.read<LanguageController>().currentLang) {
          await context.read<LanguageController>().changeLanguage(lang);
          setState(() {});
}
/// 我这里代码可能有问题，需要手动执行一次 setState((){}) 才能够生效

```

### 2.2 抽象的基页面 base page
``` dart
abstract class BasePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState() {
    // ignore: no_logic_in_create_state
    return getState();
  }

  BasePageState getState();
}

class BasePageState<T extends BasePage> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: baseBuild(context),
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void onCreate() {}
  void onDes() {}
  baseBuild(BuildContext context) {}
}

/// 我把 本地化以及其他组件功能写在了这个 base page 的 appbar 上，其他页面要继承这个页面就可以直接使用这些组件。

```

### 2.3 mixin

### 我太喜欢dart的mixin了，相比python的强一些。
```dart

mixin LoadingPageMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: baseBuild(context),
    );
  }
  // 调用这个方法！！！
  baseBuild(BuildContext context) {}
}

/// 这个LoadingOverlay是一个十分便捷地在页面中间出现等待动画的包，只需要一个参数 isLoading，在执行一些 await 方法时，不想让用户操作别的按钮或者功能，可以使用这种方式。 就是等待画面无法自定义，有点不好看。使用mixin之后，就可以不用每一次都写重复性质的代码了。

/// 这可真是极好的 ：)

```