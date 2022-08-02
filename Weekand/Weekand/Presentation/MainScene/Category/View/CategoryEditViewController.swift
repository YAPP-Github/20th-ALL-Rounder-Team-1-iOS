//
//  CategoryEditViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/11.
//

import UIKit
import Then
import RxSwift
import RxRelay

class CategoryEditViewController<T: CategoryEditViewModelType>: BaseViewController, UICollectionViewDelegate {
    
    private let disposeBag = DisposeBag()
    var viewModel: T?

    let categoryTextFieldStackView = WTextFieldStackView(fieldPlaceholder: "카테고리명", nameText: "카테고리")
    let openTypeStackView = OpenTypeStackView()
    
    lazy var colorStackView = ColorStackView(nameText: "색상").then {
        $0.setColor(UIColor(hex: selectedColor.hexCode) ?? .red)
    }
    
    lazy var confirmButton = WBottmButton().then {
        $0.setTitle("완료", for: .normal)
        $0.disable(string: "완료")
    }
    
    lazy var closeButton = UIBarButtonItem().then {
        $0.image = UIImage(named: "close")
        $0.tintColor = .gray400
    }
    
    var defaultOpenType: CategoryOpenType = .allOpen
    var selectedColor: Color = Constants.colors[0][0] {
        didSet {
            self.colorObservable.accept(self.selectedColor)
        }
    }
    
    lazy var openTypeObservable = BehaviorRelay<CategoryOpenType>(value: defaultOpenType)
    lazy var colorObservable = BehaviorRelay<Color>(value: selectedColor)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = closeButton
        stackView.spacing = 25
        openTypeStackView.openTypeCollecitonView.delegate = self
    }

    private func configureUI() {
        [categoryTextFieldStackView, openTypeStackView, colorStackView].forEach { stackView.addArrangedSubview($0) }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-WBottmButton.buttonOffset - 64)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-WBottmButton.buttonOffset)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view)
        }
    }
    
    private func bindViewModel() {
        
        self.openTypeObservable.bind { openType in
            self.openTypeStackView.openTypeCollecitonView.selectItem(at: IndexPath(item: openType.listIndex, section: 0),
                                                                animated: false,
                                                                scrollPosition: .centeredVertically)
        }
        .disposed(by: disposeBag)
        
        self.colorObservable.bind { color in
            self.colorStackView.colorView.backgroundColor = UIColor(hex: color.hexCode)
        }
        .disposed(by: disposeBag)
        
        let addInput = CategoryAddViewModel.Input(
            closeButtonDidTapEvent: closeButton.rx.tap.asObservable(),
            colorButtonDidTapEvent: colorStackView.colorView.rx.tap.asObservable(),
            categoryNameTextFieldDidEditEvent: categoryTextFieldStackView.textField.rx.text.orEmpty.asObservable(),
            confirmButtonDidTapEvent: confirmButton.rx.tap.asObservable(),
            selectedOpenType: openTypeObservable,
            selectedColor: colorObservable
        )
        
        let modifyInput = CategoryModifyViewModel.Input(
            closeButtonDidTapEvent: closeButton.rx.tap.asObservable(),
            colorButtonDidTapEvent: colorStackView.colorView.rx.tap.asObservable(),
            categoryNameTextFieldDidEditEvent: categoryTextFieldStackView.textField.rx.text.orEmpty.asObservable(),
            confirmButtonDidTapEvent: confirmButton.rx.tap.asObservable(),
            selectedOpenType: openTypeObservable,
            selectedColor: colorObservable
        )
        
        if let viewModel = viewModel as? CategoryAddViewModel {
            let _ = viewModel.transform(input: addInput)
            
        } else if let viewModel = viewModel as? CategoryModifyViewModel {
            
            viewModel.selectedCategory.bind { category in
                self.categoryTextFieldStackView.textField.text = category.name
                let color = Constants.colors.flatMap { $0 }.filter { $0.hexCode == category.color }
                self.openTypeObservable.accept(category.openType)
                self.selectedColor = color.first ?? Constants.colors[0][0]
            }
            .disposed(by: disposeBag)
            
            let _ = viewModel.transform(input: modifyInput)
        }
        
        categoryTextFieldStackView.textField.rx.text.orEmpty
            .map(checkEmptyValue)
            .subscribe(onNext: { [weak self] isVaild in
                if isVaild {
                    self?.confirmButton.enable(string: "완료")
                } else {
                    self?.confirmButton.disable(string: "완료")
                }
            }).disposed(by: disposeBag)
    }
    
    private func checkEmptyValue(text: String) -> Bool {
        return text.trimmingCharacters(in: [" "]) != ""
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == CategoryOpenType.allOpen.listIndex {
            self.openTypeObservable.accept(.allOpen)
        } else if indexPath.item == CategoryOpenType.followerOpen.listIndex {
            self.openTypeObservable.accept(.followerOpen)
        } else if indexPath.item == CategoryOpenType.closed.listIndex {
            self.openTypeObservable.accept(.closed)
        }
    }

}
