//
//  Reducers.swift
//  ComposableArchitecture
//
//  Created by Milko Škofič on 19/10/2020.
//

import Combine
import SwiftUI


//
// Counter view reducer,
//
func counterReducer(state: inout Int, action: AppAction) {
    switch action {
    
    case .counter(.decrTapped):
        state -= 1
        
    case .counter(.incrTapped):
        state += 1
        
    default:
        break
    }
}

//
// Prime modal view reducer,
//
func primeModalReducer(state: inout AppState, action: AppAction) {
    switch action {
    
    case .primeModal(.saveFavoritePrimeTapped):
         state.favoritePrimes.append(state.count)
         state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
         
     case .primeModal(.removeFavoritePrimeTapped):
         state.favoritePrimes.removeAll(where: { $0 == state.count })
         state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))

   default:
        break
    }
}

//
// Favourite primes view reducer,
//
func favoritePrimesReducer(state: inout FavoritePrimesState, action: AppAction) {
    switch action {
    
    case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
        for index in indexSet {
            let prime = state.favoritePrimes[index]
            state.favoritePrimes.remove(at: index)
            state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
        }

    default:
        break
    }
}

//
// Favourite primes state struct.
//
struct FavoritePrimesState {
    var favoritePrimes: [Int]
    var activityFeed: [AppState.Activity]
}

//
// Extend AppState.
//
extension AppState {
    var favoritePrimesState: FavoritePrimesState {
        get {
            FavoritePrimesState(
                favoritePrimes: self.favoritePrimes,
                activityFeed: self.activityFeed
            )
        }
        set {
            self.favoritePrimes = newValue.favoritePrimes
            self.activityFeed   = newValue.activityFeed
        }
    }
}

//
// Reducers combiner.
//
func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
) -> (inout Value, Action) -> Void {
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

//
// Pullback function.
//
func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>
) -> (inout GlobalValue, Action) -> Void {
    return { globalValue, action in
      reducer(&globalValue[keyPath: value], action)
    }
}

//
// Application reducer.
//
let appReducer = combine(
    pullback(counterReducer, value: \.count),
    primeModalReducer,
    pullback(favoritePrimesReducer, value: \.favoritePrimesState)
)
