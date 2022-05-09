# ScreenNavigatorKit

# API
`NavigationStack`
- push
- push(screenTag:)
- pop
- pop(screenTag:)
- popLast(_ k:)
- popToRoot

`ModalStack`
- present(_ presentationStyle:)
- present(_ presentationStyle:screenTag:)
- dismiss
- dismiss(screenTag:)
- dismissLast(_ k:)
- dismissAll
- `PresentationStyle`
    - sheet
    - fullScreenCover

# Usage

```swift
import ScreenNavigatorKit 

@main
struct ExampleApp: App { 
    @StateObject var navigationStack = NavigationStack()
    
    var body: some Group { 
        WindowGroup { 
            // under-the-hood NavigationView
            NavigationStackView(navigationStack) { 
                RootScreenView()
            }
        }
    }
}

// RootScreenView.swift

struct RootScreenView: View { 
    @EnvironmentObject var navigationStack: NavigationStack

    var body: View { 
        VStack { 
            Text("Root")

            Button("Push Screen 1") { 
                navigationStack.push(FirstScreenView())
            }

            Button("Present Screen 2") { 
                navigationStack.push(
                    screenTag: "Screen2",
                    SecondScreenView()
                )
            }
        }
    }
}

// FirstScreenView.swift

struct FirstScreenView: View { 
    @EnvironmentObject var navigationStack: NavigationStack
    @StateObject var modalStack = ModalStack()

    var body: View { 
        VStack { 
            Text("First")
            
            Button("Pop") {
                navigationStack.pop()
            }

            Button("Pop To Root") {
                navigationStack.popToRoot()
            }

            Button("Present Modal Screen") { 
                modalStack.present(
                    .sheet,
                    Text("Modal Screen Example")
                )
            }
        }
        .definesPresentationContext(with: modalStack)
    }
}

// SecondScreenView.swift

struct SecondScreenView: View { 
    @EnvironmentObject var navigationStack: NavigationStack

    var body: View { 
        VStack { 
            Text("Second")

            Button("Pop from taggeg screen") { 
                navigationStack.pop(from: "Screen 2")
            }

            Button("Pop last 2 screen") { 
                screenNavigator.popLast(2)
            }
        }
    }
}
```