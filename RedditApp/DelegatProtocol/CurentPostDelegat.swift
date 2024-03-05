//
//  UpdateTableDelegat.swift
//  RedditApp
//
//  Created by Svitlana on 26.02.2024.
//

import Foundation
import UIKit

protocol CurentPostDelegat: AnyObject {
    func didUpdateSavedPost()
    var post : Post? {get set}
}
