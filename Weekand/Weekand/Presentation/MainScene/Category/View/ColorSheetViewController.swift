//
//  ColorSheetViewController.swift
//  Weekand
//
//  Created by 이호영 on 2022/06/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxDataSources

class ColorSheetViewController: BottomSheetViewController {
    
    var viewModel: ColorSheetViewModel?
    
    override var bottomSheetHeight: CGFloat {
        get {
            return 330
        }
    }
    
    lazy var sheetTitle = WTextLabel().then {
        $0.font = WFont.body1()
        $0.textColor = .gray900
        $0.text = "색상"
    }
    
    lazy var confirmButton = WDefaultButton(title: "확인", style: .filled, font: WFont.subHead1())
    
    let colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configureUI()
        bindViewModel()
    }
    
    private func setupView() {
        self.colorsCollectionView.dataSource = self
        self.colorsCollectionView.delegate = self
        self.colorsCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: ColorsCollectionViewCell.cellIdentifier)
    }
    
    private func configureUI() {
        bottomSheetView.addSubview(sheetTitle)
        sheetTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(24)
        }
        
        bottomSheetView.addSubview(colorsCollectionView)
        colorsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sheetTitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(200)
        }
        
        bottomSheetView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func bindViewModel() {
        
    }

}

extension ColorSheetViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return UIColor.categoryColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIColor.categoryColors[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorsCollectionViewCell.cellIdentifier, for: indexPath) as? ColorsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(color: UIColor.categoryColors[indexPath.section][indexPath.item]!)
        
        return cell
    }
}

extension ColorSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 36, height: 36)
    }
}

import SwiftUI
#if canImport(SwiftUI) && DEBUG

struct ColorSheetViewControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ColorSheetViewController().showPreview(.iPhone11Pro)
        }
    }
}
#endif
