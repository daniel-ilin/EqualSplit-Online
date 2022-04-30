//
//  SendLinkViewModel.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 4/25/22.
//

import Foundation
import UIKit


class SendLinkViewModel {
    
    private var timer: Timer?
    
    var timeLeft = 0 {
        didSet {
            if email == nil { formIsValid = false; delegate?.updateButton(); return }
            else if !email!.isEmpty && timeLeft == 0 {
                formIsValid = true
            } else { formIsValid = false}
            delegate?.updateButton()
        }
    }
    
    var email: String? {
        didSet {
            if email == nil { formIsValid = false; return }
            else if !email!.isEmpty && timeLeft == 0 {
                formIsValid = true
            } else { formIsValid = false}
        }
    }
    
    var formIsValid = false
    
    weak private var delegate: SendLinkViewModelDelegate?
        
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.67)
    }
    
    func startTimer()  {
        formIsValid = false
        timeLeft = 60
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                guard self != nil else { timer.invalidate(); return }
                
                self?.timeLeft -= 1
                
                if self!.timeLeft <= 1 {
                    self!.formIsValid = true
                }
                
                if self!.timeLeft <= 0 {
                    self!.stopTimer()
                }
            }
        }
    }

    private func stopTimer()
    {
        if timer != nil {
           timer!.invalidate()
           timer = nil
        }
    }
    
    init(delegate: SendLinkViewModelDelegate) {
        self.delegate = delegate
    }
}

protocol SendLinkViewModelDelegate: AnyObject {
    func updateButton()
}
