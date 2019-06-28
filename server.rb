this_dir = File.expand_path(File.dirname(__FILE__))

lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

data_dir = File.join(this_dir, 'datas')
$LOAD_PATH.unshift(data_dir) unless $LOAD_PATH.include?(data_dir)


