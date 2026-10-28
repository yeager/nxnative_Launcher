import SwiftUI

public struct SystemView: View {
    @ObservedObject public var viewModel: AppViewModel
    
    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                // Header & Action Bar
                headerView
                
                VStack(spacing: 12) {
                    SystemKeysCard(viewModel: viewModel)
                    SystemToolsCard(viewModel: viewModel)
                }
                
                VStack(spacing: 12) {
                    SystemRepoCard(viewModel: viewModel)
                    SystemPatchesCard(viewModel: viewModel)
                }
                
                SystemDirectoriesCard(viewModel: viewModel)
                SystemStorageAndDiagnosticsCard(viewModel: viewModel)
            }
            .padding(20)
        }
        .sheet(isPresented: $viewModel.showInstallerSheet) {
            InstallerSheetView(viewModel: viewModel)
        }
        .alert(L10n.string("Apple Command Line Tools"), isPresented: $viewModel.showCltInstallAlert) {
            Button(L10n.string("OK"), role: .cancel) {}
        } message: {
            L10nText("Apple's official installer dialog has opened on screen. Follow Apple's prompt to complete the installation. Once finished, click 'Re-check' to verify.")
        }
        .confirmationDialog(
            L10n.format("Uninstall %@?", viewModel.dependencyToUninstall?.name ?? L10n.string("this tool")),
            isPresented: $viewModel.showUninstallConfirm,
            titleVisibility: .visible
        ) {
            Button(L10n.string("Uninstall Tool"), role: .destructive) {
                viewModel.executeUninstall()
            }
            Button(L10n.string("Cancel"), role: .cancel) {}
        } message: {
            L10nText("This will remove the selected package from your system environment. You can reinstall it at any time.")
        }
    }
    
    private var headerView: some View {
        HStack {
            L10nText("Settings & System Architecture")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(NXTheme.textPrimary)
            
            Spacer()
            
            if !viewModel.prerequisites.missingList.isEmpty {
                Button(action: {
                    SoundEffectService.shared.play(.click)
                    viewModel.installAllMissingDependencies()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.down.circle.fill")
                        Text(verbatim: L10n.string("Install All Missing") + " (" + String(viewModel.prerequisites.missingList.count) + ")")
                    }
                }
                .buttonStyle(NXAccentButtonStyle())
                .help(L10n.string("Install all missing dependencies sequentially one by one until completed."))
            } else {
                Button(action: {
                    SoundEffectService.shared.play(.click)
                    viewModel.repairAllDependencies()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                        L10nText("Repair All")
                    }
                }
                .buttonStyle(NXSecondaryButtonStyle())
            }
            
            Button(action: {
                SoundEffectService.shared.play(.click)
                viewModel.detectEnvironment()
                viewModel.checkForUpdates()
            }) {
                HStack(spacing: 6) {
                    if viewModel.isCheckingPrerequisites || viewModel.isCheckingUpdate {
                        ProgressView().controlSize(.small)
                    } else {
                        Image(systemName: "arrow.clockwise")
                        L10nText("Re-check")
                    }
                }
            }
            .buttonStyle(NXSecondaryButtonStyle())
        }
    }
}
