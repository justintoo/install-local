#!/bin/bash
called=$_
filename="${BASH_SOURCE[@]}"
directory="$(cd "$(dirname ${filename})" && pwd)"
bin="${directory}/bin"
export PATH="${bin}:${PATH}"

cat <<EOF
[SUCCESS] Added install-local to your \${PATH}: '${bin}'
EOF

