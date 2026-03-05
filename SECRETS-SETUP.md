# Secrets Management with sops-nix

## Overview

This repository uses **sops-nix** to manage API keys and secrets across multiple machines. Secrets are encrypted using age and stored in `secrets.yaml`.

## How It Works

1. **Encrypted secrets** are stored in `secrets.yaml` (safe to commit to git)
2. **Age private key** is stored in `~/.config/sops/age/keys.txt` (NEVER commit this!)
3. **Environment variables** are automatically set by home-manager from decrypted secrets
4. **Same key** is used across all your machines (you copy it manually)

## Files Created

- `.sops.yaml` - Configuration for sops (which keys can decrypt)
- `secrets.yaml` - Encrypted API keys (SAFE to commit to git)
- `flake.nix` - Minimal flake setup for sops-nix integration
- `~/.config/sops/age/keys.txt` - Your private age key (NEVER commit this!)

## Environment Variables Set

When you activate this configuration, these environment variables will be available:

- `OPENROUTER_API_KEY` - OpenRouter API key
- `WHATSAPP_TOKEN` - WhatsApp token
- `XAI_API_KEY` - XAI API key
- `MASSIVE_API_KEY` - Massive API key

## Setting Up on a New Machine

1. **Clone this repository** to `~/.config/home-manager` on the new machine

2. **Copy the age private key** to the new machine:
   ```bash
   # On your current machine, copy the key:
   cat ~/.config/sops/age/keys.txt

   # On the new machine, create the file:
   mkdir -p ~/.config/sops/age
   vim ~/.config/sops/age/keys.txt
   # Paste the key content
   chmod 600 ~/.config/sops/age/keys.txt
   ```

3. **Switch to flake-based home-manager**:
   ```bash
   cd ~/.config/home-manager
   home-manager switch --flake .#tbrowne
   ```

4. **Verify secrets are available**:
   ```bash
   echo $OPENROUTER_API_KEY
   # Should show your decrypted API key
   ```

## Activating the Configuration

This setup uses flakes, so the command is:

```bash
cd ~/.config/home-manager
home-manager switch --flake .#tbrowne
```

(Note: You're now using flake-based home-manager, not the standalone `home-manager switch` command)

## Adding New Secrets

1. **Edit the encrypted file**:
   ```bash
   cd ~/.config/home-manager
   nix-shell -p sops --run "sops secrets.yaml"
   ```
   This will open the file in your editor. Add your new secret in the same format:
   ```yaml
   my_new_api_key: your-secret-value-here
   ```
   Save and exit - sops will automatically re-encrypt it.

2. **Add the secret to home.nix**:
   Edit `home.nix` and add your new secret to the `sops.secrets` section:
   ```nix
   sops.secrets = {
     openrouter_api_key = {};
     whatsapp_token = {};
     xai_api_key = {};
     massive_api_key = {};
     my_new_api_key = {};  # Add this line
   };
   ```

3. **Export it as an environment variable**:
   In the same `home.nix`, add the export to the `programs.bash.initExtra` section:
   ```nix
   programs.bash.initExtra = ''
     export OPENROUTER_API_KEY="$(cat ${config.sops.secrets.openrouter_api_key.path} 2>/dev/null || true)"
     export WHATSAPP_TOKEN="$(cat ${config.sops.secrets.whatsapp_token.path} 2>/dev/null || true)"
     export XAI_API_KEY="$(cat ${config.sops.secrets.xai_api_key.path} 2>/dev/null || true)"
     export MASSIVE_API_KEY="$(cat ${config.sops.secrets.massive_api_key.path} 2>/dev/null || true)"
     export MY_NEW_API_KEY="$(cat ${config.sops.secrets.my_new_api_key.path} 2>/dev/null || true)"
   '';
   ```

4. **Rebuild**:
   ```bash
   cd ~/.config/home-manager
   ./switch.sh
   # Or: home-manager switch --flake .#tbrowne
   ```

5. **Reload your shell or start a new terminal**:
   ```bash
   source ~/.bashrc
   ```

## Your Age Public Key

```
age15fz7w8vtg0rl4m2xdrj4wx9pwvgmagm9707vtdmuxu2mqe3zrchsev8s70
```

This is safe to share. It's used to encrypt secrets. Only your private key (in `~/.config/sops/age/keys.txt`) can decrypt them.

## Security Notes

- ✅ **SAFE to commit**: `secrets.yaml`, `.sops.yaml`, `flake.nix`, `home.nix`
- ❌ **NEVER commit**: `~/.config/sops/age/keys.txt`
- The encrypted `secrets.yaml` is safe to push to GitHub
- Anyone can see the encrypted data, but only you can decrypt it
- Keep your `keys.txt` file backed up somewhere secure (password manager, encrypted USB, etc.)

## Cleaning Up Old Files

Your old unencrypted API key files can now be deleted:

```bash
rm ~/.ssh/openrouter.json ~/.ssh/whasapp_token ~/.ssh/XAI_API_KEY ~/.ssh/massive_key.json
```

**Do this AFTER verifying the secrets work!**

## Verifying It Works

After switching:

```bash
# Check if secrets are decrypted
ls -la ~/.config/sops-nix/secrets/

# Start a new bash session and check environment variables
bash -i -c 'env | grep -E "(OPENROUTER|WHATSAPP|XAI|MASSIVE)"'
```

You should see all four environment variables with your API keys!
