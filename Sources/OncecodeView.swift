//
//  OncecodeView.swift
//
//  MIT License
//  Copyright © 2024 Nico
//  Created by Nico http://github.com/niyongsheng/OncecodeView
//  V1.0.0
//

import UIKit

@objc protocol OncecodeTextFieldDelegate: AnyObject {
    @objc func didDeleteBackward()
    @objc func didBecomeFirstResponder(textField: OncecodeTextField)
}

@objc(OncecodeTextField)
class OncecodeTextField: UITextField {
    
    @objc weak var oncecodeTextFieldDelegate: OncecodeTextFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        oncecodeTextFieldDelegate?.didDeleteBackward()
    }
    
    override func becomeFirstResponder() -> Bool {
            let success = super.becomeFirstResponder()
            if success {
                oncecodeTextFieldDelegate?.didBecomeFirstResponder(textField: self)
            }
            return success
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, text.count > 1 else {
            return
        }
        textField.text = String(text.prefix(1))
    }
    
}

@objc protocol OncecodeViewDelegate: AnyObject {
    @objc func oncecodeDidFinishInput(onceCodeView: OncecodeView, code: String)
    @objc optional func oncecodeBecomeFirstResponder(onceCodeView: OncecodeView, textField: UITextField, index: Int)
}

@objc(OncecodeView)
class OncecodeView: UIView {
    
    @objc weak var delegate: OncecodeViewDelegate?
    @objc var textfieldArray = [OncecodeTextField]()
    
    private var numOfBox = 6
    private var isSecure: Bool = false
    private var marginOfBox: CGFloat = 10.0
    private var boxWidth: CGFloat = 50
    private var boxHeight: CGFloat = 50
    
    @objc var borderStyle: UITextField.BorderStyle = .none {
        didSet {
            updateUI()
        }
    }
    
    @objc var radius: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    @objc var themeColor: UIColor! = UIColor.systemBlue {
        didSet {
            updateUI()
        }
    }
    
    @objc var bgColor: UIColor! = UIColor.systemGray4 {
        didSet {
            updateUI()
        }
    }
    
    @objc var textColor: UIColor = UIColor.black {
        didSet {
            updateUI()
        }
    }
    
    @objc var font: UIFont = UIFont.systemFont(ofSize: 30) {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        for textField in textfieldArray {
            textField.isSecureTextEntry = isSecure
            textField.frame.size.width = boxWidth
            textField.frame.size.height = boxHeight
            textField.borderStyle = borderStyle
            textField.layer.cornerRadius = radius
            textField.backgroundColor = bgColor
            textField.tintColor = themeColor
            textField.textColor = textColor
            textField.font = font
        }
    }
    
    init(frame: CGRect, numOfBox: Int = 6, boxWidth: CGFloat = 50, boxHeight: CGFloat = 50, isSecure: Bool = false) {
        self.numOfBox = numOfBox
        self.boxWidth = boxWidth
        self.boxHeight = boxHeight
        self.isSecure = isSecure
        
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initUI() {
        let leftMargin = (UIScreen.main.bounds.width - boxWidth * CGFloat(numOfBox) - CGFloat(numOfBox - 1) * 10) / 2
        
        for i in 0..<numOfBox {
            let rect = CGRect(x: leftMargin + CGFloat(i) * (boxWidth + 10), y: 0, width: boxWidth, height: boxHeight)
            let textField = createTextField(frame: rect)
            textField.tag = i
            textfieldArray.append(textField)
        }
        
        if numOfBox > 0 {
            _ = textfieldArray.first?.becomeFirstResponder()
        }
    }
    
    private func createTextField(frame: CGRect) -> OncecodeTextField {
        let codeTextField = OncecodeTextField(frame: frame)
        codeTextField.isSecureTextEntry = isSecure
        codeTextField.borderStyle = borderStyle
        codeTextField.layer.cornerRadius = radius
        codeTextField.clipsToBounds = true
        codeTextField.font = font
        codeTextField.textColor = textColor
        codeTextField.tintColor = themeColor
        codeTextField.backgroundColor = bgColor
        codeTextField.textAlignment = .center
        codeTextField.clearButtonMode = .never
        codeTextField.textContentType = .oneTimeCode
        codeTextField.keyboardType = .numberPad
        codeTextField.delegate = self
        codeTextField.oncecodeTextFieldDelegate = self
        addSubview(codeTextField)
        return codeTextField
    }
    
    @objc func cleanVerificationCodeView() {
        for textField in textfieldArray {
            textField.text = ""
        }
        _ = textfieldArray.first?.becomeFirstResponder()
    }
    
}

extension OncecodeView: UITextFieldDelegate, OncecodeTextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !textField.hasText {
            let index = textField.tag
            
            if index == numOfBox - 1 {
                textField.text = string
                var code = ""
                for tv in textfieldArray {
                    code += tv.text ?? ""
                }
                delegate?.oncecodeDidFinishInput(onceCodeView: self, code: code)
                return false
            }
            
            textField.text = string
            _ = textfieldArray[index + 1].becomeFirstResponder()
        }
        
        return true
    }
    
    func didDeleteBackward() {
        for i in 1..<numOfBox {
            let textField = textfieldArray[i]
            if !textField.isFirstResponder {
                continue
            }
            
            let previousTextField = textfieldArray[i - 1]
            _ = previousTextField.becomeFirstResponder()
            previousTextField.text = ""
        }
    }
    
    func didBecomeFirstResponder(textField: OncecodeTextField) {
        if let index = self.textfieldArray.firstIndex(where: { $0 === textField}) {
            delegate?.oncecodeBecomeFirstResponder?(onceCodeView: self, textField: textField, index: index)
        }
    }
    
}
