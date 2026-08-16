//
//  AddLocationView.swift
//  Places
//

import SwiftUI

struct AddLocationView: View {
    @Bindable var viewModel: AddLocationViewModel
    @Binding var isPresented: Bool
    @FocusState private var focusedField: Field?

    private enum Field {
        case name, latitude, longitude
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.props.sheetTitle)
                    .font(.title3)
                    .fontDesign(.serif)
                    .fontWeight(.semibold)
                    .foregroundStyle(DSColor.text)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                CircularIconButton(systemImage: "xmark", accessibilityLabel: viewModel.props.closeAccessibilityLabel) {
                    isPresented = false
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)

            Divider().overlay(DSColor.divider)

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    DSTextField(label: viewModel.props.nameFieldLabel, placeholder: viewModel.props.nameFieldPlaceholder, text: $viewModel.props.name)
                        .focused($focusedField, equals: .name)

                    HStack(spacing: 12) {
                        DSTextField(label: viewModel.props.latitudeFieldLabel, placeholder: viewModel.props.latitudeFieldPlaceholder, text: $viewModel.props.latitudeText, keyboardType: .numbersAndPunctuation)
                            .focused($focusedField, equals: .latitude)
                        DSTextField(label: viewModel.props.longitudeFieldLabel, placeholder: viewModel.props.longitudeFieldPlaceholder, text: $viewModel.props.longitudeText, keyboardType: .numbersAndPunctuation)
                            .focused($focusedField, equals: .longitude)
                    }

                    if let validationError = viewModel.props.validationErrorMessage {
                        Text(validationError)
                            .font(.caption)
                            .foregroundStyle(DSColor.accent700)
                            .accessibilityLabel(viewModel.props.validationErrorAccessibilityLabel ?? validationError)
                    }

                    Button(viewModel.props.submitButtonTitle) {
                        focusedField = nil
                        viewModel.performAction(.submit)
                    }
                    .buttonStyle(.dsPrimaryBlock)
                }
                .padding(20)
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    AddLocationView(viewModel: AddLocationViewModel(), isPresented: .constant(true))
}
