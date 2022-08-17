//
//  File.swift
//  
//
//  Created by linhey on 2022/8/13.
//

import UIKit

public final class STCollectionRegistrationSection: STCollectionRegistrationSectionProtocol {
    
    public var registrationSectionInjection: STCollectionRegistrationSectionInjection?
    public var supplementaries: [SKSupplementaryKind: any STCollectionSupplementaryRegistrationProtocol]
    public var registrations: [any STCollectionCellRegistrationProtocol]
    
    public convenience init() {
        self.init([:], [])
    }
    
    public convenience init(@Builder _ supplementaries: (() -> BuilderStore)) {
        let supplementaries = supplementaries()
        self.init(supplementaries.supplementaries, supplementaries.registrations)
    }
    
    public init(_ supplementaries: [SKSupplementaryKind: any STCollectionSupplementaryRegistrationProtocol],
                _ registrations: [any STCollectionCellRegistrationProtocol]) {
        self.supplementaries = supplementaries
        self.registrations = registrations
    }
    
}


public extension STCollectionRegistrationSection {
    
    struct BuilderStore {
        public var supplementaries: [SKSupplementaryKind: any STCollectionSupplementaryRegistrationProtocol] = [:]
        public var registrations: [any STCollectionCellRegistrationProtocol] = []
    }
    
    @resultBuilder
    struct Builder {
        
        public typealias Store = BuilderStore
        public typealias CellView = STCollectionSupplementaryRegistrationProtocol
        public typealias RegistrationView = STCollectionCellRegistrationProtocol
        
        public static func buildExpression(_ expression: Void) -> Store {
            .init()
        }
        
        public static func buildExpression(_ expression: any CellView) -> Store {
            buildExpression([expression])
        }
        
        public static func buildExpression(_ expression: [any CellView]) -> Store {
            var dict = [SKSupplementaryKind: any CellView]()
            expression.forEach { item in
                dict[item.kind] = item
            }
            return Store(supplementaries: dict)
        }
        
        public static func buildExpression(_ expression: any RegistrationView) -> Store {
            buildExpression([expression])
        }
        
        public static func buildExpression(_ expression: [any RegistrationView]) -> Store {
            Store(registrations: expression)
        }
        
        public static func buildExpression(_ expression: Store?) -> Store {
            expression ?? .init()
        }
        
        public static func buildExpression(_ expression: [Store]) -> Store {
            .init(
                supplementaries: buildExpression(expression.map(\.supplementaries.values).flatMap({ $0 })).supplementaries,
                registrations: buildExpression(expression.map(\.registrations).flatMap({ $0 })).registrations)
        }
        
        public static func buildBlock(_ components: Store...) -> Store {
            buildExpression(components)
        }
        
        public static func buildArray(_ components: [Store]) -> Store {
            buildExpression(components)
        }
        
        public static func buildOptional(_ component: Store?) -> Store {
            buildExpression(component)
        }
        
        public static func buildEither(first component: Store) -> Store {
            buildExpression(component)
        }
        
        public static func buildEither(second component: Store) -> Store {
            buildExpression(component)
        }
        
        public static func buildLimitedAvailability(_ component: Store) -> Store {
            buildExpression(component)
        }
        
    }
    
}
