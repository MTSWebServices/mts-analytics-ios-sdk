# Changelog

## v.6.5.1 - Oct 14, 2026

### Fixed

- Исправлены race condition в `MTDeviceParamsReporter`:
  - Устранён data race при одновременном вызове `start(sessionId:)` с разных потоков (SIGABRT).
  - Сбор параметров `isOnCall`, `appState`, `orientation`, `batteryLevel` перенесён на главный поток через `MainActor.run` (SIGSEGV).
- Обновлен пример интеграции СДК при сборке под OS 27

## v.6.5.0 - Jul 15, 2026

### Added

- Добавлен метод `MTAnalyticsApp.metricsExporter(_:)` для создания потоков экспорта метрик с переданной конфигурацией `MTAnalyticsConfiguration`.
- Добавлен публичный API для получения активных потоков экспорта метрик на основе явной конфигурации.


### Fixed

- Внесены общие исправления, улучшения производительности и внутренние оптимизации.

## v.6.4.0 - Mar 31, 2026

### Added
- Добавлен метод `setUserAgent`, позволяющий задавать заголовок `User-Agent` в запросы.

### Changed
- Исправлена публичная ссылка на репозиторий с `https://github.com/MobileTeleSystems/mts-analytics-ios-sdk` на `https://github.com/MTSWebServices/mts-analytics-ios-sdk`
- Удален автоматический сбор `User-Agent`

### Fixed
- Исправлен конфликт с перехватом запросом при выключенном SDK.

## v.6.3.0 - Mar 5, 2026

### Added
- Добавлен метод `setUserId`, позволяющий задавать глобальный идентификатор пользователя.

### Fixed
- Исправлена проблема потенциального краша `SIGTRAP at MTDeviceParamsReporter`.
- Улучшена общая стабильность.

## v.6.2.0 - Feb 10, 2026

### Added
- Добавлено поле `сrossSessionId` в MTAppEvent.

### Fixed
- Улучшена общая стабильность.

## v.6.1.0 - Dec 17, 2025

### Changed
- Реализовано динамическое формирование батчей: размер и количество событий в батче адаптируются во время работы для более эффективной и стабильной отправки данных.
- События и отчёты о крашах теперь передаются в сжатом виде, что снижает сетевой трафик и ускоряет доставку данных.

## v.6.0.0 - Oct 20, 2025

### Changed
- Breaking: Минимально необходимая версия iOS и tvOS поднята до 15.0
- Breaking: Удалены deprecated методы
- Breaking: `MTEcosystemEvent` переименован в `MTAppEvent` с изменением структуры:
  - Enum поля изменены на optional String
  - Поле `timestamp` теперь должно заполняться вручную (ранее заполнялось автоматически)
- Breaking: MTEcosystemDefaults переименованs в MTAppEventDefaults
- Breaking: Удален метод sendAuthenticationEvent 

### Added
- Добавлено поле `timestamp` в `MTAppEvent`


## v.5.3.1 - Sep 11, 2025

### Fixed
- Исправлена проблема с открытием WebView на iPhone 7/6s на iOS 15

## v.5.3.0 - Aug 11, 2025

### Fixed
- Измененена версия зависимости GRDB на 6.29.3
- Исправлена инициализация: MTRemoteConfig, MTLinkResolver и MTPerformance теперь загружаются только при необходимости

## v.5.2.0 - Jul 22, 2025

### Added
- Добавлен Property Wrapper MTRemoteConfigWrapper для получения значения Remote Config по ключу
- Добавлено новое публичное свойство allDefaultValues в Remote Config

### Fixed
- Исправлены баги и улучшена общая стабильность работы c SQLite

## v.5.1.4 - Jun 13, 2025

### Fixed
- Исправлена проблема потенциального deadlock при обращении к db с разных потоков
- Исправлена работа трекинга запросов в Performance модуле, который мог блокировать запрос сторонних SDK

