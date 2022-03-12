//
//  ProfileViewController.swift
//  GithubRepos
//
//  Created by meng on 2022/03/12.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class ProfileViewController: BaseViewController {

    private lazy var input = ProfileViewModel.Input(
    )
    private lazy var output = viewModel.transform(input: input)
    private var viewModel: ProfileViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("InvestViewController fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {

    }

    override func setViews() {
        super.setViews()
    }

    override func setConstraints() {
        super.setConstraints()
    }

    override func setConfigurations() {
        super.setConfigurations()
    }
}
