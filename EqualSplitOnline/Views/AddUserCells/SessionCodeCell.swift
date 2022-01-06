//
//  SessionCodeCell.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 05.01.2022.
//

import Foundation
import UIKit

class SessionCodeCell: UITableViewCell {
    
    //    MARK: - Properties
    
    private var cellTitle: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "Show your friends the session code", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.label])
        label.attributedText = attributedString
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var sessionNumber: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "000000", attributes: [.font: UIFont.boldSystemFont(ofSize: 32), .foregroundColor: UIColor.label])
        label.attributedText = attributedString
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    //    MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellTitle)
        cellTitle.centerX(inView: self, topAnchor: topAnchor, paddingTop: 40)
        cellTitle.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 40, paddingRight: 40)
        
        addSubview(sessionNumber)
        sessionNumber.centerX(inView: self, topAnchor: cellTitle.bottomAnchor, paddingTop: 8)
        sessionNumber.anchor(bottom: self.bottomAnchor, paddingBottom: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

