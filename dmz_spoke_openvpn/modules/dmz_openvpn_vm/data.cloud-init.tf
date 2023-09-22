

data "template_cloudinit_config" "openvpn_config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = local.cloud_config_setup_openvpn
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("./modules/dmz_openvpn_vm/cloud_init_scripts/update-iproute2.sh")
  }
}

