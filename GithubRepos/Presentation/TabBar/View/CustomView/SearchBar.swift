//
//  SearchBar.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//


import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class SearchBar: UISearchBar {

    private let disposeBag = DisposeBag()
    private let searchButton = UIButton()

    var shouldLoadResult = Observable<String>.of("")
    let searchButtonTapped = PublishRelay<Void>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigurations()
        setConstraints()
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        Observable
            .merge (
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: searchButtonTapped)
            .disposed(by: disposeBag)

        searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)

        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(self.rx.text) {
                $1 ?? ""
            }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
    }

    private func setConfigurations() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.label, for: .normal)
    }

    private func setConstraints() {
        addSubview(searchButton)

        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }

        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}
