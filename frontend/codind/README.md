#### 我想做一个个人学习助力工具。这是前端部分。

#### 前端采用flutter,一套代码多端运行，但是移动端与其他客户端（网页、windows等）有展示方面的差异。

#### 1. 运行

大部分测试是在web上完成的

```
flutter run -d chrome --web-renderer html
```

这里如果没有“--web-renderer html”这个参数，渲染起来很容易出问题(也可以用canvas)。有条件可以在windows/linux/macos上直接运行，或者使用android/ios模拟器或真机调试。

#### 2. flutter info

```
Flutter 3.0.0 • channel stable • https://github.com/flutter/flutter.git 
Framework • revision ee4e09cce0 (8 days ago) • 2022-05-09 16:45:18 -0700
Engine • revision d1b9a6938a
Tools • Dart 2.17.0 • DevTools 2.12.2
```

#### 3. 当前版本

```0.1.0```

#### 4. packages介绍

* *cupertino_icons* ：自带的
* **package_info_plus** : 获取安装包信息，使用的```1.4.2```版本需要jdk11
* **provider** ：状态管理用的包（先前使用```bloc```，但是遇到了一些问题，所以全部替换成了provider）
* **flutter_i18n** ： 本地化/国际化用的包
* **flutter_smart_dialog** ： 本来是使用```fluttertoast```来弹出消息的，但是打包的时候会有问题（warning，可以正常使用，但是心里膈应。可能是flutter版本太高了引起的）
* **dio** ：网络请求包
* **extended_image**：图片包，可以将图片缓存到本地
* **flutter_markdown**： 官方运维的一个markdown渲染器
* **url_launcher**：提供跳转到其它应用、打开网页等功能的强大的插件
* **flutter_colorpicker**：flutter的颜色选择器
* **shared_preferences**：缓存，web上是localstorage明文存储的
* **dart_date**: 日期格式化的便捷工具
* **card_swiper**：null-safety版本的swiper，原版已经不更新了，这个是用来做轮播的
* **flutter_login**：提供了一个非常酷炫的登录页面
* **expandable**：可拓展的组件
* **fl_chart**： 生成各式各样图表的工具
* **scan**： 扫描二维码的工具，条形码不支持
* **tuple**：谷歌自己维护的一个dart元组库，但是命名规则是从Tuple2一直到Tuple7...
* **find_dropdown**: 可以用来搜索的TextEdit
* **flutter_svg**：显示svg的包，但是在1.0.3版本web端渲染有问题
* **xml**：正因为上一个包在web端渲染有问题，所以要用这个对svg数据进行修改之后再渲染
* ***awesome_notifications***：用来提供ios以及android消息通知的（这个包 0.6.21和0.7.0暂时有问题，所以还是用的低版本0.0.6+12 ），后续可能会去掉
* **day_night_time_picker**：flutter实现的一个时间选择器，用来配合```awesome_notifications```做定时提醒的
* **dropdown_button2**
* **timeline_tile** 时间线流程图，在spash_page中用到了
* **file_picker** 文件选择
* **flip_card** 可以翻面的组件
* **code_text_field** flutter上显示代码块的组件
* **qr_flutter** 生成和扫描二维码的组件
* **waterfall_flow** 瀑布流式组件
* **permission_handler** 权限组件，9.2.0版本（可能还有其它版本） jdk8 有问题，升级到jdk11之后就行了
* **path_provider** 路径
* **sqlite3** 本地存储sqlite
* **sqlite3_flutter_libs** 同上
* **add_2_calendar** 操作原生日历
* **animations** 一个动画库
* **showcaseview** 可以给操作提示的组件
* **taichi** 自己写的组件/工具库，实现了一些loading_overlay的功能