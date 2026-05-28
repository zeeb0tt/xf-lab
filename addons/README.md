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

## Add-on release ZIPs

You may also place XenForo 2 add-on release ZIPs here and pass the ZIP filename as `ADDON_ID`:

```bash
ADDON_ID=Zee-BotGuard-1.0.0.zip ./scripts/xf-up 2.3.10 8.3
```

The expected archive shape is XenForo's standard release layout:

```text
upload/src/addons/Vendor/AddOn/addon.json
```

Everything inside `upload/` is copied into the generated XenForo root, so archive files outside `src/addons/` such as `js/`, `styles/`, or other root-relative files are included too.

Do not commit commercial or licensed add-on ZIPs to a public repository.
