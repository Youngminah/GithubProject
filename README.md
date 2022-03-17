# 29cm 과제 구현


###### 참고사항: Star를 <좋아요>로 생각하고 구현하였습니다.
###### 깃허브 API Pagination최대 갯수가 제한되어있어 30Page까지 페이지네이션을 갯수를 제한하였습니다. (1 Page당 레파지토리 30개)
</br>
</br>

### 요구사항 구현

- [x] 깃허브 API 필수 사용 3가지
- [x] 로그인 기능
- [x] 레파지토리 검색
- [x] 로그인시 Star버튼 눌러 레포 Star가능 및 실시간 앱과 계정 반영
- [x] 레파지토리 필수 표시 항목 표시
- [x] 무한 스크롤 가능하게하기 
- [x] Star눌렀을 때, 다른 화면간의 동기화 (미흡)

### 요구사항 외의 추가적으로 구현사항
- [x] 좋아요, 좋아요 취소,여부확인, 로그인 API 
- [x] Pull Refresh 구현
- [x] 다크모드 대응
- [x] Topics 구현 (Self sizing 및 CollectionView Left align 이용)
- [x] ViewModel Unit Test Code 일부 작성
- [x] UITest코드 극 일부 작성
- [x] 키보드 대응
- [x] 이미지 캐싱 
- [x] 기본적 네트워크 오류 대응 (미흡함)

</br>
</br>


## 영상으로 구현화면 미리보기
### 로그인, 로그아웃 좋아요 Flow

https://user-images.githubusercontent.com/42762236/158707133-a23e185a-4c5b-411c-a8df-79b0c8f75668.mp4

</br>

### 다크모드, 검색, 무한 스크롤과 Topics Self-sizing 영상

https://user-images.githubusercontent.com/42762236/158707543-9b3c718a-9ec3-49f5-af57-f35165ba7e80.mp4

</br>

### 네트워크 연결 중간에 끊어보기
![Simulator Screen Recording - iPhone 12 Pro - 2022-03-17 at 08 37 27](https://user-images.githubusercontent.com/42762236/158708780-d4a20325-89b6-47b6-a67a-55419d0cf10b.gif)

</br>
</br>
</br>


## 테스트 코드 도전기
- 간단한 ViewModel에 관한 테스트 코드를 작성해보았다.
- 이를 위해 아키텍쳐적으로 의존성을 외부에서 주입하고, 
- 인터페이스 (프로토콜)을 사용한 부분이 테스트 코드에서 매우 편리하게 작용하였다.
- RxTest를 이용한 테스트코드를 작성하였음!
</br>

### SearchViewModel 테스트 코드 작성을 위한 선행 작업 
#### 1. SearchUseCase프로토콜을 만들어 인터페이스로 채택하도록 
```swift

import Foundation
import RxCocoa
import RxSwift

protocol SearchUseCase {

    var successReqeustSearch: PublishRelay<Repos> { get set }
    var failGithubError: PublishRelay<GithubServerError> { get set }

    func requestSearch(searchName: String, page: Int)
}

final class DefaultSearchUseCase: SearchUseCase {

    private let githubRepository: GithubRepositoryType
    private let disposeBag = DisposeBag()

    var successReqeustSearch = PublishRelay<Repos>()
    var failGithubError = PublishRelay<GithubServerError>()

    init(
        githubRepository: GithubRepositoryType
    ){
        self.githubRepository = githubRepository
    }
}

extension DefaultSearchUseCase {

    func requestSearch(searchName: String, page: Int) {
        let query = ReposQuery(searchName: searchName)
        self.githubRepository.requestSearch(query: query, page: page) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let repos):
                self.successReqeustSearch.accept(repos)
            case .failure(let error):
                self.failGithubError.accept(error)
            }
        }
    }
}

```
#### 2.SearchViewModel에선 UseCase를 프로토콜 형식으로 선언.
```swift
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
    ...
}
```
- `SearchUseCase`란 프로토콜 형식으로 유즈케이스가 선언되어있음!
</br>
</br>
</br>

### MockSearchUseCase

```swift
import Foundation

import RxCocoa
import RxSwift
@testable import GithubRepos

final class MockSearchUseCase: SearchUseCase {

    var successReqeustSearch = PublishRelay<Repos>()
    var failGithubError = PublishRelay<GithubServerError>()

    init() { }

    func requestSearch(searchName: String, page: Int) {
        if page < 30 && page > 0 {
            self.successReqeustSearch.accept(
                Repos(
                    items: [
                        RepoItem(id: 1, fullName: "29cmGodRepos/kingkinggod", description: nil, topics: ["29likes", "29king", "29godofkingking"], star: 1000, fork: 2, language: "Swift", updatedAt: Date())
                    ]
                )
            )
        } else {
            self.failGithubError.accept(.unknown)
        }
    }
}
```
```swift
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
```
![image](https://user-images.githubusercontent.com/42762236/158710830-25821188-6869-437b-8251-076d552c5804.png)
- 테스트 코드 성공 모습

</br>
</br>


## 간단한 UITest 코드 작성

- UITest코드는 아주 기초만 써보았슴

### UITest 코드
```swift
import XCTest

class GithubReposUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testSearchRepositoryFlow() throws {
        let app = XCUIApplication()
        app.launch()
        let searchField = app.otherElements["searchBar"]
        searchField.tap()
        searchField.typeText("Youngminah")
        app.buttons["searchButton"].tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
```
![image](https://user-images.githubusercontent.com/42762236/158711748-06344620-7cf6-4c86-990c-174d0f0dd46a.png)
- 테스트 성공!

### UITest 실행 화면
https://user-images.githubusercontent.com/42762236/158711822-56702268-ea28-4a4d-b50a-abe5157c0b31.mp4

</br>
</br>
</br>

## 아쉬운점
### 에러대응과 앱내 화면끼리의 좋아요 동기화
- 기본적인 에러 대응과 화면끼리의 좋아요 동기화는 구성을 해보았는데,
- 생각보다 고려할게 많아서 좀 더 그럴듯하게 구성하지 못했다.
- 탭을 눌렀을때마다 계속 API 호출을 하는것이 과연 옳은 방향일까에 관한 고민으로
- 오래 고민했던것 같다.
- 결국 델리게이트 프로토콜로 탭바와 연결시켜 구현하려 하였는데,
- 탭바는 하나인데 델리게이트로 연결해야하는 화면은 2개이다보니, 연결과정에서 이슈가 있엇다.
</br>
</br>

### 좋아요 API 아키텍처적인 고민 미흡
- 좋아요 API가 이전까지 구성하던 API구성과 다르게 
- 레파지토리 목록을 조회할 때, API 키 값을 주어도 좋아요 여부는 나오지 않음.
- 그래서 각각 셀마다 사용자가 좋아요를 한 셀인지 확인해주도록 구성하였는데,
- 이부분도 고민을 생각보다 오래하다보니 
- 좋아요 API 부분은 클린아키텍처적인 구성이 아쉬웠다.

</br>
</br>
