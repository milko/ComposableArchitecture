//
//  FavoritePrimesView.swift
//  ComposableArchitecture
//
//  Created by Milko Škofič on 19/10/2020.
//

import Combine
import SwiftUI

struct FavoritePrimesView: View {
    @ObservedObject var store: Store<AppState, AppAction>

    var body: some View {
        List {
            ForEach(self.store.value.favoritePrimes, id: \.self) { prime in
                Text("\(prime)")
            }
            .onDelete { indexSet in
                self.store.send(.favoritePrimes(.deleteFavoritePrimes(indexSet)))
            }
        }
        .navigationBarTitle(Text("Favorite Primes"))
    }
}

struct FavoritePrimesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritePrimesView(
            store: Store(
                initialValue: AppState(favoritePrimes: [3, 5]),
                reducer: appReducer
            )
        )
    }
}
