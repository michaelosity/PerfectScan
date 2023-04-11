//
//  AppError.swift
//  PerfectScan
//
//  Created by Michael Wells on 4/10/23.
//

public struct AppError {
    
    var title: String = ""
    var message: String = ""
    var primaryButtonTitle = "Accept"
    var secondaryButtonTitle: String?
    var primaryAction: (() -> ())?
    var secondaryAction: (() -> ())?
    
    init(
        title: String = "",
        message: String = "",
        primaryButtonTitle: String = "Accept",
        secondaryButtonTitle: String? = nil,
        primaryAction: (() -> ())? = nil,
        secondaryAction: (() -> ())? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryAction = secondaryAction
    }
    
}
