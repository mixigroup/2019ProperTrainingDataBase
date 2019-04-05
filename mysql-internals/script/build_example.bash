cmake /opt/mysql-server -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/tmp/boost
make example
cp ./plugin_output_directory/ha_example.so /usr/lib/mysql/plugin/
