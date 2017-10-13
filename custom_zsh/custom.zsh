#  Sections:
#  0.   Variables Definitions
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   Reminders & Notes
# 10.   Proxy specific
# 11.   Personal

#  ---------------------------------------------------------------------------

#   -------------------------------
#   -------------------------------
#   0.  VARIABLES DEFINITIONS
#   -------------------------------
#   -------------------------------

#   Proxy settings
#   ------------------------------------------------------------
proxyUser=''
proxy=''
proxyPort=''
noProxies=''
noProxiesJVM=''

# Tunneling
forwardUser=''
forwardServer=''

# Read proxy vars
[ -f ~/.dotfiles/proxy_vars.sh ] && source ~/.dotfiles/proxy_vars.sh


#   -------------------------------
#   -------------------------------
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------
#   -------------------------------

#   Variables
#   ------------------------------------------------------------
export JAVA_HOME=$(/usr/libexec/java_home)
export MAVEN_OPTS="-Xmx512m -XX:MaxPermSize=128m"
export GOPATH=$HOME/Development/go

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
export BLOCKSIZE=1k

#   Color manpages
#   from http://www.tuxarena.com/2012/04/tutorial-colored-man-pages-how-it-works/
#   ------------------------------------------------------------
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[01;32m' # begin underline

#   -----------------------------
#   -----------------------------
#   2.  MAKE TERMINAL BETTER
#   -----------------------------
#   -----------------------------

alias vim='/usr/local/bin/nvim'              # Use vim from brew
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
#alias less='less -FSRXc'                   # Preferred 'less' implementation
#cd() { builtin cd "$@"; ll; }              # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='code'                           # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
#alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
alias dsclean='find . -type f -name .DS_Store -print0 | xargs -0 rm' # dsclean: # Get rid of those pesky .DS_Store files recursively
rz () { curr=`pwd` && cd && . ~/.zshrc && cd $curr && echo "re-read zsh"; }
ez () { vim ~/.zshrc; }
ezc () { vim ~/my_custom/custom.zsh; }
eh () { vim ~/.zsh_history; }
brewFullUpdate () { brew update && brew upgrade && brew cleanup; }

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'


#   -------------------------------
#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------
#   -------------------------------

zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

#   compress:  compress folder with one command
#   ---------------------------------------------------------
function compress() {
    dirPriorToExe=`pwd`
    dirName=`dirname $1`
    baseName=`basename $1`

    if [ -f $1 ] ; then
    echo "It was a file change directory to $dirName"
    cd $dirName
        case $2 in
            tar.bz2)
            tar cjf $baseName.tar.bz2 $baseName
            ;;
            tar.gz)
            tar czf $baseName.tar.gz $baseName
            ;;
            gz)
            gzip $baseName
            ;;
            tar)
            tar -cvvf $baseName.tar $baseName
            ;;
            zip)
            zip -r $baseName.zip $baseName
            ;;
            *)
            echo "Method not passed compressing using tar.bz2"
            tar cjf $baseName.tar.bz2 $baseName
            ;;
        esac
        echo "Back to Directory $dirPriorToExe"
        cd $dirPriorToExe
    else
    if [ -d $1 ] ; then
        echo "It was a Directory change directory to $dirName"
        cd $dirName
        case $2 in
        tar.bz2)
            tar cjf $baseName.tar.bz2 $baseName
            ;;
        tar.gz)
            tar czf $baseName.tar.gz $baseName
            ;;
        gz)
            gzip -r $baseName
            ;;
        tar)
            tar -cvvf $baseName.tar $baseName
            ;;
        zip)
            zip -r $baseName.zip $baseName
            ;;
        *)
            echo "Method not passed compressing using tar.bz2"
            tar cjf $baseName.tar.bz2 $baseName
            ;;
        esac
        echo "Back to Directory $dirPriorToExe"
        cd $dirPriorToExe
    else
        echo "'$1' is not a valid file/folder"
    fi
    fi
    echo "Done"
    echo "###########################################"
}

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
extract () {
    if [ -f $1 ] ; then
        case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
            esac
        else
            echo "'$1' is not a valid file"
        fi
}

#   ---------------------------
#   ---------------------------
#   4.  SEARCHING
#   ---------------------------
#   ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


#   ---------------------------
#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


#   ---------------------------
#   ---------------------------
#   6.  NETWORKING
#   ---------------------------
#   ---------------------------

alias myip='curl ip.appspot.com'                                        # myip:         Public facing IP Address
alias netCons='lsof -i'                                                 # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'                                # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'                                 # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'                       # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'                       # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'                                  # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'                                  # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'                            # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                                      # showBlocked:  All ipfw rules inc/ blocked IPs
alias forward7070='ssh -C -nNT -D 7070 ${forwardUser}@${forwardServer}' # forward7070:  creates a ssh forward on port 7070 to the forward server

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}

#   ---------------------------------------
#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------
#   ---------------------------------------

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------
alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'


#   ---------------------------------------
#   ---------------------------------------
#   8.  WEB DEVELOPMENT
#   ---------------------------------------
#   ---------------------------------------

alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

#   cJson: perfom a post with json content
#
#   example: cJson '{"username":"mvtest", "body":"bash rocks!"}' localhost:3000/api/posts
#   -------------------------------------------------------------------
alias cJson='curl -v -H "Content-Type: application/json" -XPOST --data'


