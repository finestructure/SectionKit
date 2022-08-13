//
//  CompositionalViewController.swift
//  Example
//
//  Created by linhey on 2022/3/15.
//

import SectionKit
import Stem
import UIKit

class CompositionalViewController: SKCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let horizontalSection = SingleTypeCompositionalSection<ColorBlockCell>((0 ... 9).map { index in
            .init(color: StemColor.random.convert(), text: "\(index)", size: .zero)
        })
        horizontalSection.layoutProvider.delegate(on: self) { _, _ in
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }

        manager.set(layout: .compositional())
        manager.update(horizontalSection)
    }
}
