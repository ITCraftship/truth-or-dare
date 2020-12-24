# CI/CD for Flutter is a piece of cake with Fastlane and Codemagic

Setting up test automation and CI/CD for mobile apps is something that we commonly have to do for our projects. It's a repeatable task, but for every app that we've been setting this up it took a significant time (even up to 2 days). Based on five years of experience in configuring iOS and Android builds using Fastlane for native and hybrid mobile technologies (Cordova, Capacitor, React Native and Flutter we established a tenplate that we use to jump-start CI/CD setup for new projects.

This tutorial will present a step by step guide on how to setup Codemagic CI with Fastlane and publish the ToD Game to both App Store and Google Play using your own developer accounts.
The steps will allow you to customize your app name, so modifying this for your specific application will hardly be a challenge.

Good luck releasing your apps!

## DISCLAIMERS

### Operating System

Since building apps for iOS relies on having a computer with macOS, we'll assume that this is the environment you have. If you're running on a Linux-based OS many of the steps will look the same. On Windows, however, I recommend that you use the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about) to follow this guide.

### Shell

We are assuming either `zsh` or `bash` for your default shell. If you're using something else (ex. `fish`) you will have to use appropriate syntax for some things - like setting environment variables.

Later whenever we mention that you should set an environment variable, besides of running the `export` command in your current terminal instance, make sure to add this `export` to your shell profile (ex. `.zshrc`, `.bashrc`, `.bash_profile` ).

### Flutter & Xcode version

At the time of writing this app, Flutter was at version `1.22.5` and XCode at `12.3`. Codemagic allows setting those versions in the YAML configuration, so nothing should change for your CI. However, on your local machine you may experience issues building the app if there were significant breaking changes in Flutter or XCode versions.

# Forking the repository

To copy the repository to your account, press the **Fork** button in the top right corner of the repository. After a while it should be visible as one of yours repositories.

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3erm-7eLb1vQUgNvTIECM5WYoMs_r-i4ftvMjI0fYAltqNSKwvbf8Lv1eRAh7nhSybidyU4qBIzvjNYC1ESSnjFay3_XaJjd7QOWLl7IdNQu_goK4sAMRfHYzq15kWRlCPO_S00KAsKGs9QV_IpMKU=w2596-h880-no?authuser=1)

# Preparations

## Clone the fork

First start by cloning the repository into a desired location and

## Install the prerequisites

Before you can build and run the project locally, you'll have to follow the README to install all the required dependencies. I will assume that you already know how to create a new flutter project, but here are some of the steps from our README that will help you make sure you installed everything you need:

### Prerequisites

