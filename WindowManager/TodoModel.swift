//
//  TodoModel.swift
//  WindowManager
//
//  Created by bslayter on 6/19/17.
//
//

import Foundation
import RealmSwift

class TodoModel: Object {
    dynamic var id = ""
    dynamic var title = ""
    dynamic var isComplete = false
    dynamic var created = Date()
}
