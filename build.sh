#!/bin/sh
here=`dirname $0`
name=jboss-6.0.0
archive=$here/tmp/jboss-as-distribution-6.0.0.Final.zip

die() {
	echo $1;
	exit 1;
}

rm -Rf $here/src/var/lib/jboss
sudo rm -Rf $name
mkdir -p $here/src/var/log/jboss src/var/lib/jboss $here/tmp
if [ ! -f $archive ]; then
	echo -n "Downloading JBoss Application Server 6.0.0 archive ... "
	wget http://freefr.dl.sourceforge.net/project/jboss/JBoss/JBoss-6.0.0.Final/jboss-as-distribution-6.0.0.Final.zip -O $archive > /dev/null 2> /dev/null || die "failed"
	echo "done"
fi
echo -n "Extracting archive ... "
unzip $archive -d $here/src/var/lib > /dev/null 2> /dev/null || die "failed"
echo "done"
mv $here/src/var/lib/jboss-6.0.0.Final $here/src/var/lib/jboss
echo -n "Tainting configuration files ... "
find $here/src/var/lib/jboss -type f -exec sed -i 's/8080/${jboss.http}/g' {} \;
find $here/src/var/lib/jboss -type f -exec sed -i 's/8443/${jboss.https}/g' {} \;
echo "done"
sudo cp -R $here/src $here/$name
echo -n "Packaging ... "
dpkg --build $here/$name > /dev/null 2> /dev/null || die "failed"
echo "done"
