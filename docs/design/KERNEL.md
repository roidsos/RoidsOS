# The design of the RoidsOS kernel(h0r.net)
## 1. Initialization
Hornet has a built in init system named `wakeup`. Its role is to start up all tasks in RoidsOS. It recognizes `3` types of objects:
1. `Services` are processes ran in the background, they are like Unix daemons.
1. `Groups` are sets of `services` that are ran one after another
1. `Kernel modules` are special executables that get ran in `Kernel` or `Driver` space.</br> `Drivers` are a special type of them. They have special powers like being able to export system functions,callable by any process .   
### 1.1 The Main Config file
The config file may look like this:
```ini
[system]
shell="/bin/shashlik"
reg_syshive="/sys/registery/main.reg"
startup_group_id="root"
```
and here are the field definitions:
1. `system.shell`(`string`): The adress of the shell
1. `system.reg_syshive`(`string`): the SYSTEM hive of the registery
1. `system.startup_group_id`(`string`): the group that gets called right after `wakeup_init_hw` is done initializing hardware components
### 1.2 Service Files
They may look like this:
```ini
[service]
id="ssound"
name="Login Sound Player"
desc="Plays the login sound, thats just it"
group_id="on_login"
path="/usr/sanyika/desktop/not_sex_noises.wav"
exec="terminal-jukebox --noui ${this.path}"
root=true # execute as root, needed to acceess Sanyika's desktop
```
And here are the field definitions:
1. `service.id`(`string`): The identifier of the service 
1. `service.name`(`string`,***optional***): Human friendly name of the service, useful for viewing with GUI tools 
1. `service.desc`(`string`,***optional***): Human friendly description of the service, useful for viewing with GUI tools 
1. `service.group_id`(`string`): The group that the service is in, and gets called with 
1. `service.exec`(`string`): The executable that gets executed when the service is called, plus the arguments it takes, separated by spaces
1. `service.root`(`boolean`): Whether to run it as root, or the currently logged in user
1. **custom fields**(*any type*,***optional***): Service specific information  
### 1.3 Group files
They may look like this:
```ini
[group]
id="root"

[subgroups]
drivers="./drivers.g"
filesys="./filesys.g"

[post]
exec="/bin/logonui"
```
and here are the field definitions:
1. `group.id`(`string`): the ID of the group
1. `subgroups.*`(`string`): the path of a sub-group
1. `post.exec`(`string`,***optional***): the command that gets called after all the subgroups are done running
## 2. Driver model
TBA
## 3. Registery
### 3.1 Terminology
1. `hive`: The biggest unit of registerym it has everything inside it</br>
1. `key`: It is like a folder</br>
1. `subkey`: It is like a folder in a folder</br>
1. `entry`: A single value.
### 3.2 Structure
there are 2 hives:

- System
- Software

System is for the main system. It contains the main configuration of the OS, for example user settings etc.

Software is for programs. It contains information about the installed programs, their version, the users that own them, etc.

#### 3.3 Accessing the registery

The registery huves are on hard disk in form of `.reg` files.

Accessing the registery is done through the `reg_mount` syscall that mounts a hive to the SIV(Secondary Indexed VFS), where it can be mounted, or traversed

Each key gets turned into a directory, and each entry gets turned into a file

## 4. Filesystem
TBA
## 5. Processes and threads
TBA