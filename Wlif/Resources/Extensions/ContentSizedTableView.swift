//
//  ContentSizedTableView.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation
import UIKit

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                     height: contentSize.height + adjustedContentInset.top)
    }
}
