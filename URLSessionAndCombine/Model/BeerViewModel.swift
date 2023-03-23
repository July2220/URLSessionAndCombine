//
//  RepositoriesViewModel.swift
//  URLSessionAndCombine
//
//  Created by july on 2023/3/23.
//

import SwiftUI
import Combine

//1.
class BeerViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    // 2.
    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        
        PunkAPI.searchBeers(page: state.page)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
            switch completion {
            case .finished:
                break
            case .failure:
                state.canLoadNextPage = false
            }
        }
    private func onReceive(_ batch: [Beer]) {
            state.beers += batch
            state.page += 1
            state.canLoadNextPage = batch.count == PunkAPI.pageSize
        }

    // 3.The state contains all the information to render a view.
    struct State {
        var beers: [Beer] = []
        var page: Int = 1
        var canLoadNextPage = true
    }
}

struct RepositoriesListContainer: View {
    @ObservedObject var viewModel: BeerViewModel
    
    var body: some View {
        BeersList(
            beers: viewModel.state.beers,
            isLoading: viewModel.state.canLoadNextPage,
            onScrolledAtBottom: viewModel.fetchNextPageIfPossible
        )
        .onAppear(perform: viewModel.fetchNextPageIfPossible)
    }
}
