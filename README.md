# Portable Builds of the `rippled` server

IMPORTANT:
GPG Fingerprint: `6D70 4017 0DEA 4F69 DEF5  D569 B6F9 7CF2 1A96 2003`

## Background

While `rippled` can usually be installed and updated using package managers such as `apt` and `yum`, there are certain situations where a drop in binary can be useful. For example, when `rippled` needs to be installed without compiling from sources on distributions that aren't supported by current mechanisms. 

Another important reason is to maintain support for older distributions. For logistical reasons, it may not always be possible to update an operating system within a specific time period. Packages for such distributions are not available in the `apt` and `yum` repositories provided by Ripple. One such example is for Ubuntu 18.04. Although this distribution is near EOL, there may be a substantial portion of the network that are yet to upgrade to later versions.

The Foundation is extremely conscious that **network size is crucial to the health of the XRPL** and has therefore taken steps to provide alternate installation methods to operators.

The portable binary provided in this repo has been tested to work on a multitude of distributions (However, if you find your distribution has problems, please do open an issue here).

There will be two files for every release with the following schema
1. rippled-portable-versionnumber (eg: rippled-portable-1.10.0) - the binary file
2. rippled-portable-versionnumber.sig (eg: rippled-portable-1.10.0.sig) - the detached GPG signature for the file. The GPG public key is also published in this repository

## Installation

Since this effort is mainly for existing installations of `rippled` that need to be updated, we will not cover fresh installations. Those should be done on up to date Operating Systems using usual methods.

1. Download the binary from this repository and verify the signature
2. Make the binary executable (`chmod +x rippled-portable-versionnumber`)
3. Stop the currently running `rippled` daemon (`sudo systemctl stop rippled.service`)
4. Delete/rename the existing binary in `/opt/rippled/bin/rippled` 
5. Create a symbolic link to the downloaded binary (`sudo ln -snf /path/to/downloaded/rippled-portable-versionnumber /opt/ripple/bin/rippled` ). Replace the path/name with actual links.
6. Start the `rippled` daemon (`sudo systemctl start rippled`)

Check that `rippled` is running as expected with `rippled server_info`