- [Install Ruby Version Manager](https://rvm.io/) – not required, but recommended (see below for details)
- [Install flutter](https://flutter.dev/docs/get-started/install) and dependencies, including:
  - Xcode
  - Cocoapods (when you chose to use RVM, then make sure to install Cocoapods again for the current ruby environment – i.e. `Ruby 2.4.1`)
- [Install dart](https://dart.dev/)
  - MAC OS (assumes you have [Homebrew](https://brew.sh/))
  ```bash
  brew tap dart-lang/dart
  brew install dart
  ```

#### RVM & Ruby

You'll need a ruby environment. It's recommended to use [RVM](https://rvm.io).

1.  On a Mac you'll need to install GPG first, ex: https://gpgtools.org or better use ``
2.  Then install RVM by running:

```bash
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
curl -sSL https://get.rvm.io | bash -s stable
```

if you're getting a "no route to host" error instead run this:

```
gpg --keyserver hkp://51.38.91.189 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
```

3.  If you just installed RVM, then install Ruby as well:

```
rvm install 2.4.1
```

The ruby version is specificed in `.ruby-version` file.

## Build the project

In order to build the project, first you need to run the command:

    flutter pub get

If you are using Android Studio you can also enter **pubspec.yaml** file and press the **get** button at the top right corner.

Next, use the command

    flutter run

To see if everything is working properly and the app is building.

## Fastlane

To make publishing process easier and faster, we will use Fastlane. It is already included inside of the **Gemfile**, so all you need to do is run:

    bundle install

Now you should be ready to go.

# iOS Setup

## Bundle identifier

First thing you need to do in order to publish your app to App Store is to change the **bundle identifier** to something unique.

To make it quick we will use a **find and replace all** function.

Replace all occurrences of `com.itcraftship.truth-or-dare` with the bundle identifier of your choice.

- For Android Studio You can use `⌘⇧R` on Mac and `Ctrl+Shift+R` on Windows
- For Visual Studio Code You can use `⌘⇧F` on Mac and `Ctrl+Shift+F` on Windows, then you need to click the arrow in the top left corner to enable replacing

It will also replace the value in the tutorial Markdown, but you don't need to worry about it 😉

## Team ID

Next, You need to update the Team ID inside **Appfile**. To access it, go to `https://developer.apple.com/account`, log in to your account and click **Membership** tab. Team ID should be the 3rd row from the top.

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3dQYtIQ62Yxn_uLZ7g0DviK3M07njzmwj5bkGEenymct5on7YdO8i9u5TxSvrYCAWomw4bd3Ihl02jc21NcTEipspUtmtXfrEkhiXUWOJuhsi5Fue1iq_CykIvxkVKph4hsB9xZQna6i6lL0ByKqjk=w2176-h980-no?authuser=1)

Now, go to **Appfile** and replace the **team_id** value with your own.

## Apple ID

You will also need to add your Apple ID to environment variables, to avoid typing it every time Fastlane or Match need it. Apple ID is the email address you use to log in.

    export TOD_APPLE_ID=<your apple id>

## Application specific password

For the CI to be able to upload builds to App Store Connect, you will need to generate an **Application specific password**. [Here](https://docs.fastlane.tools/best-practices/continuous-integration/#application-specific-passwords) is a tutorial on how to do that.

As before, you should add it to environment variables:

    export TOD_APP_SPECIFIC_PASSWORD=<your app specific password for CI/CD>

## Create application with Fastlane

Now we would like to create the app inside App Store Connect. In order to do that, run the following command:

    bundle exec fastlane produce --app_name <application name of your choice> --language <primary language e.g. en-US>

As an example you could call this:

    bundle exec fastlane produce --app_name "Tod Tutorial" --language en-US

after that new iOS application should be visible in App Store Connect with the Bundle ID taken from the Appfile.

When you have the app created, you should go to App Store Connect and get the Apple ID for your app from the App Information:

![Apple ID for the app](images/app_apple_id.png)

You should copy this Apple ID and set it in the Fastfile for the pilot action. See the code below for reference:

    pilot(
      username: APPLE_ID,
      team_id: '120815547',
      skip_submission: true,
      skip_waiting_for_build_processing: true,
      apple_id: "1546377180" # this is where you set it
    )

## Match

We want to use a tool called match which will be responsible for managing application code signing certificates and provisioning profiles. This is an amazing way to keep code signing in sync in your entire team/company. You can read more about this approach in the [Code Signing Guide](https://codesigning.guide/).

Firstly, create a private repository (e.x on GitHub) where certificates will be stored.

Secondly, add the SSH URL of the repository to environment variables:

    export TOD_MATCH_REPO=<repository url>

> NOTE: To use Match on Codemagic later on, you will need SSH access from the build machine, so the best practice is to use SSH locally as well - both for the app repository as well as for the certificates repository.

We set this environment variable because later Match will use it during code signing – see the [Matchfile](../fastlane/Matchfile).

If you want to include additional layer of security and add a password to your certificates repository (**RECOMMENDED**), you will be asked for it the first time you run Match. After it is done You should of course add it also to your environment variables:

    export TOD_MATCH_PASSPHRASE=[the password to encrypt/decrypt your match repository]

Later, when you run any match commands, you will need to switch this password to a different environment variable: `MATCH_PASSWORD` that Fastlane uses by default.
Here is an example command:

    MATCH_PASSWORD=$TOD_MATCH_PASSPHRASE bundle exec fastlane match development

By doing this Match will not ask you for the password each time.
The trick of prefixing your environment variables will come very handy when you set up your local environment to build and sign several different applications. This is why we add the `TOD_` prefix for the case of this Truth or Dare repository. Other projects may have different prefixes like `TETRIS_`, `PRO_` or whatever you decide to use as abbreviation for your project.

After you have set these environment variables, you should set up your new Keychain. This is another trick that will come handy when codesigning different projects. It's also very convenient to create your own keychain on different build servers. That way you specify your own keychain password and make unlocking and picking the right keychain easier. The password isn't really sensitive (unless you leave your computer unlocked), but you might want to move it to environment variables for added security. Having a separate keychain for your project will also help you keep it clean and don't pollute your Login keychain with codesigning certificates and profiles. To create your keychain use this command:

    bundle exec fastlane ios setup_keychain

By default the keychain will be created in:

    /Users/<username>/Library/Keychains/itcKeychain-db

In the future you may want to replace the `itc` prefix to something related to your project or company, but you might just leave it like this to keep us warm in your memory 😉

Now, to create the certificates run the following command:

    bundle exec fastlane refresh_all_profiles

> NOTE: When you have no provisioning profiles for your app, this command will create new ones for you. You will also want to use this command whenever you add a new device to your development or ad-hoc provisioning profiles. We added a helpful command in the `Fastfile` for this specific purpose: `bundle exec fastlane add_device`.

## Match SSH Key

The most secure way to connect to git repository is by using SSH keys. When you start the deploy build on Codemagic, it will try to download signing certificates and provisioning profiles using Match. When you try it for the first time however, it will give you an **unauthorized** error. This is because your certificates repository is private. In order to connect successfully, Codemagic will need to have an SSH key which it can use to connect to the repository. It is considered unsafe to share your private key with external CI tools, so we will create a new one, just for Codemagic to use.

To generate an SSH key, run:

    ssh-keygen -t ed25519

You can name the file however you want.

Be sure to **Skip** the password prompt (press enter when you are asked for it). If you set a password for your SSH key, then Codemagic will not be able to load this key when setting up the build agent. Don't worry, you will encrypt this SSH key later using the awesome environment variable encryption feature in Codemagic.

Now add the key to the account that you created a private certificates repository with: [Here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account) is a GitHub guide. If you're using a different git provider than GitHub, then consult appropriate documentation to add your SSH key.

We will use that key later, during Codemagic setup.

## Setup the testers

In order to set up testers, go to `https://appstoreconnect.apple.com`, log in and go to `My Apps` section. Select the app you created and go to `TestFlight` tab. In there, select `App Store Connect Users` on the left.

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3e8MAButZBiaVdkArKN-iXsqMxPPFFsUOWy1NnDIw4lHxigPE80W_sCjFOOa6gk50j9c7NXTRGiJoALAt-prF4uJQe_wnXQrpZvNo3tp8JORuEUk9fvDeAEQybWtIk-AhcJremK0vkrWSa5SFY0ItU=w2170-h586-no?authuser=1)

Press the plus sign next to Testers and check whoever you want to test your application.

## Release the app from your local machine

Before you build your app for the first time, make sure to install all pods using:

    find . -name "Podfile" -execdir pod install \;

Now you should be all set to release the app from your local machine. Just run the following command:

    sh ci/build_ios_qa.sh

If all went according to plan, then you'll have a shiny new build uploaded to TestFlight 🚀

# Android Setup

## Keystore

In order to sign your Android application you will need to generate a **keystore** file. Run the following command:

    keytool -genkey -v -keystore <path to use for the key>/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias <key alias you choose>

After that you also need to create a **key.properties** file inside `<app dir>/android/key.properties` with the following content:

```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=<key alias from previous step>
storeFile=<location of the key store from previous step relative to android/app directory>
```

Make the keystore path somewhere inside `<app dir>/android` and update the `android/key.properties` file correctly.

Here's an example command:

    keytool -genkey -v -keystore android/app/itc-release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias tod

And the contents of the `key.properties` file:

```
storePassword=mySuperSecretP@ss
keyPassword=mySuperSecretP@ss
keyAlias=tod
storeFile=itc-release.keystore
```

> **WARNING**: Remember not to check those files into a public source control!

## Create application inside Google Play

Go to `https://play.google.com/console` and select `All apps` tab. In the top right corner, press `Create app button`.

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3eFPKsPQs-mheEei9w-MFLj-58srqJI5ZC6Ecc5pESOV5LJ0Aofv62X1h3whhSMAILzfLoQggVFG6Y4SG9SrqqR1_OASc9PN8ppMMcvDhISB9UVDF1aBTY8KRjKnbAjhHG9bE-q9rywLTREZ4_ZmNs=w2676-h754-no?authuser=1)

Select a free game categories and accept the declarations and click `Create app`:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3ep5NuCRxw4aIycXB32mBHe7bOvF14ijW7Zxk57n6wjooZ3Mk3CiNiK5mLcst1zv_W-LFLIVTcJ0Y6mB3z0ZmCViuUmQBA1rvlDLBp3UUHbo2dOeyK1HyHGYAR-XDKdroY-wDHms0dsaleIGqbgBsw=w2098-h1596-no?authuser=1)

Now, you need to set up your app. This is what you should see:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3cRT4GGpidqJ5tylL8rrUPylNPx2YBc--dZpSGX_XkaUyCBQE-R75KpqJ27_HWpMs1BJ5ZNwXX6xFfVHSL0ptiy7KfqrWtwdzpfZJUGA_CUB-xP0WfPYncqSbzR6ojMjf2Uk9rztg4bO8ipWIoX0Qk=w2058-h1570-no?authuser=1)

Click at `View tasks` and this should appear:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3di4KXwgbH_vmU4KoZc822TSdIx8ELd0Ud3ZiLv72NpJ9jsaZXyo7Z9DN7Nq8KWTLrWd0P_aSumK9Ty6N0cYT8wr3u3y-_PZ6z4cwyWrQrU7c4ye4b4XwB7sYklBXIftsKsEGa6tb9denOnQbgD9yU=w964-h914-no?authuser=1)

We will now go through each section. Go to `App access` and select the first option:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3fk-ooUKif8UaiGu9TN07zpF6McpqI3QUDexLnYxrjhVpPq467hrMmzjB8lJI3Lej8IoFgpvYcHj0AEzdkh0rbN4JNAuoo2Y2ORWyYKbdr7kgdqfSVszRITKQTDae988TZGzwhxR_8W65PqEh8nJh8=w2084-h1582-no?authuser=1)

Press `Save` and go back to Dashboard. Now go to `Ads`:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3cS95LPB-NGFxK8RqIdLdrFFcGE4REwpfnhfP09WOWfkAoAO11pdLJkWEyxE2LJgRr9Wztn2Kr6qJsbKfxdH65R7ErclwtmeSFou7kuant4DCmVMjdIzowTiSnRl1FFBEq8u-7Ykccc0eXygDx4oh0=w2090-h1568-no?authuser=1)

