//
//  Reducers.swift
//  ComposableArchitecture
//
//  Created by Milko Škofič on 19/10/2020.
//

import Combine
import SwiftUI

//
// Application reducer.
//
func appReducer(state: inout AppState, action: AppAction) {
    switch action {
    
    case .counter(.decrTapped):
        state.count -= 1
        
    case .counter(.incrTapped):
        state.count += 1
        
    case .primeModal(.saveFavoritePrimeTapped):
        state.favoritePrimes.append(state.count)
        state.activityFeed.append(.init(timestamp: Date(), type: .addedFavoritePrime(state.count)))
        
    case .primeModal(.removeFavoritePrimeTapped):
        state.favoritePrimes.removeAll(where: { $0 == state.count })
        state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(state.count)))
        
    case let .favoritePrimes(.deleteFavoritePrimes(indexSet)):
        for index in indexSet {
            let prime = state.favoritePrimes[index]
            state.favoritePrimes.remove(at: index)
            state.activityFeed.append(.init(timestamp: Date(), type: .removedFavoritePrime(prime)))
        }
    }
}
