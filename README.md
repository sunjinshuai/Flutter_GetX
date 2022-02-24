- [前言](#前言)
- [GetX生态](#GetX生态)
- [路由管理](#路由管理)
- [StateMixin](#StateMixin)
- [状态管理](#状态管理)
- [GetX依赖管理](#GetX依赖管理)
- [中间件](#中间件)
- [Worker](#Worker)
- [内存缓存](#内存缓存)
- [离线存储](#离线存储)
## 前言
GetX 是 Flutter 上的一个轻量且强大的解决方案：高性能的状态管理、智能的依赖注入和便捷的路由管理。

GetX 有三个基本的原则，分别是性能、提效和组织性。
* **性能：** GetX 专注于性能和最小资源消耗。
* **效率：** GetX 的语法非常简捷，并保持了极高的性能，能极大缩短你的开发时长。这使得开发的时间大大节省，并且保证应用性能的最大化。通常来说，开发者需要关注从内存中移除控制器。而使用 GetX 的时候，则无需这么做。当控制器不被使用的时候，资源会自动从内存中释放。如果确实需要常住内存，那就需要在依赖中声明 permanent:true。通过这种方式，可以降低内存中有过多不必要依赖对象的风险。同时，依赖默认也是懒加载。
* **结构：** GetX 可以将界面、逻辑、依赖和路由完全解耦，用起来更清爽，逻辑更清晰，代码更容易维护。路由之间跳转无需 context，因此我们的导航不会依赖组件树。

## GetX生态
GetX 有很多特性，使得编码变得容易。每个特性之间是相互独立的，并且只会在使用的时候才启动。例如，如果仅仅是使用状态管理，那么只有状态管理会被编译。而如果只使用路由，那么状态管理的部分就不会编译。
GetX 有一个很大的生态，包括了大型的社区维护，大量的协作者（GitHub 上看有132位），并且承诺只要 Flutter 存在就会继续维护下去。而且 GetX 兼容 Android, iOS, Web, Mac, Linux, Windows多个平台。GetX 甚至还有服务端版本 Get_Server。

## 路由管理
> GetX is an extra-light and powerful solution for Flutter. It combines high-performance state management, intelligent dependency injection, and route management quickly and practically.
GetX 是一个超轻量且强大的 Flutter 应用解决方案。它组合了高性能的状态管理、智能的依赖注入以及快速可用的路由管理。

### 普通路由导航
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

### 别名路由导航
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

### 传参数 arguments
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

## 状态管理
Get 有两个不同的状态管理器：简单的状态管理器（GetBuilder）和响应式状态管理器（GetX）。

### 响应式状态管理器

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

### 简单状态管理器
对于有些场景，我们可能有多个组件共享一份状态数据，但是状态数据改变后可能只需要更新其中的一个或多个组件，而不是依赖状态的全部组件。这个时候我们就可以用到 GetX 的定向更新。
GetX 的 GetBuilder 使用 id 参数实现定向刷新的特性。这种情况适用于多个组件共用一个状态对象，但更新条件不同的情况。

```dart
// 创建控制器类并扩展GetxController。
class Controller extends GetxController {
  int counter = 0;
  void increment() {
    counter++;
    update(); // 当调用增量时，使用update()来更新用户界面上的计数器变量。
  }
}
// 在你的Stateless/Stateful类中，当调用increment时，使用GetBuilder来更新Text。
GetBuilder<Controller>(
  init: Controller(), // 首次启动
  builder: (_) => Text(
    '${_.counter}',
  ),
)
//只在第一次时初始化你的控制器。第二次使用ReBuilder时，不要再使用同一控制器。一旦将控制器标记为 "init "的部件部署完毕，你的控制器将自动从内存中移除。你不必担心这个问题，Get会自动做到这一点，只是要确保你不要两次启动同一个控制器。
```

如果你需要在许多其他地方使用你的控制器，并且在GetBuilder之外，只需在你的控制器中创建一个get，就可以轻松地拥有它。(或者使用`Get.find<Controller>()`)

```dart
class Controller extends GetxController {

  /// 你不需要这个，我推荐使用它只是为了方便语法。
  /// 用静态方法：Controller.to.increment()。
  /// 没有静态方法的情况下：Get.find<Controller>().increment();
  /// 使用这两种语法在性能上没有区别，也没有任何副作用。一个不需要类型，另一个IDE会自动完成。
  static Controller get to => Get.find(); // 添加这一行

  int counter = 0;
  void increment() {
    counter++;
    update();
  }
}
```

然后你可以直接访问你的控制器，这样：

```dart
FloatingActionButton(
  onPressed: () {
    Controller.to.increment(),
  } // 是不是贼简单！
  child: Text("${Controller.to.counter}"),
),
```

当你按下FloatingActionButton时，所有监听'counter'变量的widget都会自动更新。
**适合控制多控制器、多状态更新，可精细控制初始、局部渲染。**
## StateMixin
App 的大部分页面都会涉及到数据加载、错误、无数据和正常几个状态，在一开始的时候我们可能数据获取的状态枚举用 if...else 或者 switch 来显示不同的 Widget，这种方式会显得代码很丑陋，譬如下面这样的代码：

```
if (PersonalController.to.loadingStatus == LoadingStatus.loading) {
  return Center(
    child: Text('加载中...'),
  );
}
if (PersonalController.to.loadingStatus == LoadingStatus.failed) {
  return Center(
    child: Text('请求失败'),
  );
}
// 正常状态
PersonalEntity personalProfile = PersonalController.to.personalProfile;
return Stack(
  ...
);
```

这种情况实在是不够优雅，在 GetX 中提供了一种 StateMixin 的方式来解决这个问题。

StateMixin 是 GetX 定义的一个 mixin，可以在状态数据中混入页面数据加载状态，包括了如下状态：

* RxStatus.loading()：加载中；
* RxStatus.success()：加载成功；
* RxStatus.error([String? message])：加载失败，可以携带一个错误信息 message；
* RxStatus.empty()：无数据。

StateMixin 的用法如下：
```
class XXXController extends GetxController
    with StateMixin<T>  {
}
```

其中 T 为实际的状态类，可以定义为：
```
class PersonalMixinController extends GetxController
    with StateMixin<PersonalEntity>  {
}
```

然后 StateMixin 提供了一个 change 方法用于传递状态数据和状态给页面。
```
void change(T? newState, {RxStatus? status})
```

其中 newState 是新的状态数据，status 就是上面我们说的4种状态。这个方法会通知 Widget 刷新。

GetX 提供了一个快捷的 Widget 用来访问容器中的 controller，即 GetView。GetView是一个继承 StatelessWidget的抽象类，实现很简单，只是定义了一个获取 controller 的 get 属性。
```
abstract class GetView<T> extends StatelessWidget {
  const GetView({Key? key}) : super(key: key);

  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag)!;

  @override
  Widget build(BuildContext context);
}
```

通过继承 GetView，就可以直接使用controller.obx构建界面，而 controller.obx 最大的特点是针对 RxStatus 的4个状态分别定义了四个属性：
```
Widget obx(
  NotifierBuilder<T?> widget, {
  Widget Function(String? error)? onError,
  Widget? onLoading,
  Widget? onEmpty,
})
```

* NotifierBuilder<T?> widget：实际就是一个携带状态变量，返回正常状态界面的函数，NotifierBuilder<T?>的定义如下。通过这个方法可以使用状态变量构建正常界面。
* onError：错误时对应的 Widget构建函数，可以使用错误信息 error。
* onLoading：加载时对应的 Widget；
* onEmpty：数据为空时的 Widget。

通过这种方式可以自动根据 change方法指定的 RxStatus 来构建不同状态的 UI 界面，从而避免了丑陋的 if...else 或 switch 语句。
```
class PersonalHomePageMixin extends GetView<PersonalMixinController> {
  PersonalHomePageMixin({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (personalEntity) => _PersonalHomePage(personalProfile: personalEntity!),
      onLoading: Center(
        child: CircularProgressIndicator(),
      ),
      onError: (error) => Center(
        child: Text(error!),
      ),
      onEmpty: Center(
        child: Text('暂无数据'),
      ),
    );
  }
}
```

对应的 PersonalMixinController 的代码如下：
```
class PersonalMixinController extends GetxController
    with StateMixin<PersonalEntity> {
  final String userId;
  PersonalMixinController({required this.userId});
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getPersonalProfile(userId);
  }

  void getPersonalProfile(String userId) async {
    change(null, status: RxStatus.loading());
    var personalProfile = await JuejinService().getPersonalProfile(userId);
    if (personalProfile != null) {
      change(personalProfile, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.error('获取个人信息失败'));
    }
  }
}
```

从 GetView 的源码可以看到，Controller 是从容器中获取的，这就需要使用 GetX 的容器，在使用 Controller 前注册到 GetX 容器中。
```
class PersonalStateMixinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalMixinController>(
      () => PersonalMixinController(userId: '1521379823060024'),
    );
  }
}
```
## GetX依赖管理
### 概念
-   Inversion of Control: `控制反转`是一种重要的面向对象编程原则，控制反转就是，关于一个对象如何获取他所依赖的对象的引用，这个责任的反转。

    控制反转一般分为两种类型，`依赖注入`（Dependency Injection，简称DI）和依赖查找（Dependency Lookup）。依赖注入应用比较广泛。

-   Dependency Injection: 依赖注入，依赖注入模式是指客户类Client不用自己来初始化(new)它所依赖的成员变量IServer，而是等待某个对象创建IServer的适当的(实现类）的对象并将它赋值给Client的成员变量。

### sample

```js
classA {
 AInterface a;  

 A(){}
 
 AMethod(){
 a = new AInterfaceImpl();
 }
}
```

这里面 `Class A`与`AInterfaceImpl`就是依赖关系,如果想使用AInterface的另外一个实现就需要更改代码了,依赖注入就是为了解决这种耦合关系的

使用new（对象创建)是一种硬编码,是代码耦合度变得很高,不方便测试.依赖注入简单的讲**就是通过外界传入依赖来进行成员变量的初始化**

### 依赖注入的三种实现方式

-   Contructor Injection(构造函数注入)

```js
 public interface IFather {
  //method
 }

public class Human {
 IFather father;
 public Human(IFather father) {
  this.father = father;
 }
}
```

-   基于setter,通过JavaBean的[属性](https://www.jb51.cc/tag/shuxing/)(setter[方法](https://www.jb51.cc/tag/fangfa/))为可服务对象指定服务

```js
public class Human {
  IFather father;
  public void setIFather(IFather father) {
   this.father = father;
  }
}
```
-   接口注入
```js
// 注入[功能](https://www.jb51.cc/tag/gongneng/)的interface
public interface InjectFinder {
  void injectFinder(IFather father);
}
 // 让我们的Human实现接口
public class Human implements InjectFinder {
  IFather father;
  public void injectFinder(IFather father) {
   this.father = father;
  }
}
```
### 依赖注入的优点
-   易于复用\
    更容易换掉依赖项的实现。由于控制反转，代码重用得以改进，并且类不再控制其依赖项的创建方式，而是支持任何配置。

-   易于重构\
    依赖项的创建分离，可以在创建对象时或编译时进行检查、修改，一处修改，使用处不需修改。

-   易于测试\
    类不管理其依赖项，因此在测试时，可以传入不同的实现以测试所有不同用例。

### GetX中如何使用依赖注入

Get有一个简单而强大的依赖管理器，它允许你只用1行代码就能检索到 Controller 或者需要依赖的类，无需上下文，无需inheritedWidget。

```js
//注入依赖
Controller controller = Get.put(Controller()); 
// 而不是 Controller controller = Controller();
说明: Get实例中实例化它，而不是在你正在使用的类中实例化你的类，这将使它在整个App中可用。
//获取依赖：
Get.find<PutController>();
```
### GetX通过Get依赖管理器提供如下4种手动注入依赖的方式:

-   Get.put()\
    立即注入内存的注入方法(最常用), 调用后已经注入到内存中, 例如:

```js
Get.put<SomeClass>(SomeClass());
Get.put<LoginController>(LoginController(), permanent: true);
Get.put<ListItemController>(ListItemController, tag: "some unique string");
//使用put时可以设置的所有选项:
Get.put<S>(
  // 必备：要注入的类。
  // 注：" S "意味着它可以是任何类型的类。
  S dependency

  // 可选：想要注入多个相同类型的类时，可以用这个方法。
  // 比如有两个购物车实例，就需要使用标签区分不同的实例。
  // 必须是唯一的字符串。
  String tag,

  // 可选：默认情况下，get会在实例不再使用后进行销毁
  // （例如：一个已经销毁的视图的Controller)
  // 如果需要这个实例在整个应用生命周期中都存在，就像一个sharedPreferences的实例。
  // 默认值为false
  bool permanent = false,

  // 可选：允许你在测试中使用一个抽象类后，用另一个抽象类代替它，然后再进行测试。
  // 默认为false
  bool overrideAbstract = false,

  // 可选：允许你使用函数而不是依赖（dependency）本身来创建依赖。
  // 这个不常用
  InstanceBuilderCallback<S> builder,
)
```
`permanent`是代表是否不销毁。通常`Get.put()`的实例的生命周期和 put 所在的 Widget 生命周期绑定，如果在全局 （main 方法里）put，那么这个实例就一直存在。如果在一个 Widget 里 put ，那么这个那么这个 Widget 从内存中删除，这个实例也会被销毁。

-   Get.lazyPut()\
    懒加载一个依赖，只有在使用时才会被实例化。适用于不确定是否会被使用的依赖或者计算高昂的依赖。类似 Kotlin 的 Lazy 代理。, 例如:

```js
///只有当第一次使用Get.find<ApiMock>时，ApiMock才会被调用。
Get.lazyPut<ApiMock>(() => ApiMock());

Get.lazyPut<S>(
  // 强制性：当你的类第一次被调用时，将被执行的方法。
  InstanceBuilderCallback builder,
  // 可选：和Get.put()一样，当你想让同一个类有多个不同的实例时，就会用到它。
  // 必须是唯一的
  String tag,
  // 可选：类似于 "永久"，
  // 不同的是，当不使用时，实例会被丢弃，但当再次需要使用时，Get会重新创建实例，
  // 就像 bindings api 中的 "SmartManagement.keepFactory "一样。
  // 默认值为false
  bool fenix = false
)
```
-   Get.putAsync()\
    注入一个异步创建的实例。比如`SharedPreferences`。
```js
Get.putAsync<SharedPreferences>(() async {
    final sp = await SharedPreferences.getInstance();
    return sp;
  });
)
Get.putAsync<S>(
  // 必备：一个将被执行的异步方法，用于实例化你的类。
  AsyncInstanceBuilderCallback<S> builder,
  // 可选：和Get.put()一样，当你想让同一个类有多个不同的实例时，就会用到它。
  // 必须是唯一的
  String tag,
  // 可选：与Get.put()相同，当你需要在整个应用程序中保持该实例的生命时使用。
  // 默认值为false
  bool permanent = false
)
```
-   Get.create()\
    这个方法可以创建很多实例。很少用到。可以当做`Get.put`。
```js
Get.create<S>(
  // 需要：一个返回每次调用"Get.find() "都会被新建的类的函数。
  // 示例: Get.create<YourClass>(()=>YourClass())
  FcBuilderFunc<S> builder,
  // 可选：就像Get.put()一样，但当你需要多个同类的实例时，会用到它。
  // 当你有一个列表，每个项目都需要自己的控制器时，这很有用。
  // 需要是一个唯一的字符串。只要把标签改成名字
  String name,
  // 可选：就像 Get.put() 一样，
  // 它是为了当你需要在整个应用中保活实例的时候
  // 区别在于 Get.create 的 permanent默认为true
  bool permanent = true
```
### GetX通过Bindings类提供的自动注入依赖的方式:
上述通过Get实现的依赖注入和使用, 为了生命周期和使用的 Widget 绑定，需要在 Widget 里注入和使用，并没有完全解耦。要实现自动注入，就需要这个Bindings类。
### Bindings类

-   创建一个类并实现Binding,IDE会自动重写 "dependencies"方法，然后插入在该路由上使用的所有类。

```
class DetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsController>(() => DetailsController());
  }
}
```
-   通知路由，使用该 Binding 来建立路由管理器、依赖关系和状态之间的连接。

-   使用别名路由：

```
getPages: [
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: DetailsBinding(),
  ),
];
```

-   使用正常路由。

```
Get.to(DetailsView(), binding: DetailsBinding())
```

至此，就不必再担心应用程序的内存管理，Get会自动做这件事。

上面注入依赖解耦了，但是获取还是略显不方便，可使用`GetView`完美的搭配 Bindings。

```
class InjectSimplePage extends GetView<InjectSimpleController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyPage')),
      body: Center(
        child: Obx(() => Text(controller.obj.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.getAge();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```
这里完全没有`Get.find`，但是可以直接使用`controller`，因为`GetView`里封装好了：

```
abstract class GetView<T> extends StatelessWidget {
  const GetView({Key key}) : super(key: key);
  final String tag = null;
  T get controller => GetInstance().find<T>(tag: tag);
  @override
  Widget build(BuildContext context);
}
```

不在需要 StatelessWidget 和 StatefulWidget。这也是开发最常用的模式，推荐大家使用。

如果每次声明一个 Bingings 类也很麻烦，那么可以使用 BindingsBuilder ，这样就可以简单地使用一个函数来实例化任何想要注入的东西。

```
  GetPage(
    name: '/details',
    page: () => DetailsView(),
    binding: BindingsBuilder(() => {
      Get.lazyPut<DetailsController>(() => DetailsController());
    }),
```
上述两种方式都可以，可根据自己的编码习惯选择最适合的风格。
### Bindings 的工作原理

Bindings 会创建过渡性工厂，在点击进入另一个页面的那一刻，这些工厂就会被创建，一旦路由过渡动画发生，就会被销毁。 工厂占用的内存很少，它们并不持有实例，而是一个具有我们想要的那个类的 "形状"的函数。 这在内存上的成本很低，但由于这个库的目的是用最少的资源获得最大的性能，所以Get连工厂都默认删除。

### 智能管理

GetX 默认情况下会将未使用的控制器从内存中移除。 但是如果你想改变 GetX 控制类的销毁方式，你可以用 `SmartManagement` 类设置不同的行为。

如何改变配置? 方法如下。
```
void main () {
  runApp(
    GetMaterialApp(
      smartManagement: SmartManagement.onlyBuilders //这里
      home: Home(),
    )
  )
}
```
-   SmartManagement.full\
    这是默认的。销毁那些没有被使用的、没有被设置为永久的类。在大多数情况下，你会希望保持这个配置不受影响。如果你是第一次使用GetX，那么不要改变这个配置。
-   SmartManagement.onlyBuilders\
    使用该选项，只有在`init:`中启动的控制器或用`Get.lazyPut()`加载到Binding中的控制器才会被销毁。

    如果你使用`Get.put()`或`Get.putAsync()`或任何其他方法，SmartManagement将没有权限移除这个依赖。

    在默认行为下，即使是用 "Get.put "实例化的widget也会被移除，这与SmartManagement.onlyBuilders不同。

-   SmartManagement.keepFactory\
    就像SmartManagement.full一样，当它不再被使用时，它将删除它的依赖关系，但它将保留它们的工厂，这意味着如果你再次需要该实例，它将重新创建该依赖关系。

## 中间件
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

## Worker

在前后端对接过程中，经常会遇到快速重复点击导致重复请求的问题，如果处理不好一方面容易产生垃圾数据，另一方面还增加了很多无谓请求，导致服务器请求数量过多。在 GetX 中，针对这种场景提供了一个 Worker 类以及几个勾子函数来解决这类问题。

举个例子，某些购物 App 会提供互动游戏，通过在限定时间内点击的次数来刷红包或优惠券，这个时候我们会疯狂地点击天上掉下来的红包或者锦鲤，试想如果每次点击都请求后端，那如果是上万人都这么点击，服务器都会被点崩！对于这种情况，GetX 提供了一个 debounce 的勾子函数，这个函数在限定的时间内只会执行一次指定的回调动作：
```
Worker debounce<T>(
  RxInterface<T> listener,
  WorkerCallback<T> callback, {
  Duration? time,
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
});
```
然后有一个按钮每点击一次就给计数器的值加 1。如果手速够快，我们1秒钟可以点击很多次。这个时候假设我们要防抖，就可以将网络请求放到 callback 里，从而在限定的时间范围内，避免用于的疯狂点击造成过多网络请求。通过这种方式可以减少无谓的请求。这种场景还可以用于搜索场合，当在输入的时候，因为内容在变化，我们不用请求后端数据，而等到用户输入结束之后再请求，这样体验更好而且也能减少后端请求。

在有些场合，我们需要限定一定时间内的请求次数，做类似限流的效果。比如，在点击按钮刷金币的行为，我们可以限制没 2 秒最多刷 1 次，这样1分钟内最多只能刷 30 次，在 GetX 中提供了一个 interval 的方法：
```
Worker interval<T>(
  RxInterface<T> listener,
  WorkerCallback<T> callback, {
  Duration time = const Duration(seconds: 1),
  dynamic condition = true,
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
})
```

GetX 还提供了下面三种 Worker 勾子函数，函数的调用和 interval 一样。
* once：状态变量变化时只执行一次，比如详情页面的刷新只更新一次浏览次数。
* ever：每次变化都执行，可以用于点赞这种场合
* everAll：用于列表类型状态变量，只要列表元素改变就会执行回调。

## 内存缓存
GetX 可以缓存内容对象，以便在不同页面共享数据。使用的时候需要注意，需要先 put 操作再 find 操作，否则会抛异常。
```
Get.put(CacheData(name: '这是缓存数据'));
CacheData cache = Get.find();
```

## 离线存储
GetX 提供了一个 get_storage 插件用于离线存储，与 shared_preferences 相比，其优点是纯 Dart 编写，不依赖于原生，因此可以在安卓、iOS、Web、Linux、Mac 等多个平台使用。GetStorage 是基于内存和文件存储的，当内存容器中有数据时优先从内存读取。同时在构建 GetStorage 对象到时候指定存储的文件名以及存储数据的容器。
```
GetStorage storage = GetStorage();
storage.write('name', '岛上码农');
storage.read('name');
```