Select no ads, press save and go to next section: `Content ratings`. Provide your email address and select `Game` category:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3fxtmI4mxWZ-O4leJ0jc2Fk3-irV4UO8JUnM3jQGP8EfeXqL0AKmSMcP69gmJusyjEOnlC15zRd31gnXy07GtY1gvm5yITc9WGJNj3D-j64Zy3YoARNHlmms7V-8y_M4pcLVp_xfkjFj6-bKXxeTwk=w2086-h1610-no?authuser=1)

Next, start the questionaire and select `No` in every possible option:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3dpedVZx-3YXN5sDFx839RNSVRLqtVROxtUUzEAvfGF-Dl8FqBtoLQl5jsxLJ8s-N8X4d_HgIM19zfZyS3ZtEYwtpmIgE5sc2ZXRGdjRxunT3kDnFKYQ51CRzpeUBmmNAehvSGBxfQEEhsZHIRlMDc=w2070-h1582-no?authuser=1)

On summary screen press `Submit` and again, go to Dashboard and select the next section: `Target audience and content`:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3f33FlppmiFMZGgnUKXB004wCjR5JqOm2-CXM0EXK4n7PR2ta7OPdVyuCSymn_El6xctlZizjFtSFIpuSy9wsbQvnUZB2pPj_M3QXDH1ntVPVLIYcz4c_HVd23BlatB268MXpjDtBrKITUMewTpA7A=w2104-h1558-no?authuser=1)

