//
//  ExampleApp.swift
//  ScreenNavigatorKitExample
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI
import ScreenNavigatorKit

@main
struct ExampleApp: App {
    @StateObject var screenNavigator = ScreenNavigator<ScreenTag>(rootScreenTag: .root)

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(screenNavigator)
        }
    }
}
