## Pol
Pol means bridge in Farsi.
This tiny dockerfile helps you build a docker image to run a Tor obfs4 bridge 
and help censored users.

### Instructions

    $ git clone https://github.com/mrphs/pol
    
Edit Dockerfile to include your bridge name and contact info.

    $ docker build -t torbridge /path/to/Dockerfile
    
    $ docker run -it torbridge

That's it!

## Note
If your (host) kernel doesn't have `CONFIG_AUFS_XATTR` set to `y`,
you might have problems running your bridge on port 80. Pick a port higher than 1024.

Debian hosts need to install `aufs-tools cgroupfs-mount libapparmor1 libdrm2 libltdl7 libnih-dbus1 libnih1 makedev mountall plymouth`

## Why port 80?
Because it's unlikely to be blocked, even on the most fascist firewall.
