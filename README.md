# How this container was built on Windows 10

- Downloaded [CentOS 6.4 Live cd](https://vault.centos.org/6.4/isos/x86_64/CentOS-6.4-x86_64-LiveCD.iso)
- Created a Debian container that was used to mount the iso inside of.
  - Used a volume mount to attach the iso
  - `docker run --privileged --rm --name centbuild -v D:\Docker\Centos64\iso:/mnt/iso -it debian:stable /bin/bash`
- mounted the iso to a rootfs dir
  - `mkdir /rootfs && mount -o loop /mnt/iso/CentOS-6.4-x86_64-LiveCD.iso /rootfs`
- mounted the squashfs.img
  - `mkdir /squashfs && mount -o loop /rootfs/LiveOS/squashfs.img /squashfs`
- mounted the ext3fs.img into the unsquash directory
  - `mkdir /unsquashdir && mount -o loop ext3fs.img /unsquashdir`
- then tar'd up the resulting image to the directory with the iso
  - `tar -C /unsquashdir -cf /mnt/iso/centos6.4.tar .`

Then docker was switched to not use WSL and user Windows containers and restarted

- docker import /location/to/tar centos:6.4
- This allows us to then use docker run to build the image with CentOS as the base image
- Some Packages from CentOS 6.8 were used in order to allow SSL TLSv1.2 connections to work
- Epel repo was added

# Building the container
`
docker build --force-rm=true --no-cache=true -t centos:6.4-livecd -f .\Dockerfile . 
&& docker builder prune; 
`

# Running container
`docker run --name centos64 --rm -it centos:6.4-livecd /bin/bash`
