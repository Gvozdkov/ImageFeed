import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    static var isShowing: Bool = false
    
    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return nil
        }
        return window
    }

    static func show() {
        ProgressHUD.colorProgress = .black
        ProgressHUD.colorHUD = .white
        isShowing = true
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    static func dismiss() {
        ProgressHUD.colorProgress = .black
        ProgressHUD.colorHUD = .white
        isShowing = false
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
