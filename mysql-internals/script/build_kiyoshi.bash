cmake /opt/mysql-server -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/tmp/boost
make kiyoshi
cp ./plugin_output_directory/ha_kiyoshi.so /usr/lib/mysql/plugin/
