//
//  ViewController.swift
//  Chpater06-SQLite3
//
//  Created by 박힘찬 on 2022/02/16.
//

import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        let dbPath = self.getDBPath()
        self.dbExecute(dbPath: dbPath)
    }
    func getDBPath() -> String {
        // 앱 내 문서 디렉터리 경로에서 SQLite DB 파일을 찾는다.
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        // dbPath 경로에 db.sqlite 파일이 없다면 앱 번에 만들어 둔 db.sqlite를 가져와 복사한다.
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        return dbPath
    }
    func dbExecute(dbPath: String) {
        var db: OpaquePointer? = nil // SQLite 연결 정보를 담을 변수
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            print("Database Connect Fail")
            return
        }
        // 데이터베이스 연결 종료
        defer {
            print("Close Database Connection")
            sqlite3_close(db)
        }
        
        var stmt: OpaquePointer? = nil // 컴파일된 SQL 정보를 담을 변수
        let sql = "CREATE TABLE IF NOT EXISTS seqeunce (num INTEGER)"
        guard sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK  else {
            print("Prepare Statement Fail")
            return
        }
        // stmt 변수 해제
        defer {
            print("Finalize Statemnet")
            sqlite3_finalize(stmt)
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Create Table Success!")
            print("dir = \(dbPath)") // 파일 경로 확인
        }
    }
}
