//
//  PreferencesViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/03.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    let userdefaults = UserDefaults.standard
    
    private var currentUserName: String?
    private var currentUIEnabled: Bool?
    
    @IBOutlet weak var UIEnabledCheckbox: NSButton!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var fetchStatLabel: NSTextField!
    @IBOutlet weak var loadCircle: NSProgressIndicator!
    @IBOutlet weak var applyButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NSUserdefaultsから値を取得
        // TODO: キーをenumに
        self.currentUserName = userdefaults.string(forKey: "UserName")
        self.currentUIEnabled = userdefaults.bool(forKey: "UIEnabled")
        
        loadCircle.isHidden = true

    }
    
    override func viewWillAppear() {
        // UIに反映
        usernameField.stringValue = self.currentUserName ?? ""
        UIEnabledCheckbox.intValue = (self.currentUIEnabled ?? false) ? 1 : 0
    }
    
    override func viewDidAppear() {
    }
    
    @IBAction func onChangeUsernameField(_ sender: NSTextField) {
        let newName = sender.stringValue
        
        // UDからフェッチしたデータと違うならフェッチテスト
        if currentUserName != newName {
            fetchStatLabel.stringValue = "Fetching..."
            loadCircle.startAnimation(nil)
            loadCircle.isHidden = false
            
            let parser = ContributionXMLParser(userName: newName)
            do {
                // TODO: ここでフェッチするだけじゃなくてできればUint配列で保存したい
                try parser?.fetchContributions(completion: nil)
            } catch {
                fetchStatLabel.stringValue = "Failed! Please check if you typed valid name."
                loadCircle.stopAnimation(nil)
                loadCircle.isHidden = true
                return
            }
            
            // 成功したらラベルをいじって
            loadCircle.stopAnimation(nil)
            loadCircle.isHidden = true
            
            // FetchDateを更新し
            let formatter = DateFormatter()
            formatter.dateFormat = "y/M/d hh:mm:ss"
            fetchStatLabel.stringValue = "Last Fetched: \(formatter.string(from: Date()))"
            
            // NotificationCenterから通知をぶち投げて
            currentUserName = newName
            NotificationCenter.default.post(name: .kUserNameChangedNotification, object: currentUserName)
            
            // UDに反映
            userdefaults.setValue(currentUserName, forKey: "UserName")
        }
    }
    
    @IBAction func onCheckUIEnabled(_ sender: NSButton) {
        let checkStat = Bool(exactly: NSNumber(value: sender.intValue))!
        currentUIEnabled = checkStat

        // NotificationCenterから通知をぶち投げる
        NotificationCenter.default.post(name: .kUserInteractionEnabledNotification, object: currentUIEnabled)
        
        // UDに反映
        userdefaults.setValue(currentUIEnabled, forKey: "UIEnabled")
    }
    
    @IBAction func onTapApplyChanges(_ sender: Any) {
        updateAllStoredData()
    }
    
    deinit {
        updateAllStoredData()
    }
    
    // 変更をUDに反映
    func updateAllStoredData(){
        userdefaults.setValue(currentUserName, forKey: "UserName")
        userdefaults.setValue(currentUIEnabled, forKey: "UIEnabled")
    }
    
}
