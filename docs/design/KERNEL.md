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
The thing is copied straight from NT lmao.
## 3. Filesystem
TBA
## 4. Processes and threads
TBA