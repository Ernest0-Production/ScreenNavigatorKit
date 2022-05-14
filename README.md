# ScreenNavigatorKit

Framework that provide convenient environment for manage navigation in SwiftUI.

##  Pros:
- 🤢 No boolean flag such as `@State var isActive`
- 🤮 No `enum` flag  such as `@State var route: RouteAction?` with big `switch-case` statement
- 🤡 No implicit `UIKit` hacks with `UIViewController`
- 💩 No singleton/shared/global presenter of application

### 🔩 Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

# 🧐 How does it work?!

Framework has only two `state object`, each of which isolates "toggle-work" of `@State var isActive: Bool` and `@State var isPresent: Bool` flags.

## 1. `NavigationStack`

Like `UINavigationController`, it **store stack state** and **provide stack transformation** using `push` and `pop` methods:
```swift
let navigationStack = NavigationStack()

// Standard usage

navigationStack.push(Text("My View"))
navigationStack.pop()
navigationStack.popToRoot()

// Advanced usage

enum Screen: Hashable { 
    case detail
    ...
}

navigationStack.push(tag: Screen.detail, DetailView())
navigationStack.pop(to: Screen.detail)
```
Its companion is `NavigationStackView` – wrapper over `NavigationView` that bind `NavigationStack` with it:
```swift
struct ContentView: View { 
    @StateObject var navigationStack = NavigationStack() 

    var body: some View { 
        NavigationStackView(navigationStack) { 
            RootView(
                showDetails: { model in 
                    navigationStack.push(DetailView(model: model))
                },
                showSettings: { 
                    navigationStack.push(SettingsView())
                }
            )
        }
    }
}

// Another usage with automatic initialized NavigationStack

struct ContentView: View { 
    var body: some View { 
        NavigationStackView { navigationStack in
            RootView(
                showDetails: { model in 
                    navigationStack.push(DetailView(model: model))
                },
                showSettings: { 
                    navigationStack.push(SettingsView())
                }
            )
        }
    }
}
```

Any pushed view has access to `NavigationStack` of `NavigationStackView` through `EnvironmentObject`:
```swift
struct DetailView: View { 
    let model: Model
    @EnvironmentObject var navigationStack: NavigationStack

    var body: some View { 
        VStack { 
            Text(model.title)
            Button("pop to root") { 
                navigationStack.popToRoot()
            }
        }
    }
}
```
**💫 EXTRA FEATURE:** You can tag any pushed view using any `Hashable` type. It allow refer to specific screen on pop:
```swift
navigationStack.push(tag: "Screen 1", Screen1()))
navigationStack.pop(to: "Screen 1")
```

## 2. `ModalStack`

Like `NavigationStack`, the `ModalStack` **control modal stack hierarchy** and **provide stack transformation** using `present` and `dismiss` methods:
```swift
let modalStack = ModalStack()

// Standard usage

modalStack.present(.sheet, Text("My View"))
modalStack.present(.fullScreenCover, Text("Another View"))
modalStack.dismiss()
modalStack.dismissAll()

// Advanced usage

enum Screen: Hashable { 
    case detail
    ...
}

modalStack.present(.sheet, tag: Screen.detail, DetailView())
modalStack.dismiss(to: Screen.detail)
```

**🚧 NOTE:** `SwiftUI` does not allow to dismiss multiple views at once! Therefore, methods such as `dismissAll()` or `dismiss(to:)`/`dismiss(from:)` will close all views **sequentially**. 

To attach `ModalStack` to a `view`, you need to declare a **root view** on top of which all views will be presented using the method `definesPresentationContext(with:)`:
```swift
struct ExampleApp: App { 
    @StateObject var modalStack = ModalStack()

    var body: some Scene { 
        WindowGroup { 
            RootView()
                .definesPresentationContext(with: modalStack)
                // or just call .definesPresentationContext()
        }
    }
}
```
Any presented view has access to `ModalStack` through `EnvironmentObject` too:
```swift
struct RootView: View { 
    @EnvironmentObject var modalStack: ModalStack

    var body: some View { 
        VStack { 
            Text("Home screen")
            Button("FAQ") { 
                modalStack.present(.sheet, FAQView())
            }
            Button("Authorize") { 
                modalStack.present(.fullScreenCover, LoginView())
            }
        }
    }
}
```
> 💫 Just like in `NavigationStack` you can tag presented views when present with `ModalStack`

# API
`NavigationStack`
- push
- push(tag:)
- pop
- pop(tag:)
- popLast(_ k:)
- popToRoot

`ModalStack`
- present(_ presentationStyle:)
- present(_ presentationStyle:tag:)
- dismiss
- dismiss(tag:)
- dismissLast(_ k:)
- dismissAll
- `PresentationStyle`
    - sheet
    - fullScreenCover

# FAQ

### Can i mix this framework with existing navigation approach in my project?

**Yes, you can**. The framework does not affect navigation built in other ways, such as through the standard `@State var isActive: Bool` flags or through UIKit hacks.\
`NavigationStack` and `ModalStack` create local state and manage only their own state.

### What about `Alert`?

Unfortunately, the framework **does not support** such a mechanism for working with `Alert`, BUT **you can implement it yourself by analogy** with `ModalStack`.\
Your project can have many different custom presentations (`popup`, `snackbar`, `toast`, `notifications`) and each of them require specific logic for handle hierarchy, depending on their implementation.\
So adding new presentation methods to the framework **is not planned**.

# 📦 Installation

#### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.

```swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "YOUR_PROJECT_NAME",
  dependencies: [
      .package(url: "https://github.com/Ernest0-Production/ScreenNavigatorKit.git", from: "0.0.3")
  ],
  targets: [
      .target(name: "YOUR_TARGET_NAME", dependencies: ["ScreenNavigatorKit"])
  ]
)
```

### Credits

- [Telegram](https://t.me/Ernest0n)

### License

ScreenNavigatorKit is released under the MIT license. See [LICENSE](https://github.com/Ernest0-Production/ScreenNavigatorKit/blob/main/LICENSE.md) for details.