## v.5.1.3 - Jun 9, 2025

### Fixed
- Исправлена проблема с падением SDK при блокировании db

## v.5.1.2 - May 30, 2025

### Fixed
- Исправлена проблема с установкой SDK через cocoapods

## v.5.1.1 - May 30, 2025

### Fixed
- Исправлены баги и ошибки

## v.5.1.0 - May 29, 2025

### Added
- Добавлена версия MTAnalytics в формате Static Framework
- Добавлен функционал Perfomance
- Добавлено новое публичное свойство allValues в Remote Config

### Fixed
- Исправлен data race в SQLite

## v.5.0.0 - April 2, 2025

### Changed

- Breaking: MTMetricsConfiguration переименован на MTAnalyticsConfiguration
- Breaking: MTMetricsApp переименован на MTAnalyticsApp
- Breaking: метод resolveLink перенесен в linkResolver
- Breaking: sdkVersion and sdkBuildNumber перенесены в MTAnalyticsApp
- Обновлена структура лог сообщений

### Added
- Добавлены async track методы

## v.4.1.0 - February 11, 2025

### Added
- Добавлено проперти для получения sdkBuildNumber

### Fixed
- Исправлена работа log сообщений

## v.4.0.0 - February 5, 2025

### Changed
- Breaking: MTAnalyticsConfiguration переименован на MTMetricsConfiguration
- Breaking: MTAnalyticsProvider переименован на MTAnalytics

### Added
- Добавлен новый способ конфигурировать SDK, используя класс MTMetricsApp
- Добавлен функционал Remote Config
- Добавлено проперти для получения sdkVersion
- Добавлен новый алгоритм вычисления hit_id
- Добавлено экосистемное поле MtsIDAuthState
- Добавлено название модуля откуда логгируется сообщение

### Removed
- Breaking: Удалена возможность передавать кастомный тип события в MTCustomEvent

## v.3.2.0 - December 5, 2024

### Added
- Добавлена валидация flowId для Debug сборки
- Максимальное количество символов для MTEcosystemEvent увеличен с 100 до 200

### Fixed
- Исправлены баги и улучшена общая стабильность

## v.3.1.0 - October 11, 2024

### Added
- Добавлен публичный метод resolveLink для получения параметров при переходе на universal link
- Лимит количества символов для поля eventName увеличен с 100 до 500
- Добавлен публичный метод trackViewDidAppear для отслеживания скорости загрузки экрана

### Fixed
- Исправлены баги и улучшена общая стабильность

## v.3.0.0 - September 12, 2024

### Changed
- Breaking: Деперсонализация SDK для МТС Банка

### Fixed
- Исправлены баги и улучшена общая стабильность

## v.2.5.3 - August 12, 2024

### Changed
- Обновлена версия swift protobuf для установки через SPM

## v.2.5.2 - August 8, 2024

### Added
- Добавлены новые шаблоны события для работы с ECommerce
- Добавлено шаблон события для работы с deeplinks

## v.2.4.0 - June 20, 2024

### Added
- Добавлен Privacy Manifest

### Fixed
- Исправлены баги и улучшена общая стабильность

## v.2.3.0 - June 10, 2024

### Fixed
- Исправлены баги и улучшена общая стабильность

## v.2.2.2 - May 23, 2024

### Fixed
- Исправлены баги и улучшена общая стабильность

## v.2.2.1 - May 23, 2024

### Added
- Реализована поддержка SDK на tvOS с минимальной версией 13.0

## v.2.1.0 - April 15, 2024

### Changed
- Breaking: Минимально необходимая версия iOS поднята до 13.0

### Fixed
- Исправлено предупреждение, связанное с лицензией, возникающее при установке SDK
- Исправлена ошибка парсинга null значений, при передаче таких значений из приложений на flutter

## v.2.0.0 - March 22, 2024

### Fixed
- Исправлено дублирование параметров event и event_type для экосистемного ивента
