//
//  ExampleApp.swift
//  ScreenNavigatorKitExample
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI
import ScreenNavigatorKit

struct PushExample: View {
    @StateObject var controller = NavigationStackController()
    @State var globalState = 0

    var body: some View {
        VStack(spacing: 0) {
            NavigationStackView(controller) {
                VStack {
                    ScreenView(tag: "ROOT")
                }
            }

            Divider()

            PushControlView(controller: controller)
        }
    }

    struct ScreenView: View {
        let tag: String

        @State var state: Int = 0

        @EnvironmentObject var controller: NavigationStackController

        var body: some View {
            VStack(spacing: 16) {
                Text("tag: \(tag)")

                Text("items count: \(controller.itemsCount)")

                Text("Local state \(state)")
                Button("Increment state") { state += 1 }
            }
        }
    }

    struct PushControlView: View {
        let controller: NavigationStackController

        @State var tag: String = ""

        @State var screenCount: Int = 4

        var body: some View {
            VStack(alignment: .leading) {
                Text("Move to")

                Divider()

                Group {
                    HStack {
                        Text("TAG:")
                        TextField("tag", text: $tag)
                    }
                    Button("PUSH") {
                        if tag.isEmpty {
                            let autoTag = UUID().uuidString
                            controller.push(tag: autoTag, ScreenView(tag: autoTag))
                        } else {
                            controller.push(tag: tag, ScreenView(tag: tag))
                        }
                    }
                    Button("POP TO") {
                        if tag.isEmpty {
                            controller.pop()
                        } else {
                            controller.pop(to: tag)
                        }
                    }
                    Button("POP FROM") {
                        controller.pop(from: tag)
                    }
                }

                Divider()

                Group {
                    HStack {
                        Text("SCREEN COUNT:")
                        TextField("count", value: $screenCount, formatter: NumberFormatter())
                    }
                    Button("PUSH") {
                        for number in 1...screenCount {
                            controller.push(tag: number, ScreenView(tag: "\(number)"))
                        }
                    }
                    .disabled(screenCount == 0)
                    Button("POP LAST") {
                        controller.popLast(screenCount)
                    }
                    .disabled(screenCount == 0)
                }

                Divider()

                Button("POP TO ROOT") {
                    controller.popToRoot()
                }
            }
            .padding()
        }
    }
}

struct ModalExample: View {
    @StateObject var controller = ModalStackController()
    @State var globalState = 0

    var body: some View {
        VStack(spacing: 0) {
            ModalStackView(controller) {
                VStack {
                    ScreenView(tag: "ROOT")
                }
            }
        }
    }

    struct ScreenView: View {
        let tag: String

        @State var state: Int = 0

        @EnvironmentObject var controller: ModalStackController

        var body: some View {
            VStack {
                VStack(spacing: 16) {
                    Text("tag: \(tag)")

                    Text("items count: \(controller.itemsCount)")

                    Text("Local state \(state)")
                    Button("Increment state") { state += 1 }
                }
                .frame(maxHeight: .infinity)

                Divider()

                ModalControlView(controller: controller)
            }
        }
    }

    struct ModalControlView: View {
        let controller: ModalStackController

        @State var tag: String = ""

        @State var screenCount: Int = 4
        @State var presentationStyle: PresentationStyle = .sheet

        var body: some View {
            VStack(alignment: .leading) {
                Picker("Style", selection: $presentationStyle) {
                    Text(String(describing: PresentationStyle.sheet)).tag(PresentationStyle.sheet)
                    Text(String(describing: PresentationStyle.fullScreenCover)).tag(PresentationStyle.fullScreenCover)
                }
                .pickerStyle(.segmented)

                Text("Move to")

                Divider()

                Group {
                    HStack {
                        Text("TAG:")
                        TextField("tag", text: $tag)
                    }
                    Button("PRESENT") {
                        if tag.isEmpty {
                            let autoTag = UUID().uuidString
                            controller.present(presentationStyle, tag: autoTag, ScreenView(tag: autoTag))
                        } else {
                            controller.present(presentationStyle, tag: tag, ScreenView(tag: tag))
                        }
                    }
                    Button("DISMISS TO") {
                        if tag.isEmpty {
                            controller.dismiss()
                        } else {
                            controller.dismiss(to: tag)
                        }
                    }
                    Button("DISMISS FROM") {
                        controller.dismiss(from: tag)
                    }
                }

                Divider()

                Group {
                    HStack {
                        Text("SCREEN COUNT:")
                        TextField("count", value: $screenCount, formatter: NumberFormatter())
                    }
                    Button("PRESENT") {
                        for number in 1...screenCount {
                            controller.present(presentationStyle, tag: number, ScreenView(tag: "\(number)"))
                        }
                    }
                    .disabled(screenCount == 0)
                    Button("DISMISS LAST") {
                        controller.dismissLast(screenCount)
                    }
                    .disabled(screenCount == 0)
                }

                Divider()

                Button("DISMISS TO ROOT") {
                    controller.dismissAll()
                }
            }
            .padding()
        }
    }
}

@main
struct ExampleApp: App {
    @State var isPushExample = false

    var body: some Scene {
        WindowGroup {
            Toggle("Push Example", isOn: $isPushExample)
                .padding()

            if isPushExample {
                PushExample()
            } else {
                ModalExample()
            }
        }
    }
}

func recursive(_ function: @escaping (@escaping () -> Void) -> Void) {
    var functionPointer: (() -> Void)? = nil

    functionPointer = {
        function {
            functionPointer!()
        }
    }

    functionPointer!()
}

private extension Binding {
    func number() -> Binding<String> where Value == Int {
        Binding<String> {
            self.wrappedValue.description
        } set: { newValue, transaction in
            self.transaction(transaction).wrappedValue = Int(newValue) ?? -1
        }
    }
}
