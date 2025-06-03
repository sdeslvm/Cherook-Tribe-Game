import WebKit
import Foundation

class CherookWebViewCoordinator: NSObject, WKNavigationDelegate {
    private let stateHandler: (CherookWebLoadState) -> Void
    private var didNavigate = false

    init(stateHandler: @escaping (CherookWebLoadState) -> Void) {
        self.stateHandler = stateHandler
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        handleStartNavigation()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        didNavigate = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stateHandler(CherookWebLoadState.success())
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        stateHandler(CherookWebLoadState.error(error))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        stateHandler(CherookWebLoadState.error(error))
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        handlePolicy(for: navigationAction, webView: webView)
        decisionHandler(.allow)
    }

    private func handleStartNavigation() {
        if !didNavigate {
            stateHandler(CherookWebLoadState.progress(0.0))
        }
    }

    private func handlePolicy(for action: WKNavigationAction, webView: WKWebView) {
        if action.navigationType == .other && webView.url != nil {
            didNavigate = true
        }
    }
}
