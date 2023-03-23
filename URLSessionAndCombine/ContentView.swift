//
//  ContentView.swift
//  URLSessionAndCombine
//
//  Created by july on 2023/3/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = BeerViewModel()
    
    var body: some View {
        BeersList(
            beers: viewModel.state.beers,
            isLoading: viewModel.state.canLoadNextPage,
            onScrolledAtBottom: viewModel.fetchNextPageIfPossible
        )
        .onAppear(perform: viewModel.fetchNextPageIfPossible)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

