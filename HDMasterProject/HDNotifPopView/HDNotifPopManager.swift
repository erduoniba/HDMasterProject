//
//  HDNotifPopView.swift
//  HDMasterProject
//
//  Created by 邓立兵 on 2021/2/23.
//  Copyright © 2021 HarryDeng. All rights reserved.
//

import UIKit

@objc class HDNotifPopManager: NSObject {
    static private let screenWidth = UIScreen.main.bounds.width
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    static private let popViewHeight: CGFloat = statusBarHeight + 100
    
    @objc static let shared = HDNotifPopManager()
    private var notif: HDNotifObj = HDNotifObj()
    private var dismissTimer: Timer?
    
    typealias HDNotifPopHandler = () -> Void
    private var tabHandler: HDNotifPopHandler?
    
    lazy var backgroundWindow: UIWindow? = {
        var window = UIApplication.shared.keyWindow
        if window == nil, let dWindow = (UIApplication.shared.delegate?.window) {
            window = dWindow
        }
        return window
    }()
    
    lazy private var notifPopView: HDNotifPopView = {
        let view = HDNotifPopView(frame: CGRect(x: 0, y: -HDNotifPopManager.popViewHeight, width: HDNotifPopManager.screenWidth, height: HDNotifPopManager.popViewHeight))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(onPanGuestureRecognized(pan:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapGestureRecognized(pan:)))
        view.addGestureRecognizer(pan)
        view.addGestureRecognizer(tap)
        return view
    }()
    
    @objc static func showNotifPopView(notif: HDNotifObj, tapHandler: @escaping HDNotifPopHandler) {
        HDNotifPopManager.shared.showNotifPopView(notif: notif)
        HDNotifPopManager.shared.tabHandler = tapHandler
    }
    
    private func showNotifPopView(notif: HDNotifObj) {
        self.notif = notif
        notifPopView.frame = CGRect(x: 0, y: -HDNotifPopManager.popViewHeight, width: HDNotifPopManager.screenWidth, height: HDNotifPopManager.popViewHeight)
        backgroundWindow?.addSubview(notifPopView)
        notifPopView.drawNotifPopView(notif: notif)
        startDismissTimer()
        showNotifPopViewAnimate()
    }
    
    private func showNotifPopViewAnimate() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            self?.notifPopView.frame = CGRect(x: 0, y: 0, width: HDNotifPopManager.screenWidth, height: HDNotifPopManager.popViewHeight)
        } completion: { _ in
            
        }
    }
    
    private func hideNotifPopViewAnimate() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            self?.notifPopView.frame = CGRect(x: 0, y: -HDNotifPopManager.popViewHeight, width: HDNotifPopManager.screenWidth, height: HDNotifPopManager.popViewHeight)
        } completion: { [weak self] (_) in
            self?.notifPopView.removeFromSuperview()
        }
    }
}

extension HDNotifPopManager {
    private func startDismissTimer() {
        debugPrint("startDismissTimer")
        stopDismissTimer()
        dismissTimer = Timer.scheduledTimer(timeInterval: notif.timeInterval, target: self, selector: #selector(dismissNotifView), userInfo: nil, repeats: false)
    }
    
    private func stopDismissTimer() {
        if dismissTimer != nil {
            dismissTimer?.invalidate()
            dismissTimer = nil
        }
    }
    
    @objc private func dismissNotifView() {
        debugPrint("dismissNotifView")
        notifPopView.layer.removeAllAnimations()
        
        hideNotifPopViewAnimate()
    }
}

extension HDNotifPopManager {
    @objc func onPanGuestureRecognized(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self.backgroundWindow)
        switch pan.state {
        case .began:
            fallthrough
        case .changed:
            stopDismissTimer()
            if translation.y < 0 {
                notifPopView.frame = CGRect(x: 0, y: translation.y, width: notifPopView.frame.size.width, height: notifPopView.frame.size.height)
            }
        case .ended:
            // 往上移动超过1/3放手后需要消失
            if translation.y < -notifPopView.frame.size.height/3 {
                stopDismissTimer()
                hideNotifPopViewAnimate()
            }
            else {
                startDismissTimer()
                showNotifPopViewAnimate()
            }
        default: break
        }
    }
    
    @objc func onTapGestureRecognized(pan: UIPanGestureRecognizer) {
        if let tabHandler = tabHandler {
            tabHandler()
        }
        stopDismissTimer()
        hideNotifPopViewAnimate()
    }
}


@objc class HDNotifObj: NSObject {
    @objc var title: String?
    @objc var text: String?
    @objc var img: String?
    
    @objc var timeInterval: TimeInterval = 2.0
}

class HDNotifPopView: UIView {
    private var notif: HDNotifObj?
    
    private var tipLabel: UILabel!
    private var timeLabel: UILabel!
    private var titleLabel: UILabel!
    private var textLabel: UILabel!
    private var imageView: UIImageView!

    func initNotifPopView() {
        let infoPlist = Bundle.main.infoDictionary
        guard let cFBundleIcons = infoPlist?["CFBundleIcons"] as? [String: Any] else { return }
        guard let cFBundlePrimaryIcon = cFBundleIcons["CFBundlePrimaryIcon"] as? [String: Any] else { return }
        guard let cFBundleIconFiles = cFBundlePrimaryIcon["CFBundleIconFiles"] as? [String]  else { return }
        let logoImageView = UIImageView(frame: CGRect(x: 10, y: HDNotifPopManager.statusBarHeight - 6, width: 20, height: 20))
        logoImageView.image = UIImage(named: cFBundleIconFiles.last ?? "")
        addSubview(logoImageView)
        
        tipLabel = UILabel(frame: CGRect(x: 40, y: HDNotifPopManager.statusBarHeight - 2, width: 100, height: 16))
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.text = "消息通知"
        tipLabel.textColor = .gray
        addSubview(tipLabel)
        
        let swidth = UIScreen.main.bounds.width
        timeLabel = UILabel(frame: CGRect(x: swidth - 115, y: tipLabel.frame.origin.y, width: 100, height: 16))
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.text = "现在"
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .right
        addSubview(timeLabel)
        
        let notifContentView = UIView(frame: CGRect(x: 0, y: HDNotifPopManager.statusBarHeight + 20, width: swidth, height: 80))
        notifContentView.backgroundColor = UIColor(white: 0, alpha: 0.05)
        addSubview(notifContentView)
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: swidth - 90, height: 16))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .black
        notifContentView.addSubview(titleLabel)
        
        textLabel = UILabel(frame: CGRect(x: 10, y: 26, width: swidth - 110, height: 50))
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textColor = .black
        textLabel.numberOfLines = 0
        notifContentView.addSubview(textLabel)
        
        imageView = UIImageView(frame: CGRect(x: swidth - 90, y: 10, width: 80, height: 60))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: cFBundleIconFiles.last ?? "")
        notifContentView.addSubview(imageView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        initNotifPopView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawNotifPopView(notif: HDNotifObj) {
        self.notif = notif
        titleLabel.text = notif.title ?? "消息标题"
        textLabel.text = notif.text ?? ""
    }
}
