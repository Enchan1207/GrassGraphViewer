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
    private var currentUserLastFetchDate: Date?
    
    var isVisible: Bool = false
    
    @IBOutlet weak var UIEnabledCheckbox: NSButton!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var fetchStatLabel: NSTextField!
    @IBOutlet weak var loadCircle: NSProgressIndicator!
    @IBOutlet weak var applyButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NSUserdefaultsから値を取得
        self.currentUserName = userdefaults.string(forKey: .UserName)
        self.currentUIEnabled = userdefaults.bool(forKey: .UIEnabled)
        self.currentUserLastFetchDate = userdefaults.date(forKey: .LastFetched)
        
        loadCircle.isHidden = true

    }
    
    override func viewWillAppear() {
        // UIに反映
        usernameField.stringValue = self.currentUserName ?? ""
        UIEnabledCheckbox.intValue = (self.currentUIEnabled ?? false) ? 1 : 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y/M/d hh:mm:ss"
        formatter.timeZone = .autoupdatingCurrent
        
        fetchStatLabel.stringValue = "Last Fetched: \(formatter.string(from: currentUserLastFetchDate ?? Date()))"
    }
    
    override func viewDidAppear() {
        // 表示フラグが立っていなければ表示しない(Rootviewcontrollerとして起動したとき用)
        if(!isVisible){
            self.view.window?.orderOut(self)
            return
        }
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
            currentUserLastFetchDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "y/M/d hh:mm:ss"
            formatter.timeZone = .autoupdatingCurrent
            fetchStatLabel.stringValue = "Last Fetched: \(formatter.string(from: currentUserLastFetchDate ?? Date()))"
            
            // NotificationCenterから通知をぶち投げて
            currentUserName = newName
            NotificationCenter.default.post(name: .kUserNameChangedNotification, object: currentUserName)
            
            // UDに反映
            userdefaults.setValue(currentUserName, forKey: .UserName)
            userdefaults.setValue(currentUserLastFetchDate, forKey: .LastFetched)
        }
    }
    
    @IBAction func onCheckUIEnabled(_ sender: NSButton) {
        let checkStat = Bool(exactly: NSNumber(value: sender.intValue))!
        currentUIEnabled = checkStat

        // NotificationCenterから通知をぶち投げる
        NotificationCenter.default.post(name: .kUserInteractionEnabledNotification, object: currentUIEnabled)
        
        // UDに反映
        userdefaults.setValue(currentUIEnabled, forKey: .UIEnabled)
    }
    
    @IBAction func onTapApplyChanges(_ sender: Any) {
        updateAllStoredData()
    }
        
    @IBAction func onClickAddWindow(_ sender: Any) {
        
    }
    
    deinit {
        updateAllStoredData()
    }
    
    // 変更をUDに反映
    func updateAllStoredData(){
        userdefaults.setValue(currentUserName, forKey: .UserName)
        userdefaults.setValue(currentUIEnabled, forKey: .UIEnabled)
        userdefaults.setValue(currentUserLastFetchDate, forKey: .LastFetched)
    }
    
}
