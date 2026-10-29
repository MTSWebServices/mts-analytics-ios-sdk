# [MTS Analytics SDK](https://a.mts.ru/support/)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMTSWebServices%2Fmts-analytics-ios-sdk%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/MTSWebServices/mts-analytics-ios-sdk)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMTSWebServices%2Fmts-analytics-ios-sdk%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/MTSWebServices/mts-analytics-ios-sdk)

## Инсталляция SDK

### Swift Package Manager
[Swift Package Manager](https://docs.swift.org/swiftpm/documentation/packagemanagerdocs) — это инструмент для автоматизации распространения кода на Swift, встроенный непосредственно в компилятор.

После того как ваш **Swift Package** настроен, подключить **MTAnalytics** в качестве зависимости можно очень просто: достаточно добавить его в список **dependencies** в файле **Package.swift** или в раздел пакетов прямо в **Xcode**.

#### Через Xcode:
1. Откройте меню **File** > **Add Package Dependency**.
2. Укажите GitHub ссылку на SDK: `https://github.com/MTSWebServices/mts-analytics-ios-sdk`

#### Через Package.swift:
1. Добавьте зависимость в **Package.swift**
```
.dependencies: [
    .package(url: "https://github.com/MTSWebServices/mts-analytics-ios-sdk", from: "6.6.0")
],
```
2. В секции **targets** подключите модуль SDK:
```
.target(
    name: "YourLibrary",
    dependencies: [
        .product(name: "MTAnalytics", package: "mts-analytics-ios-sdk"),
    ]
),
```

### Cocoapods
1. Чтобы добавить библиотеку MTAnalytics в проект, через CocoaPods добавьте в Podfile:
```ruby
pod 'MTAnalytics',  '~> 6.6.0'
```

Теперь при установке MTAnalytics через Cocoapods, начиная с **5.3.0**, необходимо указывать **pod GRDB** таким образом:
```ruby
pod 'GRDB.swift', git: 'https://github.com/groue/GRDB.swift.git', tag: 'v6.29.3'
pod 'MTAnalytics', '~> 6.6.0'
```

2. Далее устанавливаем ссылку на библиотеку MTAnalytics в Podfile:
```ruby
source 'https://github.com/MTSWebServices/mts-analytics-ios-sdk'
```
3. Сохраните **Podfile** и введите `pod install` в Терминале для установки библиотеки.
4. Откройте проект в Xcode через `.xcworkspace` файл.

## Использование SDK

### Common

1. Используйте `UIApplicationDelegate`.

Начиная с версии XCode 27 часть колбэков жизненого цикла будет ограничена в работе, но в СДК они не используются. В остальном, делегат по-прежнему остаётся легальным способом инициализации.

2. Сделайте импорт библиотеки:
```swift
import MTAnalytics
```

3. Инициализируйте библиотеку в методе `application(_:didFinishLaunchingWithOptions:)` вашего делегата.

### Уточнение для SwiftUI

1. В .swift файле `AppDelegate` проинициализируйте СДК Аналитики:
```swift
import UIKit
import MTAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let configuration = MTAnalyticsConfiguration(flowId: "your-flow-id")
        MTAnalyticsApp.configure(configuration)

        return true
    }
}
```

2. Entry point

Не надо добавлять `@UIApplicationMain`, точка входа переносится в `App` класс.

3. В `App` подключите `AppDelegate` через адаптер:
```swift
import SwiftUI

@main
struct YourAppNameApp: App {

    // Подключаем AppDelegate через property wrapper
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

4. Для отлова и передачи deep links и universal links в СДК МТС Аналитики, в `SwiftUI`, точки перехвата ссылок перенесены в колбэки:
```swift
var body: some Scene {
    WindowGroup {
        ContentView()
            // 1. Обработка Диплинков (myapp://*)
            .onOpenURL { url in
                handleURL(url)
            }
            
            // 2. Обработка Универсальных ссылок (https://*)
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                if let url = userActivity.webpageURL {
                    handleURL(url)
                }
            }
    }
}
```

Где в `func handleURL(_ url: URL)`:
- `MTAnalyticsApp.analytics?.tracker?.track(url: url, parameters: [:])`
- `MTAnalyticsApp.linkResolver?.resolveLink(url: url)`

См. отслеживание Deeplink ниже

### Для UIKit

1. Оставляем entry point и инициализацию СДК в `AppDelegate`:

```swift
import UIKit
import MTAnalytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let configuration = MTAnalyticsConfiguration(flowId: "your-flow-id")
        MTAnalyticsApp.configure(configuration)

        return true
    }
}
```

2. Отлов и передача deep links и universal links в СДК МТС Аналитики, для `UIKit`, переносится в `SceneDelegate`:

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // Some inits

    private var tracker: MTTracker? { /* MTSA SDK tracker instance: MTAnalyticsApp.analytics?.tracker */ }
    private var linkResolver: MTLinkResolver? { /* MTSA SDK linkResolver instance: MTAnalyticsApp.linkResolver */ }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let userActivity = connectionOptions.userActivities.first
        if userActivity?.activityType == NSUserActivityTypeBrowsingWeb {
            // Universal link
            guard let url = userActivity?.webpageURL else { return }
            Task(priority: .userInitiated) {
                await [tracker?.track(url: url, parameters: [:]), linkResolver?.resolveLink(url: url)]
            }
            
        } else {
            // Deeplink
            if let context = connectionOptions.urlContexts.first {
                Task(priority: .userInitiated) {
                    await [tracker?.track(url: context.url, parameters: [:]), linkResolver?.resolveLink(url: context.url)]
                }
            }
        }
    }

    // Universal link
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        let url = userActivity.webpageURL
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url {
            Task(priority: .userInitiated) {
                await [tracker?.track(url: url, parameters: [:]), linkResolver?.resolveLink(url: url)]
            }
        }
    }

    // Deeplink
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let context = URLContexts.first {
            Task(priority: .userInitiated) {
                await [tracker?.track(url: context.url, parameters: [:]), linkResolver?.resolveLink(url: context.url)]
            }
        }
    }

    // ...
}
```

