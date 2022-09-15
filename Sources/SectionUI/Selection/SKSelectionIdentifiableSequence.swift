//
//  File.swift
//  
//
//  Created by linhey on 2022/9/9.
//

import Foundation

public class SKSelectionIdentifiableSequence<Element: SKSelectionProtocol, ID: Hashable> {
    
    /// 是否需要支持反选操作 | default: false
    public var needInvert: Bool
    /// 是否保证选中在当前序列中是否唯一 | default: true
    public var isUnique: Bool
    
    private var store: [ID: Element]
    
    public init(store: [ID: Element] = [:],
                isUnique: Bool = true,
                needInvert: Bool = false) {
        self.store = store
        self.isUnique = isUnique
        self.needInvert = needInvert
    }
    
}

public extension SKSelectionIdentifiableSequence {
    
    func update(_ element: Element, by id: ID) {
        store[id] = element
    }
    
    func remove(id: ID) {
        store[id] = nil
    }
    
    func contains(id: ID) -> Bool {
        return store[id] != nil
    }
    
    func select(id: ID) {
        
        if isUnique {
            store.map(\.value).forEach { element in
                element.isSelected = false
            }
        }
        
        if needInvert {
            store[id]?.isSelected.toggle()
        } else {
            store[id]?.isSelected = true
        }
    }
    
}