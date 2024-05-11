# The design of the RoidsOS kernel(h0r.net)
Note: since typing h0r.net is hard and takes a long time, I will drop the stylization and just type Hornet. 
## 1. Kernel architecture
### 1.3 Privilege levels
1. `Kernel space`: `ring 0` on **x86_64**
1. `Driver space`: `ring 1-2` on **x86_64**
1. `User space`: `ring 3` on **x86_64**
### 1.2 General Architecture
Hornet is a `hybrid kernel`
## 2. Initialization
Hornet has a built in init system named `wakeup`. Its role is to start up in RoidsOS. It recognizes `3` types of objects:
1. `Services` are processes run in the background, they are like Unix demons.
1. `Groups` are sets of `services` that are run one after another.
1. `Kernel modules` are special executables that are run in `Kernel` or `Driver` space.</br> `Drivers` are a special type of them. They have special privileges like being able to export system functions, callable by any process.
### 2.1 The Main Config file
The config file may look like this:
```ini
[system]
shell="/bin/shashlik"
reg_syshive="/sys/registery/main.reg"
startup_group_id="root"
```
And here are the field definitions:
1. `system.shell`(`string`): The path to the shell.
1. `system.reg_syshive`(`string`): The `SYSTEM` hive of the registery.
1. `system.startup_group_id`(`string`): The group that gets called right after `wakeup_init_hw` is done initializing hardware components.
### 2.2 Service Files
They may look like this:
```ini
[service]
id="ssound"
name="Login Sound Player"
desc="Plays the login sound, thats just it"
group_id="on_login"
path="/usr/sanyika/desktop/not_sex_noises.wav" # this is a custom field that may be used in exec or anywhere really
exec="terminal-jukebox --noui ${this.path}"
root=true # execute as root, needed to acceess Sanyika's desktop
```
And here are the field definitions:
1. `service.id`(`string`): The identifier of the service. 
1. `service.name`(`string`,***optional***): Human friendly name of the service, useful for viewing with GUI tools.
1. `service.desc`(`string`,***optional***): Human friendly description of the service, useful for viewing with GUI tools. 
1. `service.group_id`(`string`): The group that the service is in, and gets called with. 
1. `service.exec`(`string`): The executable that gets executed when the service is called, plus the arguments it takes, separated by spaces.
1. `service.root`(`boolean`): Whether to run it as root, or the currently logged in user.
1. **custom fields**(*any type*,***optional***): Service specific information.
### 2.3 Group files
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
1. `group.id`(`string`): The ID of the group.
1. `subgroups.*`(`string`): The path of a sub-group.
1. `post.exec`(`string`,***optional***): The command that gets called after all the subgroups are done running.
## 3. Driver model
ummmmmmm
```c
typedef struct {
    char* name;
    (*init)();
} header_idk;
```
??????
## 4. Registery
### 4.1 Terminology
1. `hive`: The biggest unit of registery.
1. `key`: It is like a directory.
1. `entry`: A single value.

### 4.2 Entry Types
1. `0x0`: `I8`: 8 bit signed integer.
1. `0x1`: `I16`: 16 bit signed integer.
1. `0x2`: `I32`: 32 bit signed integer.
1. `0x2`: `I64`: 64 bit signed integer.
1. `0x3`: `U8`: 8 bit unsigned integer.
1. `0x4`: `U16`: 16 bit unsigned integer.
1. `0x5`: `U32`: 32 bit unsigned integer.
1. `0x5`: `U64`: 64 bit unsigned integer.
1. `0x6`: `BOOL`: A boolean.
1. `0x7`: `CHAR`: A unicode character, it is 32 bits wide.
1. `0x8`: `SZ`: A string in the system's preferred encoding, zero-terminated.
1. `0x9`: `FLOAT`: A 32-bit floating point number.
1. `0xA`: `DOUBLE`: A 64-bit floating point number.
### 4.3 Structure
there are `3` hives:

- `SYSTEM`
- `USER`
- `HARDWARE`

`SYSTEM` is for the main system. It contains the main configuration of the OS.

`USER` is for programs. It contains information about the installed programs, their version, the users that own them, etc.

`HARDWARE` is for hardware configuration.

#### A `hive` file header:
Header:
```c
typedef struct {
    uint64_t magic;   // a magic value meant to verify whether this file is actually a hive file
    uint32_t num_keys // the number of keys in the file
    uint8_t checksum; // a checksum that makes all bytes add up to 0x00
    char name[64];    // the name of the hive
} hive_header;

```
After the header comes `num_keys` key fields.
#### A `key` field
Header:
```c
typedef struct {
    uint32_t magic;         // magic number(0xB16B00B5)
    uint32_t num_entries;   // the number of entries
    uint32_t num_subkeys;   // the number of subkeys
    char name[64];          // the name of the key
} key_header;
```
After the header comes `num_entries` entry fields, and `num_subkeys` keys after that.
#### An `entry` field
Header:
```c
typedef struct {
    uint8_t type;   // The type of the entry.
    uint8_t length; // The length of the entry not including the header.
} entry header
``` 
After that comes `length` bytes of data.

#### 4.4 Accessing the registery

The registery huves are on hard disk in form of `.reg` files.

Accessing the registery is done through the `reg_mount` syscall that mounts a hive to the SIV(`Secondary Indexed VFS`), where it can be mounted, or traversed.

Each key gets turned into a directory, and each entry gets turned into a file

## 5. Filesystem
Hornet its VFS split in half, one half is the `Primary Mounting VFS`, the other is the `Secondary Indexed VFS`. 
#### 5.0 Abbriviations
1. `PMV` : Primary Mounting VFS.
1. `SIV` : Secondary Indexed VFS.
###  5.1 The roles of the 2 halves
The `PMV`'s role is to convert unix-like paths into `SIV` paths. The `SIV`'s role is to handle opening and closing files, abstract FS operations away, and whatever else a VFS has to do.

### 5.2 syscalls
1. `sys_open`: Opens a file.(`RBX`=`file path`,`RCX`=`pointer to the file ID`)
1. `sys_close`: Closes a file.(`RBX`=`file ID`)
1. `sys_read`: Reads from an **opened** file.(`RBX`=`file ID`, `RCX`=`offset`,`RDX`=`value pointer`)
1. `sys_write`: Writes to an **opened** file.(`RBX`=`file ID`, `RCX`=`offset`,`RDX`=`value`)
1. `sys_create`: Creates a file or directory.(`RBX`=`file path`,`RCX`=`recursive?`)
1. `sys_delete`: Deletes a file or directory.(`RBX`=`file path`)
1. `sys_modify`: Modifies a fiel or directory.(`RBX`=`file ID`,`RCX`=`field ID`,`RDX`=`value`)
## 6. Processes and threads
ye ye the h0r.net scheduler currently is a dead simple Round Robin, Ik Ik its bad
### 6.1 Process states
there are 4 process states in h0r.net:
1. `nonexistant`: The process slot is not occupied.
1. `ready`: The process can be scheduled without problem.  
1. `blocked`: The process is blocked and shouldn't be scheduled.
1. `dead`: The process has been killed or exited and must be cleaned up.