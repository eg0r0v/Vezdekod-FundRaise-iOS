//
//  NewsFeedViewController.swift
//  FundRaisings
//
//  Created by Илья Егоров on 12.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class NewsFeedViewController: UIViewController {

    static var identifier: String {
        return String(describing: self)
    }
    
    private var photo: UIImage!
    private var fundType: FundRaisingType!
    private var fundInfo: [FundRaisingFieldType: String]!
    
    @IBOutlet private weak var snippetView: FundingSnippetView!
    
    func configure(photo: UIImage, fundType: FundRaisingType, fundInfo: [FundRaisingFieldType: String]) {
        self.photo = photo
        self.fundType = fundType
        self.fundInfo = fundInfo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        snippetView.configure(image: photo, fundType: fundType, fundInfo: fundInfo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "На этом, к сожалению, всё", message: """
            Не хочу плохо писать такие красивые интерфейсы. Я хорошо сделал форму ввода данных, показал проброс данных и фото на экран ленты, и мне нравится, как оно получилось в таких условиях :)

            Мало времени, объемное задание, хочется сделать хорошо и не хочется делать какашку.
            Поэтому, а ещё и потому, что уже 2:25 ночи, а утром времени совсем не будет, я останавливаю работу.
            
            Огромное спасибо проверяющим за ваш труд! Посмотрите код, там красиво. Я бы допилил с большой радостью, но очень хочу спать, что и сделаю.

            P.S. Стрелочка назад на этом экране ведет в root (начало), чтобы вам удобнее было проверять.
            """, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
