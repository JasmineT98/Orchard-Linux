# Orchard hardware architecture

Orchard relies on the Linux kernel for the majority of generic drivers.

```text
Hardware
  ↓
Linux kernel drivers/modules
  ↓
Firmware blobs where required
  ↓
NetworkManager / BlueZ / PipeWire / UPower / UDisks
  ↓
Orchard UI
```

Firmware packages are included because many open kernel drivers still need a
device-specific firmware blob before the hardware can operate.

The live image includes broad wireless firmware, Intel and AMD CPU microcode,
modern Intel audio firmware, Mesa graphics userspace, and common laptop services.

The current image targets amd64/x86-64 systems. ARM Chromebooks require a
separate arm64 build and device-specific boot work.
