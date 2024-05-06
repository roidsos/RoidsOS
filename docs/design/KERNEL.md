# The design of the RoidsOS kernel(h0r.net)
## 1. Initialization
Hornet has a built in init system named `wakeup`.
Its role is to start up all tasks in RoidsOS.
It expects the configuration file to be located at `/sys/wu.conf`, and the task files to be located in `/sys/wutasks/`, and they must be symlinks to services in `/sys/wuservs/`. The config file may look like this:
```ini
[system]
shell="/bin/shashlik"
reg_syshive="/sys/registery/main.reg"
```
a service file may look like this:
```ini
[service]
id="ssound"
desc="Plays the startup sound"
group_ID="on_login"
path="/usr/sanyika/desktop/not_sex_noises.wav"
exec="terminal-jukebox --noui ${this.path}"
root=true # execute as root, needed to acceess Sanyika's desktop
```
and a group like this:
```ini
[group]
id="root"

[subgroups]
drivers="./drivers.g"
filesys="./filesys.g"

[post]
exec="/bin/logonui"
```
## 2. Registery
### 2.1 Terminology
`hive`: The biggest unit of registerym it has everything inside it</br>
`key`: It is like a folder</br>
`subkey`: It is like a folder in a folder</br>
`entry`: A single value.
### 2.2 Structure
there are 2 hives:

- System
- Software

System is for the main system. It contains the main configuration of the OS, for example user settings etc.

Software is for programs. It contains information about the installed programs, their version, the users that own them, etc.

#### 2.3 Accessing the registery

The registery huves are on hard disk in form of `.reg` files.

Accessing the registery is done through the `reg_mount` syscall that mounts a hive to the SIV(Secondary Indexed VFS), where it can be mounted, or traversed

Each key gets turned into a directory, and each entry gets turned into a file

## 3. Filesystem
TBA
## 4. Processes and threads
TBA