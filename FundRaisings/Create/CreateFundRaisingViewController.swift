//
//  CreateFundRaisingViewController.swift
//  FundRaisings
//
//  Created by Илья Егоров on 11.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit
import YPImagePicker

final class CreateFundRaisingViewController: UIViewController {

    static var identifier: String {
        return String(describing: self)
    }
    
    private var viewModel: CreateFundRaisingViewModel!
    
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var addImageButton: UIButton!
    @IBOutlet private weak var currentImageContainerView: UIView!
    @IBOutlet private weak var currentImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var fieldsStackView: UIStackView!
    @IBOutlet private weak var nextButton: UIButton!
    
    private var dashLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.vkBlueTintColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 4]
        return shapeLayer
    }()
    
    func configure(viewModel: CreateFundRaisingViewModel) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawAddImageButtonDash()
        registerKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawAddImageButtonDash()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup() {
        headerTitleLabel.text = viewModel.fundRaisingType.title
        
        scrollView.delegate = self
        
        updateImageViewsVisibility()
        
        insertFieldViews()
    }
    
    private func updateImageViewsVisibility() {
        if let image = viewModel.image {
            currentImageView.image = image
            currentImageContainerView.isHidden = false
            addImageButton.isHidden = true
        } else {
            currentImageContainerView.isHidden = true
            addImageButton.isHidden = false
        }
    }
    
    private func insertFieldViews() {
        
        guard fieldsStackView.arrangedSubviews.count > 3 else { return }
        
        for item in viewModel.fieldItems.reversed() {
            guard let view = Bundle.main.loadNibNamed(String(describing: FundRaisingFieldView.self), owner: self, options: nil)?.compactMap({ $0 as? FundRaisingFieldView }).first else { break }
            
            view.configure(fieldType: item) { [weak self] newText in
                self?.viewModel.didSet(text: newText, for: item)
            }
            fieldsStackView.insertArrangedSubview(view, at: 3)
        }
    }
    
    private func drawAddImageButtonDash() {
        dashLayer.removeFromSuperlayer()
        let path = CGPath(roundedRect: addImageButton.bounds, cornerWidth: 10, cornerHeight: 10, transform: nil)
        dashLayer.path = path
        addImageButton.layer.insertSublayer(dashLayer, at: 0)
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeImage(_ sender: Any) {
        viewModel.image = nil
        updateImageViewsVisibility()
    }
    
    @IBAction func pickImage(_ sender: Any) {
        let picker = YPImagePicker(configuration: YPImagePickerConfiguration())
        picker.didFinishPicking { [unowned picker, weak self] items, _ in
            if let photo = items.singlePhoto?.image {
                self?.viewModel.image = photo
                self?.updateImageViewsVisibility()
            }
            picker.dismiss(animated: true)
        }
        present(picker, animated: true)
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        view.endEditing(true)
        
        if viewModel.isDataReady {
            let fieldInfo = viewModel.fieldInfo
            guard let image = viewModel.image else { return }
            
            toNewsFeed(image: image, fundType: viewModel.fundRaisingType, fundInfo: fieldInfo)
        } else {
            for fieldView in fieldsStackView.arrangedSubviews.reversed() {
                if (fieldView as? FundRaisingFieldView)?.isEmpty == true {
                    (fieldView as? FundRaisingFieldView)?.becomeFirstResponder()
                }
            }
        }
    }
    
    private func toNewsFeed(image: UIImage,
                            fundType: FundRaisingType,
                            fundInfo: [FundRaisingFieldType: String]) {
        
        let identifier = NewsFeedViewController.identifier
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: identifier)

        (viewController as? NewsFeedViewController)?.configure(photo: image,
                                                               fundType: fundType,
                                                               fundInfo: fundInfo)
        show(viewController, sender: self)
    }
}

// Keyboard
extension CreateFundRaisingViewController {
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow(notification:)),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide(notification:)),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}

extension CreateFundRaisingViewController: CreateFundRaisingViewModelDelegate {
    func didChangeData() {
        switch viewModel.fundRaisingType {
        case .regular:
            let nextButtonTitle = viewModel.isDataReady ? "Создать сбор" : "Далее"
            nextButton.setTitle(nextButtonTitle, for: .normal)
        case .target:
            headerTitleLabel.text = viewModel.isDataReady ? "Целевой сбор" : "Основное"
        }
    }
}

extension CreateFundRaisingViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}


