import Foundation
import SwiftUI
import WebKit

struct CherookWebLoadState: Equatable {
    enum CherookStateType: Int {
        case idle = 0
        case progress
        case success
        case error
        case offline
    }
    let type: CherookStateType
    let percent: Double?
    let error: Error?
    
    static func idle() -> CherookWebLoadState {
        CherookWebLoadState(type: .idle, percent: nil, error: nil)
    }
    static func progress(_ percent: Double) -> CherookWebLoadState {
        CherookWebLoadState(type: .progress, percent: percent, error: nil)
    }
    static func success() -> CherookWebLoadState {
        CherookWebLoadState(type: .success, percent: nil, error: nil)
    }
    static func error(_ err: Error) -> CherookWebLoadState {
        CherookWebLoadState(type: .error, percent: nil, error: err)
    }
    static func offline() -> CherookWebLoadState {
        CherookWebLoadState(type: .offline, percent: nil, error: nil)
    }
    
    static func == (lhs: CherookWebLoadState, rhs: CherookWebLoadState) -> Bool {
        if lhs.type != rhs.type { return false }
        switch lhs.type {
        case .progress:
            return lhs.percent == rhs.percent
        case .error:
            return true // Не сравниваем ошибки по содержимому
        default:
            return true
        }
    }
}

