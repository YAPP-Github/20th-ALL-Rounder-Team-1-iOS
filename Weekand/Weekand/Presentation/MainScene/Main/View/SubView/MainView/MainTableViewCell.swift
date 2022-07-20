//
//  MainTableViewCell.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/05/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxGesture

protocol MainTableViewCellDelegate: AnyObject {
    func cellTapped(id: String?)
    func emojiViewTapped(id: String?)
    func stickerButtonTapped(id: String?)
}

/// 메인화면 일정 리스트 TableView에 쓰이는 Cell
class MainTableViewCell: UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    
    var dataId: String?
    let disposeBag = DisposeBag()
    var delegate: MainTableViewCellDelegate?
    
    
    // MARK: 상단 (카테고리 색상 원 + 일정 이름)
    lazy var nameLabel = WCategoryTitleLabel()
    
    // MARK: 하단 (아이콘 & 시작~종료 시간 + 이모지)
    lazy var timeLineLabel = WStatusTimeLabel()
    lazy var emojiView = WEmojiView()
    lazy var stickerButton = UIButton().then {
        let image = UIImage(named: "sticker.button") ?? UIImage(systemName: "hand.thumbsup.circle")?.withTintColor(.mainColor)
        $0.setImage(image, for: .normal)
        $0.isHidden = true
        
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    lazy var bottomStack = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
    }
    
    lazy var cellStack = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 9
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        configureUI()
        bindGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        self.selectionStyle = .none
    }
    
    private func configureUI() {
        
        [timeLineLabel, emojiView, stickerButton].forEach { bottomStack.addArrangedSubview($0) }
        stickerButton.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(28)
            make.width.equalTo(stickerButton.snp.height)
        }
        
        [nameLabel, bottomStack].forEach { cellStack.addArrangedSubview($0) }

        self.contentView.addSubview(cellStack)
        cellStack.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 12, left: 31, bottom: 15, right: 24))
        }
        
    }
    
    // MARK: Gesture Binding
    private func bindGesture() {
        
        cellStack.rx.tapGesture(configuration: { recognizer, _ in
            recognizer.delegate = self
        })
        .when(.recognized)
        .subscribe(onNext: { _ in
            self.delegate?.cellTapped(id: self.dataId)
        }).disposed(by: disposeBag)
        
        emojiView.rx.tapGesture(configuration: { recognizer, _ in
            recognizer.delegate = self
        })
        .when(.recognized)
        .subscribe(onNext: { _ in
            self.delegate?.emojiViewTapped(id: self.dataId)
        })
        .disposed(by: disposeBag)
        
        stickerButton.rx.tap.subscribe(onNext: { _ in
            self.delegate?.stickerButtonTapped(id: self.dataId)
        })
        .disposed(by: disposeBag)
    }

}

// MARK: Data Injection
extension MainTableViewCell {
    
    public func setUpCell(id: String, color: UIColor, title: String, status: StatusIcon, time: String, emojiNumber: Int, emojiOrder: [Emoji]) {
        
        self.dataId = id
        
        self.nameLabel.editValue(color: color, title: title)
        self.timeLineLabel.configureValue(status: status, title: time)
        self.emojiView.numberLabel.text = String(emojiNumber)
        self.emojiView.setEmoji(emojiOrder: emojiOrder)
    }
    
    /// 일정 주인의 userID를 받아 로그인한 유저 본인이 아니라면 스티커 추가 버튼을 보여준다
    public func switchStickerButtonAppearance(isMine: Bool?) {
        
        guard let isMine = isMine else {
            return
        }

        stickerButton.isHidden = isMine ? true : false
    }
    
    public func setUpCell(_ model: ScheduleMain) {
        self.dataId = model.scheduleId
        
        self.nameLabel.editValue(color: UIColor(hex: model.color) ?? .gray100, title: model.name)
        
        let icon = getStatusIcon(status: model.status, dateStart: model.dateStart, dateEnd: model.dateEnd)
        self.timeLineLabel.configureValue(status: icon, title: Date.getTimelineString(model.dateStart, model.dateEnd))
        self.emojiView.numberLabel.text = String(model.stickerCount)
        self.emojiView.setEmoji(emojiOrder: model.stickerNameList)
    }
    
    /// 현재 진행중인 일정이면 "진행중" 아이콘 리턴
    private func getStatusIcon(status: Status, dateStart: Date, dateEnd: Date) -> StatusIcon {
        
        if status == .upcoming {
            if Date().compare(dateStart) == .orderedDescending && Date().compare(dateEnd) == .orderedAscending {
                return .proceeding
            }
        }
        
        return status.icon
    }
    
}
