---
link: https://www.notion.so/05-implementation-a5ed19f41d1a4e8ba57af3b9daa29bcd
notionID: a5ed19f4-1d1a-4e8b-a57a-f3b9daa29bcd
---
# Implementation details

In this chapter we will cover the implementation of \gls{e3}. The source code is a fork of [MPyC](https://github.com/lschoe/mpyc) with the addition of and can be found at https://github.com/e-nikolov/mpyc. We will now discuss the more critical parts in as snippets.

## Reproducible development of MPyC
As previously discussed, we will use the Linux distribution NixOS which is based on the declarative Nix package manager. One of the main features of Nix are nix dev shells. They allow 

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
## Summary

We have designed an extensible setup for running experiments with various MPyC networking scenarios including combinations of cloud and physical machines.

The test setup is currently using DigitalOcean as a cloud provider because they offer free credits to students but the setup can be adapted to other cloud providers.

The cloud provisioning is defined declaratively using Terraform. The setup allows to define a set of machines across the regions supported by DigitalOcean, e.g. Amsterdam, New York City, San Francisco, Singapore and others.

The machines run NixOS - a declarative and highly reproducible Linux distribution.
