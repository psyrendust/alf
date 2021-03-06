::#
::# Script for bootstraping your Windows environment.
::#
::# Authors:
::#   Larry Gordon
::#
::# License:
::#   The MIT License (MIT) <http://psyrendust.mit-license.org/2014/license.html>
::# ------------------------------------------------------------------------------


:: Install chocolatey package manager
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin

:: Install some default packages
choco install ConEmu Cygwin ruby ruby.devkit nodejs

:: Install default Cygwin packages
choco cygwin install _autorebase _update-info-dir alternatives autoconf autoconf2.1 autoconf2.5 automake automake1.10 automake1.11 automake1.12 automake1.13 automake1.14 automake1.4 automake1.5 automake1.6 automake1.7 automake1.8 automake1.9 base-cygwin base-files bash bash-completion binutils bison bzip2 ca-certificates chere colorgcc coreutils crypt csih curl cygrunsrv cygutils cygwin cygwin32 cygwin32-binutils cygwin32-gcc-core cygwin32-libiconv cygwin32-ncurses cygwin32-readline cygwin32-w32api-headers cygwin32-w32api-runtime dash diffutils dos2unix editrights file findutils gamin gawk gcc-core getent gettext git git-completion git-gui git-svn gitk grep groff gsettings-desktop-schemas gzip hostname ImageMagick ipc-utils less libapr1 libaprutil1 libarchive13 libargp libasn1_8 libasprintf0 libatomic1 libattr1 libautotrace3 libblkid1 libbz2_1 libcaca0 libcairo2 libcatgets1 libcharset1 libcloog-isl4 libcom_err2 libcroco0.6_3 libcrypt0 libcurl-devel libcurl4 libdatrie1 libdb5.3 libedit0 libEMF1 libexpat1 libfam0 libffi6 libfftw3_3 libfontconfig1 libfpx1 libfreetype6 libgcc1 libgcrypt-devel libgcrypt11 libgd2 libgdbm4 libgdk_pixbuf2.0_0 libgif4 libGL1 libglapi0 libglib2.0_0 libGLU1 libglut3 libgmp10 libgomp1 libgpg-error-devel libgpg-error0 libgraphite2_3 libgs9 libgssapi3 libharfbuzz0 libheimbase1 libheimntlm0 libhx509_5 libICE6 libiconv libiconv-devel libiconv2 libicu51 libidn11 libintl8 libiodbc2 libisl10 libjasper1 libjbig2 libjpeg8 libkafs0 libkrb5_26 liblcms2_2 libltdl7 liblzma5 liblzo2_2 libMagick-devel libMagickCore5 libmetalink3 libming1 libmpc3 libmpfr4 libmysqlclient18 libncursesw10 libneon27 libnettle4 libopenldap2_4_2 libopenssl100 libp11-kit0 libpango1.0_0 libpaper-common libpaper1 libpcre1 libpixman1_0 libpng15 libpopt0 libpq5 libproxy1 libpstoedit0 libquadmath0 libreadline7 libroken18 librsvg2_2 libsasl2_3 libserf1_0 libSM6 libsqlite3_0 libssh2_1 libssp0 libstdc++6 libtasn1_6 libthai0 libtiff5 libtool libuuid1 libwind0 libwrap0 libX11-xcb1 libX11_6 libXau6 libxcb-glx0 libxcb-render0 libxcb-shm0 libxcb1 libXdmcp6 libXext6 libXft2 libXi6 libxml2 libxml2-devel libXpm4 libXrandr2 libXrender1 libxslt libxslt-devel libXss1 libXt6 libyaml-devel libyaml0_2 libzzip0.13 login m4 make man mingw-binutils mingw-bzip2 mingw-gcc-core mingw-gcc-fortran mingw-gcc-g++ mingw-gcc-objc mingw-libbz2-devel mingw-libbz2_2 mingw-libminizip-devel mingw-libminizip1 mingw-minizip mingw-pthreads mingw-runtime mingw-w32api mingw-zlib mingw-zlib-devel mingw-zlib1 mingw64-i686-binutils mingw64-i686-bzip2 mingw64-i686-gcc-core mingw64-i686-gcc-fortran mingw64-i686-gcc-g++ mingw64-i686-headers mingw64-i686-libgcrypt mingw64-i686-libgpg-error mingw64-i686-minizip mingw64-i686-pthreads mingw64-i686-runtime mingw64-i686-winpthreads mingw64-i686-xz mingw64-i686-zlib mingw64-x86_64-binutils mingw64-x86_64-bzip2 mingw64-x86_64-gcc-core mingw64-x86_64-gcc-fortran mingw64-x86_64-gcc-g++ mingw64-x86_64-headers mingw64-x86_64-libgcrypt mingw64-x86_64-libgpg-error mingw64-x86_64-minizip mingw64-x86_64-pthreads mingw64-x86_64-runtime mingw64-x86_64-winpthreads mingw64-x86_64-xz mingw64-x86_64-zlib mintty nano ncurses openssh openssl openssl-devel p11-kit p11-kit-trust patch perl perl-Error pkg-config popt python python-tkinter rebase rsync run sed sqlite3 subversion subversion-perl tar tcl tcl-tix tcl-tk tcsh terminfo texinfo tzcode unzip util-linux vim vim-common vim-minimal w32api-headers w32api-runtime wget which xxd xz zlib zlib-devel zlib0 zsh zziplib

:: Install alf
call "C:\cygwin64\bin\zsh" --login -i -c "mkdir -p $HOME/.alf/repos/frameworks && git clone https://github.com/psyrendust/alf.git $HOME/.alf/repos/frameworks/alf"

:: Startup the bootstrap-shell installer
call "C:\cygwin64\bin\zsh" --login -i -c "$HOME/.alf/repos/frameworks/alf/tools/bootstrap-shell.zsh"
