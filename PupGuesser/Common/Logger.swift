//
//  Logger.swift
//  PupGuesser
//
//  Created by See Soon Kiat on 1/6/25.
//

import OSLog

class ErrorLogger {
    static func logError(error: Error, category: String? = nil) {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "unknown", category: category ?? "generic")
        logger.error("Error occured: \(error, privacy: .public)")
    }
}
