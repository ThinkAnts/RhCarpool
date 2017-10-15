//
//  FIRDataObject.swift
//  RhCarpool
//
//  Created by Ravi on 07/10/17.
//  Copyright © 2017 ThinkAnts. All rights reserved.
//

import Foundation
import Firebase

class FIRDataObject: NSObject {

    let snapshot: DataSnapshot
    var key: String { return snapshot.key }
    var ref: DatabaseReference { return snapshot.ref }

    required init(snapshot: DataSnapshot) {
        self.snapshot = snapshot
        super.init()
        for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
        }
    }
}

protocol FIRDatabaseReferenceable {
    var ref: DatabaseReference { get }
}

extension FIRDatabaseReferenceable {
    var ref: DatabaseReference {
        return Database.database().reference()
    }
}
