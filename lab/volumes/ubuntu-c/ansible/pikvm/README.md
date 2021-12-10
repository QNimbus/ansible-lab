# pikvm

## Installation

- Download and flash image to SD card

## Running playbook

Initially the host keys for the host(s) are not yet in the `~/.ssh/known_hosts` file. You can run `ansible-playbook` with additional ssh arguments or you can manually fetch the host keys before running the initial setup ansible playbook.

```bash
# Initial setup - run as root and store host keys in ~/.ssh/known_hosts file
$ ansible-playbook setup.yaml --user root --ask-pass --ssh-extra-args="-o StrictHostKeyChecking=no -o UpdateHostKeys=yes"

# Or to manually fetch host keys:
$ echo pikvm.lan.besqua.red | printf "%s\n%s" "$(cat -)" "$(getent hosts pikvm.lan.besqua.red | awk '{ print $1 }')" | xargs -n1 -r ssh-keyscan -t rsa,ed25519 > ~/.ssh/known_hosts
$ ansible-playbook setup.yaml --user root --ask-pass

# For subsequent runs:
$ ansible-playbook setup.yaml
```

