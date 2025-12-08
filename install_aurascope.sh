#!/bin/sh

# Remove temp directory if it exists (failed previous install)
if [ -d "./aurascope_temp" ]; then
    rm -r ./aurascope_temp
fi

# Create temp download directory
mkdir ./aurascope_temp
cd ./aurascope_temp

# Create location for files to transplant
mkdir ./transplant

# Create SteamCMD temp install directory
mkdir ./steamcmd
cd ./steamcmd

# Download SteamCMD
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_osx.tar.gz" | tar zxvf -


# Get login information (required to download from Steam)
if [ -z ${username+x} ]; then
    username=$(osascript -e 'display dialog "Enter your Steam username (will only be used for SteamCMD and then forgotten)" default answer "" hidden answer false with title "SteamCMD Login" buttons {"Cancel", "Submit"} default button "Submit"' -e 'text returned of result')

    echo $username

    if [ "" = "$username" ]; then
        echo "No username provided"
        exit
    fi
fi

if [ -z ${password+x} ]; then
    password=$(osascript -e 'display dialog "Enter your Steam password (will only be used for SteamCMD and then forgotten)" default answer "" hidden answer true with title "SteamCMD Login" buttons {"Cancel", "Submit"} default button "Submit"' -e 'text returned of result')


    if [ "" = "$password" ]; then
        echo "No password provided"
        exit
    fi
fi

# Warn user about Steam Guard (if warning isn't disabled)
if [ "1" != "$skip_guard_warning" ]; then
    osascript -e 'display dialog "If you have Steam Guard enabled, you will recieve a notification in your Steam Mobile app shortly." with title "SteamCMD" buttons {"OK"} default button "OK"'
fi

# Download the Aurascope Demo depot from Steam
./steamcmd.sh +login $username $password +download_depot 3188440 3188441 +exit

# Extract required game files
mv ./steamapps/content/app_3188440/depot_3188441/data.win ../transplant/game.ios
mv ./steamapps/content/app_3188440/depot_3188441/audio/ ../transplant/audio/

# Exit directory and delete
cd ..
rm -r steamcmd

# Download SURVEY_PROGRAM (Deltarune Chapter 1)
curl -OL https://archive.org/download/SURVEY_PROGRAM/English/SURVEY_PROGRAM_MACOSX_ENGLISH.dmg

# Mount SURVEY_PROGRAM image
hdiutil attach ./SURVEY_PROGRAM_MACOSX_ENGLISH.dmg

# Extract app bundle from image
mv /Volumes/SURVEY_PROGRAM/SURVEY_PROGRAM.app/ ./SURVEY_PROGRAM.app/

# Unmount image and delete
hdiutil detach /Volumes/SURVEY_PROGRAM
rm ./SURVEY_PROGRAM_MACOSX_ENGLISH.dmg

# Move transplant files into app bundle
mv -f ./transplant/game.ios ./SURVEY_PROGRAM.app/Contents/Resources/game.ios
mv -f ./transplant/audio/ ./SURVEY_PROGRAM.app/Contents/Resources/audio/

# Remove unnecessary Deltarune files
rm -r ./SURVEY_PROGRAM.app/Contents/Resources/mus/
rm -r ./SURVEY_PROGRAM.app/Contents/Resources/lang/
rm ./SURVEY_PROGRAM.app/Contents/Resources/snd_*
rm ./SURVEY_PROGRAM.app/Contents/Resources/audio_intronoise.ogg

# Rename app name to "Aurascope Demo"
sed '2s/.*/DisplayName="Aurascope Demo"/' ./SURVEY_PROGRAM.app/Contents/Resources/options.ini > ./SURVEY_PROGRAM.app/Contents/Resources/options_2.ini

mv -f ./SURVEY_PROGRAM.app/Contents/Resources/options_2.ini ./SURVEY_PROGRAM.app/Contents/Resources/options.ini

# Download new icon and add it to app bundle
curl -OL https://github.com/InfinaMii/aurascope-macos-installer/raw/refs/heads/main/icon.icns
mv -f icon.icns ./SURVEY_PROGRAM.app/Contents/Resources/icon.icns

# Download dynamic (Tahoe) icon assets and update plist to support it
curl -OL https://github.com/InfinaMii/aurascope-macos-installer/raw/refs/heads/main/Assets.car
mv -f Assets.car ./SURVEY_PROGRAM.app/Contents/Resources/Assets.car
plutil -insert CFBundleIconName -string "auraq" ./SURVEY_PROGRAM.app/Contents/Info.plist

# Set additional app info
plutil -replace NSHumanReadableCopyright -string "(c) 2019-2025 Nick Oztok" ./SURVEY_PROGRAM.app/Contents/Info.plist
plutil -replace CFBundleVersion -string "0.3.2" ./SURVEY_PROGRAM.app/Contents/Info.plist
plutil -replace CFBundleShortVersionString -string "0.3.2" ./SURVEY_PROGRAM.app/Contents/Info.plist

# Re-sign app bundle so that it launches now that the plist file has been modified
codesign --force --deep --sign - ./SURVEY_PROGRAM.app

# Move Aurascope to app directory
mv ./SURVEY_PROGRAM.app/ /Applications/Aurascope\ Demo.app/

# Exit directory and delete
cd ..
rm -fr ./aurascope_temp

if [ -d "/Applications/Aurascope Demo.app/" ]; then


    # Success message
    rungame=$(osascript -e 'display dialog "Installed Aurascope Demo successfully! Would you like to open it?" with title "Yippee!" buttons {"No Thanks", "Yes"} default button "Yes"')

    if [ "button returned:Yes" = "$rungame" ]; then
        open /Applications/Aurascope\ Demo.app
    fi
    
else
    # Failure message
    rungame=$(osascript -e 'display dialog "Failed to install Aurascope Demo." with title "Aw man..." buttons {"OK"} default button "OK"')
fi

