
### 前言
GetX 是 Flutter 上的一个轻量且强大的解决方案：高性能的状态管理、智能的依赖注入和便捷的路由管理。

GetX 有三个基本的原则，分别是性能、提效和组织性。
* **性能：** GetX 专注于性能和最小资源消耗。
* **效率：** GetX 的语法非常简捷，并保持了极高的性能，能极大缩短你的开发时长。这使得开发的时间大大节省，并且保证应用性能的最大化。通常来说，开发者需要关注从内存中移除控制器。而使用 GetX 的时候，则无需这么做。当控制器不被使用的时候，资源会自动从内存中释放。如果确实需要常住内存，那就需要在依赖中声明 permanent:true。通过这种方式，可以降低内存中有过多不必要依赖对象的风险。同时，依赖默认也是懒加载。
* **结构：** GetX 可以将界面、逻辑、依赖和路由完全解耦，用起来更清爽，逻辑更清晰，代码更容易维护。路由之间跳转无需 context，因此我们的导航不会依赖组件树。

### GetX 生态
GetX 有很多特性，使得编码变得容易。每个特性之间是相互独立的，并且只会在使用的时候才启动。例如，如果仅仅是使用状态管理，那么只有状态管理会被编译。而如果只使用路由，那么状态管理的部分就不会编译。
GetX 有一个很大的生态，包括了大型的社区维护，大量的协作者（GitHub 上看有132位），并且承诺只要 Flutter 存在就会继续维护下去。而且 GetX 兼容 Android, iOS, Web, Mac, Linux, Windows多个平台。GetX 甚至还有服务端版本 Get_Server。

### 路由
> GetX is an extra-light and powerful solution for Flutter. It combines high-performance state management, intelligent dependency injection, and route management quickly and practically.
GetX 是一个超轻量且强大的 Flutter 应用解决方案。它组合了高性能的状态管理、智能的依赖注入以及快速可用的路由管理。

#### 普通路由导航

导航到新的页面。

```dart
Get.to(NextScreen());
```

关闭SnackBars、Dialogs、BottomSheets或任何你通常会用Navigator.pop(context)关闭的东西。

```dart
Get.back();
```

进入下一个页面，但没有返回上一个页面的选项（用于SplashScreens，登录页面等）。

```dart
Get.off(NextScreen());
```

进入下一个界面并取消之前的所有路由（在购物车、投票和测试中很有用）。

```dart
Get.offAll(NextScreen());
```

要导航到下一条路由，并在返回后立即接收或更新数据。

```dart
var data = await Get.to(Payment());
```

在另一个页面上，发送前一个路由的数据。

```dart
Get.back(result: 'success');
```

并使用它，例：

```dart
if(data == 'success') madeAnything();
```

#### 别名路由导航
导航到下一个页面

```dart
Get.toNamed("/NextScreen");
```

浏览并删除前一个页面。

```dart
Get.offNamed("/NextScreen");
```

浏览并删除所有以前的页面。

```dart
Get.offAllNamed("/NextScreen");
```

要定义路由，使用GetMaterialApp。

```dart
void main() {
  runApp(
    GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/second', page: () => Second()),
        GetPage(
          name: '/third',
          page: () => Third(),
          transition: Transition.zoom  
        ),
      ],
    )
  );
}
```

要处理到未定义路线的导航（404错误），可以在 GetMaterialApp 中定义 unknownRoute 页面。

```dart
void main() {
  runApp(
    GetMaterialApp(
      unknownRoute: GetPage(name: '/notfound', page: () => UnknownRoutePage()),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => MyHomePage()),
        GetPage(name: '/second', page: () => Second()),
      ],
    )
  );
}
```

#### 传参数 arguments

只要发送你想要的参数即可。Get在这里接受任何东西，无论是一个字符串，一个Map，一个List，甚至一个类的实例。

```dart
Get.toNamed("/home/list/detail", arguments: {"id": 999});
```

```dart
Get.toNamed("/home/list/detail?id=666");
```

在你的类或控制器上：

```dart
Map? details = Get.arguments;
Map? parameters = Get.parameters;
```

GetX 的路由好处是不依赖于 context，十分简洁。

