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
    
    var selectedCategory: Category? {
        didSet {
            self.categoryTextFieldStackView.textField.text = selectedCategory?.name
            self.selectedOpenType = selectedCategory?.openType ?? .closed
            let color = Constants.colors.flatMap { $0 }.filter { $0.hexCode == selectedCategory?.color }
            self.selectedColor = color.first ?? Constants.colors[0][0]
        }
    }
    var selectedOpenType: CategoryOpenType = .allOpen
    var selectedColor: Color = Constants.colors[0][0] {
        didSet {
            self.colorStackView.colorView.backgroundColor = UIColor(hex: selectedColor.hexCode)
            self.colorObservable.accept(selectedColor)
        }
    }
    lazy var openTypeObservable = BehaviorRelay<CategoryOpenType>(value: selectedOpenType)
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
            selectedColor: colorObservable,
            selectedCategory: selectedCategory 
        )
        
        if ((viewModel as? CategoryAddViewModel) != nil) {
            let output = viewModel?.transform(input: addInput as! T.Input)
        } else {
            let output = viewModel?.transform(input: modifyInput as! T.Input)
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
