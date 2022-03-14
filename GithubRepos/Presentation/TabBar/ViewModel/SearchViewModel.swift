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
        let pullRefresh: Signal<Void>
        let didScrollToBottom: Signal<Void>
        let searchBarText: Signal<String>
    }
    struct Output {
        let repoList: Driver<[RepoItem]>
        let refreshAction: Signal<Bool>
        let bottomSpinnerAction: Signal<Bool>
    }
    var disposeBag = DisposeBag()

    private var currentPage = 1
    private let maxPage = 30
    private var currentText = ""
    private var isPagination = false

    private let repoList = BehaviorRelay<[RepoItem]>(value: [])
    private let refreshAction = PublishRelay<Bool>()
    private let bottomSpinnerAction = PublishRelay<Bool>()

    init(coordinator: TabBarCoordinator?, useCase: SearchUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {

        Signal
            .merge(
                input.searchBarText,
                input.pullRefresh.withLatestFrom(input.searchBarText).delay(.seconds(1))
            )
            .emit(onNext: { [weak self] text in
                guard let self = self else { return }
                print(text)
                self.repoList.accept([])
                self.refreshAction.accept(true)
                self.currentPage = 1
                self.currentText = text
                self.requestSearchRepos(text: text)
            })
            .disposed(by: disposeBag)

        input.didScrollToBottom
            .filter { [weak self] _ in
                guard let self = self else { return false }
                return !self.isPagination
                && !self.repoList.value.isEmpty
                && self.repoList.value.count % 30 == 0
                && self.currentPage <= self.maxPage
            }
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("바텀!!")
                self.isPagination = true
                self.bottomSpinnerAction.accept(true)
                self.requestSearchRepos(text: self.currentText)
            })
            .disposed(by: disposeBag)

        self.useCase.successReqeustSearch
            .asSignal()
            .emit(onNext: { [weak self] repos in
                guard let self = self else { return }
                print(repos.items.count, self.currentPage)
                let list = self.repoList.value + repos.items
                self.repoList.accept(list)
                self.resetLoadingAction()
                self.currentPage += 1
            })
            .disposed(by: disposeBag)

        self.useCase.failGithubError
            .asSignal()
            .do { [weak self]  _ in
                self?.resetLoadingAction()
            }
            .map { _ in [] }
            .emit(to: repoList)
            .disposed(by: disposeBag)

        return Output(
            repoList: repoList.asDriver(),
            refreshAction: refreshAction.asSignal(),
            bottomSpinnerAction: bottomSpinnerAction.asSignal()
        )
    }

    private func resetLoadingAction() {
        self.refreshAction.accept(false)
        self.isPagination = false
        self.bottomSpinnerAction.accept(false)
    }
}

extension SearchViewModel {

    private func requestSearchRepos(text: String) {
        self.useCase.requestSearch(searchName: text, page: currentPage)
    }
}
