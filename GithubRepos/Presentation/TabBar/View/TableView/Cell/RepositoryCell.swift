//
//  RepositoryCell.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit
import ProgressHUD
import RxCocoa
import RxSwift
import SnapKit

final class RepositoryCell: BaseTableViewCell {

    enum RepositoryCase {
        case all
        case starred
    }

    static let identifier = "RepositoryCell"

    private let githubRepository: GithubRepositoryType

    private lazy var collectionView: DynamicCollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout()
        let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    let starButton = StarButton()
    var repositoryCase: RepositoryCase = .all

    private let repoImageView = UIImageView(image: UIImage(systemName: "text.book.closed"))
    private let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    private let languageColorView = CircleView()
    private let nameLabel = DefaultLabel(font: .subHeaderDefaultBold, textColor: .blue400)
    private let descriptionLabel = DefaultLabel(font: .bodyDefaultMedium)
    private let starCountLabel = DefaultLabel(font: .bodySmallMedium, textColor: .gray500)
    private let languageLabel = DefaultLabel(font: .bodySmallMedium, textColor: .gray500)
    private let updateDateLabel = DefaultLabel(font: .bodyTinyRegular, textColor: .gray500)

    private let topicList = PublishRelay<[String]>()
    private let isStarred = PublishRelay<Bool>()
    private let successReqeustStar = PublishRelay<Void>()
    private let successReqeustUnstar = PublishRelay<Void>()
    private let failStarError = PublishRelay<GithubServerError>()

    var disposeBag = DisposeBag()

    private var repoName = ""
    private var starCount = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.githubRepository = GithubRepository()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bind()
    }

    private func bind() {
        self.topicList
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(
                cellIdentifier: TopicCell.identifier,
                cellType: TopicCell.self)
            ) { index, topic, cell in
                cell.configure(topic: topic)
            }
            .disposed(by: disposeBag)

        self.starButton.rx.tap.asSignal()
            .throttle(.seconds(1))
            .map { [weak self] _ -> Bool in
                guard let self = self else { return false }
                return self.starButton.isSelected
            }
            .distinctUntilChanged()
            .emit(onNext: { [weak self] isSelected in
                guard let self = self else { return }
                if isSelected {
                    self.requestUnstar(repos: self.repoName)
                } else {
                    self.requestStar(repos: self.repoName)
                }
            })
            .disposed(by: disposeBag)

        self.successReqeustStar
            .asSignal()
            .do (onNext: { [weak self] _ in
                guard let self = self else { return }
                ProgressHUD.show("좋아요 성공", icon: .heart, interaction: false)
                self.starCount += 1
                self.starCountLabel.text = self.starCount.toCommaString
            })
            .map { true }
            .emit(to: self.starButton.rx.isSelected)
            .disposed(by: disposeBag)

        self.successReqeustUnstar
            .asSignal()
            .do (onNext: { [weak self] _ in
                guard let self = self else { return }
                ProgressHUD.show("좋아요 취소", icon: .succeed, interaction: false)
                self.starCount -= 1
                self.starCountLabel.text = self.starCount.toCommaString
            })
            .map { false }
            .emit(to: self.starButton.rx.isSelected)
            .disposed(by: disposeBag)

        self.failStarError
            .asSignal()
            .emit(onNext: { _ in
                ProgressHUD.show("좋아요 실패", icon: .failed, interaction: false)
            })
            .disposed(by: disposeBag)

        self.isStarred
            .asSignal()
            .emit(to: self.starButton.rx.isSelected)
            .disposed(by: disposeBag)
    }

    override func setView() {
        super.setView()
        contentView.addSubview(starImageView)
        contentView.addSubview(repoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(starCountLabel)
        contentView.addSubview(languageColorView)
        contentView.addSubview(languageLabel)
        contentView.addSubview(updateDateLabel)
        contentView.addSubview(collectionView)
    }

    override func setConstraints() {
        super.setConstraints()
        repoImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.width.height.equalTo(25)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(repoImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-56)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
        }
        starImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(12)
            make.bottom.equalToSuperview().offset(-16)
        }
        starCountLabel.snp.makeConstraints { make in
            make.left.equalTo(starImageView.snp.right).offset(3)
            make.centerY.equalTo(starImageView)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        languageColorView.snp.makeConstraints { make in
            make.left.equalTo(starCountLabel.snp.right).offset(10)
            make.centerY.equalTo(starImageView)
            make.width.height.equalTo(12)
        }
        updateDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView)
            make.right.equalToSuperview().offset(-16)
        }
        languageLabel.snp.makeConstraints { make in
            make.left.equalTo(languageColorView.snp.right).offset(3)
            make.centerY.equalTo(starImageView)
            make.right.equalTo(updateDateLabel.snp.left).offset(-16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(starCountLabel.snp.top).offset(-10).priority(.low) // 셀프사이징
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        contentView.isUserInteractionEnabled = true
        nameLabel.textAlignment = .natural
        descriptionLabel.textAlignment = .natural
        repoImageView.tintColor = .orange
        starImageView.tintColor = .gray500
        languageLabel.lineBreakMode = .byCharWrapping
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .secondarySystemGroupedBackground
    }

    func configure(item: RepoItem) {
        repoName = item.fullName
        starCount = item.star
        nameLabel.text = item.fullName
        descriptionLabel.text = item.description
        starCountLabel.text = item.star.toCommaString
        languageLabel.text = item.language
        updateDateLabel.text = item.updatedAt.getElapsedInterval()
        updateDateLabel.textAlignment = .right
        languageColorView.setColor(language: LanguageCase(rawValue: item.language ?? "Empty") ?? .unknown)
        if item.topics == [] {
            topicList.accept(["Nothing"])
        } else {
            topicList.accept(item.topics)
        }
        layoutIfNeeded()
        if UserDefaults.standard.string(forKey: "accessToken") != nil {
            contentView.addSubview(starButton)
            starButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.width.height.equalTo(40)
            }
            switch repositoryCase {
            case .all:
                requestIsStar(repo: item.fullName)
            case .starred:
                starButton.isSelected = true
            }
        } else {
            starButton.removeFromSuperview()
        }
    }
}

//MARK: - 좋아요 로직
extension RepositoryCell {

    private func requestIsStar(repo: String) {
        self.githubRepository.requestIsStar(repos: repo)  { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.isStarred.accept(true)
            case .failure(let error):
                switch error {
                case .notFoundError:
                    self.isStarred.accept(false)
                default:
                    self.failStarError.accept(error)
                }
            }
        }
    }

    private func requestStar(repos: String) {
        self.githubRepository.requestStar(repos: repos) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.successReqeustStar.accept(())
            case .failure(let error):
                self.failStarError.accept(error)
            }
        }
    }

    private func requestUnstar(repos: String) {
        self.githubRepository.requestUnstar(repos: repos) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(_):
                self.successReqeustUnstar.accept(())
            case .failure(let error):
                self.failStarError.accept(error)
            }
        }
    }
}