См. отслеживание Deeplink ниже

## Функциональность SDK

**Конфигурация SDK**: На этом этапе вы настраиваете параметры работы SDK - длительность сессий, лимиты хранения событий, режим отправки данных в роуминге. Конфигурация задаётся через MTAnalyticsConfiguration.
Подробная инструкция: [<u>Конфигурация</u>](https://a.mts.ru/support/analytics-software/app-sdk-setup/ios-sdk#шаг-3-конфигурация-библиотеки)

**Отправка событий:** Чтобы собирать аналитику пользовательских действий в приложении, настройте отправку событий SDK. События могут описывать клики, просмотры экранов, открытия функций.
Подробности см.: [<u>Events</u>](https://a.mts.ru/support/analytics-software/app-sdk-setup/data-collection/mapping/app)

**Подключение Crashlytics:** MTAnalytics SDK поддерживает интеграцию с Crashlytics, чтобы отслеживать сбои и падения приложения.
Это помогает выявлять критические ошибки и улучшать стабильность.
Руководство по настройке: [<u>Crashlytics</u>](https://a.mts.ru/support/analytics-software/crashlytics)

**Электронная коммерция**: Для отслеживания покупок, просмотров товаров и корзины используйте событие E-commerce. Поддерживается логирование товарных событий (просмотр, добавление в корзину, оформление заказа). Это позволит строить воронки продаж и анализировать поведение пользователей на всех этапах.
Подробности см.: [<u>Ecommerce</u>](https://a.mts.ru/support/analytics-software/app-sdk-setup/data-collection/mapping/app)

**А/Б-тесты и Remote Config**: Для экспериментов и персонализации интерфейса можно подключить А/Б-тесты и Remote Config. Это позволяет динамически изменять логику или внешний вид приложения без публикации в App Store.
Подробности: [<u>A/B тесты</u>](https://a.mts.ru/support/analytics-software/experiments/remote-config-ios)

**Отслеживание Deeplink**: Если приложение открывается по ссылкам (deeplink или universal link), важно передавать эти данные в SDK. Это позволяет корректно учитывать источник установки и перехода.
Подробная инструкция: [<u>Отслеживание Deeplink</u>](https://a.mts.ru/support/analytics-software/app-sdk-setup/data-collection/deeplink)

**Работа с Link Manager:** Link Manager помогает управлять кастомными ссылками для маркетинга, кампаний и интеграций. Через него можно отслеживать переходы и связывать их с событиями в приложении.
Подробная инструкция: [<u>Link Manager</u>](https://a.mts.ru/support/analytics-software/app-sdk-setup/link/general)

## Документация
Подробные инструкции по интеграции, включая установку, конфигурацию, тестирование и многое другое, вы можете найти в [полной документации](https://a.mts.ru/support/).
