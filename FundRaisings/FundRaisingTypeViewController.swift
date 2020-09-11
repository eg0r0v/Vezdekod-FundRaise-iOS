//
//  FundRaisingTypeViewController.swift
//  FundRaisings
//
//  Created by Илья Егоров on 11.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class FundRaisingTypeViewController: UIViewController {
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapCreateTargetRaising(_ sender: Any) {
        toCreateFundRaising(type: .target)
    }
    
    @IBAction func didTapCreateRegularRaising(_ sender: Any) {
        toCreateFundRaising(type: .regular)
    }
    
    private func toCreateFundRaising(type: FundRaisingType) {
        
        let identifier = CreateFundRaisingViewController.identifier
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: identifier)
        
        let viewModel = CreateFundRaisingViewModel(fundRaisingType: type)
        (viewController as? CreateFundRaisingViewController)?.configure(viewModel: viewModel)
        show(viewController, sender: self)
    }
}
