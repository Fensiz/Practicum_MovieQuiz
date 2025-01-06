//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 26.11.2024.
//

import UIKit

final class AlertPresenter : AlertPresenterProtocol {
	private weak var controller: UIViewController?

	init(controller: UIViewController) {
		self.controller = controller
	}

	func present(alert: AlertModel) {
		let alertController = UIAlertController(
			title: alert.title,
			message: alert.message,
			preferredStyle: .alert)

		let action = UIAlertAction(title: alert.buttonText, style: .default, handler: alert.action)

		alertController.addAction(action)

		DispatchQueue.main.async { [weak controller] in
			guard let controller else { return }
			controller.present(alertController, animated: true, completion: nil)
		}
	}
}
