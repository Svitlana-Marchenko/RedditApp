//
//  ShareButtonDelegate.swift
//  RedditApp
//
//  Created by Svitlana on 24.02.2024.
//

import Foundation
import UIKit

protocol ShareButtonDelegate: AnyObject {
    func didTapShareButton(url : URL)
}
