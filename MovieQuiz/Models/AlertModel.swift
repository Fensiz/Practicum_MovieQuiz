//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Симонов Иван Дмитриевич on 26.11.2024.
//
import UIKit

struct AlertModel {
	let title: String
	let message: String
	let buttonText: String
	let action: ((UIAlertAction) -> Void)?

	init(_ result: QuizResultsViewModel, _ action: ((UIAlertAction) -> Void)? = nil) {
		title = result.title
		message = result.text
		buttonText = result.buttonText
		self.action = action
	}

	init(title: String, message: String, buttonText: String, action: ((UIAlertAction) -> Void)? = nil) {
		self.title = title
		self.message = message
		self.buttonText = buttonText
		self.action = action
	}
}
