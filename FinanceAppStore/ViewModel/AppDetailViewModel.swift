//
//  AppDetailViewModel.swift
//  FinanceAppStore
//
//  Created by sally on 2017. 4. 13..
//  Copyright © 2017년 sally. All rights reserved.
//

import Foundation

class AppDetailViewModel {
    
    var model: AppDetailModel
    var delegate: AppDetailViewModelDelegate?
    var appId: String?
    private var appDetail: AppDetailVO?
    
    var name: String? = nil
    var icon: URL? = nil
    var rating: Float? = nil
    var screenShot: [URL]? = nil
    var description: String? = nil
    
    init(appId: String) {
        self.appId = appId
        self.model = AppDetailModel(appId: appId)
        self.appDetail = model.appDetail
        
        subscribeToNotifications()
        model.load()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appListDidChangeNotification(_:)),
                                               name: NSNotification.Name(rawValue: Notifications.AppDetailDidChange),
                                               object: model)
    }
    
    fileprivate func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func appListDidChangeNotification(_ notification: NSNotification){
        guard let appDetail = model.appDetail else { return }
        
        self.appDetail = appDetail
        self.name = appDetail.name
        self.icon = URL(string: appDetail.iconUrl)
        self.rating = appDetail.rating
        self.description = appDetail.description
        self.screenShot = [URL]()
        for urlItem in appDetail.screenShotUrl {
            self.screenShot?.append(URL(string: urlItem)!)
        }
        
        delegate?.reloadView()
    }
    
}
