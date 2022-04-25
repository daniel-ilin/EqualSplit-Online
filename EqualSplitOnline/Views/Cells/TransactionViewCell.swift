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
    let expandedView = TransactionExpandedCellView(frame: CGRect.zero, newTransaction: false)
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
    
    func cellSetup(at indexPath: IndexPath, withViewModel viewModel: Person, forSession session: SessionViewModel)->UITableViewCell {
        findIfUserCanEditCell(at: indexPath, withViewModel: viewModel, forSession: session)
        
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

extension TransactionViewCell {
    func findIfUserCanEditCell(at indexPath: IndexPath, withViewModel viewModel: Person, forSession session: SessionViewModel) {
        if AuthService.activeUser?.id == viewModel.id || AuthService.activeUser?.id == session.ownerId {
            userCanEdit = true
        } else {
            userCanEdit = false
            return
        }
        
        let person = viewModel
        
        var tableSectionsData = [[CalculatorTransaction]]()
        if person.owes.count > 0 {
            tableSectionsData = [person.spent, person.owes]
        } else if person.needs.count > 0 {
            tableSectionsData = [person.spent, person.needs]
        } else {
            tableSectionsData = [person.spent, person.needs]
        }
        
        let spentCount = tableSectionsData[0].count
        let owesOrNeedsCount = tableSectionsData[1].count
        
        if spentCount > 0 && owesOrNeedsCount == 0 {
            userCanEdit = true
        } else if spentCount == 0 && owesOrNeedsCount > 0 {
            userCanEdit = false
        } else if spentCount > 0 && owesOrNeedsCount > 0 {
            if indexPath.section == 0 {
                userCanEdit = true
            } else {
                userCanEdit = false
            }
        } else {
            userCanEdit = false
        }
    }
}

