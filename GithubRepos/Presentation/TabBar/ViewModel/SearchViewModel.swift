//
//  SearchViewModel.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import Foundation
import RxCocoa
import RxSwift

final class SearchViewModel: ViewModelType {

    private weak var coordinator: TabBarCoordinator?
    private let useCase: SearchUseCase

    struct Input {
    }
    struct Output {
    }
    var disposeBag = DisposeBag()

    init(coordinator: TabBarCoordinator?, useCase: SearchUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}

