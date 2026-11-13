# Ventilator GUI

![In-Action](in-action.png)

Here resides the code for the ventilator graphical user interface. It is based on QT and runs on Raspberry Pi (henceforth "*RPi*").

Please also see the [Software design pages](../design/GUI_architecture.md) for more information on GUI architecture.

## Requirements

For development purposes you may build and run it locally on a Linux or macOS machine of your choice.

To deploy it as intended for the ventilator you will need:
* Rasberry Pi 4
* SD card
* Card reader USB

A more complete list of hardware components is on the
[Electronics sub-assembly page](../../manufacturing/internals/electronics).

If you are not actively working on the code for this application but simply need it for prototype testing, you will probably want to use the [automated deployment scripts](../bootstrap).

## Building the GUI

The GUI requires Qt 6 development libraries and QML runtime modules, including Qt Multimedia, SerialPort, SVG, Quick Controls, and Qt5Compat Graphical Effects. Use a distribution that supplies these packages; the older Raspberry Pi OS Bullseye image previously used by this project is not a verified Qt 6 deployment target. Target-device rendering, audio and serial behavior must be validated separately.

The [gui.sh](gui.sh) script does almost everything you need:
* installs dependencies
* builds the app
* runs the app
* runs unit tests

The script should work for most debian systems using `apt` as the package manager. It should also work on macOS. For a comprehensive list of commands and options you can always run:

```
./gui.sh help
```

Here is a quick summary of some of those options (which may not be up to date).

To install dependencies, run:
```
./gui.sh install
```

To build the application, run:

```
./gui.sh build
```

You can run this latest step with `-j` option to make it faster, but when compiling on *RPi* you may run out of virtual memory.

You can also compile with `--debug` option. You will see additional information on the screen, and logs will be more detailed (`debug` and `trace` level messages will be written), and will output to both console and log file.

### Mac OS X

Install Qt 6 with Homebrew (`brew install qt`) or the Qt Online Installer, including Multimedia, SerialPort and Qt 5 Compatibility Module. Set `CMAKE_PREFIX_PATH` to the Qt 6 installation prefix if CMake cannot discover it. macOS has not been verified as part of this migration.

### Installing Qt Creator (optional)

It is possible to develop the GUI without using Qt Creator, but it is convenient to use Creator for editing the qml layout files.

Note that any resources (e.g. images, all qml files) need to be referenced in the qml.qrc file.

To install Qt Creator on Linux, use:
```
sudo apt-get install qtcreator
```

### Running

Upon a successful compilation, you can run the app like so:

```
./gui.sh run --serial-port /dev/ttyS0
```

Where you may specify whatever serial port the ventilator controller is for the GUI to communicate with. The above has been the correct port for all prototypes tested to date.

If you do not specify a serial-port, the app will run with pre-recorded data.

If you are running the application remotely, via ssh for example, don't forget to set the display environment variable:
```
export DISPLAY=:0
```

### Testing

To run unit tests, type:

```
./gui.sh test
```

After building both application and test targets, run `ctest --test-dir build --output-on-failure` to run the backend tests and the headless QML startup smoke test. Startup without `--serial-port` uses recorded data and does not connect to hardware.

### Logs & debugging

Timestamped logs written by the app should be found locally at:

```
$HOME/.local/share/RespiraWorks/VentilatorUI/gui.log
```

Upon start, the application will log the git hash of the commit it was built from.

If app was built in release mode, messages down to `info` level should be seen. In debug mode, `debug` as well as `trace` level messages will also be written to log.

If you want to add additional debug messages, refer to [logger.h](src/logger.h). This is a thread-safe logger. Log macros accept [fmt](https://github.com/fmtlib/fmt) syntax.

### Screen resolution issues

The qml layout has been designed for a resolution of 1024x600, in case of the display defaulting to some other setting, this messes up the GUI layout. If this randomly happens to you (it did to me), add the following to the /boot/config.txt file on your *RPi*.
```
hdmi_cvt=1024 600 60 3 0 0 0

# uncomment to force a specific HDMI mode (this will force VGA)
hdmi_group=2
hdmi_mode=87
```
