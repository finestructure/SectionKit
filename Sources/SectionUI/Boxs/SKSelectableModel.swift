// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Combine

public class SKSelectableModel: Equatable {
    
    fileprivate let selectedSubject: CurrentValueSubject<Bool, Never>
    fileprivate let canSelectSubject: CurrentValueSubject<Bool, Never>
    fileprivate lazy var changedSubject = PassthroughSubject<SKSelectableModel, Never>()

    public static func == (lhs: SKSelectableModel, rhs: SKSelectableModel) -> Bool {
        return lhs.isSelected == rhs.isSelected && lhs.canSelect == rhs.canSelect
    }
    
    public var isSelected: Bool {
        set { selectedSubject.send(newValue) }
        get { selectedSubject.value }
    }
    
    public var canSelect: Bool {
        set { canSelectSubject.send(newValue) }
        get { canSelectSubject.value }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(isSelected: Bool = false, canSelect: Bool = true) {
        selectedSubject = CurrentValueSubject<Bool, Never>(isSelected)
        canSelectSubject = CurrentValueSubject<Bool, Never>(canSelect)
        
        selectedSubject.sink { [weak self] value in
            guard let self = self else { return }
            self.changedSubject.send(self)
        }.store(in: &cancellables)
        
        canSelectSubject.sink { [weak self] value in
            guard let self = self else { return }
            self.changedSubject.send(self)
        }.store(in: &cancellables)
    }
}

public protocol SelectableProtocol {
    var selectableModel: SKSelectableModel { get }
}

public extension SelectableProtocol {
    var isSelected: Bool {
        get { selectableModel.isSelected }
        nonmutating set { selectableModel.isSelected = newValue }
    }
    var canSelect: Bool {
        get { selectableModel.canSelect }
        nonmutating set { selectableModel.canSelect = newValue }
    }
    
    var selectedPublisher: AnyPublisher<Bool, Never> { selectableModel.selectedSubject.eraseToAnyPublisher() }
    var canSelectPublisher: AnyPublisher<Bool, Never> { selectableModel.canSelectSubject.eraseToAnyPublisher() }
    var changedPublisher: AnyPublisher<SKSelectableModel, Never> { selectableModel.changedSubject.eraseToAnyPublisher() }
}

public protocol SelectableCollectionProtocol {
    associatedtype Element: SelectableProtocol
    
    /// 可选元素序列
    var selectables: [Element] { get }
    
    /// 已选中某个元素
    /// - Parameters:
    ///   - index: 选中元素索引
    ///   - element: 选中元素
    func element(selected index: Int, element: Element)
}

public extension SelectableCollectionProtocol {
    func element(selected _: Int, element _: Element) {}
}

public extension SelectableCollectionProtocol {
    /// 序列中第一个选中的元素
    func firstSelectedElement() -> Element? {
        return selectables.first(where: { $0.isSelected })
    }
    
    /// 序列中第一个选中的元素的索引
    func firstSelectedIndex() -> Int? {
        return selectables.firstIndex(where: { $0.isSelected })
    }
    
    /// 已选中的元素
    var selectedElements: [Element] {
        selectables.filter(\.isSelected)
    }
    
    /// 已选中的元素序列
    var selectedIndexs: [Int] {
        selectables.enumerated().filter { $0.element.isSelected }.map(\.offset)
    }
    
    /// 选中元素
    /// - Parameters:
    ///   - index: 选择序号
    ///   - isUnique: 是否保证选中在当前序列中是否唯一 | default: true
    ///   - needInvert: 是否需要支持反选操作 | default: false
    func select(at index: Int, isUnique: Bool = true, needInvert: Bool = false) {
        guard selectables.indices.contains(index) else {
            return
        }
        
        let element = selectables[index]
        
        guard element.canSelect else {
            return
        }
        
        guard isUnique else {
            element.selectableModel.isSelected = needInvert ? !element.isSelected : true
            self.element(selected: index, element: element)
            return
        }
        
        for (offset, item) in selectables.enumerated() {
            if offset == index {
                item.selectableModel.isSelected = needInvert ? !element.isSelected : true
            } else {
                item.selectableModel.isSelected = false
            }
        }
        self.element(selected: index, element: element)
    }
}

public extension SelectableCollectionProtocol where Element: Equatable {
    /// 选中指定元素
    /// - Parameters:
    ///   - element: 指定元素
    ///   - needInvert: 是否需要支持反选操作 | default: false
    func select(_ element: Element, needInvert: Bool = false) {
        guard selectables.contains(element) else {
            return
        }
        
        for (offset, item) in selectables.enumerated() {
            item.selectableModel.isSelected = needInvert ? !item.isSelected : item == element
            if item == element {
                self.element(selected: offset, element: element)
            }
        }
    }
}
