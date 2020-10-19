//
//  Model.swift
//  ComposableArchitecture
//
//  Created by Milko Škofič on 19/10/2020.
//

import Combine
import SwiftUI

//
// Application state structure.
//
struct AppState {
    var count = 0
    var favoritePrimes: [Int] = []
    var loggedInUser: User? = nil
    var activityFeed: [Activity] = []

    struct Activity {
        let timestamp: Date
        let type: ActivityType

        enum ActivityType {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
    }

    struct User {
        let id: Int
        let name: String
        let bio: String
    }
}

//
// Actions.
//
enum CounterAction {
    case decrTapped
    case incrTapped
}
enum PrimeModalAction {
    case saveFavoritePrimeTapped
    case removeFavoritePrimeTapped
}
enum FavoritePrimesAction {
    case deleteFavoritePrimes(IndexSet)
}
enum AppAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
    case favoritePrimes(FavoritePrimesAction)
}

//
// Prime alert structure.
//
struct PrimeAlert: Identifiable {
  let prime: Int

  var id: Int { self.prime }
}

//
// Application state store.
//
final class Store<Value, Action>: ObservableObject {
    let reducer: (inout Value, Action) -> Void
    
    @Published var value: Value
    
    init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
        self.reducer = reducer
        self.value = initialValue
    }
    
    func send(_ action: Action) {
        self.reducer(&self.value, action)
    }
}
