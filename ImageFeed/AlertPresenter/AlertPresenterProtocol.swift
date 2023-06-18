//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 18.06.2023.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showError(error model: AlertModel)
}
