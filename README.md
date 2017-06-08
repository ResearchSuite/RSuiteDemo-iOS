# RSuiteDemo-iOS
This demo app provides a small overview of some of the ResearchSuite libraries. It also is a great place to start development on new Measures.

Integration with Ohmage-OMH is supported out of the box!

Requirements:
 - [Xode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12)
 - [Cocoapods](https://cocoapods.org)

To get started, open a terminal and navigate to where you would like to put the repo.

Then, clone the repository.

```
git clone https://github.com/ResearchSuite/RSuiteDemo-iOS
```

Then, install the cocoapods in the project directory

```
cd RSuiteDemo-iOS
pod install
```

In order to build the app, you'll need to create a OMHClient.plist file that contains your Ohmage-OMH client information. OMHClient.sample.plist is provided as a starting point. Copy OMHClient.sample.plist in the same directory and name it OMHClient.plist.

```
cp RSuiteDemo/OMHClient.sample.plist RSuiteDemo/OMHClient.plist
```

Open the workspace

```
open RSuiteDemo.xcworkspace/
```

Build and Run!
