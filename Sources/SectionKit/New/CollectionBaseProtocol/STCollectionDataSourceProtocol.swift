//
//  File.swift
//  
//
//  Created by linhey on 2022/8/11.
//

import UIKit

public protocol STCollectionDataSourceProtocol {
    var sectionIndex: Int? { get }
    
    @available(iOS 14.0, *)
    var indexTitle: String? { get }
    @available(iOS 14.0, *)
    var indexTitleRow: Int { get }
    
    var itemCount: Int { get }
    func item(at row: Int) -> UICollectionViewCell
    func supplementary(kind: SKSupplementaryKind, at row: Int) -> UICollectionReusableView?
    
    func item(canMove row: Int) -> Bool
    func move(from source: IndexPath, to destination: IndexPath)
}

public extension STCollectionDataSourceProtocol {
    
    var sectionIndex: Int? { nil }
    
    @available(iOS 14.0, *)
    var indexTitle: String? { nil }
    @available(iOS 14.0, *)
    var indexTitleRow: Int { 0 }
    
    func supplementary(kind: SKSupplementaryKind, at row: Int) -> UICollectionReusableView? { nil }
    
    func item(canMove row: Int) -> Bool { true }
    func move(from source: IndexPath, to destination: IndexPath) {}
    
}
