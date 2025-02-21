//
//  Database.swift
//  Harmony
//
//  Created by Ibrahim Kteish on 21/2/25.
//

import Foundation
import GRDB
import IssueReporting

// MARK: - Database Setup & Migrations
extension DatabaseWriter where Self == DatabaseQueue {
    public static var appDatabase: DatabaseQueue {
        let databaseQueue: DatabaseQueue
        var configuration = Configuration()
        configuration.prepareDatabase { db in
            db.trace(options: .profile) {
#if DEBUG
                print($0.expandedDescription)
#else
                print($0)
#endif
            }
        }
        
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil && !isTesting {
            let path = URL.documentsDirectory.appending(component: "db.sqlite").path()
            print("open", path)
            databaseQueue = try! DatabaseQueue(path: path, configuration: configuration)
        } else {
            databaseQueue = try! DatabaseQueue(configuration: configuration)
        }
        
        var migrator = DatabaseMigrator()

      migrator.registerMigration("create \(FavoriteTrack.databaseTableName)") { db in
        try db.create(table: FavoriteTrack.databaseTableName) { t in
          t.column("id", .integer).primaryKey()
          t.column("img", .text)
          t.column("url", .text)
          t.column("trackName", .text)
          t.column("artistName", .text)
          t.column("collectionName", .text)
          t.column("infoURL", .text)
        }
      }

        do {
#if DEBUG
            migrator.eraseDatabaseOnSchemaChange = true
#endif
            
            try migrator.migrate(databaseQueue)
        } catch {
            reportIssue(error)
        }
        return databaseQueue
    }
}
