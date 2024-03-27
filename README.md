# Portable Builds of the `rippled` server


**GPG Fingerprint:** `6D70 4017 0DEA 4F69 DEF5  D569 B6F9 7CF2 1A96 2003`

## Background

While `rippled` can usually be installed and updated using package managers such as `apt` and `yum`, there are certain situations where a drop in binary can be useful. For example, when `rippled` needs to be installed without compiling from sources on distributions that aren't supported by current mechanisms. 

Another important reason is to maintain support for older distributions (backports). For logistical reasons, it may not always be possible to update an operating system within a specific time period. Packages for such distributions are not available in the `apt` and `yum` repositories provided by Ripple. One such example is for Ubuntu 18.04. Although this distribution is EOL, there may be a substantial portion of the network that are yet to upgrade to later versions. We do not recommend that operators run EOL and insecure systems. Additionally, this binary may help operators try `rippled` on a variety of *nix systems.

The Foundation is extremely conscious that **network size is crucial to the health of the XRPL** and has therefore taken steps to provide alternate installation methods to operators.

The portable binary provided in this repo **has been tested to work on a multitude of distributions** (however, if you find your distribution has problems, please do open an issue here).

There will be two files for every release with the following schema
1. rippled-portable-versionnumber (eg: rippled-portable-2.1.1) - the binary file
2. rippled-portable-versionnumber.sig (eg: rippled-portable-2.1.1.sig) - the detached GPG signature for the file. The GPG public key is also published in this repository

## Installation

Since this effort is mainly for existing installations of `rippled` that need to be updated, we will not cover fresh installations. Those should be done on up to date Operating Systems using [usual methods](https://xrpl.org/install-rippled.html).

First download and import the Public key:

`wget https://raw.githubusercontent.com/XRPLF/rippled-portable-builds/main/xrplf-binary-packages-public.gpg`

`gpg --import xrplf-binary-packages-public.gpg`

1. Download the binary from this repository and verify the signature

`wget https://github.com/XRPLF/rippled-portable-builds/raw/main/releases/rippled-portable-2.1.1` (change version number as required)

`wget https://github.com/XRPLF/rippled-portable-builds/raw/main/releases/rippled-portable-2.1.1.sig` (change version number as required)

`gpg --verify rippled-portable-2.1.1.sig rippled-portable-2.1.1` (change version number of both binary and signature as required)

This and only this part of the warning that is safe to ignore (should you see it):

```
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
```
Typically a successful verification will look like this:

```
gpg: Signature made Thu 16 Mar 2023 02:31:58 PM UTC
gpg:                using RSA key 6D7040170DEA4F69DEF5D569B6F97CF21A962003
gpg:                issuer "noreply+binary-packages@xrpl.org"
gpg: Good signature from "XRPLF Binaries <noreply+binary-packages@xrpl.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 6D70 4017 0DEA 4F69 DEF5  D569 B6F9 7CF2 1A96 2003
```

2. Make the binary executable (`chmod +x rippled-portable-versionnumber`)
3. Stop the currently running `rippled` daemon (`sudo systemctl stop rippled.service`)
4. Delete/rename the existing binary in `/opt/ripple/bin/rippled` 
5. Create a symbolic link to the downloaded binary (`sudo ln -snf /path/to/downloaded/rippled-portable-versionnumber /opt/ripple/bin/rippled` ). Replace the path/name with actual links.
6. Start the `rippled` daemon (`sudo systemctl start rippled`)

Check that `rippled` is running as expected with `rippled server_info`

For fresh systems, you can also run the [first-run.sh](https://github.com/XRPLF/rippled-portable-builds/tree/main/bootstrap) bash script.

**Credits: An enormous Thank you to [@RichardAH](https://github.com/richardah) for his amazing work on this project!**
