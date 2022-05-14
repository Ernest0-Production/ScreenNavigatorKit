//
//  PushScreen.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 08.05.2022.
//

import SwiftUI


final class PushScreen: ObservableObject, CustomStringConvertible {
    init(tag: AnyHashable? = nil) { self.tag = tag }

    let tag: AnyHashable?
    @Published var pushedView: AnyView? {
        willSet { onChangePushedView?(newValue) }
    }

    var onChangePushedView: ((AnyView?) -> ())?

    var description: String {
        if let tag = tag {
            return "PushScreen<\(tag.description)>"
        } else if let content = pushedView {
            return "PushScreen<\(content)>"
        } else {
            return "PushScreen inactive"
        }
    }
}

struct PushScreenView<Content: View>: View {
    let content: Content
    @ObservedObject var screen: PushScreen

    var body: some View {
        content.push($screen.pushedView)
    }
}
