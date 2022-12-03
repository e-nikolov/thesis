# Evaluation Setup - Implementation

\todo{Talk about the specifics of the implementation}

\todo{Show snippets from the terraform spec}

\todo{Show snippets from the Nix spec}

body

body

body

$$
x^2 + y^2 = 1
$$

```nix
packages.colmena = {
    meta = {
        nixpkgs = pkgs;
    };
    defaults = mkDigitalOceanImage {
        inherit pkgs lib modulesPath;
        extraPackages = [ mpyc-demo ];
    };
} // builtins.fromJSON (builtins.readFile ./hosts.json);
```

```terraform
output "node" {
    value = local.nodes_expanded
    }
    output "node-hostnames" {
    value = { for i, node in local.nodes_expanded : node.name => merge(node, { hostname = "${node.name}-${random_id.mpyc-node-hostname[node.name].hex}" }) }
    }

    resource "digitalocean_droplet" "mpyc-node" {
    for_each = local.nodes

    image    = digitalocean_custom_image.nixos-image.id
    name     = each.value.hostname
    region   = each.value.region
    size     = "s-1vcpu-1gb"
    ssh_keys = [for key in digitalocean_ssh_key.ssh-keys : key.fingerprint]

    connection {
        type = "ssh"
        user = "root"
        host = self.ipv4_address
    }

    # provisioner "file" {
    #   content     = tailscale_tailnet_key.keys.key
    #   destination = "/root/keys/tailscale"
    # }

    provisioner "remote-exec" {
        inline = [
        "mkdir -p /var/keys/",
        "echo ${tailscale_tailnet_key.keys.key} > /var/keys/tailscale",
        "tailscale up --auth-key file:/var/keys/tailscale"
        ]
    }

    provisioner "remote-exec" {
        when = destroy
        inline = [
        "tailscale logout"
        ]
    }

    lifecycle {
        replace_triggered_by = [
        tailscale_tailnet_key.keys
        ]
    }
}
```

asd

asd
