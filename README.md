# LiveStreamRadio
Lightweight 24/7 Twitch and YouTube Music Radio using FFMPEG.


## Dependencies
Install the following software on your machine:  *git*, *screen*, *alsa*, *mpg123* and *ffmpeg*
```bash
sudo apt install git screen alsa mpg123 ffmpeg
```


## Installation
- Clone this repository
```bash
git clone https://github.com/NoniDOTio/LiveStreamRadio.git
```
- Add ALSA loopback (on some systems, you will have to re-run this command after every reboot)
```bash
sudo modprobe snd-aloop pcm_substreams=1
```
- Make loopback the default PCM device by adding it to `.asoundrc`
```bash
echo 'pcm.!default { type plug slave.pcm "hw:Loopback,0,0" }' >> ~/.asoundrc
```


## How To Use
- Open `config.sh` in an editor and add your RTMP urls to *PLATFORMS*, remove any lines you don't need 
```bash
PLATFORMS=(
    "rtmp://a.rtmp.youtube.com/live2/1234-5678-90ab-cdef-ghij"
)
```
- Specify a file path for `MUSIC_DIR=` and `BACKGROUND=`. Alternatively, you can move all your audio files to `/media/music`.
- Start streaming by launching the script
```bash
./lsr.sh --start
```
- Stop streaming by quitting the script
```bash
./lsr.sh --stop
```


## Links
- [Demo (Live Stream Recording)](https://www.youtube.com/watch?v=lcEKoSz7Ah8)
- [Report a bug](https://github.com/NoniDOTio/LiveStreamRadio/issues)
