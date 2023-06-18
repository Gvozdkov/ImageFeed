//
//  AlertPresenterDelegate.swift
//  ImageFeed
//
//  Created by Алексей Гвоздков on 18.06.2023.
//

import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func didShowAlert(quiz model: AlertModel?)
}
