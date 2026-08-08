#!/usr/bin/env bash
set -e

BRANCH="ipa-steucguromg-xcode-template"
REMOTE="origin"

# Ensure repo is up to date
git fetch "$REMOTE"

# Try to check out the remote branch if it exists; otherwise create it locally
if git show-ref --verify --quiet "refs/remotes/${REMOTE}/${BRANCH}"; then
  git checkout -B "$BRANCH" "${REMOTE}/${BRANCH}"
else
  git checkout -B "$BRANCH"
fi

# Create directories
mkdir -p ios-template/ESignJrTemplate/Sources/ESignJrTemplate
mkdir -p Fastlane
mkdir -p .github/workflows
mkdir -p ios-template/build

# Write ios-template/project.yml
cat > ios-template/project.yml <<'EOF'
name: ESignJrTemplate
options:
  bundleIdPrefix: com.example
configs: {}
targets:
  ESignJrTemplate:
    type: application
    platform: iOS
    deploymentTarget: "14.0"
    sources: [ESignJrTemplate]
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.example.ESignJrTemplate
EOF

# Write App.swift
cat > ios-template/ESignJrTemplate/Sources/ESignJrTemplate/App.swift <<'EOF'
import SwiftUI

@main
struct ESignJrTemplateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
EOF

# Write ContentView.swift
cat > ios-template/ESignJrTemplate/Sources/ESignJrTemplate/ContentView.swift <<'EOF'
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("ESignJr Template")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
EOF

# Write Info.plist
cat > ios-template/ESignJrTemplate/Info.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>com.example.ESignJrTemplate</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>ESignJrTemplate</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
</dict>
</plist>
EOF

# Fastlane files
cat > Fastlane/Fastfile <<'EOF'
# fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Build and export .ipa (requires signing credentials configured)"
  lane :build do
    UI.message("Generating project with xcodegen (if using it)")
    sh("xcodegen || true")

    UI.message("Building and exporting with gym")
    gym(
      project: "ESignJrTemplate.xcodeproj",
      scheme: "ESignJrTemplate",
      configuration: "Release",
      export_options: {
        provisioningProfiles: {
          "com.example.ESignJrTemplate" => ENV["PROVISIONING_PROFILE_NAME"] || ""
        }
      }
    )
  end
end
EOF

cat > Fastlane/Appfile <<'EOF'
app_identifier("com.example.ESignJrTemplate") # Replace with your bundle id
apple_id("you@example.com") # Your Apple ID

# team_id "YOUR_TEAM_ID" # optional
EOF

# GitHub Actions workflow
cat > .github/workflows/ios-build.yml <<'EOF'
name: iOS build
on:
  workflow_dispatch:
  push:
    branches:
      - ipa-steucguromg-xcode-template

jobs:
  build:
    name: Build iOS app and export .ipa
    runs-on: macos-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Install xcodegen
        run: |
          brew install xcodegen || true

      - name: Generate Xcode project
        run: |
          cd ios-template || true
          xcodegen || true

      - name:
