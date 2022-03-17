//
//  SearchViewModelTests.swift
//  GithubReposTests
//
//  Created by meng on 2022/03/17.
//

import XCTest

import RxCocoa
import RxSwift
import RxTest

@testable import GithubRepos

class SearchViewModelTests: XCTestCase {

    private var viewModel: SearchViewModel!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var input: SearchViewModel.Input!
    private var output: SearchViewModel.Output!

    private let dummyData = [
        RepoItem(id: 1, fullName: "29cmGodRepos/kingkinggod", description: nil, topics: ["29likes", "29king", "29godofkingking"], star: 1000, fork: 2, language: "Swift", updatedAt: Date())
    ]

    override func setUpWithError() throws {
        self.viewModel = SearchViewModel(
            coordinator: nil,
            useCase: MockSearchUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
    }

    func test_Search_Success_Case() throws {
        let refreshTestableObservable = self.scheduler.createHotObservable([
                    .next(0, ())
                ])

        let scrollTestableObservable = self.scheduler.createHotObservable([
                    .next(20, ())
                ])

        let textTestableObservable = self.scheduler.createHotObservable([
            .next(10, "29cm")
        ])

        let repoListObserver = self.scheduler.createObserver([RepoItem].self)

        self.input = SearchViewModel.Input(
            pullRefresh: refreshTestableObservable.asSignal(onErrorJustReturn: ()),
            didScrollToBottom: scrollTestableObservable.asSignal(onErrorJustReturn: ()),
            searchBarText: textTestableObservable.asSignal(onErrorJustReturn: "")
        )

        self.viewModel.transform(input: input)
            .repoList
            .drive(repoListObserver)
            .disposed(by: self.disposeBag)

        scheduler.start()
        
        XCTAssertEqual(repoListObserver.events, [
            .next(0, []),
            .next(10, []), // 백그라운드 배경을 띄우려고 나온 빈배열
            .next(10, dummyData)
        ], "The objects should be equal but is not")
    }
}
