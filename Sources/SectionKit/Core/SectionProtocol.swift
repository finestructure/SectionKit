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

#if canImport(UIKit)
import UIKit

public protocol SectionProtocol: AnyObject {
    
    var core: SectionState? { get set }
    var index: Int { get set }
    
    /// UICollectionViewDelegate & UITableViewDelegate
    func item(selected row: Int)
    func item(shouldSelect row: Int) -> Bool

    func item(deselected row: Int)
    func item(shouldDeselect row: Int) -> Bool
    
    /// MultipleSelectionInteraction
    func shouldBeginMultipleSelectionInteraction(at row: Int) -> Bool
    func didBeginMultipleSelectionInteraction(at row: Int)
    func didEndMultipleSelectionInteraction()
    
    /// Managing Cell Highlighting
    func item(shouldHighlight row: Int) -> Bool
    func item(didHighlight row: Int)
    func item(didUnhighlight row: Int)
    
    func item(willDisplay row: Int)
    func item(didEndDisplaying row: Int)
    
    /// Editing Items
    func canEditItem(at row: Int) -> Bool
    
    var indexTitle: String? { get }
        
    var itemCount: Int { get }
    
    func canMove(at: Int) -> Bool
    
    func move(from source: IndexPath, to destination: IndexPath)
    
    func pick(_ updates: (() -> Void), completion: ((Bool) -> Void)?)
}

public extension SectionProtocol {

    var index: Int {
        set { core?.index = newValue }
        get { core?.index ?? 0 }
    }

    var isLoaded: Bool { core != nil }

}

/// delegate
public extension SectionProtocol {

    /// UICollectionViewDelegate & UITableViewDelegate
    func item(selected row: Int) { }
    func item(shouldSelect row: Int) -> Bool { true }

    func item(deselected row: Int) { }
    func item(shouldDeselect row: Int) -> Bool { true }
    
    /// MultipleSelectionInteraction
    func shouldBeginMultipleSelectionInteraction(at row: Int) -> Bool { false }
    func didBeginMultipleSelectionInteraction(at row: Int) {}
    func didEndMultipleSelectionInteraction() {}
    
    /// Managing Cell Highlighting
    func item(shouldHighlight row: Int) -> Bool { true }
    func item(didHighlight row: Int) { }
    func item(didUnhighlight row: Int) { }

    /// Tracking the Addition and Removal of Views
    func item(willDisplay row: Int) {}
    func item(didEndDisplaying row: Int) {}
    
    /// Editing Items
    func canEditItem(at row: Int) -> Bool { true }

}

public extension SectionProtocol {

    func indexPath(from value: Int?) -> IndexPath? {
        return value.map({ IndexPath(item: $0, section: index) })
    }

    func indexPath(from value: Int) -> IndexPath {
        return IndexPath(item: value, section: index)
    }

    func indexPath(from value: [Int]) -> [IndexPath] {
        return value.map({ IndexPath(item: $0, section: index) })
    }

}

public extension SectionProtocol {
    var indexTitle: String? { nil }
    func canMove(at: Int) -> Bool { false }
    func move(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
}


public extension SectionProtocol {
    var eraseToDynamicType: SectionDynamicType { .section(self) }
}
#endif
