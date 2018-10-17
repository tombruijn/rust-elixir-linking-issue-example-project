# Rust staticlib linking with Elixir issue example app

## Usage

```sh
./build <Rust version>
./test
```

- `./build`
    - Builds the Rust library.
    - `<Rust version>`: The Rust version is the version of the [Rust language](https://rust-lang.org/) to test against. It will automatically install it.
- `./test`
    - Load the Rust library into the Elixir app and test it.

This testing tool will follow the process described in "Build and test process details" below. Afterwards it will open a shell in which the user can do additional debugging, such as:

```sh
./bin/elixir_app stop                    # Stop application that's currently running
./bin/elixir_app foreground              # Run application in foreground
cat lib/elixir_package-0.0.1/install.log # Print install log file with error (if present)
```

### Examples

```sh
./build 1.20.0 && ./test
# Works, creates a build and complains about a missing install.log file, which is fine

./build 1.21.0 && ./test
# Fails, starts app but prints the error listed below

./build 1.29.1 && ./test
# Fails, unrelated error that's already fixed in the latest nightly

./build nightly-2018-10-08 && ./test
# Fails, starts app but prints the error listed below
```

## Unexpected error

This error occurs when linking a staticlib with the `x86_64-unknown-linux-musl` target to an Elixir app.

```
Error loading NIF (host triple: x86_64-pc-linux-musl)
Error: Failed to load NIF library: 'Error loading shared library libgcc_s.so.1: No such file or directory (needed by /app/lib/elixir_package-0.0.1/priv/elixir_package_extension.so)'
```

## Testing

### Requirements

Requirements for running this project on a macOS host machine, see "Build and test process details". This project is not optimized for a Linux host machine, but will run the same.

- [Virtualbox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

### Build and test process details

The following steps describe the automated process this project performs. No manual steps required.

1. Build extension
    - Create a virtual machine (controlled through Vagrant) that will act as the build environment.
      - You will be prompted for your password the first time to mount a NFS volume on the virtual machine.
      - Install Docker on this build machine.
    - With cross, cross compile the extension to musl.
      - This cannot be done if the host is macOS, which is why we're running this through the virtual build machine.
2. Install the extension as an Erlang [NIF](http://erlang.org/doc/man/erl_nif.html)
    - Move built extension to Elixir package (`elixir_app/elixir_package/c_src`)
    - Start a Docker image build process that compiles the Elixir app.
      - Start the first stage that compiles the app.
    - Make an app release with [distillery](https://github.com/bitwalker/distillery).
      - Compile the Elixir app.
      - Install the Erlang NIF.
      - Package the release as a zip.
3. Run the app.
    - Create a second stage for the release in which the app is run. This is a slimmer version of the Docker image than the build stage. This does not include the compilation dependencies from the first stage.
      - Copy and extract the zip file from the first stage.
    - Run the Elixir app release (including the NIF).
    - The error will be printed as the `install.log` file is read.
      - If this file is not present it will warn it cannot be found. Which is good.

### Clean up

**Note**: This testing process will create a new Docker image per build. Be sure to clean them after you're done testing.

```sh
docker rmi alpine-elixir-build-test:build
```
