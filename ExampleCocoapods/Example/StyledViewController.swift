//
//  SimpleViewController.swift
//  FlagPhoneNumber_Example
//
//  Created by Aurelien on 24/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class StyledViewController: UIViewController {

	@IBOutlet weak var phoneNumberTextField: FPNTextField!

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "In Simple View"

		view.backgroundColor = UIColor.groupTableViewBackground

		phoneNumberTextField.borderStyle = .roundedRect

		phoneNumberTextField.parentViewController = self
		phoneNumberTextField.delegate = self

		phoneNumberTextField.font = UIFont.systemFont(ofSize: 14)

		// Custom the size/edgeInsets of the flag button
		phoneNumberTextField.flagButtonSize = CGSize(width: 35, height: 35)
		phoneNumberTextField.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

		view.addSubview(phoneNumberTextField)

		phoneNumberTextField.center = view.center
        
        view.backgroundColor = UIColor(white: 0.3, alpha: 1)
        
        phoneNumberTextField.font = UIFont.systemFont(ofSize: 20)
        phoneNumberTextField.textColor = UIColor(white: 0.9, alpha: 1)
        phoneNumberTextField.backgroundColor = UIColor(white: 0.5, alpha: 1)
        phoneNumberTextField.phoneNumberExampleAttributes = [
            .foregroundColor: UIColor(white: 0.6, alpha: 1)
        ]
        
        phoneNumberTextField.countryPicker.tintColor = UIColor(white: 0.9, alpha: 1)
        phoneNumberTextField.countryPicker.barStyle = .black
        phoneNumberTextField.countryPicker.isTranslucent = true
        phoneNumberTextField.countryPicker.backgroundColor = phoneNumberTextField.backgroundColor
        phoneNumberTextField.countryPicker.countryNameAttributes = [
            .foregroundColor: phoneNumberTextField.textColor!
        ]
        phoneNumberTextField.countryPicker.countryCodeAttributes = phoneNumberTextField.countryPicker.countryNameAttributes
	}

	private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
		let toolbar: UIToolbar = UIToolbar()

		toolbar.barStyle = UIBarStyle.default
		toolbar.items = items
		toolbar.sizeToFit()

		return toolbar
	}
}

extension StyledViewController: FPNTextFieldDelegate {

	func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
		textField.rightViewMode = .always
		textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "success") : #imageLiteral(resourceName: "error"))

		print(
			isValid,
			textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
			textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
			textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
			textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
			textField.getRawPhoneNumber() ?? "Raw: nil"
		)
	}

	func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
		print(name, dialCode, code)
	}
}