Select ages from 13 up, otherwise you will have to provide a privacy policy (you can do that of course if you want).

On the next screen press `No`

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3fPvHpY3XP-meH_fmtPWfqeduUuRpinWeAxkKDQKfzk16f1FW3cZJphFXE4SU4IX77Mf7-MUCRwZFO45OU6fWmccrgxv0W7YR4DmBOr_tMdrnXxDmmqYry0giL-hBSikqOMqWQ4q7sq8s8F_bWTCGk=w2092-h1582-no?authuser=1)

Go to summary, press `Save` and again go back to dashboard and next section: `News app`

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3fBxbYXVvIaJcYhtdr0KsixFSG9EQKM3ra2zB72zCplpkSN9uJzARb8QfvbY4U_HvXCRavPins0_Gr1P0nyvkBivYzDrBibyrtpB3FezTutkZi0aAEdEGrwlQtSDgyca_nXfCtBMuV6lpDMuR1gfyo=w2084-h1574-no?authuser=1)

Select `No`, save and go to next section: `Store settings`:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3eSslBf94GpNkST8nT_ACQ-T3oFpRKvt9gKYq5JKscqBwAOJ9Es5ZiKpzrRFdjyAe93hwgToGnMDBRwVHdxaDcTPfnPwrXRoGQWcVtotKcbA3gxhG4NuO_lmvsNn1M2D__rnqWQ9bqVPvl7R1JaU4M=w2094-h1604-no?authuser=1)

