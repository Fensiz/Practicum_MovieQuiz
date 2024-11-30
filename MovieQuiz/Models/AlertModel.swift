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
	let action: (UIAlertAction) -> Void
	init(_ result: QuizResultsViewModel, _ action: @escaping (UIAlertAction) -> Void) {
		title = result.title
		message = result.text
		buttonText = result.buttonText
		self.action = action
	}
}
