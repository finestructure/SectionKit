//
//  SingleTypeHorizontalSection.swift
//  Passionate
//
//  Created by linhey on 2022/3/25.
//

import UIKit
import SectionKit

public extension SKCRegistrationSectionProtocol {
    
    func horizontalWrapper(height: CGFloat,
                           insets: UIEdgeInsets = .zero,
                           style: ((SKCollectionView) -> Void)? = nil) -> SKCRegistrationSection {
        SKCRegistrationSection {
            SKCSectionViewCell
                .registration(.init(section: .registration([self]),
                                    height: height,
                                    insets: insets,
                                    scrollDirection: .horizontal,
                                    style: style))
        }
    }
    
}

public extension SKCSectionProtocol {
    
    func horizontalWrapper(height: CGFloat,
                           insets: UIEdgeInsets = .zero,
                           style: ((SKCollectionView) -> Void)? = nil) -> SKCSingleTypeSection<SKCSectionViewCell> {
        SKCSectionViewCell
            .singleTypeWrapper([.init(section: .normal([self]),
                                      height: height,
                                      insets: insets,
                                      scrollDirection: .horizontal,
                                      style: style)])
        
    }
    
}

public final class SKCSectionViewCell: UICollectionViewCell, SKConfigurableView, SKLoadViewProtocol {
    
    public struct Model {
        
        public enum SectionType {
            case registration([any SKCRegistrationSectionProtocol])
            case normal([any SKCSectionProtocol])
        }
        
        public let section: SectionType
        public let height: CGFloat
        public let insets: UIEdgeInsets
        public let style: ((SKCollectionView) -> Void)?
        public let scrollDirection: UICollectionView.ScrollDirection
        
        public init(section: SectionType,
                    height: CGFloat,
                    insets: UIEdgeInsets = .zero,
                    scrollDirection: UICollectionView.ScrollDirection,
                    style: ((SKCollectionView) -> Void)? = nil) {
            self.section = section
            self.height = height
            self.insets = insets
            self.scrollDirection = scrollDirection
            self.style = style
        }
        
    }
    
    public static func preferredSize(limit size: CGSize, model: Model?) -> CGSize {
        guard let model = model else { return .zero }
        return CGSize(width: size.width, height: model.height + model.insets.top + model.insets.bottom)
    }
    
    public func config(_ model: Model) {
        sectionView.scrollDirection = model.scrollDirection
        model.style?(sectionView)
        edgeConstraint.apply(model.insets)
        switch model.section {
        case .normal(let list):
            sectionView.manager.reload(list)
        case .registration(let list):
            sectionView.registrationManager.reload(list)
        }
    }
    
    private struct EdgeConstraint {
        
        var all: [NSLayoutConstraint] { [top, left, right, bottom] }
        
        let top: NSLayoutConstraint
        let left: NSLayoutConstraint
        let right: NSLayoutConstraint
        let bottom: NSLayoutConstraint
        
        init(_ view: UIView, superView: UIView) {
            top = view.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0)
            left = view.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 0)
            right = view.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: 0)
            bottom = view.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0)
        }
        
        func apply(_ inset: UIEdgeInsets) {
            top.constant = inset.top
            left.constant = inset.left
            right.constant = -inset.right
            bottom.constant = -inset.bottom
        }
        
        func activate() {
            NSLayoutConstraint.activate(all)
        }
        
        func deactivate() {
            NSLayoutConstraint.deactivate(all)
        }
    }
    
    private lazy var sectionView = SKCollectionView()
    private lazy var edgeConstraint = EdgeConstraint(sectionView, superView: contentView)
    
    override init(frame _: CGRect) {
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        sectionView.translatesAutoresizingMaskIntoConstraints = false
        sectionView.backgroundColor = .clear
        contentView.addSubview(sectionView)
        sectionView.scrollDirection = .horizontal
        edgeConstraint.activate()
    }
}
