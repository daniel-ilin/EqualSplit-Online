//
//  TransactionViewCell.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 08.01.2022.
//

import Foundation
import UIKit

class TransactionViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var userCanEdit = false
    private let collapsedView = TransactionCollapsedCellView()
    private let expandedView = TransactionExpandedCellView()
    private let containerView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //    MARK: - UISetup
    
    func cellSetup(at indexPath: IndexPath, withViewModel viewModel: Person)->UITableViewCell {
        if AuthService.activeUser?.id == viewModel.id {
            userCanEdit = true
        }
        collapsedView.uiSetup(at: indexPath, withViewModel: viewModel)
        expandedView.uiSetup(at: indexPath, withViewModel: viewModel)
        return self
    }
    
    private func commonInit() {
        let cellView = collapsedView
        let detailView = expandedView
        
        selectionStyle = .none
        detailView.isHidden = true
        
        containerView.axis = .vertical

        contentView.addSubview(containerView)
        containerView.addArrangedSubview(cellView)
        containerView.addArrangedSubview(detailView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        cellView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
}


extension TransactionViewCell {
    var isDetailViewHidden: Bool {
        return expandedView.isHidden
    }

    func showDetailView() {
        expandedView.isHidden = false
    }

    func hideDetailView() {
        expandedView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard userCanEdit == true else { return }
        if isDetailViewHidden, selected {
            showDetailView()
        } else {
            hideDetailView()
        }
    }
}
