//
//  RepeatTabViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/19.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

class RepeatTabViewController: TabmanViewController {
    
    enum RepeatType: CaseIterable {
        case day
        case week
        case month
        case year
        
        var description: String {
            switch self {
            case .day:
                return "매일"
            case .week:
                return "매주"
            case .month:
                return "매월"
            case .year:
                return "매년"
            }
        }
    }
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureUI()
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
        
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = .mainColor
        bar.layout.transitionStyle = .snap 
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func configureUI() { }
}

extension RepeatTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
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
        return TMBarItem(title: RepeatType.allCases[index].description)
    }
    
}
