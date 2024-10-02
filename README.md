# mio_client

mio_client is an open-source CLI tool designed to automate Electronic Design Automation (EDA) tasks encountered during the development of ASICs (Application Specific Integrated Circuits), FPGAs, and UVM (Universal Verification Methodology) IP. This tool also serves as a client for mio_web (the Moore.io Web Server), providing functionalities such as installing package dependencies and publishing.

## Features

- Automate EDA tasks for ASICs, FPGAs, and UVM IP
- Serve as a client for mio_web
- Install package dependencies
- Publish packages
- Integrate with Jenkins CI

## Installation

You can install `mio_client` via `pip`:

```sh
pip install mio_client
```

## Usage

```sh
mio <command> [<args>]
```

For complete list of commands and options, you can use:

```sh
mio --help
```

## Documentation

Comprehensive documentation is available on [Read the Docs](https://readthedocs.org/projects/mooreio_client).

## Development

### Requirements

- Python 3.11.4
- `pip` package manager
- `make` utility (for convenience in development and CI)

### Setup

1. Clone the repository:
    ```sh
    git clone https://github.com/Datum-Technology-Corporation/mooreio_client.git
    cd mooreio_client
    ```

2. Install dependencies:
    ```sh
    pip install -r requirements.txt
    ```

3. Run tests:
    ```sh
    make test
    ```

4. Build documentation:
    ```sh
    make docs
    ```

5. Build package:
    ```sh
    make build
    ```

## Contributing

We welcome contributions! Please see the [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on how to contribute.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- Official site: [www.mooreio.com](http://www.mooreio.com)
- Copyright Holder: [Datum Technology Corporation](http://www.datumtc.ca)