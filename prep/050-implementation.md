---
link: https://www.notion.so/05-implementation-a5ed19f41d1a4e8ba57af3b9daa29bcd
notionID: a5ed19f4-1d1a-4e8b-a57a-f3b9daa29bcd
---
# Implementation details

In this chapter we will cover the implementation of \gls{e3}, which can be found on [Github](https://github.com/e-nikolov/mpyc). It is a fork of [MPyC](https://github.com/lschoe/mpyc) that adds deployment capabilities. We will now discuss the more critical parts of the implementation.

## Reproducible development of MPyC
As previously discussed, the \glspl{vm} of \gls{e3} run the NixOS distribution of Linux, which is based on the declarative package manager Nix. One of its benefits is that it can also be used to declaratively manage the dependencies of a software project via its development shells feature. Normally such a project would have to explain in its readme how to install and configure all of the extra tools that are needed for working with it. On the other hand, with Nix, we can run the command `nix develop` in a directory containing a declarative specification in a flake.nix file. This will open a temporary shell environment and install the specified versions of the dependencies. Exiting the shell will uninstall them. This process makes it easy to work on projects that require conflicting versions of packages. To achieve this, nix does the following:


- it places each build result under `/nix/store/`, in a sub-directory prefixed by the hash of its inputs, e.g. `/nix/store/2ispfz80kmwrsvwndxkxs56irn86h43p-bash-5.1-p16/`
- nix opens a new shell with a modified `PATH` environment variable that includes the nix store path that contains the new package.

There are tools like nix-direnv that take dev shells a step further by automatically loading/unloading the specified dependencies when entering/leaving a directory that   contains a dev shell specification.






\newpage

The entrypoint for Nix in our MPyC fork is the [flake.nix](https://github.com/e-nikolov/mpyc/blob/master/flake.nix) file. A simplified version can be seen below:


```nix

{
  description = "MPyC flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
	  # import the derivation of mpyc and all of its python dependencies
      mpyc-demo = (import ./nix/mpyc-demo.nix { inherit pkgs; dir = ./.; });

      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      devShell.x86_64-linux = pkgs.mkShell {
        shellHook = ''
          export PYTHONPATH=./
        '';
        
        nativeBuildInputs = [
          pkgs.curl pkgs.jq
          pkgs.colmena pkgs.pssh
          (pkgs.terraform.withPlugins
            (tp: [
              tp.digitalocean tp.null
              tp.external tp.tailscale
              tp.random
            ]))
          mpyc-demo
        ];
      };
    };
}

```


The flake is functionally pure in the sense that all external inputs are explicitly declared in the inputs section and their hashes are kept in a `flake.lock` file. In our example, the only input is `nixpkgs` - a community managed repository containing the nix build expressions for more than 80 000 packages. When a nix command uses the file for the first time,  the latest revision of the nixos-unstable branch of the git repository will be fetched and its contents will be hashed and placed in the flake.lock. Further executions will reuse the revision from the lock file and verify that the resulting hash matches the original one. The lock file can be updated via the `nix flake update`  command.
The output section contains the `devShell.x86_64-linux` attribute which declares the packages required to work with the project. Specifically, it needs the nix packages for curl, jq, colmena, pssh and terraform with a number of plugins. 
Finally it also builds the `mpyc-demo` package which contains python and all python dependencies needed by MPyC. Its specification is imported from the `mpyc-demo.nix` file:

\newpage 

``` Nix
{ pkgs, dir }:
(pkgs.poetry2nix.mkPoetryEnv {
    python = pkgs.python3;
    projectDir = dir;

    extraPackages = (ps: [
      (pkgs.python3Packages.buildPythonPackage
        {
          name = "mpyc";
          src = dir;
        })
    ]);

    overrides = pkgs.poetry2nix.overrides.withDefaults (
      self: super: {
        gmpy2 = pkgs.python3Packages.gmpy2;
      }
    );
  })
```

MPyC uses the python specific dependency management tool poetry[@poetryDocs] and the poetry2nix package dynamically generates nix expressions from its configuration in `pyproject.toml` 
```toml
[tool.poetry]
name = "mpyc"
version = "0.8.8"
description = "MPyC for Multiparty Computation in Python"
authors = ["Berry Schoenmakers <berry@win.tue.nl>"]
readme = "README.md"
packages = [{include = "demos"}]

[tool.poetry.dependencies]
python = "^3.10"
qrcode = "^7.3.1"
numpy = "^1.23.4"
gmpy2 = "^2.1.2"

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```
There was an issue with the gmpy2 library when building it via poetry2nix, but fortunately we could override it with the version already present in nixpkgs.

Using this setup we can now go to the root directory of MPyC and run the `nix develop` command, which will automatically download, build and install all of our dependencies in a temporary shell. We are then ready to make changes to MPyC or locally run the demos, e.g. via `python ./demos/secretsanta.py`.

## Building a NixOS image for DigitalOcean

As previously discussed we will deploy \gls{e3} on DigitalOcean droplets - their name for \glspl{vm}. They do not provide an official NixOS image, but we can build our own using nix. 

\newpage


``` nix
## flake.nix

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      mpyc-demo = (import ./nix/mpyc-demo.nix { inherit pkgs; dir = ./.; });

      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };

      digitalOceanConfig = import ./nix/digitalocean/image.nix {
        inherit pkgs;
        extraPackages = [ mpyc-demo ];
      };
    in
    {
		packages.digitalOceanImage = (pkgs.nixos digitalOceanConfig).digitalOceanImage;
	};
}
```


```nix
## nix/digitalocean/image.nix

{ pkgs, extraPackages ? [ ], ... }:
{
  imports = [ "${pkgs.path}/nixos/modules/virtualisation/digital-ocean-image.nix" ];
  system.stateVersion = "22.11";

  environment.systemPackages = with pkgs; [
    jq
  ] ++ extraPackages;

  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = [ "tailscale0" ];
  };
}
```
The image is based on the default version provided by nixpkgs and adds some extra packages and configurations. It:

- enables the tailscale service so that we can easily configure them to join the same tailscale network;
- configures the firewall to allow tailscale traffic;
- includes the `mpyc-demo` package we made earlier for the development shell.

The image will likely be built only once, but it is still useful to  have even an outdated version of the demo baked into it as it helps us avoid having to build all of the python dependencies while deploying later. 

Running `nix build .#packages.digitalOceanImage` creates a `.qcow2.gz` formatted image file that can be imported into DigitalOcean.

## Building a NixOS image for RaspberryPi
We can build a NixOS image for a RaspberryPi4 with a similar nix expression:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      mpyc-demo = (import ./nix/mpyc-demo.nix { inherit pkgs; dir = ./.; });

      pkgs = import nixpkgs {
        system = "aarch64-linux";
      };
    in
    {
	    packages.raspberryPi4Image = (pkgs.nixos ({ config, ... }: {
	        system.stateVersion = "22.11";
	        imports = [
	          ("${pkgs.path}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix")
	        ];
			
			environment.systemPackages = [
				mpyc-demo
			];
	    })).sdImage;
	};
}

```
The build command has to be executed on an ARM64 based processor in order to succeed. This can be achieved either via emulation with qemu binfmt or via a virtual machine. When already running NixOS as a host, all that is required is to add `extra-platforms = aarch64-linux` to the `/etc/nixos/nix.conf` file.

## Provisioning via Terraform

We will provision DigitalOcean droplets with Terraform from the VM image created earlier. We need to provide it with a DigitalOcean authorization key in the `DIGITALOCEAN_TOKEN` environment variable so it can use their API on our behalf.

#### Importing the image
The snippet below handles the upload of our NixOS image.

\newpage

``` terraform
variable "nixos-image-path" {
  type    = string
  default = "../../bin/image/nixos.qcow2.gz"
}

resource "digitalocean_spaces_bucket" "tf-state" {
  name   = "mpyc-tf-state"
  region = "ams3"

  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_spaces_bucket_object" "nixos-image" {
  region = digitalocean_spaces_bucket.tf-state.region
  bucket = digitalocean_spaces_bucket.tf-state.name
  key    = basename(var.nixos-image-path)
  source = var.nixos-image-path
  acl    = "public-read"
  etag   = filemd5(var.nixos-image-path)
}

resource "digitalocean_custom_image" "nixos-image" {
  name    = "nixos-22.11"
  url     = "https://${digitalocean_spaces_bucket.tf-state.bucket_domain_name}/${digitalocean_spaces_bucket_object.nixos-image.key}"
  regions = local.all_regions
  tags    = ["nixos"]

  lifecycle {
    replace_triggered_by = [
      digitalocean_spaces_bucket_object.nixos-image
    ]
  }
}
```
The DigitalOcean API only supports importing images from a URL, so we first need to upload the image to a publicly accessible location. For that purpose, the snippet above first provisions a Bucket within Spaces - DigitalOcean's cloud storage solution and uploads the image there. After that, the `digitalocean_custom_image` will import the image from the URL generated by the bucket.


#### Generating hostnames

The snippet below starts with a specification of how many machines per region we want to have and transforms it into a list of descriptive ids (e.g. `mpyc-demo--ams3-0-15e53f39`) that will be used as host names so we can easily distinguish the machines when they start communicating with each other.
```terraform
locals {
  node_definitions = var.DESTROY_NODES != "" ? [
    { region = "ams3", num = 0 },
    { region = "sfo3", num = 0 },
    { region = "nyc3", num = 0 },
    { region = "sgp1", num = 0 },
    ] : [
    { region = "ams3", num = 3 },
    { region = "sfo3", num = 1 },
    { region = "nyc3", num = 1 },
    { region = "sgp1", num = 1 },
  ]

  nodes_expanded = flatten([
    for node in local.node_definitions : [
      for i in range(node.num) :
      merge(node, {
        name = "mpyc-demo--${node.region}-${i}"
      })
    ]
  ])

  nodes = {
    for node in local.nodes_expanded :
    node.name => merge(node, {
      hostname = "${node.name}-${random_id.mpyc-node-hostname[node.name].hex}"
    })
  }
}
```

#### Provisioning the hosts

The snippet below provisions the droplets in the specified regions and then using Tailscale's terraform provider creates auth keys for the machines, copies them to the machines and configures them to join the tailscale network. When the droplets are being destroyed, the provisioner will remove the nodes from the network.

```terraform
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

resource "tailscale_tailnet_key" "keys" {
  reusable      = true
  ephemeral     = true
  preauthorized = true
}
```

#### Interfacing with other tools
This snippet outputs the hostnames of the provisioned droplets so they can be picked up by other tools. For example Colmena will read them from a json file so it can deploy further software changes to them.
```terraform


output "hosts-colmena" {
  value = { for node in local.nodes : node.hostname => {} }
}

output "hosts-pssh" {
  value = join("", [for node in local.nodes : "root@${node.hostname}\n"])
}

```
## Colmena deployment

Whenever we need to update the NixOS configuration of our VMs, we could rebuild the image and re-provision them, but this would be slow. Instead we use Colmena to deploy and apply the new configuration to all existing VMs. 
It uses the same `digitalOceanConfig` attribute we created for the NixOS image:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      mpyc-demo = (import ./nix/mpyc-demo.nix { inherit pkgs; dir = ./.; });

      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };

      digitalOceanConfig = import ./nix/digitalocean/image.nix {
        inherit pkgs;
        extraPackages = [ mpyc-demo ];
      };
    in
    {
      packages.colmena = {
        meta = {
          nixpkgs = pkgs;
        };
        defaults = digitalOceanConfig;
      } // builtins.fromJSON (builtins.readFile ./hosts.json);
    };
}
```
This allows us to quickly make changes to the NixOS configuration, deploy it via Colmena and once we are satisfied with it, we can choose to rebuild the image so that new machines get provisioned with all of our changes baked in.

## Runtime execution
We have identified the tools we will use to deploy \gls{e3} and how the host machines will communicate. What remains is to determine how to run a joint computation on the hosts. When running such an experiment, it would be desirable to be able to iterate quickly. Colmena can be used to deploy a new version of the whole operating system, but it would be unnecessary to rebuild all dependencies every time we want to run a command. 
Therefore we decided to use two additional tools:

- *prsync* - a variant of the popular *rsync* utility that can additively sync the contents of a directory to multiple remote hosts
- *pssh* - a tool for executing an ssh command on many hosts in parallel 

An example execution looks like this:
```bash
prsync -h hosts.pssh -zarv -p 4 ./ /root/mpyc
pssh -h hosts.pssh -iv -o ./logs/$t "cd /root/mpyc && ./prun.sh"
```
It loads the hostnames from the `hosts.pssh` file that was previously generated by terraform and syncs the current state of the mpyc directory.
The second line will execute the `prun.sh` script on each host.

An example of a possible `prun.sh` script:

\newpage

```bash
#!/bin/sh

MAX_PARTIES=600
hosts="./hosts.pssh"
port=11599

i=0
MY_PID=-1

args=""
while IFS= read -r line
do
    if [ $i -ge $MAX_PARTIES ]
    then
        break
    fi
    if [ -z "$line" ]
    then 
        break
    fi

    host=${line#"root@"}

    if [ "$host" = "$HOSTNAME" ]
    then
        MY_PID=$i
    fi
    ((i = i + 1))

    args+=" -P $host:$port" 
done < "$hosts"

if [ $MY_PID = -1 ]
then
    echo Only $i parties are allowed. $HOSTNAME will not participate in this MPC session
else

cmd="python ./demos/secretsanta.py 3 --log-level debug \
    -I ${MY_PID} \
    ${args}"

echo $cmd
$cmd

fi
```
Each host runs the same script that builds the arguments for the `secretsanta.py` demo of MPyC. Each party determines its own Party ID based on the index at which its hostname appears in the `hosts.pssh` file.

## Secrets
The implementation expects that secrets are supplied as environment variables with the specific mechanism being left up to the user. We are currently keeping the secret values in the 1Password manager and use its \gls{cli} to populate the environment variables at runtime, e.g. via `op run -- make deploy`.

