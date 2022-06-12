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
    @State var globalState = 0

    var body: some Scene {
        WindowGroup {
            VStack {
                Button("Global state \(globalState)") {
                    globalState += 1
                }

                NavigationStackView {
                    ExampleScreenView(
                        title: "Root screen",
                        pushActions: [
                            PushAction(title: "push") {
                                $0.push(
                                    tag: "Screen 2",
                                    ExampleScreenView(
                                        title: "Screen 2",
                                        pushActions: [
                                            PushAction(title: "push") {
                                                $0.push(ExampleScreenView(
                                                    title: "Screen 3",
                                                    pushActions: [
                                                        PushAction(title: "pop") { $0.pop() },

                                                        PushAction(title: "pop to root") { $0.popToRoot() },

                                                        PushAction(title: "pop last 2") { $0.popLast(2) },

                                                        PushAction(title: "pop to tagged Screen 2") { $0.pop(to: "Screen 2") },

                                                        PushAction(title: "pop from tagged Screen 2") { $0.pop(from: "Screen 2") }
                                                    ])
                                                )
                                            },

                                            PushAction(title: "pop") { $0.pop() }
                                        ]
                                    )
                                )
                            },

                            PushAction(title: "pop") { $0.pop() }
                        ],
                        presentActions: [
                            PresentAction(title: "present") {
                                $0.present(.fullScreenCover, tag: "Screen 2", ExampleScreenView(
                                    title: "Screen 2",
                                    presentActions: [
                                        PresentAction(title: "Update global state \(globalState)") { _ in
                                            globalState += 1
                                        },

                                        PresentAction(title: "dismiss") { $0.dismiss() },

                                        PresentAction(title: "present") {
                                            $0.present(.sheet, ExampleScreenView(
                                                title: "Screen 3",
                                                presentActions: [
                                                    PresentAction(title: "dismis") { $0.dismiss() },
                                                    PresentAction(title: "dismis all") { $0.dismissAll() },
                                                    PresentAction(title: "dismis last 2") { $0.dismissLast(2) },
                                                    PresentAction(title: "dismis from tagged Screen 2") { $0.dismiss(from: "Screen 2") },
                                                    PresentAction(title: "dismis to tagged Screen 2") { $0.dismiss(to: "Screen 2") },
                                                ]
                                            ))
                                        }
                                    ]
                                ))
                            }
                        ]
                    )
                        .definesPresentationContext()
                }
            }
        }
    }
}

struct PushAction {
    internal init(title: String, _ perform: @escaping (NavigationStackController) -> Void) {
        self.title = title
        self.perform = perform
    }

    let title: String
    let perform: (NavigationStackController) -> Void
}

struct PresentAction {
    internal init(title: String, _ perform: @escaping (ModalStackController) -> Void) {
        self.title = title
        self.perform = perform
    }

    let title: String
    let perform: (ModalStackController) -> Void
}

struct ExampleScreenView: View {
    let title: String
    @EnvironmentObject var navigationStackController: NavigationStackController
    @EnvironmentObject var modalStackController: ModalStackController
    var pushActions: [PushAction] = []
    var presentActions: [PresentAction] = []
    @State var state = 0

    var body: some View {
        VStack {
            Text(title)
            Button("update screen state \(state)") {
                state += 1
            }
            ForEach(0..<pushActions.count, id: \.self) { index in
                Button(pushActions[index].title) {
                    pushActions[index].perform(navigationStackController)
                }
            }
            ForEach(0..<presentActions.count, id: \.self) { index in
                Button(presentActions[index].title) {
                    presentActions[index].perform(modalStackController)
                }
            }
        }
    }
}
