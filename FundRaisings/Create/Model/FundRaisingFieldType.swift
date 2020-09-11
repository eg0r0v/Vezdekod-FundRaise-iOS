//
//  FundRaisingFieldType.swift
//  FundRaisings
//
//  Created by Илья Егоров on 11.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

enum FundRaisingFieldType: String {
    
    case fundTitle
    case fundSum
    case fundSumPerMonth
    case goal
    case description
    case account
    case author
    
    var title: String {
        switch self {
            
        case .fundTitle:
            return "Название сбора"
        case .fundSum:
            return "Сумма, ₽"
        case .fundSumPerMonth:
            return "Сумма в месяц, ₽"
        case .goal:
            return "Цель"
        case .description:
            return "Описание"
        case .account:
            return "Куда получать деньги"
        case .author:
            return "Автор"
        }
    }
    
    var placeholder: String {
        switch self {
            
        case .fundTitle:
            return "Название сбора"
        case .fundSum:
            return "Сколько нужно собрать?"
        case .fundSumPerMonth:
            return "Сколько нужно в месяц?"
        case .goal:
            return "Например, поддержка приюта"
        case .description:
            return "На что пойдут деньги и как они кому-то помогут?"
        case .account:
            return "Счёт VK Pay • 1234"
        case .author:
            return "Матвей Правосудов"
        }
    }
}
