//
//  File.swift
//  
//
//  Created by Ernest Babayan on 09.05.2022.
//

import SwiftUI


final class PresentScreen: ObservableObject, CustomStringConvertible {
    init(tag: AnyHashable? = nil) { self.tag = tag }

    let tag: AnyHashable?

    var presentationStyle: PresentationStyle?
    @Published var presentedView: AnyView? {
        willSet { onChangePresentedView?(newValue) }
    }

    var onChangePresentedView: ((AnyView?) -> ())?

    var description: String {
        if let tag = tag {
            return "PresentScreen<\(tag.description)>"
        } else  if let content = presentedView {
            return "PresentScreen<\(content)>"
        } else {
            return "PresentScreen inactive"
        }
    }
}

struct PresentScreenView<Content: View>: View {
    let content: Content
    @ObservedObject var screen: PresentScreen

    var body: some View {
        switch screen.presentationStyle {
        case .sheet, .none:
            content.sheet($screen.presentedView)
        case .fullScreenCover:
            content.fullScreenCover($screen.presentedView)
        }
    }
}
