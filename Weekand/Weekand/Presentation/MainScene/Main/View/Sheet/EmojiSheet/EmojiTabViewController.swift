//
//  EmojiTabViewController.swift
//  Weekand
//
//  Created by Daegeon Choi on 2022/07/11.
//

import UIKit
import SnapKit
import Tabman
import Pageboy
import RxSwift

class EmojiTabViewController: TabmanViewController {
    
    let emojis: [Emoji?] = [nil, .good, .awesome, .cool, .support]
    private var viewControllers = [
        EmojiTableViewController(emoji: nil),
        EmojiTableViewController(emoji: .good),
        EmojiTableViewController(emoji: .awesome),
        EmojiTableViewController(emoji: .cool),
        EmojiTableViewController(emoji: .support)
    ]
    
    private let mainUseCase = MainUseCase()
    private let disposeBag = DisposeBag()
    
    var totalCount = 0
    var emojiCount: [Emoji: Int] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
        
    init(id: String, date: Date) {
        super.init(nibName: nil, bundle: nil)
        getStickerSummary(id: id, date: date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpView() {
        
        self.dataSource = self

        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.buttons.customize { (button) in
            button.tintColor = .gray500
            button.selectedTintColor = .gray700
            button.font = WFont.body2()
            button.selectedFont = WFont.body2()
        }
        
        bar.indicator.weight = .custom(value: 4)
        bar.indicator.tintColor = .mainColor
        bar.layout.transitionStyle = .snap // Customize
        addBar(bar, dataSource: self, at: .top)
        
        let divider = UIView().then { $0.backgroundColor = .gray200 }
        bar.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
        
}

extension EmojiTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        var title = ""
        
        if index == 0 {
            title = "총\(totalCount)개"
        } else {
            let emojiCount = emojiCount[emojis[index]!] ?? 0
            title = "\(emojis[index]!.emojiName) \(emojiCount)"
        }
        
        let barItem = TMBarItem(title: title)
        
        return barItem
    }
    
}

extension EmojiTabViewController {
    
    func getStickerSummary(id: String, date: Date) {
        self.mainUseCase.stickerSummary(id: id, date: date).subscribe(onSuccess: { stickerData in
            
            let list = stickerData.scheduleStickerUser
            
            self.emojis.enumerated().forEach { idx, value in
                self.viewControllers[idx].viewModel = EmojiTableViewModel(emoji: value, list: list)
            }
            
            self.totalCount = stickerData.totalCount
            self.emojiCount = stickerData.scheduleStickers

            self.bars.forEach({ $0.reloadData(at: 0...4, context: .full) })
            
            
            
        }, onFailure: { error in
            print("\(#function) Error: \(error)")
        }, onDisposed: nil)
        .disposed(by: disposeBag)

    }
}
