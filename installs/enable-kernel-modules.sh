#!/bin/bash
set -Eeuo pipefail

container_memory_enable() {
  local CMDLINE_PATH

  CMDLINE_PATH=/boot/firmware/cmdline.txt

  options=(
    cgroup_enable=cpuset
    cgroup_enable=memory
    cgroup_memory=1
  )

  if ! grep "${options[*]}" <"$CMDLINE_PATH" &>/dev/null; then
    printf " %s" "${options[@]}" >>"$CMDLINE_PATH"
  fi
}

nfs_enable() {
  modprobe {nfs,nfsd,rpcsec_gss_krb5}
}

container_memory_enable
nfs_enable
