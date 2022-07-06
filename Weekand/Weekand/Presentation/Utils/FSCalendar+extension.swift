//
//  FSCalendar+extension.swift
//  Weekand
//
//  Created by 이호영 on 2022/07/07.
//

import UIKit
import RxSwift
import FSCalendar
import RxCocoa

extension Reactive where Base: FSCalendar {
    var delegate: DelegateProxy<FSCalendar, FSCalendarDelegate> {
        return RxFSCalendarDelegateProxy.proxy(for: self.base)
    }
    
    var didSelect: Observable<Date> {
        return delegate.methodInvoked(#selector(FSCalendarDelegate.calendar(_:didSelect:at:)))
            .map { parameter in
                return parameter[1] as? Date ?? Date()
            }
    }
}

class RxFSCalendarDelegateProxy: DelegateProxy<FSCalendar, FSCalendarDelegate>, DelegateProxyType, FSCalendarDelegate {
    static func registerKnownImplementations() {
        self.register { (calendar) -> RxFSCalendarDelegateProxy in
            RxFSCalendarDelegateProxy(parentObject: calendar, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: FSCalendar) -> FSCalendarDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: FSCalendarDelegate?, to object: FSCalendar) {
        object.delegate = delegate
    }
}

