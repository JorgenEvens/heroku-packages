# Heroku Binary Package howto

This document will give an introduction to how most heroku binary packages are built for the [heroku modular buildpack](https://github.com/JorgenEvens/heroku-modular-buildpack).

## Environment

The environment used can be set up in two way. One is in a virtualized environment, for example [virtualbox](http://www.virtualbox.com). And the second, which has my preference, is using a chroot.

The base of each environment is the same, we will start using an ubuntu 10.04 installation. We will sync the packages installed in this environment with the packages that are available on a heroku dyno.

To do fast and easy builds we will be using diff-disks so we do not have to set up an environment for each individual build.

We will give an introduction here to each of the individual environments, followed by instruction on how to setup the ubuntu system inside this environment.

### Virtualized

We will be using [virtualbox](http://www.virtualbox.com) here and make use of immutable disks to generate extra build systems. We are going to assume that virtualbox is installed and you know the basic usage.

You will first need to install an ubuntu 10.04 in virtualbox, preferably a [server edition](http://mirror.as29550.net/releases.ubuntu.com/10.04/ubuntu-10.04.4-server-amd64.iso).

### Chroot

We will be making use of a [chroot helper](https://github.com/JorgenEvens/chroot-diff-disks) to set up our environments.

The quickest way to use this helper is by installing it as follows:

```shell
git clone https://github.com/JorgenEvens/chroot-diff-disks ~/.chroot-helper
export PATH="$PATH:~/.chroot-helper"
```

Next we will be setting up our chroot directory

```shell
# Setup basic environment
mkdir -p ~/chroots/base
mkdir -p ~/chroots/vm
mkdir -p ~/chroots/diff

# Create a directory for our heroku environment
mkdir -p ~/chroots/base/heroku
```

We will now be installing an ubuntu 10.04 minimal.

```shell
debootstrap lucid ~/chroots/base/heroku http://archive.ubuntu.com/ubuntu
```

To login to your your ubuntu install we will make use of the chroot helper we installed earlier.

```shell
cd ~/chroots
enter base/heroku
# You now are inside the chroot environment
```

### Sync packages

Retrieve a list of packages that are currently being used by heroku.
```shell
heroku run "dpkg --get-selections | grep -v deinstall | cut -f1" -a empty-app | grep -v -P '^Running' > heroku-packages
```

Lets create an apt-get command to use in our base image.

```shell
echo "apt-get install `tr '\n' ' ' < heroku-packages`" > apt-command
```

Now we have to login to our VM / chroot to install the packages we just selected. If you simply copy the file into your environment you can run it using `/bin/sh apt-command`.

We now have to remove packages that are "extra" in our current environment, for this you will need the heroku-packages file in your VM / chroot.

```shell
dpkg --get-selections | grep -v deinstall | cut -f1 > env-packages
apt-get --purge remove `diff heroku-packages env-packages | grep '^>' | sed 's/> //g' | tr '\n' ' '`
apt-get --purge autoremove
```

Now you will want to setup a user so you do not have to run as root in your environment. We will be creating an `/app` directory as well so it resembles heroku.

```shell
adduser your-name

mkdir -p /app
chown your-name:your-name /app
```

#### Naming convention
The install you just did will be referred to as the `base image`.

The images we are going to create next are the VM's that will be used to build the packages. We will refer to these as `buildbox`. You will be creating one of these for each package you will be building.

## Creating a buildbox

### Virtualbox

#### Setting up the disk
In virtualbox you will have to release the disk image form the `base` VM to be able to use it as a basis for other machines.

You can detach it in the virtual media manager ( File -> Virtual Media Manager ).

Once your disk has been detached you will be able to edit the disk. Do this by first selecting the disk of the base image we created earlier and click on the modify button.

In the pop up dialog you can select to make the disk immutable, do so.


#### Creating a new machine
Now you will create a new virtual machine with the same configuration as the `base` machine had. The only difference is that you will select **use existing storage** when you are asked to configure the disk. Select the disk of the `base` image.

Virtualbox will automatically create a diff disk for you, if you startup the VM now you will boot into a clean `base` image. Any modification you do now will be stored in a different disk file and the `base` image will stay untouched.

### Chroot

Using the chroot helper setting up a new disk is very easy.

```shell
cd ~/chroots
new heroku name-of-buildbox
# You now are logged in to your buildbox
```

You can use the `login` command to login to the user account you created in your base image.

## Compiling

Compile options are specific to the project you are trying to compile, some things to keep in mind:

- Always compile with a prefix that is located in `/app` ( `/app/vendor` is where most people put everything )
- If you are compiling a library you will have to setup the `LD_LIBRARY_PATH` variable on heroku.
- If you are compiling a binary, you will have to configure `PATH`

Packaging up the build you just did is as simple as:

```shell
cd /app/vendor
tar -caf my-app.tar.gz my-app
```


