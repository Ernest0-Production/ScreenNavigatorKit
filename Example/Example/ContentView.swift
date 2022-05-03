//
//  ContentView.swift
//  ScreenNavigatorKitExample
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI
import ScreenNavigatorKit

enum ScreenTag {
    case root
    case first
    case second
    case third
}

struct ContentView: View {
    @EnvironmentObject var screenNavigator: ScreenNavigator<ScreenTag>
    @State var someValue = 0

    var body: some View {
        AnyScreenView(
            title: "MAIN",
            actions: [
                .push("push screen 1", AnyScreenView(title: "Screen 1")),

                    .push("push screen 2", AnyScreenView(
                        title: "Screen 2",
                        actions: [
                            .push("push screen 3", AnyScreenView(
                                title: "Screen 3",
                                actions: [
                                    .pop("Pop"),
                                    .popTo("Pop To Root", ScreenTag.root),
                                ]
                            )),
                            .pop("Pop")
                        ]
                    )),

                    .present("present screen 1", AnyScreenView(
                        title: "Screen 1",
                        actions: [
                            .present("present screen 3", AnyScreenView(
                                title: "Screen 3",
                                actions: [
                                    .dismiss("dismiss"),
                                    .dismissTo("dismiss to root", ScreenTag.root),
                                    .custom("update root state") { someValue += 1 }
                                ]
                            ))
                        ]
                    )),

                    .present("present screen 2", AnyScreenView(title: "Screen 2")),

                    .custom("Push Another Screen") {
                        screenNavigator.push { AnotherView() }
                    }
            ]
        )
            .screenTag(ScreenTag.root)
            .navigationTitle(String(someValue))
    }
}

struct AnotherView: View {
    @EnvironmentObject var screenNavigator: ScreenNavigator<ScreenTag>

    var body: some View {
        VStack {
            Text("Another View")

            Button("Push Settings") {
                screenNavigator.push {
                    Text("Settings")
                }
            }
        }
    }
}

struct AnyScreenView: View {
    @EnvironmentObject var screenNavigator: ScreenNavigator<ScreenTag>

    enum Action {
        case push(String, AnyScreenView)
        case pop(String)
        case popTo(String, ScreenTag)

        case present(String, AnyScreenView)
        case dismiss(String)
        case dismissTo(String, ScreenTag)
        case custom(String, () -> Void)
    }

    let title: String
    var actions: [Action] = []

    var body: some View {
        VStack {
            Text(title)

            ForEach(0..<actions.count, id: \.self) { index in
                switch actions[index] {
                case let .push(name, view):
                    Button(name) {
                        screenNavigator.push() { view }
                    }
                case let .pop(name):
                    Button(name) {
                        screenNavigator.pop()
                    }
                case .popTo(let name, let screen):
                    Button(name) {
                        screenNavigator.pop(to: screen)
                    }
                case let .present(name, view):
                    Button(name) {
                        screenNavigator.present { view }
                    }
                case let .dismiss(name):
                    Button(name) {
                        screenNavigator.dismiss()
                    }
                case let .dismissTo(name, screen):
                    Button(name) {
                        screenNavigator.dismiss(to: screen)
                    }
                case let .custom(name, action):
                    Button(name) {
                        action()
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
