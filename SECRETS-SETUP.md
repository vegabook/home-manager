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

2. **Add the secret to home.nix**:
   ```nix
   sops.secrets = {
     # ... existing secrets ...
     my_new_secret = {};
   };

   home.sessionVariables = {
     # ... existing vars ...
     MY_NEW_SECRET = "$(cat ${config.sops.secrets.my_new_secret.path})";
   };
   ```

3. **Rebuild**:
   ```bash
   home-manager switch --flake .#tbrowne
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
