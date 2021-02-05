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
    
    var currentContributionWindows: [ContributionWindow] = []
    
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
        self.windowListView.delegate = self
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
            self.view.window?.close()
            return
        }
    }
    
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
        
        print(selectedRowIndex)
    }
    
    // ウィンドウ追加・削除ボタン
    @IBAction func onClickWindowsOperate(_ sender: NSSegmentedControl) {
        let selectedSegment = sender.selectedSegment
        if(selectedSegment == 0){
            
            // ウィンドウを構成
            let contributionViewStoryboard = NSStoryboard(name: "Contribution", bundle: nil)
            
            // VCを呼び出して
            guard let contributionViewController = contributionViewStoryboard.instantiateInitialController() as? ContributionViewController else{
                fatalError("Couldn't generate virewController instance!")
            }
            
            // コンフィグ渡して
//            contributionViewController.config = config
            
            // NSWindow作って表示
            let window = ContributionWindow(contentViewController: contributionViewController)
            let windowController = NSWindowController(window: window)
            windowController.showWindow(self)
            
        }else if (selectedSegment == 1){
            
            // 選択されたウィンドウを取得して
            let selectedRow = windowListView.selectedRow
            if(selectedRow >= 0){
                // 閉じる
                let selectedWindow = self.currentContributionWindows[selectedRow]
                selectedWindow.close()
            }
        }
        
        updateWindowListView()
    }
    
    // ウィンドウリストビューを更新
    func updateWindowListView(){
        currentContributionWindows = self.application.windows.filter({return $0.isKind(of: ContributionWindow.self) && $0.isVisible}) as! [ContributionWindow]
        windowListView.reloadData()
    }
    
    // 変更をUDに反映
    func updateAllStoredData(){
        userdefaults.setValue(currentUserName, forKey: .UserName)
        userdefaults.setValue(currentUIEnabled, forKey: .UIEnabled)
        userdefaults.setValue(currentUserLastFetchDate, forKey: .LastFetched)
    }
    
    deinit {
        updateAllStoredData()
    }
}
