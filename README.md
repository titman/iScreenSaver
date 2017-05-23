<p align="center">
<a href="https://github.com/titman/iScreenSaver" target="_blank">
<img align="center" alt="A magic screen saver, a lot of fun. You can also customize your own screen saver." src="https://raw.githubusercontent.com/titman/Pictures-of-the-warehouse/master/iScreenSaver/Header.gif" />
</a>
</p>

<p align="center">
<a href="https://github.com/titman/iScreenSaver/stargazers" target="_blank">
<img alt="GitHub stars" src="https://img.shields.io/github/stars/titman/iScreenSaver.svg?style=social" />
</a>
<a href="https://github.com/titman/iScreenSaver/tree/master/Releases" target="_blank">
<img alt="Github All Releases" src="https://img.shields.io/github/downloads/titman/iScreenSaver/total.svg?style=social&maxAge=2592000" />
</a>
</p>

## iScreenSaver - A Screen Saver for Mac OSX 10.8+
A magic screen saver, a lot of fun. You can also customize your own screen saver. iScreenSaver is based on the [WebView].


## Installation on Mac OSX

1. **[Download the last release (iScreenSaver.x.xx.saver.zip)](https://github.com/titman/iScreenSaver/releases/)**
2. Unzip the downloaded file.
3. Open the iScreenSaver.saver and install it.
4. Open up System Preferences > Desktop and Screen Saver > Screen Saver
5. Select "iScreenSaver" (It'll be at the bottom of the Screen Savers list.)
Press "Screen Saver Options" and choose your favorite screen saver! or you can also customize your own screen saver.

## Video instructions

* [The Geek Circle](https://www.youtube.com/watch?v=8fTiSQgb8Io)
* [Technical Ustad](https://www.youtube.com/watch?v=UZzyJhMoj_k)
* [Ryan Heuer](https://www.youtube.com/watch?v=cHy36rfocQo)

## Uninstallation on Windows 7, 8 and 10

To uninstall, delete the downloaded `.scr` file.

## Features
* **Auto Load Latest Aerials:** Aerials are loaded directly from Apple, so you're never out of date.
* **Play Different Aerial On Each Display:** If you've got multiple monitors, this setting loads a different aerial for each of your displays.

<p align="center"><img align="center" alt="windows aerial screen saver settings" src="imgs/settings.png" /></p>

## Compatibility
Aerial is written in C# for [.Net Framework v4.6](https://www.microsoft.com/en-us/download/details.aspx?id=48130).

## FAQ

> After insalling on Windows XP, 7, 8.1, I get an error message "This application could not be started"

Please [install Microsoft's .Net Framework 4.6](https://support.microsoft.com/en-us/kb/2715633).

> The app freezes or returns to desktop?

Try to install `Windows Media Player` via `Turn Windows features on or off` in the control panel.

> Blank black screen on screen saver preview?

The application needs an internet connection to work.

> BitBlocker / McAfee / execution blocking the download?

Historically `.scr` files have a bad history with anti-virus software — erroneously positive reports of this screensaver being a Malware or Generic Trojan or Unverified Executable is a [known issue](https://github.com/cDima/Aerial/issues/9), you can help by [reporting the source](https://www.opswat.com/blog/what-do-i-do-if-engine-detects-my-safe-file-threat) of this open source repository to the faulty anti-virus software companies. The builds are verified to be clean.

> Where are the .mov files located on Apple TV servers?

The movie files are [located at apple.com](https://github.com/cDima/Aerial/issues/55), they are cached to your local user directory, usually this: `C:\Users\YOURUSERNAME\AppData\Local\Aerial` 

> There's a red line on the screen saver!

This is an issue with video cards and  Windows Media Player, this can be solved by [disabling 'Demo Mode'](https://github.com/cDima/Aerial/issues/71#issuecomment-250318463).

> How do I setup a proxy?

To setup proxy information, create a [.config file as shown](https://github.com/cDima/Aerial/issues/87) alongside the screensaver.

## Community
- **Find a bug?** [Open an issue](https://github.com/cdima/Aerial/issues/new). Try to be as specific as possible.
- **Have a feature request** [Open an issue](https://github.com/cdima/Aerial/issues/new). Tell me why this feature would be useful, and why you and others would want it.

## Contribute
I appreciate all pull requests. Caching hasn't been added yet.

## Changelog

- October 27th, 2015 - 0.1: First release.
- November 5th, 2015 - 0.2: Multi-screenoptions and scaling:

<p align="center"><img align="center" alt="multiscreen aerial screensaver" src="imgs/multiscreen.gif" /></p>

## License
[MIT License](https://raw.githubusercontent.com/JohnCoates/Aerial/master/LICENSE)


#### Coded with :heart: in New York by [Dmitry Sadakov](http://sadakov.com/)

<p align="center"><img align="center" alt="Dmtiry Sadakov" src="imgs/dmitrysadakov.jpg" /></p>
