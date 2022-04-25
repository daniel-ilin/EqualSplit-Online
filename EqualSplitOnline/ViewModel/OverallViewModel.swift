//
//  DetailUserViewModel.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 08.01.2022.
//

import Foundation
import UIKit

class SessionViewModel {
    var sessionId: String
    var people: [Person]
    var ownerId: String
    
    init(forPeople people: [Person], inSessionWithId sessionid: String, ownerId: String) {
        self.people = people
        self.sessionId = sessionid
        self.ownerId = ownerId
    }
}

struct Calculator {    
    
//    MARK: - FindOwersNeeders
    
    static func findOwersNeeders(inSession session: Session) -> SessionViewModel {
        
        var people = [Person]()
        let users = session.users
        let personSpent = session.totalSpent()/users.count
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        for user in users {
            let newPerson = Person(name: user.username, id: user.userid)
            for transaction in user.transactions {
                let calcTransaction = CalculatorTransaction(amount: Int(transaction.amount) ?? 0, sender: user.username, description: transaction.description, date: dateFormatter.date(from: transaction.date) ?? Date())
                calcTransaction.id = transaction.id
                newPerson.spent.append(calcTransaction)
            }
            people.append(newPerson)
        }
        
        for person in people {
            if person.spentGeneral < personSpent {
                person.owesGeneral = personSpent - person.spentGeneral
                person.ower = .isOwer
            } else if person.spentGeneral > personSpent {
                person.needsGeneral = person.spentGeneral - personSpent
                person.ower = .isNeeder
            } else if person.spentGeneral == personSpent {
                person.ower = .isClean
            }
        }
        
        var owers = [Person]()
        var needers = [Person]()
        
        for person in people {
            if person.ower != nil {
                if person.ower == .isOwer {
                    owers.append(person)
                } else if person.ower == .isNeeder {
                    needers.append(person)
                }
            }
        }
        
        for needer in needers {
            needer.needs.removeAll()
        }
        
        for ower in owers {
            ower.owes.removeAll()
            ower.needs.removeAll()
            for needer in needers {
                needer.owes.removeAll()
                if ower.owesGeneral != nil && needer.needsGeneral != nil && personSpent > 1 {
                    if ower.owesGeneral >= needer.needsGeneral {
                        let payment = needer.needsGeneral
                        ower.owesGeneral -= payment!
                        needer.needsGeneral = 0
                        
                        let transaction = CalculatorTransaction(amount: payment!, receiver: needer.name, sender: ower.name, date: Date())
                        
                        if transaction.amount != 0 {
                            ower.owes.append(transaction)
                            needer.needs.append(transaction)
                        }
                        
                    } else if ower.owesGeneral < needer.needsGeneral {
                        let payment = ower.owesGeneral
                        needer.needsGeneral -= payment!
                        ower.owesGeneral = 0
                        
                        let transaction = CalculatorTransaction(amount: payment!, receiver: needer.name, sender: ower.name, date: Date())
                        
                        if transaction.amount != 0 {
                            ower.owes.append(transaction)
                            needer.needs.append(transaction)
                        }
                    }
                }
            }
        }
        
        for person in needers {
            person.totalDebtFieldText = person.findTotalNeeds()
            if person.owesGeneral == 0 {
                person.owes.removeAll()
            }
        }
        
        for person in owers {
            person.totalDebtFieldText = person.findTotalOwes()
            if person.needsGeneral == 0 {
                person.needs.removeAll()
            }
        }
        
        if people.count == 1 {
            for person in people {
                person.owes.removeAll()
                person.owesGeneral = 0
                person.needs.removeAll()
                person.needsGeneral = 0
            }
        }
        
        if personSpent != 0 {
            for person in people {
                person.progress = CGFloat(person.spentGeneral)/CGFloat(personSpent)
            }
        } else {
            for person in people {
                person.progress = 0
            }
        }
        
        for (index, person) in people.enumerated() {
            if person.id == AuthService.activeUser?.id {
                people.move(from: index, to: 0)
            }
        }
        
        return SessionViewModel(forPeople: people, inSessionWithId: session.id, ownerId: session.ownerid)
    }
}

// MARK: - Person

class Person {
    var name: String
    var id: String
    var owesGeneral: Int!
    var needsGeneral: Int!
    var spentGeneral: Int!
    var owes = [CalculatorTransaction]()
    var needs = [CalculatorTransaction]()
    var spent = [CalculatorTransaction]() {
        didSet {
            self.findSpentGeneral()
        }
    }
    var progress: CGFloat!
        
    var ower: PersonType? {
        didSet {
            if ower == .isOwer {
                moneyTextColor = UIColor(named: "Red")
                owesOrOwed = "Owes"
            } else if ower == .isNeeder {
                moneyTextColor = UIColor(named: "Green")
                owesOrOwed = "Owed"
            } else if ower == .isClean {
                moneyTextColor = UIColor(named: "Green")
                owesOrOwed = "Owes"
            }
        }
    }
    
    var totalDebtFieldText: Int?
    
    var moneyTextColor: UIColor?
    
    var owesOrOwed = "Owes"
    
    init(name: String, id: String) {
        self.name = name
        self.progress = 0.05
        self.spentGeneral = 0
        self.id = id
    }
    
//    convenience init(name: String, id: String, owesGeneral: Int, needsGeneral: Int, spentGeneral: Int, progress: CGFloat) {
//        self.init(name: name, id: id)
//        self.owesGeneral = owesGeneral
//        self.needsGeneral = needsGeneral
//        self.spentGeneral = spentGeneral
//        self.progress = progress
//    }
    
    private func findSpentGeneral() {
        var spentGeneralAmount: Int = 0
        for money in spent {
            spentGeneralAmount += money.amount
        }
        self.spentGeneral = spentGeneralAmount
    }
    
    func findTotalNeeds() -> Int {
        var totalNeeds: Int = 0
        for need in needs {
            totalNeeds += need.amount
        }
        return totalNeeds
    }
    
    func findTotalOwes() -> Int {
        var totalOwes: Int = 0
        for owe in owes {
            totalOwes += owe.amount
        }
        return totalOwes
    }
        
}

// MARK: - CalculatorTransaction

class CalculatorTransaction {
    var date: Date
    var amount: Int
    var receiver: String
    var sender: String
    var complete: Bool
    var transacDescription: String!
    var id: String?
    
    var moneyTextColor: UIColor?
    var moneyTextFont: UIFont?
    
    init(amount: Int, receiver: String, sender: String, date: Date) {
        self.amount = amount
        self.receiver = receiver
        self.sender = sender
        self.date = date
        complete = false
    }
    
    convenience init(amount: Int, sender: String, description: String, date: Date) {
        self.init(amount: amount, receiver: "Everyone", sender: sender, date: date)
        self.transacDescription = description
        complete = false
    }
}

enum PersonType {
    case isOwer
    case isNeeder
    case isClean
}
