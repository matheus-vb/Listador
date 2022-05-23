//
//  ProductList+CoreDataProperties.swift
//  Grocery_Manager
//
//  Created by matheusvb on 19/05/22.
//
//

import Foundation
import CoreData


extension ProductList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductList> {
        return NSFetchRequest<ProductList>(entityName: "ProductList")
    }

    @NSManaged public var name: String?
    @NSManaged public var qtdHome: Int32
    @NSManaged public var qtdList: Int32
    @NSManaged public var qtdReq: Int32

}

extension ProductList : Identifiable {

}
