//
//  HomeIndexCell.swift
//  Example
//
//  Created by linhey on 2022/3/12.
//

import UIKit
import SectionKit
import SnapKit

final class HomeIndexCell<Model: RawRepresentable>: UICollectionViewCell, LoadViewProtocol where Model.RawValue == String {
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont.preferredFont(forTextStyle: .body, compatibleWith: nil)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}

// MARK: - Actions
extension HomeIndexCell {
    
}

// MARK: - ConfigurableView
extension HomeIndexCell: ConfigurableView {
    
    static func preferredSize(limit size: CGSize, model: Model?) -> CGSize {
        return .init(width: size.width, height: 50)
    }
    
    func config(_ model: Model) {
        titleLabel.text = model.rawValue
    }
    
}

// MARK: - UI
extension HomeIndexCell {
    
    private func setupView() {
        
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 16
        contentView.layer.cornerCurve = .continuous
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
