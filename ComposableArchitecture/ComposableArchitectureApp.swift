//
//  ComposableArchitectureApp.swift
//  ComposableArchitecture
//
//  Created by Milko Škofič on 19/10/2020.
//

import SwiftUI
import Combine

//
// Application state.
//
var state = AppState()

@main
struct ComposableArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialValue: AppState(), reducer: appReducer))
        }
    }
}
