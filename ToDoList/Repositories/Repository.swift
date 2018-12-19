//
//  Repository.swift
//  ToDoList
//
//  Created by IGNACIO GALAN DE PINA on 19/12/18.
//  Copyright © 2018 IGNACIO GALAN DE PINA. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype T
    
    func getAll() -> [T]
    func get(identifier: String) -> T?
    func create(a: T) -> Bool
    func update(a: T) -> Bool
    func delete(a: T) -> Bool
    
}
