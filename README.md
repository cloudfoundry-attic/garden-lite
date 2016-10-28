# GARDEN-LITE

`garden-lite` is a standalone garden vagrant box created with packer.

## Usage:

* Starting up the vm:
```
git clone https://github.com/tscolari/garden-lite
cd garden-lite
vagrant up
```

* Connecting to garden

The easier way to spin up a container in garden is to use the `gaol` tool. 
Download -> https://github.com/contraband/gaol/releases

```
gaol -t 192.168.150.4:7777 create -r docker:///busybox -n my-image
gaol -t 192.168.150.4:7777 shell my-image
gaol -t 192.168.150.4:7777 destroy my-image
```

