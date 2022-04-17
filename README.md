# ScreenNavigatorKit

# Usage

```swift
import ScreenNavigatorKit 

enum Screen { 
    case root
    case firstScreen
    case secondScreen
    case ...
}

@main
struct ExampleApp: App { 
    @StateObject var screenNavigator = ScreenNavigator<Screen>(rootScreenTag: .root)
    
    var body: some Group { 
        WindowGroup { 
            RootScreenView()
              .environmentObject(screenNavigator)
        }
    }
}

// RootScreenView.swift

struct RootScreenView: View { 
    @EnvironmentObject var screenNavigator: ScreenNavigator<Screen>

    var body: View { 
        VStack { 
            Text("Root")
            Button("Push Screen 1") { 
                screenNavigator.push { 
                    FirstScreenView()
                }
            }
            Button("Present Screen 2") { 
                screenNavigator.push { 
                    SecondScreenView()
                }
            }
        }
        .screenTag(Screen.root)
    }
}

// FirstScreenView.swift

struct FirstScreenView: View { 
    @EnvironmentObject var screenNavigator: ScreenNavigator<Screen>

    var body: View { 
        VStack { 
            Text("First")
            Button("Push Screen 3") { 
                screenNavigator.push { 
                    ThrirdScreenView()
                }
            }
            Button("Pop") { 
                screenNavigator.pop()
            }
        }
        .screenTag(Screen.first)
    }
}

// ThirdScreenView.swift

struct ThirdScreenView: View { 
    @EnvironmentObject var screenNavigator: ScreenNavigator<Screen>

    var body: View { 
        VStack { 
            Text("Third")
            Button("Pop") { 
                screenNavigator.pop()
            }
            Button("Pop to root") { 
                screenNavigator.pop(to: Screen.root)
            }
        }
        .screenTag(Screen.third)
    }
}
```

<img width="875" alt="image" src="https://user-images.githubusercontent.com/19843524/163728673-e8e98185-586c-40b9-ae2c-cb98e06d11ad.png">
