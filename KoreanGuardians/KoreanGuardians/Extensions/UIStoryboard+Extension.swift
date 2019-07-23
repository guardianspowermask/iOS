//
//  UIStoryboard+Extension.swift
//  KoreanGuardians
//
//  Created by 강수진 on 23/07/2019.
//  Copyright © 2019 강수진. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func viewController<T>(_ type: T.Type) -> T where T: NibLoadable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.nibId) as? T else {
            fatalError("Could not find viewController \(T.nibId)")
        }
        return viewController
    }
}
