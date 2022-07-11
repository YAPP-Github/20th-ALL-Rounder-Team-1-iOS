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

class EmojiTabViewController: TabmanViewController {
    
    let emojis: [Emoji?] = [nil, .good, .awesome, .cool, .support]
    private var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
    }
    
    private func setUpView() {
        
        emojis.forEach { value in
            viewControllers.append(EmojiTableViewController(emoji: value))
        }
        
        self.dataSource = self

        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .clear
        bar.buttons.customize { (button) in
            button.tintColor = .gray500
            button.selectedTintColor = .gray700
            button.font = WFont.body2()
            button.selectedFont = WFont.body2()
        }
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .mainColor
        bar.layout.transitionStyle = .snap // Customize
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func configureUI() {
        
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
        
        var title = (index == 0) ? "전체" : String(describing: emojis[index]!.emojiName)
        var barItem = TMBarItem(title: title)
        
        return barItem
    }
    
    
}
