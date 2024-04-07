//
//  ViewController.swift
//  OncecodeViewExample
//
//  Created by niyongsheng on 2024/4/2.
//

import UIKit

class ViewController: UIViewController, OncecodeViewDelegate {
    
    // 验证码
    private lazy var smsCodeView: OncecodeView! = {
        let frame = CGRect(x: 0, y: statusBarHeight() + 50, width: UIScreen.main.bounds.width, height: 50)
        let view = OncecodeView(frame: frame, numOfBox: 4)
        view.themeColor = .orange
        view.textColor = .orange
        view.bgColor = .clear
        view.borderStyle = .line
        view.delegate = self
        return view
    }()
    
    // 密码
    private lazy var pwdCodeView: OncecodeView! = {
        let frame = CGRect(x: 0, y: statusBarHeight() + 150, width: UIScreen.main.bounds.width, height: 50)
        let view = OncecodeView(frame: frame, numOfBox: 6, boxHeight: 65, isSecure: true)
        view.themeColor = .systemBlue
        view.textColor = .systemBlue
        view.radius = 10
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(smsCodeView)
        view.addSubview(pwdCodeView)
    }
    
    // MARK: - OncecodeViewDelegate
    func oncecodeDidFinishInput(onceCodeView: OncecodeView, code: String) {
        print("once code: \(code)")
    }
    
    func oncecodeBecomeFirstResponder(onceCodeView: OncecodeView, textField: UITextField, index: Int) {
        if onceCodeView.isEqual(pwdCodeView) {
            for (i, value) in onceCodeView.textfieldArray.enumerated() {
                value.layer.borderWidth = i == index ? 1.5 : 0
                value.layer.cornerRadius = onceCodeView.radius
                value.layer.borderColor = onceCodeView.themeColor.cgColor
            }
        }
    }
}


extension ViewController {
    // MARK: - 状态栏高度
    func statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
}