Select `Game` and `Card` category. Provide you email address and click save. The next section we need to go to is `Main store listing`:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3e_vWSDB198kAF5BKvXRt90C3s2x0y1tvfinA5JSyoRawQvNeGg0I1Py2iwZ6uuXFGNCtiNuMjpjo5JAnBxd-HcinL8NQEXWk2ZM2wDmybOZzDw-MI7nJPPl2Z3Cn4dwhEyRqlgu2v8ZpnxMO9hLgo=w2090-h1598-no?authuser=1)

Here, you need to provide app name and two types of descriptions. It is totally up to you. Later you need to add app icon and some screenshots. After that, press save and that should be it for the app setup. Now, go back to Dashboard and expand the second cell:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3eyF3uyCGVboGE29ltHihjftAoDryOXAgM_KtYEbR2-dRyVnSC3Q2ObghnETR5LJJBMef9_NBqRnY2Vv6Ew_CDE0fE97mSMMcXvKMAFhg9tAvPw220XAQLTLhKapghXq0OJ4WEM2aqWzguL3iNJjm8=w2024-h924-no?authuser=1)

Go to `Select testers`:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3ckVjXMtqSYif0LXv6SMY5tGJZk8hMz4BN6KcLukLLW8u_-3_nbDOHrgVBnEiN3WqFis9BhJNKOi-yleByU3tGLcx4AxO4DnCPopN3QBQjGhfQXeUyNz9tsajX9rgAskOPEH9DoMhJ0T1ZqmyPkis8=w2060-h1586-no?authuser=1)

Select list names you want or create one if there are none existing. Press `Save changes`.

Now we should upload a new build manually, but first we need to acquire GooglePlay.json file.

## Google Play JSON

Again, go to `https://play.google.com/console` and log in. After you entered your account, go to **Settings -> API access**

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3clPUOCzeqfyTCi0Aq7AkblJ1WueSWnH3p0M-lTqgAJY5CU8xg1mHVL1ldubUgDWb3ABKOGa64aWnkES1mZ2merpuy2qaEOj1u3N9U_6WpglGc8F8kT8QPdV1iCpKvdqA_95ROMvPCbAFsUaaYMNBU=w1200-h918-no?authuser=1)

Press the `Choose a project to link` button. After that, press `Create new service account` button.

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3ckg8Ox9kBfYT_UDX7caFUIc-s3NQ4qKK44apESINJVQEgjeLxZPCueJc2nyclpJUZIuZTOnos6h_jvNRTk9AhcsSYWkNA7QfcHZNubJ9_yRLkAKzLFQ5tefHXvcLvufSrkhmWa9abbn-bxPwU8yr8=w479-h97-no?authuser=1)

A small window should be displayed:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3de-JOpcTs012_KWScQzUFzX5ehzrMhOR4jvxoMHeetyH4Ujukn_vrKvJNt8G8RhTczBsdDsHd1loCN63KBGXrD7qCemOZbh0F4OUvIU6j_wN4DRaABQ-OORnlfeh5zXgRloeb5iYNhmSI-gcq898g=w622-h345-no?authuser=1)

Go to the `Google Cloud Platform` and press the `Create service account` button once again:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3eYrFKRhgyASvL-jtgG4H-6egL4Eylomhu3pOABpmnGTyGhyMAAFYDz5u8KMBmBEaCKivnK2OHjgkmKQSzCFZV5m59cjRDzOQMRpjMb65RpUhDlnJ23iKwzOiBSv_qIF9aU331ao5aIz6c-KyRyJQI=w797-h343-no?authuser=1)

At the first step provide the name and description of your choice:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3e2aORZ0z2WeD45Us0GwIZIw7upqHaqfgpeTbnhbOux0WQqJaGsaNLmUCM64CBHAi8G7nfoWbFUS2QfL3-j10LgT3z1z9BPGOqhhSB1sPodcKdngvA78GT_KT2OZoXUjTGnAZxa0g4nwvjXhfqu9yE=w672-h666-no?authuser=1)