#   dlWebSite: download the website via wget and makes
#              it available offline
#   -------------------------------------------------------------------
stripDomain () { echo $1 | sed -e 's#http[s]*://##' -e 's#www[0-9]*\.##' -e 's#/.*$##' ; }
dlWebSite () {	wget --recursive --no-clobber --page-requisites	--html-extension --convert-links --domains `stripDomain $1`	--no-parent	$1 ; }

#   urlencode & urldecode: encode and decode a string
#   -------------------------------------------------------------------
urlencode() {
    # urlencode <string>
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%s' "$c" | xxd -p -c1 |
                while read c; do printf '%%%s' "$c"; done ;;
        esac
    done
}

urldecode() {
    # urldecode <string>
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}


#   ---------------------------------------
#   ---------------------------------------
#   9.  REMINDERS & NOTES
#   ---------------------------------------
#   ---------------------------------------

#   remove_disk: spin down unneeded disk
#   ---------------------------------------
#   diskutil eject /dev/disk1s3

#   to change the password on an encrypted disk image:
#   ---------------------------------------
#   hdiutil chpass /path/to/the/diskimage

#   to mount a read-only disk image as read-write:
#   ---------------------------------------
#   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

#   mounting a removable drive (of type msdos or hfs)
#   ---------------------------------------
#   mkdir /Volumes/Foo
#   ls /dev/disk*   to find out the device to use in the mount command)
#   mount -t msdos /dev/disk1s1 /Volumes/Foo
#   mount -t hfs /dev/disk1s1 /Volumes/Foo

#   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
#   ---------------------------------------
#   e.g.: mkfile 10m 10MB.dat
#   e.g.: hdiutil create -size 10m 10MB.dmg
#   the above create files that are almost all zeros - if random bytes are desired
#   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat


#   ---------------------------------------
#   ---------------------------------------
#   10. Proxy specific
#   ---------------------------------------
#   ---------------------------------------
command_exists () {
    type "$1" &> /dev/null ;
}
#
# sets auth for a proxy of the given variables set above
#
set_http_proxy() {
    if [[ -z ${proxy} ]]; then
        echo "No 'proxy' variable set in bashrc!"
    else
        local fullProxyString='';
        if [[ -z ${proxyUser} ]]; then
            fullProxyString="http://${proxy}:${proxyPort}";
        else
            read -p "Please enter a password for proxy '${proxyUser}@${proxy}:${proxyPort}':" -s proxyPwd;
            echo "";
            echo -n  "its sha1 is: " && echo "$proxyPwd" | shasum;

            fullProxyString="http://${proxyUser}:${proxyPwd}@${proxy}:${proxyPort}";
        fi

        echo "-> setting env variables";
        export http_proxy=${fullProxyString};
        export https_proxy=${fullProxyString};
        export HTTP_PROXY=${fullProxyString};
        export HTTPS_PROXY=${fullProxyString};
        export FTP_PROXY=${fullProxyString};
        export JAVA_OPTS="${JAVA_OPTS} -Dhttp.proxyHost=${proxy} -Dhttp.proxyPort=${proxyPort} -Dhttps.proxyHost=${proxy} -Dhttps.proxyPort=${proxyPort} -Dhttp.nonProxyHosts=${noProxiesJVM} -Dhttps.nonProxyHosts=${noProxiesJVM}"
        if [[ -n ${proxyUser} ]]; then
            export JAVA_OPTS="${JAVA_OPTS} -Dhttp.proxyUser=${proxyUser} -Dhttp.proxyPassword=${proxyPwd} -Dhttps.proxyUser=${proxyUser} -Dhttps.proxyPassword=${proxyPwd}"
        fi
        export ALL_PROXY=${fullProxyString};
        export no_proxy=${noProxies};
        export NO_PROXY=${noProxies};

        if command_exists npm ; then
          echo "-> setting npm proxy";
          npm config set proxy ${fullProxyString};
          npm config set https-proxy ${fullProxyString};
        fi

        if command_exists git ; then
          echo "-> setting git proxy";
          git config --global http.proxy ${fullProxyString};
          git config --global https.proxy ${fullProxyString};
        fi

        if [ -s ~/.m2/settings.xml ]; then
          echo "-> setting maven proxy in ~/.m2/settings.xml";
          sed -E -e 's#(<!--)*<proxy>#<proxy>#' -e 's#</proxy>(-->)*#</proxy>#' -io ~/.m2/settings.xml
        fi

        # clear variables
        proxyPwd="";
        fullProxyString="";
        echo "=> done!";
    fi
}

#
# unsets auth for the proxy
#
unset_http_proxy() {

    echo "-> unsetting env variables";
    unset http_proxy;
    unset https_proxy;
    unset HTTP_PROXY;
    unset HTTPS_PROXY;
    unset FTP_PROXY;
    unset ALL_PROXY;
    unset no_proxy;
    unset NO_PROXY;
	unset JAVA_OPTS;

    if command_exists npm ; then
      echo "-> unsetting npm proxy";
      npm config delete proxy;
      npm config delete https-proxy;
    fi

    if command_exists git ; then
      echo "-> unsetting git proxy";
      git config --global --remove-section http
      git config --global --remove-section https
    fi

    if [ -s ~/.m2/settings.xml ]; then
      echo "-> unsetting maven proxy in ~/.m2/settings.xml";
      sed -E -e 's#(<!--)*<proxy>#<!--<proxy>#' -e 's#</proxy>(-->)*#</proxy>-->#' -io ~/.m2/settings.xml
    fi

    echo "=> done";
}
