//
//  AuthViewModel.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import Foundation
import RxCocoa
import RxSwift

final class AuthViewModel: ViewModelType {

    private weak var coordinator: TabBarCoordinator?
    private let useCase: AuthUseCase

    struct Input {
    }
    struct Output {
    }
    var disposeBag = DisposeBag()

    init(coordinator: TabBarCoordinator?, useCase: AuthUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
