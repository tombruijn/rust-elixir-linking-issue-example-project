# Rust staticlib linking with Elixir issue example app

## Usage

```sh
./build_and_test <Rust version>
```

- The Rust version is the version of the [Rust language](https://rust-lang.org/) to test against. It will automatically install it.

**Note**: This process will create a new Docker image per build. Be sure to clean them after you're done testing.

```sh
docker rmi alpine-elixir-build-test:build
```

### Examples

```sh
./build_and_test 1.20.0
# Works, creates a build and complains about a missing install.log file

./build_and_test 1.21.0
# Fails, starts app but prints the error listed below

./build_and_test 1.29.1
# Fails, unrelated error that's already fixed in the latest nightly

./build_and_test nightly-2018-10-08
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

1. Build extension
    - Create a virtual machine (controlled through Vagrant) that will act as the build environment.
      - You will be prompted for your password the first time to mount a NFS volume on the virtual machine.
      - Install Docker on this build machine.
    - With cross, cross compile the extension to musl.
      - This cannot be done if the host is macOS, which is why we're running this through the virtual build machine.
2. Install the extension as an Erlang NIF
    - Move built extension to Elixir package (`elixir_app/elixir_package/c_src`)
    - Make a app release with distillery.
      - Compile the Elixir app.
      - Install the Erlang NIF.
3. Run the app.
    - Run the Elixir app with the NIF from the package.
    - See error.
