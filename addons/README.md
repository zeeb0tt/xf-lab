# Add-ons

Place local add-on source here when you want the lab to mount it into XenForo.

Example for an add-on with ID `Vendor/AddOn`:

```text
addons/Vendor/AddOn/addon.json
```

Run it with:

```bash
ADDON_ID=Vendor/AddOn ./scripts/xf-up 2.3.10 8.3
```

You can also keep your add-on outside this repository and point to it directly:

```bash
ADDON_ID=Vendor/AddOn \
ADDON_SOURCE=/absolute/path/to/Vendor/AddOn \
./scripts/xf-up 2.3.10 8.3
```

or point `ADDON_SOURCE` at a project root that contains `src/addons/Vendor/AddOn/addon.json`.
