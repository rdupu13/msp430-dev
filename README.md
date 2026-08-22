# MSP430 Project Template

Project template for programming with the TI MSP430 Microcontroller family.


## Repository organization

- :file_folder: [docs](docs) &mdash; Documentation
    - :file_folder: [assets](docs/assets) &mdash; Where images go
    - :file_folder: [planning](docs/planning) &mdash; Where your planning documentation goes
    - :file_folder: [procedures](docs/procedures) &mdash; Git workflow 
- :file_folder: [mcu](mcu) &mdash; MCU source code
    - :file_folder: [include](mcu/include) &mdash; Header files 
    - :file_folder: [src](mcu/src) &mdash; Source code
    - :file_folder: [test](mcu/test) &mdash; Test code
    - :file_folder: [tmp](mcu/tmp) &mdash; Template code with blinky demo
- :page_facing_up: [Makefile](Makefile) &mdash; File that defines rules for building/flashing/debugging your project.
- :page_facing_up: [.gitignore](.gitignore) &mdash; [gitignore files](https://git-scm.com/docs/gitignorehttps://git-scm.com/docs/gitignore) specify files and folders that git should ignore / not track.


## Development setup

1. Clone this repo somewhere.

2. If you haven't already, follow the steps outlined in the [**development environment setup guide**](msp430_dev_setup.md).

3. The project already contains a Makefile. Modify it to fit your platform (under "MODIFY FOR YOUR PLATFORM:"):
    - :gear: `PLATFORM` &mdash; Put `linux` or `wsl` depending on which you're using.
    - :gear: `MCU` &mdash; Microcontroller unit number you are programming, e.g. `msp430fr2355`.
    - :gear: `EXCLUDE` &mdash; Paths (relative to project root) to any files you'd like to exclude from the build.
    - :gear: `WARNFLAGS` &mdash; Compiler flags to suppress warnings of your choosing, e.g. `-Wno-implicit-function-declaration`.

4. Run the command `make flash` at the project root to compile your project and program the MSP430. Other build options include:
    - :wrench: `make` &mdash; Only compile the project, **don't** program the MSP430.
    - :wrench: `make test` &mdash; Compile only source files under [mcu/test](mcu/test).
    - :wrench: `make test-flash` &mdash; Compile only source files under [mcu/test](mcu/test) and program the MSP430.
    - :wrench: `make debug` &mdash; Compile the project, program the MSP430, and enter `mspdebug`'s debugger.
    - :wrench: `make clean` &mdash; Delete all `.out` binaries.
