//
//  RepositoryCell.swift
//  GithubRepos
//
//  Created by meng on 2022/03/13.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class RepositoryCell: BaseTableViewCell {

    static let identifier = "RepositoryCell"

    private lazy var collectionView: DynamicCollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout()
        let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let starButton = UIButton()
    private let repoImageView = UIImageView(image: UIImage(systemName: "text.book.closed"))
    private let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    private let languageColorView = CircleView()
    private let nameLabel = DefaultLabel(font: .subHeaderDefaultBold, textColor: .blue400)
    private let descriptionLabel = DefaultLabel(font: .bodyDefaultMedium)
    private let starCountLabel = DefaultLabel(font: .bodySmallMedium, textColor: .gray500)
    private let languageLabel = DefaultLabel(font: .bodySmallMedium, textColor: .gray500)
    private let updateDateLabel = DefaultLabel(font: .bodyTinyRegular, textColor: .gray500)

    private let topicList = PublishRelay<[String]>()
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //disposeBag = DisposeBag()
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
    }

    override func setView() {
        super.setView()
        contentView.addSubview(starButton)
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
        starButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }
        repoImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.width.height.equalTo(25)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(repoImageView.snp.right).offset(10)
            make.right.equalTo(starButton.snp.left).offset(-16)
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
            make.bottom.equalTo(starCountLabel.snp.top).offset(-10).priority(.low)
        }
    }

    override func setConfiguration() {
        super.setConfiguration()
        nameLabel.textAlignment = .natural
        descriptionLabel.textAlignment = .natural
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        starButton.imageView?.tintColor = .systemYellow
        repoImageView.tintColor = .orange
        starImageView.tintColor = .gray500
        languageLabel.lineBreakMode = .byCharWrapping
        collectionView.register(TopicCell.self, forCellWithReuseIdentifier: TopicCell.identifier)
        collectionView.isScrollEnabled = false
    }

    func configure(item: RepoItem) {
        nameLabel.text = item.fullName
        descriptionLabel.text = item.description
        starCountLabel.text = item.star.toCommaString
        languageLabel.text = item.language
        updateDateLabel.text = item.updatedAt.getElapsedInterval()
        updateDateLabel.textAlignment = .right
        languageColorView.setColor(language: LanguageCase(rawValue: item.language ?? "nothing") ?? .unknown)
        if item.topics == [] {
            topicList.accept(["Nothing"])
        } else {
            topicList.accept(item.topics)
        }
        layoutIfNeeded()
    }
}

