//
//  SearchViewController.swift
//  GithubRepos
//
//  Created by meng on 2022/03/11.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class SearchViewController: BaseViewController {

    private let searchBar = SearchBar()
    private let refreshControl = UIRefreshControl()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private lazy var input = SearchViewModel.Input(
        pullRefresh: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
        didScrollToBottom: tableView.rx.didScrollToBottom.asSignal(onErrorJustReturn: ()),
        searchBarText: searchBar.shouldLoadResult.asSignal(onErrorJustReturn: "")
    )
    private lazy var output = viewModel.transform(input: input)
    private var viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    private let viewDidLoadEvent = PublishRelay<Void>()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("InvestViewController fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        bind()
    }

    private func bind() {
        output.repoList
            .map { return $0.count <= 0 }
            .drive(tableView.rx.isEmpty(
                title: "검색 결과가 없어요.")
            )
            .disposed(by: disposeBag)

        output.repoList
            .drive(tableView.rx.items) { tv, index, element in
                let cell = tv.dequeueReusableCell(withIdentifier: RepositoryCell.identifier) as! RepositoryCell
                cell.configure(item: element)
                return cell
            }
            .disposed(by: disposeBag)

        output.refreshAction
            .emit(to: tableView.rx.isRefresh())
            .disposed(by: disposeBag)

        output.bottomSpinnerAction
            .emit(to: tableView.rx.isAnimatingBottomSpinner())
            .disposed(by: disposeBag)

        output.refreshAction
            .emit(onNext: { [weak self] isRefresh in
                if !isRefresh {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }

    override func setViews() {
        super.setViews()
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }

    override func setConstraints() {
        super.setConstraints()
        searchBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "검색할 레파지토리를 입력해주세요."
        tableView.register(RepositoryCell.self,
                           forCellReuseIdentifier: RepositoryCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 80
    }
}

// MARK: - 키보드 관련
extension SearchViewController {

    private func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
