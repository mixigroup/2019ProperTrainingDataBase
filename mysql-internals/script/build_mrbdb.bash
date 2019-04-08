cmake /opt/mysql-server -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/tmp/boost
make -j4 mrbdb
cp ./plugin_output_directory/ha_mrbdb.so /usr/lib/mysql/plugin/
