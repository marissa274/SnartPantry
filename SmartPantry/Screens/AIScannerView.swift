import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct AIScannerView: View {
    @StateObject private var viewModel = ScannerViewModel()

    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var goToValidation = false
    @State private var showFileImporter = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.smartCream.ignoresSafeArea()

                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Smart Scanner")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.smartRed)

                        Text("Pick a food package or ingredients image to extract text.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                    }
                    .padding(.top, 20)

                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white)
                        .frame(height: 360)
                        .overlay {
                            Group {
                                if let selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 360)
                                        .clipShape(RoundedRectangle(cornerRadius: 28))
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .font(.system(size: 60))
                                            .foregroundColor(.smartRed)

                                        Text("No image selected yet")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                    }

                    VStack(spacing: 14) {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Text("Choose from Photos")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.smartRed)
                                .cornerRadius(30)
                        }

//                        Button {
//                            showFileImporter = true
//                        } label: {
//                            Text("Choose from Files")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .frame(height: 56)
//                                .background(Color.smartRed)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 30)
//                                        .stroke(Color.smartRed, lineWidth: 1.5)
//                                )
//                                .cornerRadius(30)
//                        }

                        Button {
                            if !viewModel.extractedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                goToValidation = true
                            }
                        } label: {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(viewModel.extractedText.isEmpty ? .smartRed.opacity(0.45) : .white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    viewModel.extractedText.isEmpty ? Color.white : Color.smartRed
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(
                                            viewModel.extractedText.isEmpty ? Color.smartRed.opacity(0.25) : Color.smartRed,
                                            lineWidth: 1.5
                                        )
                                )
                                .cornerRadius(30)
                        }
                        .disabled(viewModel.extractedText.isEmpty)
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
            .navigationTitle("Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $goToValidation) {
                TextValidationView(initialText: viewModel.extractedText)
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }

                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                        await viewModel.extractText(from: image)
                    }
                }
            }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.image],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }

                    let didStartAccessing = url.startAccessingSecurityScopedResource()
                    defer {
                        if didStartAccessing {
                            url.stopAccessingSecurityScopedResource()
                        }
                    }

                    do {
                        let data = try Data(contentsOf: url)
                        if let image = UIImage(data: data) {
                            selectedImage = image

                            Task {
                                await viewModel.extractText(from: image)
                            }
                        } else {
                            viewModel.errorMessage = "Impossible de lire cette image."
                        }
                    } catch {
                        viewModel.errorMessage = "Erreur lors de l’importation du fichier."
                    }

                case .failure:
                    viewModel.errorMessage = "Importation annulée ou impossible."
                }
            }
            .overlay {
                if viewModel.isScanning {
                    SmartPantryLoadingView(
                        title: "Scanning image...",
                        subtitle: "SmartPantry is extracting your ingredients"
                    )
                }
            }
        }
    }
}

#Preview {
    AIScannerView()
}
