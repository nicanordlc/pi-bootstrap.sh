#!/bin/bash
set -Eeuo pipefail

sudo tee /etc/modules-load.d/nfs.conf <<EOF
nfs
nfsd
rpcsec_gss_krb5
EOF