Proceed to step 2 and select Editor role:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3fmEL5XPqzKpPfDD4xYK-bpbe6JCA3sIKvmvNphPTfKX5wNXmMv4Py08JwghEluIRBJmTgFN97sDmYBdeKlTPtr6D8rax3Zs4DhOLZdhyLtl3IP5Nwq7IXD-37IUV3dlOztzUnpm80i7en_pxsZWqs=w538-h316-no?authuser=1)

You can skip step 3 and click `Done`. Next, scroll down to the `Keys` section. Press the `Add Key` and then `Create new key` button:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3cK5K33eJBiLBrPjYrfjjbnMRyB4bmfo8KK4WJqMULgL0i0b5CSg42YeJHI5MyUKU5xOzdlanDnU7J99ck0Y9uJ9fRtYwzPRNjnPFotPsSYH8XJzIu0EMqVuwZN_417A4Bmh1yRS0ubVMg70nzXsPU=w555-h257-no?authuser=1)

Select the JSON format:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3evbjjdKrYnv-n0sNIz3nABsw_DKOvcP4_31lChIX5RF7u2ZTJ5vLf_1puYtOCYGHHqPSaKjSTDCEa4I74b1cBqVrUHVyMvv3bel1Tedf5_r6exkraufMG2GhEx8Wz3jbOHYPdgCda7vMLQiFfWdkA=w586-h385-no?authuser=1)

Now it should download to your machine. After that, it should be visible on the list:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3eoojoqeJzqhXAFzW29IXHUgZhz9Fru40tBifr4y30yVDpj0tttWqOvBEJ57vmsZv4HzWt1eM6eu_kZaKy89VHNnAGknn3xwbddA8ErrQJ8XH7hgN3g1-iFB66nBq0o50yjK82sVVa4eZzxtNJ0b3E=w799-h257-no?authuser=1)

Now, go back to Google Play Console and a new service account should be visible. Press `Grant access` next to it:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3col1DH6iuNFMT_SvJ4lUuWU6vL1RhEJOf8-Zy2RloCxsdUBLPyKs79USxaQN_84uVZ6KuRGya_PMC06FMMxwSnhnXLTiCclC4DlVGsLU1fIoj3WUrTUEGmwNv6Vh8vHF6t7GDVxoiu0lj47nK34Bo=w689-h238-no?authuser=1)

At the bottom switch the tab to `App permissions`:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3c0hYxORxnaamPI99QS88wugef6_fEhovsaluia3ct94Qat5nwDFH2V7P4eSgKcdC5-N65MlgGDBAC7KsIjdpq9Va87zLGVBxfqZlHGvUKhm0X3jcLoyVKwBb9G43crmwaBLaeY-8zYY9HHjree1VQ=w865-h316-no?authuser=1)

Click `Add app` and select your truth or dare app.

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3cEQs4Z9euSLbDEksgAaUPGBBSs7atiV8lNfAKA_kk2pqGktONLZms_M9U9sRbb22WvjxFBhYHsfFw_3Sg00aSj28pkD0Z3A_-2jk37jBYn0iithNbxaeW7R3KgjUonw289IT4Pi2_HH3PImHxoYxc=w434-h450-no?authuser=1)

On the next screen press `Next`:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3cNFIeLubl4n4efVAtcMuzm7MNcJ6RtBjPshSYT9nHK3E9UP52iU_cXykGgi4tjxxMk4A0j49QI2bZz77iy1jbb7jyxT_vWuSr8aQDgfANHE0fpRyCfMU2R8o2Vcq-kGGj1apIH7yVDDe38welYCKs=w1195-h830-no?authuser=1)

And confirm sending the invitation:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3di02XrXRKjk2G1y6RKKLsMd7ifATYz2bN4VXyaTmSa1KIIUvpYXzDKVYFTeMDsXYHxGpayIxBDxhgN5eOTlEJ2omJu8XPcqLSwaUM2nIlXkvEm73VVhTMQV4Hk68pb2wrcirVvmHCKQdSTmDpBggY=w447-h234-no?authuser=1)

Finally, this is what you should see:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3fqAD2_AJYQ2Akv6GhIV-ZVSgUcwsZLQhiL_xl-B0t6kgpbXeGJO2epAxgZtvorCveny29MjG9eWCZ-BT-mZuRFHTo2Z-6E0ubn33TPUrYAYWFUMx0qv_522NerCZ2mJfqqBWLIncDujuJlFR2FMjY=w883-h778-no?authuser=1)

## First Upload

Put the `google_play.json` file inside your project root directory.

