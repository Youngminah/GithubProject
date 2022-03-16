//
//  ProfileViewModel.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import Foundation
import ProgressHUD
import RxCocoa
import RxSwift

final class ProfileViewModel: ViewModelType {

    private weak var coordinator: TabBarCoordinator?
    private let useCase: ProfileUseCase

    struct Input {
        let viewDidLoad: Signal<Void>
        let pullRefresh: Signal<Void>
        let didScrollToBottom: Signal<Void>
    }
    struct Output {
        let userInfo: Signal<UserInfo>
        let repoList: Driver<[RepoItem]>
        let refreshAction: Signal<Bool>
        let bottomSpinnerAction: Signal<Bool>
        let failRequestAction: Signal<Void>
    }
    var disposeBag = DisposeBag()

    private var currentPage = 1
    private let maxPage = 30
    private var isPagination = false

    private let userInfo = PublishRelay<UserInfo>()
    private let repoList = BehaviorRelay<[RepoItem]>(value: [])
    private let refreshAction = PublishRelay<Bool>()
    private let bottomSpinnerAction = PublishRelay<Bool>()
    private let successRequest = PublishRelay<Void>()
    private let failRequestAction = PublishRelay<Void>()

    init(coordinator: TabBarCoordinator?, useCase: ProfileUseCase) {
        self.coordinator = coordinator
        self.useCase = useCase
    }

    func transform(input: Input) -> Output {
        Signal
            .merge(
                input.viewDidLoad,
                input.pullRefresh.delay(.milliseconds(500))
            )
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                if UserDefaults.standard.string(forKey: "accessToken") != nil {
                    self.requestUserInfo()
                }
            })
            .disposed(by: disposeBag)

        successRequest.asSignal()
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.repoList.accept([])
                self.refreshAction.accept(true)
                self.currentPage = 1
                self.requestUserStarredRepos()
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
                self.requestUserStarredRepos()
            })
            .disposed(by: disposeBag)

        self.useCase.successReqeustUserInfo
            .asSignal()
            .emit(onNext: { [weak self] info in
                guard let self = self else { return }
                //print(info)
                self.successRequest.accept(())
                self.userInfo.accept(info)
            })
            .disposed(by: disposeBag)

        self.useCase.successReqeustUserRepos
            .asSignal()
            .emit(onNext: { [weak self] repos in
                guard let self = self else { return }
                print(repos[0].fullName, self.currentPage)
                let list = (self.currentPage == 1) ? repos : self.repoList.value + repos
                self.resetLoadingAction()
                self.repoList.accept(list)
                self.currentPage += 1
            })
            .disposed(by: disposeBag)

        self.useCase.failGithubError
            .asSignal()
            .emit(onNext: { [weak self]  _ in
                guard let self = self else { return }
                ProgressHUD.show("네트워크 오류", icon: .failed, interaction: false)
                self.repoList.accept([])
                self.resetLoadingAction()
                self.failRequestAction.accept(())
            })
            .disposed(by: disposeBag)

        return Output(
            userInfo: userInfo.asSignal(),
            repoList: repoList.asDriver(),
            refreshAction: refreshAction.asSignal(),
            bottomSpinnerAction: bottomSpinnerAction.asSignal(),
            failRequestAction: failRequestAction.asSignal()
        )
    }

    private func resetLoadingAction() {
        self.refreshAction.accept(false)
        self.isPagination = false
        self.bottomSpinnerAction.accept(false)
    }
}

extension ProfileViewModel {

    private func requestUserInfo() {
        self.useCase.requestUserInfo()
    }

    private func requestUserStarredRepos() {
        self.useCase.requestUserStarredRepos(page: currentPage)
    }
}
