# Secrets Management with sops-nix

## Quick Start

**Age private key**: `~/.config/sops/age/keys.txt` (NEVER commit!)
**Encrypted secrets**: `secrets.yaml` (safe to commit)

### Apply Configuration
```bash
./switch.sh
```

### New Machine Setup

1. Clone repo to `~/.config/home-manager`
2. Copy age key from another machine:
   ```bash
   mkdir -p ~/.config/sops/age
   cat ~/.config/sops/age/keys.txt  # On old machine
   vim ~/.config/sops/age/keys.txt  # On new machine, paste & save
   chmod 600 ~/.config/sops/age/keys.txt
   ```
3. Run `./switch.sh`
4. Open new terminal (env vars auto-loaded)

### Add New Secret

1. Edit encrypted file:
   ```bash
   nix-shell -p sops --run "sops secrets.yaml"
   ```

2. Add to `home.nix`:
   ```nix
   sops.secrets = {
     # ... existing ...
     my_new_key = {};
   };
   ```

3. Export in **both** shells in `home.nix`:
   - `programs.bash.initExtra` (Linux)
   - `programs.zsh.initContent` (macOS)
   ```nix
   export MY_NEW_KEY="$(cat ${config.sops.secrets.my_new_key.path} 2>/dev/null || true)"
   ```

4. Run `./switch.sh` and reload shell (`source ~/.bashrc` or `source ~/.zshrc`)

## Security

- ✅ **Commit**: `secrets.yaml`, `.sops.yaml`, `flake.nix`, `home.nix`
- ❌ **Never commit**: `~/.config/sops/age/keys.txt`
- Back up your age key somewhere secure!

## Verify

```bash
env | grep -E "(OPENROUTER|WHATSAPP|XAI|MASSIVE)"
```
