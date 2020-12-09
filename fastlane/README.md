fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios setup_keychain
```
fastlane ios setup_keychain
```

### ios add_device
```
fastlane ios add_device
```
Lane to add a new device to provisioning profiles
If you want to add a new device run:

```
fastlane add_device
```

After the new device was added you can refresh your provisioning profile by running:
```
fastlane renew_profile
```
  
### ios refresh_appstore_profiles
```
fastlane ios refresh_appstore_profiles
```

### ios refresh_development_profiles
```
fastlane ios refresh_development_profiles
```

### ios refresh_all_profiles
```
fastlane ios refresh_all_profiles
```

### ios test
```
fastlane ios test
```
Test
### ios deploy
```
fastlane ios deploy
```
Builds an appstore version of the application and distributes to AppStore Connect

----

## Android
### android deploy
```
fastlane android deploy
```
Builds and signs a production release to distribute in Google Play Store

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
