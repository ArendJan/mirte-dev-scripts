git clone https://github.com/raspberrypi/picotool.git --single-branch --depth=1 # shallow clone to save space
cd picotool || exit 1
sudo cp udev/*.rules /etc/udev/rules.d/

mkdir build
cd build || exit 1
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j
sudo make install
