# qbittorrent-post-process

Script meant to be run by qBittorrent for post-processing torrents on completion.

- [Dependencies](#Dependencies)
- [Installation](#Installation)

## Dependencies

The script has the following dependencies:

- curl, grep, dirname commands
- [jq](https://stedolan.github.io/jq) command line JSON processor
- [7z](https://www.7-zip.org) for automatically running decompression on completed torrents
- [qBittorrent WebAPI](https://github.com/qbittorrent/qBittorrent/wiki/Web-API-Documentation)

 On most linux installations, curl and grep should already be present. On recent Debian distributions, including Ubuntu, jq and 7z can be installed with

```sh
 sudo apt install jq p7zip-full p7zip-rar
```

> **Note**: If you are already running the full qBittorrent GUI or would prefer to use the qBittorrent desktop GUI client, then to use this script you will need to enable the qBittorrent WebAPI REST endpoints by navigating to your qBittorrent desktop clients settings and "Options" --> "Web UI" --> "Web User Interface (Remote control)".

## Installation

The script contains 3 constants at the top of the file `HOST`, `USER`, and `PASS` which should
be changed to the correct values for your server.
Clone this repository:

```sh
git clone https://github.com/CoryG89/qbittorrent-post-process
cd qbittorrent-post-process
```

The script contained in this repository has 3 constants set at the top of the file: `HOST`, `USER`, and `PASS`. These should be updated for the correct values for your server.

Copy the script to your desired location. You also need to ensure that the script is set to be executable by the user which owns the qbittorrent process.

```sh
sudo chmod a+x qbittorrent-post-process.sh
```

Now, in the qBittorrent settings navigate to the `"Downloads"` section, and underneath there is a setting that is labeled `"Run external program on torrent completion"`:

Enable this feature, then in the textbox provide the following:

```sh
/path/to/qbittorrent-post-process.sh "%I"
```

This will cause qBittorrent to execute the script whenever a download completes and pass it the torrent's "Info hash" as a parameter.
