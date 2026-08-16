//
//  PlacesListView.swift
//  Places
//

import SwiftUI

struct PlacesListView: View {
    @State private var viewModel: PlacesListViewModel
    @State private var addLocationViewModel: AddLocationViewModel
    @State private var isAddSheetPresented = false

    init(dependencies: AppDependencies) {
        _viewModel = State(initialValue: dependencies.makePlacesListViewModel())
        _addLocationViewModel = State(initialValue: dependencies.makeAddLocationViewModel())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            ZStack(alignment: .bottomTrailing) {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

                CircularIconButton(systemImage: "plus", accessibilityLabel: viewModel.props.addLocationAccessibilityLabel, diameter: 52) {
                    addLocationViewModel.performAction(.reset)
                    isAddSheetPresented = true
                }
                .shadow(color: DSColor.shadowLarge, radius: DSShadow.lgRadius / 2, y: DSShadow.lgY / 2)
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
        }
        .background(DSColor.background.ignoresSafeArea())
        .task { await viewModel.performAction(.onAppear) }
        .alert(viewModel.props.wikipediaAppMissingAlertTitle, isPresented: $viewModel.props.isWikipediaAppMissingAlertPresented) {
            Button(viewModel.props.alertOKButtonTitle, role: .cancel) {}
        }
        .sheet(isPresented: $isAddSheetPresented) {
            AddLocationView(viewModel: addLocationViewModel, isPresented: $isAddSheetPresented)
        }
        .onChange(of: addLocationViewModel.props.submittedEntry) { _, entry in
            guard let entry else { return }
            Task { await viewModel.performAction(.addLocation(name: entry.name, latitude: entry.latitude, longitude: entry.longitude)) }
            isAddSheetPresented = false
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(viewModel.props.title)
                .font(.largeTitle)
                .fontDesign(.serif)
                .fontWeight(.semibold)
                .foregroundStyle(DSColor.text)
                .accessibilityAddTraits(.isHeader)

            Text(viewModel.props.subtitle)
                .font(.footnote)
                .foregroundStyle(DSColor.textSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 2)
        .padding(.bottom, 14)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.props.loadState {
        case .loading:
            ScrollView {
                LoadingSkeletonList(accessibilityLabel: viewModel.props.loadingAccessibilityLabel, rowCount: 5)
                    .padding(.horizontal, 20)
            }

        case .error(let message):
            ErrorStateView(
                title: viewModel.props.errorStateTitle,
                message: message,
                retryTitle: viewModel.props.retryButtonTitle,
                onRetry: { Task { await viewModel.performAction(.retry) } }
            )

        case .empty:
            EmptyStateView(title: viewModel.props.emptyStateTitle, message: viewModel.props.emptyStateMessage)

        case .loaded(let rows):
            List(rows) { row in
                Button {
                    Task { await viewModel.performAction(.selectLocation(row.location)) }
                } label: {
                    PlaceRow(name: row.displayName, coordinatesText: row.coordinatesText, accessibilityHint: viewModel.props.placeRowAccessibilityHint)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .listRowBackground(DSColor.background)
                .listRowSeparatorTint(DSColor.divider)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .contentMargins(.bottom, 110, for: .scrollContent)
        }
    }
}

#Preview {
    PlacesListView(dependencies: AppDependencies())
}
