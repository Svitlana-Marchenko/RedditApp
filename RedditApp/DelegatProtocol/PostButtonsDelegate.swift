//
//  ShareButtonDelegate.swift
//  RedditApp
//
//  Created by Svitlana on 24.02.2024.
//

import Foundation
import UIKit

protocol PostButtonsDelegate: AnyObject {
    func didTapShareButton(url : URL)
    func didTapSaveButton(post : Post)
    func didTapCommentButton(post : Post)
}
