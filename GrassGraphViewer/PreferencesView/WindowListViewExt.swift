//
//  WindowListViewExt.swift
//  GrassGraphViewer
//
//  Created by EnchantCode on 2021/02/05.
//

import Cocoa

extension PreferencesViewController: NSTableViewDelegate {
}

extension PreferencesViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.currentContributionWindows.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return self.currentContributionWindows.map({return $0.hashValue})[row]
    }
    
}