#### 中间件
路由中间件，用于路由权限控制等操作，比如拦截路由进行跳转登陆界面。

```dart
class RouteAuthMiddleware extends GetMiddleware {
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    // 加入 AuthService
    Future.delayed(Duration(seconds: 1), () => Get.snackbar("提示", "请先登录APP"));

    return RouteSettings(name: AppRoutes.Login);
  }
}

// 我的，需要认证
GetPage(
  name: AppRoutes.My,
  page: () => MyView(),
  middlewares: [
    RouteAuthMiddleware(priority: 1),
  ],
),
```

GetPage 现在有个新的参数可以把列表中的 Get 中间件按指定顺序执行。

**注意**: 当 GetPage 有中间件时，所有的子 page 会自动有相同的中间件。

### 优先级

设置中间件的优先级定义 Get 中间件的执行顺序。

```dart
final middlewares = [
  GetMiddleware(priority: 2),
  GetMiddleware(priority: 5),
  GetMiddleware(priority: 4),
  GetMiddleware(priority: -8),
];
```

这些中间件会按这个顺序执行 **-8 => 2 => 4 => 5**

### Redirect

当被调用路由的页面被搜索时，这个函数将被调用。它将 RouteSettings 作为重定向的结果。或者给它 null，就没有重定向了。

```dart
RouteSettings redirect(String route) {
  final authService = Get.find<AuthService>();
  return authService.authed.value ? null : RouteSettings(name: '/login')
}
```

#### 内存缓存

GetX 可以缓存内容对象，以便在不同页面共享数据。使用的时候需要注意，需要先 put 操作再 find 操作，否则会抛异常。
```
Get.put(CacheData(name: '这是缓存数据'));
CacheData cache = Get.find();
```

#### 离线存储

GetX 提供了一个 get_storage 插件用于离线存储，与 shared_preferences 相比，其优点是纯 Dart 编写，不依赖于原生，因此可以在安卓、iOS、Web、Linux、Mac 等多个平台使用。GetStorage 是基于内存和文件存储的，当内存容器中有数据时优先从内存读取。同时在构建 GetStorage 对象到时候指定存储的文件名以及存储数据的容器。
```
GetStorage storage = GetStorage();
storage.write('name', '岛上码农');
storage.read('name');
```

#### 状态管理
Get 有两个不同的状态管理器：简单的状态管理器（GetBuilder）和响应式状态管理器（GetX）。

响应式状态管理器

* 第一种是使用 **`Rx{Type}`**。

```dart
// 建议使用初始值，但不是强制性的
final name = RxString('');
final isLogged = RxBool(false);
final count = RxInt(0);
final balance = RxDouble(0.0);
final items = RxList<String>([]);
final myMap = RxMap<String, int>({});
```

* 第二种是使用 **`Rx`**，规定泛型 `Rx<Type>`。

```dart
final name = Rx<String>('');
final isLogged = Rx<Bool>(false);
final count = Rx<Int>(0);
final balance = Rx<Double>(0.0);
final number = Rx<Num>(0)
final items = Rx<List<String>>([]);
final myMap = Rx<Map<String, int>>({});

// 自定义类 - 可以是任何类
final user = Rx<User>();
```

* 第三种更实用、更简单、更可取的方法，只需添加 **`.obs`** 作为`value`的属性。

```dart
final name = ''.obs;
final isLogged = false.obs;
final count = 0.obs;
final balance = 0.0.obs;
final number = 0.obs;
final items = <String>[].obs;
final myMap = <String, int>{}.obs;

// 自定义类 - 可以是任何类
final user = User().obs;
```

如何使用
```dart
// controller
final count = 0.obs;
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Obx(...)"),
      ),
      body: Center(
        child: Column(
          children: [
            Obx(() => Text("count1 -> " + count.toString())),
            Obx(() => Text("count2 -> " + count.toString())),
            Divider(),
            ElevatedButton(
              onPressed: () {
                count.value++;
              },
              child: Text('add'),
            ),
          ],
        ),
      ),
    );
}
```
> 如果我在一个类中有 30 个变量，当我更新其中一个变量时，它会更新该类中**所有**的变量吗？

不会，只会更新使用那个 _Rx_ 变量的**特定 Widget**。
