# Enapter Industrial Linux - Layer Example

This repository provides an example of how to create a custom layer for [Enapter Industrial Linux](https://github.com/Enapter/enapter-industrial-linux). The example layer includes a systemd service and a Docker container.

## About Enapter Industrial Linux

Enapter Industrial Linux (EIL) is a robust and minimalistic Linux distribution optimized for industrial IoT and embedded devices.

### Key Features

- **Reliable and Secure**: Utilizes an overlayfs with a SquashFS root image for read-only root, aiding in system stability and reliability.

- **Power Failure Tolerance**: System files are read-only, reducing the risk of corruption during power failures.

- **USB Stick Boot**: Easily boot from a USB stick with a simple FAT32 partition.

- **Service Discovery**: Built-in service for device discovery in the network.

- **Docker Integration**: Easily run third-party programs and services inside Docker containers using Podman.

- **Flexible Layer System**: Introducing the concept of layers for modular and scalable system enhancements. Add functionality using layers with systemd services, Docker containers, and more.

## Requirements

To build the example layer, you need the following utilities installed. These require a Linux environment, Windows Subsystem for Linux (WSL) on Windows, or MacOS.

* **make utility**: [GNU Make](https://www.gnu.org/software/make/)

  Install on **Ubuntu/Debian**:


  ```sh
  sudo apt-get install make
  ```

  Install on **Fedora**:

  ```sh
  sudo dnf install make
  ```
  Install on **MacOS** (using Homebrew):

  ```sh
  brew install make
  ```

* **skopeo utility**: [Skopeo](https://github.com/containers/skopeo)

  Install on **Ubuntu/Debian**:

  ```sh
  sudo apt-get install skopeo
  ```

  Install on **Fedora**:

  ```sh
  sudo dnf install skopeo
  ```

  Install on **MacOS** (using Homebrew):

  ```sh
  brew install skopeo
  ```

* **mksquashfs utility**: Part of the [SquashFS tools](https://github.com/plougher/squashfs-tools)

  Install on **Ubuntu/Debian**:

  ```sh
  sudo apt-get install squashfs-tools
  ```

  Install on **Fedora**:

  ```sh
  sudo dnf install squashfs-tools
  ```

  Install on **MacOS** (using Homebrew):

  ```sh
  brew install squashfs
  ```

## Custom Layers

Layers are SquashFS images containing additional software and services. Each layer has:

- `rootfs/`: Directory structure overlaid on the root filesystem.

- `images/`: Docker container registry for including pre-packaged containers.

## Example Layer: Adding a Systemd Service and Docker Container

### Layer Directory Structure

```
cloudflared-remote-access-layer/
├── rootfs/
│   ├── usr/
│       ├── lib/
│       │   ├── systemd/
│       │       └── system/
│       │           └── cloudflared-remote-access.service
│   ├── etc/
│       ├── systemd/
│       │   ├── system/
│       │       │   ├── default.target.wants/
│       │       │   │   └── cloudflared-remote-access.service -> /usr/lib/systemd/system/cloudflared-remote-access.service
│       │       │   └── multi-user.target.wants/
│       │       │       └── cloudflared-remote-access.service -> /usr/lib/systemd/system/cloudflared-remote-access.service
└── images/
    ├── # (Docker container registry structure will be created by 'skopeo copy')`
```

### Build Process

1. **Prepare your USB stick**:
    - Use [Etcher](https://etcher.balena.io) utility or `dd` Linux utility to flash `.img` image of [Enapter Industrial Linux](https://github.com/Enapter/enapter-industrial-linux/releases/download/v3.0.0-dev1/enapter-industrial-linux-v3.0.0-dev1.zip) onto USB stick.

2. **Create and deploy your layer**:
    - Structure your layer as shown. Please check the `Makefile` in this repository as an example
    - Use `mksquashfs` to create the SquashFS image.
    - Copy the SquashFS image to the USB stick into `layers/` directory (create it if not exists).

3. **Insert the USB stick and boot**.

The system will boot, mount the USB in read-only mode, and overlay your custom layer to provide the additional functionality.

## Conclusion

This example demonstrates how to extend Enapter Industrial Linux using custom layers. By leveraging the robustness of read-only filesystems and the flexibility of overlayfs, you can easily add new functionalities, such as systemd services and Docker containers, without modifying the core system files.

## Support

For any questions, feel free to reach out to us at [developers@enapter.com](mailto:developers@enapter.com) or join our community on [Discord](https://discord.com/invite/TCaEZs3qpe).
