#!/bin/bash -e

function install_libtool_dependencies() {
  installdir="$1"
  install-local install automake 1.14
}

function install_libtool() {
  version="$1"
  installdir="$2"
  setup_file="${installdir}/setup.sh"
  srcdir="$(pwd)/libtool-${version}"
  tarball="libtool-${version}.tar.xz"
  download_url="http://ftp.gnu.org/gnu/libtool/${tarball}"

  echo "version=${version}"
  echo "installdir=${installdir}"
  echo "setup_file=${setup_file}"
  echo "srcdir=${srcdir}"
  echo "tarball=${tarball}"
  echo "download_url=${download_url}"

  #-------------------------------------------------------------------------------
  # Install dependencies
  #-------------------------------------------------------------------------------
  install_libtool_dependencies "${installdir}"
  # TODO:
  # install-local use automake 1.14 --silent | while read setup_cmd; do
  #   echo "${setup_cmd}"
  #   eval ${setup_cmd}
  #   which autoconf
  #   installdir="${installdir}/autoconf/2.69"
  # done
 
  #-------------------------------------------------------------------------------
  # Download and unpack
  #-------------------------------------------------------------------------------
  if [ ! -f "$tarball" -a ! -f "${tarball%.xz}" ]; then
      echo "[INFO] Downloading Libtool '$download_url'"
      wget --verbose "$download_url" || exit 1
  else
      echo "[INFO] [SKIP] Libtool tarball already exists: '$tarball'"
  fi
  
  if [ ! -d "$srcdir" ]; then
      echo "[INFO] Unpacking Libtool tarball: '$tarball'"
      unxz "$tarball" || exit 1
      tar xvf "${tarball%.xz}"
  else
      echo "[INFO] [SKIP] Libtool source code already exists: '$srcdir'"
  fi
  
  #-------------------------------------------------------------------------------
  # Build and install
  #-------------------------------------------------------------------------------
  cd "${srcdir}"
  
  if [ ! -e "${installdir}/bin" ]; then
      echo "[INFO] Configuring Libtool"
      echo "[INFO] Installing to '$installdir'"
  
      "${srcdir}/configure" --prefix="$installdir" || exit 1
  
      make -j all || exit 1
      make -j install || exit 1
  fi
  
      echo "[INFO] Creating Libtool environment setup file ${setup_file}"
      cat > "${setup_file}" <<-EOF
#!/bin/bash
#
# Automatically generated by $0 on $(date)

# TODO:
$(install-local use automake 1.14 --silent)

export LIBTOOL_VERSION="${version}"
export LIBTOOL_HOME="${installdir}"
export PATH="\${LIBTOOL_HOME}/bin:\${PATH}"
EOF
}
