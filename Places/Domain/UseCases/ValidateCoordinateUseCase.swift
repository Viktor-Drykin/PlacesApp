//
//  ValidateCoordinateUseCase.swift
//  Places
//

import Foundation

/// Kept text-free — display copy lives in the presentation layer's
/// localization providers.
enum CoordinateValidationError: Error, Equatable {
    case invalidLatitude
    case invalidLongitude
}

/// Pure validation logic for user-entered coordinates, kept free of any UI
/// framework so it can be unit tested in isolation.
enum ValidateCoordinateUseCase {
    static func validateLatitude(_ text: String) -> Result<Double, CoordinateValidationError> {
        guard let value = Double(text.trimmingCharacters(in: .whitespaces)), value >= -90, value <= 90 else {
            return .failure(.invalidLatitude)
        }
        return .success(value)
    }

    static func validateLongitude(_ text: String) -> Result<Double, CoordinateValidationError> {
        guard let value = Double(text.trimmingCharacters(in: .whitespaces)), value >= -180, value <= 180 else {
            return .failure(.invalidLongitude)
        }
        return .success(value)
    }
}