> **WARNING**: Remember not to check in this file to a public code repository.

Now, we should be good to go and build our first .aab. Go to terminal, change directory to your project and run:

    flutter build appbundle

If everything goes right, a path to .abb should be printed.

Now, go to Google Play console, enter Dashboard and go to `Create a new release` section:

![enter image description here](https://lh3.googleusercontent.com/wYtrpJdK0iW4CsV1FhyCdJ4qTDZ7U8pw1ai6yOrn_fVI8uzjW6KtL3WQFxLs5q-Ur3hYd6vYx9fnsYVnw-xWrNJ9YJ87eGS7Gx5ChynVq20hoTCGMdzIRe-ycW3QQ4RVZIfxIVmNfQpWILx-UIXEL0bIjb3tZ0ypzdeIfV30yPCvplQ3vQ2dJWn85B5xR6pkWlvgSix-jhXJk3ztGWdGwf0czF0HL1emm_LpHs0BQLBzNXzFsHR332HUsbEXBk4zcvTysXdvjNk8IW5LUoAzTEJyXNYlK_AK4BjRbcoOaG0qIeyMT72aS5z-danAtk5FsLqSsox7HhionD49cyiGApdMZx_p-ta3juYKYnfTtXkIjlcdzAZ6YnQgBjMbv_UE8yjk7fbhdEo83TvBy8Rhh-UB9D_pc8-818xl-EPjHEaWKBL5P7VgWy7nwtXN0wPKVvU3uV954U5VMzXl13VfvxZ7plDWPURdrnbCteRrTvvsEN02pgmetzl2mdDk-gK-6hVVpM4gyDOW0JP-3-EUl7zet2sGM_7MLfObPMejNDnHw1zI_bZtTRKg6Qzmm4jmir18UfR0VVSPbVSRAqpVD2G5BunwDbSYZcVgt2b1OocKcAN2JasisGil3v627yWCt-1oXcvGmF3HGS2BwQU42H5DFCBzKBfDUQO1g3cxTTwOn_ruM1wP3Jt9IhZR=w2088-h1300-no?authuser=1)

Press `Create new release`, click `Continue` in the middle of the screen and then upload an .abb you just built.

![enter image description here](https://lh3.googleusercontent.com/4UsSzQZVRdSReVBv_gXKjiZAYSa80l2Pdy2kS5UJvmUIdpEdO3vUUaDfwGwphBAH_zfGZOZ5f2g2vr51KNrpL0MB-WhVFAc-w5wH6zfN82OHYOVNNJTo_Ab6QrpvXPVbVfc_WMbWYs-2RsjkN-sDmOgIJMkrRqwmbp00T4dfBf8Lx9X73kVtYY4Zl-k8gECvf9_YvVnV0JhxQsqY1_RWBnc9WIoZbDsiimCzjFOSAOzI5twxKJ20jxe3aGa4Pt8PNVumtlAE3JxhVOK6pNiK8VhKFo88SO7rIcxmqanoWPXrnp2yFPuMgGmRo9iASYBJtMnVeudvpPCy9EvZXGWHmZq_tTwgaQyMDwU18HDyxlipF1GciipNmxw_BiPxCtaE3VZ0XoPmcaoy3kBnKDmJOf9VBqXWZw0YQMf4XKgMlxh5QXdf7txq5zI1UD7mBEU3r8XuiOtxOtSPSHocITQ8zyq9o22KCNZi740px1lliim2nsJsQcNJnq8JqFQx6nWLi4E7vEPJPWVHI3oa3pt5DdU9HP11jMsPruE9X-ql9yNqqSU-Q-NnMJjVPiyPANB64tkHFeZtq3Eb8xDcpZhU5chw6BvUojwRbzNRgAZyuc5SSbaieDyV589BfrX5NF9hjdsd3GWcRCxhqD5IxhwnjZlgD39TnhR5QBRUYeqzBG_3aF-3dA7Zc2r-pUiW=w2050-h1424-no?authuser=1)

After that, press `Save`, then `Review Release` and finally `Rollout`.

# Codemagic setup

After you log in to your Codemagic account, go to `Teams` tab:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3dC6WJ5Rd1TrBC5eCRaQPs_vN1eMx_grY3Tigfz7rtlW_8n22vmr1dT3q98cqqjodvhASKKCUeoIlJi4P3kc8KTtS5C-yjO1LyHJpIcOsYcZsPCXUQasy9ohC7tpg8H9ne4i1aSpqlAiMWf1NoAMs8=w1062-h450-no?authuser=1)

If you haven't already, create new team.

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3dx8uI8NR_9G4z6kk-N7TmATrp_y918UfhaqgIKNbsXP5Jx6Wq3P_ugqsag39P7rr96kU-nvb70KhPIA_iPHl9LSAsrGf48UyZUXjWJPfk_xonDR2b_xI5FH8hCK5YLXTGNeTZaCzVj_-6hp3DLG9U=w669-h536-no?authuser=1)

