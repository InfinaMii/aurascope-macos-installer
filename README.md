# aurascope-macos-installer
Aurascope Demo install script for macOS
<br><br>
<img src="https://github.com/InfinaMii/aurascope-macos-installer/blob/main/image.png?raw=true" />

# Instructions:

- Add Aurascope Demo to your Steam library [here](https://store.steampowered.com/app/1547880/Aurascope/)

- Run the following command in Terminal:
  <br>`curl -sL https://github.com/InfinaMii/aurascope-macos-installer/raw/refs/heads/main/install_aurascope.sh | bash`

- Follow the on-screen instructions
  <br><br>

# Explanation:

The script (provided in this repo) does the following:

- Downloads SteamCMD (terminal steam client)
- Signs into SteamCMD with your account information (required to download Aurascope)
- Downloads the Aurascope Demo and extracts the required data.win and audio files
- Downloads the Deltarune [SURVEY_PROGRAM](https://archive.org/details/SURVEY_PROGRAM) app bundle (Chapter 1)
- Transplants the Aurascope data.win and audio files over the Deltarune ones (and changes the app icon to the one above)
- Moves the newly-created Aurascope into the Applications folder so that it appears in Spotlight/Launchpad
