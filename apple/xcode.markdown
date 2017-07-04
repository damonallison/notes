## xcodebuild ##

### Diagnostic Information ###

List all SDKs:
> xcodebuild -showsdks

List all schemes in a workspace
> xcodebuild -list [-workspace Workspace.xcworkspace]

List all targets and configurations in a scheme
> xcodebuild -list -scheme scheme

  > xcodebuild -showBuildSettings [-workspace name -scheme name]
