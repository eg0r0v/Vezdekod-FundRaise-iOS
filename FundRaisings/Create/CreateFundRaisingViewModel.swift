//
//  CreateFundRaisingViewModel.swift
//  FundRaisings
//
//  Created by Илья Егоров on 11.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

enum FundRaisingType {
    case target
    case regular
    
    var title: String {
        switch self {
        case .target:
            return "Целевой сбор"
        case .regular:
            return "Регулярный сбор"
        }
    }
}


protocol CreateFundRaisingViewModelDelegate: AnyObject {
    func didChangeData()
}

final class CreateFundRaisingViewModel {
    
    let fundRaisingType: FundRaisingType
    var image: UIImage?
    
    private(set) var fieldInfo = [FundRaisingFieldType: String]()
    var isDataReady: Bool {
        if image == nil {
            return false
        }
        for item in fieldItems {
            if fieldInfo[item] == nil {
                return false
            }
        }
        return true
    }
    
    weak var delegate: CreateFundRaisingViewModelDelegate?
    
    
    private(set) lazy var fieldItems: [FundRaisingFieldType] = {
        var fieldItems: [FundRaisingFieldType] = [
            .fundTitle
        ]
        switch fundRaisingType {
        case .target:
            fieldItems.append(.fundSum)
        case .regular:
            fieldItems.append(.fundSumPerMonth)
        }
        fieldItems.append(contentsOf: [
            .goal,
            .description,
            .account
        ])
        
        if fundRaisingType == .regular {
            fieldItems.append(.author)
        }
        return fieldItems
    }()
    
    init(fundRaisingType: FundRaisingType) {
        self.fundRaisingType = fundRaisingType
    }
    
    func didSet(text: String?, for fieldType: FundRaisingFieldType) {
        let prev = isDataReady
        fieldInfo[fieldType] = text
        if isDataReady != prev {
            delegate?.didChangeData()
        }
    }
}
