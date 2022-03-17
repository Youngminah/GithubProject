//
//  ProfileViewController.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class ProfileViewController: UIViewController {

    private let refreshControl = UIRefreshControl()
    private let headerView = ProfileHeaderView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let loginDescriptionView = EmptyBackgroundView(title: "로그인이\n필요합니다.", imageName: "eye.slash")

    private lazy var input = ProfileViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asSignal(),
        pullRefresh: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
        didScrollToBottom: tableView.rx.didScrollToBottom.asSignal(onErrorJustReturn: ())
    )
    private lazy var output = viewModel.transform(input: input)
    private var viewModel: ProfileViewModel
    private let disposeBag = DisposeBag()

    private let viewDidLoadEvent = PublishRelay<Void>()

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<RepoSection.RepoSectionModel>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            switch item {
            case .firstItem(let item):
                let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier) as! RepositoryCell

                cell.repositoryCase = .starred
                cell.configure(item: item)

                return cell
            }
        })

    private var isFirstLoad = true

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("ProfileViewController fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        bind()
    }

    private func bind() {
        output.userInfo
            .emit(onNext: { [weak self] user in
                self?.headerView.configure(user: user)
            })
            .disposed(by: disposeBag)

        output.repoList
            .map { return $0.count <= 0 }
            .drive(tableView.rx.isEmpty(
                title: "좋아요한\n레파지토리가 없어요.",
                imageName: "star.fill")
            )
            .disposed(by: disposeBag)

        output.repoList
            .map { value in
                return [RepoSection.RepoSectionModel(model: 0, items: value.map { RepoSection.RepoItems.firstItem($0) })]
            }
            .drive(tableView.rx.items(dataSource: dataSource))
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

        output.failRequestAction
            .do { [weak self] _ in
                guard let self = self else { return }
                self.isFirstLoad = true
                self.tableView.tableHeaderView = nil
            }
            .map { return true }
            .emit(to: tableView.rx.isEmpty(
                title: "네트워크 오류",
                imageName: "arrow.counterclockwise")
            ).disposed(by: disposeBag)

        viewDidLoadEvent.accept(())
    }

    private func setViews() {
        if UserDefaults.standard.string(forKey: "accessToken") != nil {
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
        } else {
            view.addSubview(loginDescriptionView)
            loginDescriptionView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
    
    private func setConfigurations() {
        tableView.register(RepositoryCell.self,
                           forCellReuseIdentifier: RepositoryCell.identifier)
        tableView.register(ProfileHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: ProfileHeaderView.identifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 80
    }
}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
}

extension ProfileViewController: AuthDelegate {

    func login() {
        print("ProfileViewController login")
        if UserDefaults.standard.string(forKey: "accessToken") != nil {
            loginDescriptionView.removeFromSuperview()
            view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            if isFirstLoad {
                viewDidLoadEvent.accept(())
            }
            isFirstLoad = false
        }
    }

    func logout() {
        print("ProfileViewController logout")
        tableView.removeFromSuperview()
        view.addSubview(loginDescriptionView)
        loginDescriptionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
