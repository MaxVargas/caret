Simple enough, I mainly just want a quick reference so that I can transfer pictures from an SD card to internal storage. This is just following the instructions over [here](https://askubuntu.com/questions/37767/how-to-access-a-usb-flash-drive-from-the-terminal). First, find the drive you want to pull data from using `lsblk`. 

Second, create a mount point:
```
sudo mkdir /media/usb
sudo mount /dev/sdxX /media/usb
```
Then you can copy files over from `/media/usb` into any more permanent location. Once copying is done, you can unmount with
```
sudo umount /media/usb
```