Provide team name, user limit, and billing information later on. After that you should see a similar screen:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3f-FDgPEqhnU9BwjQsX7CApWK-Xhl_ZFwWgYGLjS2Z8RghJ2jIZpbp-Dw8wlmVrjWN7ZpgGnX2RhprffxmMyR01izJyFzD1cyEwuhOyluSgivzKRbvUXrmx7iZAln57rxCtXfqt8ZUE0u-pbY_bEXk=w680-h867-no?authuser=1)

Go to `Team integrations` and connect to the service you are using (e.x. GitHub).

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3erwxjaaS3DB4v2m9cWkdDf7CrKGdU-Q1D7mE7_uVA_Vct1Y9VVzWbjuWvJGKzrrrvyH-JTPt-vmcpIym1g_KhdqkAQdjEFHqUFvSlIi8yccduVMFpXX8qcBWg8PjkHUEqptvomEnrytba5Ta7b1i4=w579-h359-no?authuser=1)

After successful connection you should see a green light:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3e-XlTbJsjeirxdYjaioHXX1WSyW3JitFIVtBGcAf7S5ryrOiLDi49F_4xpbSVFB2h2CWEOTvNB5021asV9tiduuH4zTf1n7XallV9t-ozrmdG8KXBHq1dQBOCaKtXhH2LVdXfRxqWnZI0qmOgSc1Y=w621-h370-no?authuser=1)

Now, go to `Shared application` and select your truth or dare repository:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3eh0rojtrWaaaTixBIJsmmoBVz0Xu1N0WoJzXzMmkemFAzC9rVJ_266OyVqhnlHXuwH0F166TfuBVI8Br-KG33tAxJKMYnSEvH_eJCSoR5fjP7Kg6PIrk157jZA96r210eGZOcyMsgbduonw-OAvtA=w595-h383-no?authuser=1)

Next, go to `Apps` tab. Your application should be visible there. Press the `Finish build setup` button next to it. Select `Flutter App`.

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3dMiCtovSTeKEfqdIgp7l7jFmaavYLpM1cuFeEVu44xudBfKKwcTQP5IO0wVcEpTe0vxLzpHo6VULkxn5W_cT4U2E7nnmboEK_zRjmGNhhN265zCrZfLtJGdewrpFKY7T-c1K8xVEm4XtzrpkPcstM=w1578-h1636-no?authuser=1)

We are almost done by this point. Now, on the right side of the screen, click the `Encrypt environmental variables`. You should see something like:

![enter image description here](https://lh3.googleusercontent.com/pw/ACtC-3cX9qQu7e6pYd5b_08SViJlsIiiGuf1B79__3Ao-sp5GVWBqx8RBjGEsY5SObUzR7PIuXrCPmnUIqsP-HcGtqwV57U8752-lGPCCfEhlKMC8tORLbTyGpIZz_BesW7D4rZokDsR6bwbVdneIKBwPQ4=w1316-h1186-no?authuser=1)

Now, this part is kind of time consuming. You now need to paste every environmental variable we set up during this tutorial and copy the result to `Codemagic.yaml` file. You can enter mentioned file to see the list of all needed variables. Here is an example:

    TOD_APPLE_ID:  Encrypted(Z0FBQUFBQmYzZ2dSVkIxQzRZYXlCS2FaMXQ1bS0waFNialQwX0NfZWxIUlNYOE9kWG5heWdPRXlIZzB3ZGJOS3dFa2dtbzNiZGNScWIxZFlRVjhJZXV4MUdnNExBam9tTy1JTzVEd1hYaWY5WEk2dDBKTFVCdkk9)

After you make changes don't forget to push them to your version control system.

When you're done, press `Start new build` button, on the bottom of that window press `Select workflow from codemagic.yaml`, select the branch you are using and select `publish-qa` workflow. Press `Start new build` and wait for your build to complete. If everything goes well, new builds should be uploaded to App Store Connect and GooglePlay.
