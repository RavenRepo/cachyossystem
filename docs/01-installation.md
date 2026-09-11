# 01 — Installation

## Recommended clean-install sequence

1. Back up existing data.
2. Verify the intended target disk.
3. Boot CachyOS installer in UEFI mode.
4. Select GNOME.
5. Configure partitions deliberately.
6. Install.
7. Reboot.
8. Verify networking.
9. Run the repository phases.

Check UEFI mode:

```bash
test -d /sys/firmware/efi && echo "UEFI" || echo "Legacy BIOS"
```

Do not copy partitioning commands from another machine without verifying disk names first.
