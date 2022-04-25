//
//  SendCodeViewModel.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 4/22/22.
//

import Foundation
import UIKit

class SendCodeViewModel {
    
    private var timer: Timer?
    
    private var formIsValid = true
    
    weak private var delegate: SendCodeViewModelDelegate?
    
    private var timeLeft = 0 {
        didSet {
            delegate?.updateCounter(to: timeLeft, isFormValid: formIsValid)
        }
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : .white.withAlphaComponent(0.67)
    }
    
    init(delegate: SendCodeViewModelDelegate) {
        self.delegate = delegate
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
}

protocol SendCodeViewModelDelegate: AnyObject {
    func updateCounter(to time: Int, isFormValid valid: Bool)
}
