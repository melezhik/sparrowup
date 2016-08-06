kill `ps -o pid,user,cmd|grep 'app.pl'|grep -v grep|perl -n -e '/(\d+)/ and print $1, " "'`

