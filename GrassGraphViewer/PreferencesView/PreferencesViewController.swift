//
//  PreferencesViewController.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/03.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    private let userdefaults = UserDefaults.standard
    private let application = NSApplication.shared
    
    private let windowManager = WindowManager()
    var currentContributionWindows: [ContributionWindow] = []
    private var currentSelectedConfigutration: ContributionViewConfiguration? = nil
    
    // configベースで編集した方が良さそう
    private var currentUserName: String?
    private var currentUIEnabled: Bool?
    private var currentUserLastFetchDate: Date?
    
    var isVisible: Bool = false
    
    @IBOutlet weak var UIEnabledCheckbox: NSButton!
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var fetchStatLabel: NSTextField!
    @IBOutlet weak var loadCircle: NSProgressIndicator!
    @IBOutlet weak var applyButton: NSButton!
    @IBOutlet weak var windowListView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NSUserdefaultsから値を取得
        self.currentUserName = userdefaults.string(forKey: .UserName)
        self.currentUIEnabled = userdefaults.bool(forKey: .UIEnabled)
        self.currentUserLastFetchDate = userdefaults.date(forKey: .LastFetched)
        
        // windowListView初期化
        self.windowListView.dataSource = self
    }
    
    override func viewWillAppear() {
        // UIに反映
        usernameField.stringValue = self.currentUserName ?? ""
        UIEnabledCheckbox.intValue = (self.currentUIEnabled ?? false) ? 1 : 0
        let formatter = DateFormatter()
        formatter.dateFormat = "y/M/d hh:mm:ss"
        formatter.timeZone = .autoupdatingCurrent
        fetchStatLabel.stringValue = "Last Fetched: \(formatter.string(from: currentUserLastFetchDate ?? Date()))"
        loadCircle.isHidden = true
        
        // 現在開いているContributionウィンドウを表示
        updateWindowListView()
    }
    
    override func viewDidAppear() {
        // 表示フラグが立っていなければ表示しない
        // (Rootviewcontrollerとして起動したときに隠すため)
        // TODO: isVisibleをPreferencesで変えられるように
        if(!isVisible){
            self.view.window?.animationBehavior = .none
            self.view.window?.orderOut(self)
            return
        }
    }
    
    override func viewWillDisappear() {
        if(isVisible){
            updateAllStoredData()
        }
    }
    
    // ウィンドウリストビューを更新
    func updateWindowListView(){
        currentContributionWindows = windowManager.getActiveContributionWindows()
        windowListView.reloadData()
    }
    
    // 変更をUDに反映
    func updateAllStoredData(){
        userdefaults.setValue(currentUserName, forKey: .UserName)
        userdefaults.setValue(currentUIEnabled, forKey: .UIEnabled)
        userdefaults.setValue(currentUserLastFetchDate, forKey: .LastFetched)
        windowManager.updateStoredConfiguration()
    }
}

// UIアクション
extension PreferencesViewController {
    // ユーザ名フィールドに入力があったとき
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
    
    // UIEnabledがクリックされたとき
    @IBAction func onCheckUIEnabled(_ sender: NSButton) {
        let checkStat = Bool(exactly: NSNumber(value: sender.intValue))!
        currentUIEnabled = checkStat
        
        // NotificationCenterから通知をぶち投げる
        NotificationCenter.default.post(name: .kUserInteractionEnabledNotification, object: currentUIEnabled)
        
        // UDに反映
        userdefaults.setValue(currentUIEnabled, forKey: .UIEnabled)
    }
    
    // 「変更を確定」ボタン
    @IBAction func onTapApplyChanges(_ sender: Any) {
        updateAllStoredData()
    }
    
    // ウィンドウリストの項目が選択されたとき
    @IBAction func didSelectRowAt(_ sender: NSTableView){
        let selectedRowIndex = sender.selectedRow
        guard selectedRowIndex != -1 else {return}
        
        // 選択された項目のウィンドウのconfigを設定し
        guard let selectedContributionViewController = self.currentContributionWindows[selectedRowIndex].contentViewController as? ContributionViewController else {return}
        currentSelectedConfigutration = selectedContributionViewController.config
        print("Selected Items Config: \(currentSelectedConfigutration)")
        
        // TODO: 右ペインの内容を更新
        
    }
    
    // ウィンドウ追加・削除ボタン
    @IBAction func onClickWindowsOperate(_ sender: NSSegmentedControl) {
        let selectedSegment = sender.selectedSegment
        
        switch selectedSegment {
        
        // ウィンドウ追加
        case 0:
            let newConfig = ContributionViewConfiguration(title: "", userName: "", lastFetchDate: Date(), presentOnLaunch: true)
            let newWindow = windowManager.generateContributionWindow(config: newConfig)
            let windowController = NSWindowController(window: newWindow)
            windowController.showWindow(self)

        // ウィンドウ削除
        case 1:
            let selectedRow = windowListView.selectedRow
            if selectedRow >= 0{
                self.currentContributionWindows[selectedRow].close()
            }
            
        default:
            fatalError("Invalid segment selected!")
        }
        
        updateWindowListView()
    }

}

// ウィンドウリストのdatasource
extension PreferencesViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.currentContributionWindows.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let config = (self.currentContributionWindows[row].contentViewController as? ContributionViewController)?.config, config.title != "" else {return "Untitled"}
        return config.title
    }
}

