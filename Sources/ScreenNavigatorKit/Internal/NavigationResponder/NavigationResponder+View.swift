//
//  NavigationResponderView.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

extension View {
    func navigationResponding(with responder: NavigationResponder) -> some View {
        NavigationResponderView(content: self, responder: responder)
    }
}

private struct NavigationResponderView<Content: View>: View {
    let content: Content
    @StateObject var responder: NavigationResponder

    var body: some View {
        content
            .push(responder.binding(\.pushedView))
            .sheet(responder.binding(\.presentedView))
    }
}
