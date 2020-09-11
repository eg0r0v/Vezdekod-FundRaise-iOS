//
//  FundingSnippetView.swift
//  FundRaisings
//
//  Created by Илья Егоров on 12.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class FundingSnippetView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    func configure(image: UIImage, fundType: FundRaisingType, fundInfo: [FundRaisingFieldType: String]) {
        imageView.image = image
        titleLabel.text = fundInfo[.fundTitle]
        let typeString: String
        switch fundType {
        case .regular:
            typeString = "Помощь нужна каждый месяц"
        case .target:
            typeString = "Закончится через 5 дней"
        }
        captionLabel.text = (fundInfo[.author] ?? "Матвей Правосудов") + " • " + typeString
    }

}
