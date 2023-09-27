
##########################################################
#     Template file replacement for OpenVPN Server
##########################################################

locals {
  ca_cert_file_name                 = basename(var.openvpn_ca_root_cert_path)
  server_cert_file_name             = basename(var.openvpn_server_public_key_path)
  server_private_key_file_name      = basename(var.openvpn_server_private_key_path)
  server_private_key_pass_file_name = basename(var.openvpn_server_private_key_password_path)
  dh_cert_file_name                 = basename(var.openvpn_dh_cert_path)

  server_conf_contents = templatefile(
    "${path.module}/cloud_init_scripts/openvpn_server.conf.tftpl",
    {
      ca_cert_file_name                 = local.ca_cert_file_name,
      server_cert_file_name             = local.server_cert_file_name,
      server_private_key_file_name      = local.server_private_key_file_name,
      server_private_key_pass_file_name = local.server_private_key_pass_file_name,
      dh_cert_file_name                 = local.dh_cert_file_name,
      client_cidr_host                  = local.openvpn_client_cidr_host,
      client_cidr_netmask               = local.openvpn_client_cidr_netmask
      client_dns_server_ip              = var.openvpn_client_dns_server_address
    }
  )

  setup_routing_contents = templatefile(
    "${path.module}/cloud_init_scripts/setup_routing.tftpl",
    {
      client_cidr_host            = var.openvpn_client_address_prefix,
      client_cidr_gateway_ip      = local.openvpn_client_cidr_gateway_ip,
      untrusted_subnet_gateway_ip = local.untrusted_subnet_gateway_ip,
      trusted_subnet_gateway_ip   = local.trusted_subnet_gateway_ip,
    }
  )

  teardown_routing_contents = templatefile(
    "${path.module}/cloud_init_scripts/teardown_routing.tftpl",
    {
      client_cidr_host            = var.openvpn_client_address_prefix,
      client_cidr_gateway_ip      = local.openvpn_client_cidr_gateway_ip,
      untrusted_subnet_gateway_ip = local.untrusted_subnet_gateway_ip,
      trusted_subnet_gateway_ip   = local.trusted_subnet_gateway_ip,
    }
  )
}

############################################
#     Cloud Init setup for OpenVPN Server
############################################

locals {
  cloud_config_setup_openvpn = <<-END
    #cloud-config
    ${jsonencode({
  #cloud-config
  "package_update" : true,
  "package_upgrade" : true,
  "packages" : [
    "openvpn",
    "traceroute",
  ],
  write_files = [
    {
      path        = "/etc/openvpn/${local.ca_cert_file_name}"
      permissions = "0755"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64("${var.openvpn_ca_root_cert_path}")
    },
    {
      path        = "/etc/openvpn/${local.dh_cert_file_name}"
      permissions = "0700"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64("${var.openvpn_dh_cert_path}")
    },
    {
      path        = "/etc/openvpn/${local.server_private_key_pass_file_name}"
      permissions = "0700"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64("${var.openvpn_server_private_key_password_path}")
    },
    {
      path        = "/etc/openvpn/${local.server_private_key_file_name}"
      permissions = "0700"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64("${var.openvpn_server_private_key_path}")
    },
    {
      path        = "/etc/openvpn/${local.server_cert_file_name}"
      permissions = "0755"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64("${var.openvpn_server_public_key_path}")
    },
    {
      path        = "/etc/openvpn/server.conf"
      permissions = "0755"
      owner       = "root:root"
      encoding    = "b64"
      content     = base64encode(local.server_conf_contents)
    },
    {
      path        = "/var/log/openvpn/openvpn-status.log"
      permissions = "0755"
      owner       = "root:root"
      encoding    = "b64"
      content     = ""
    },
    {
      path        = "/var/log/openvpn/openvpn.log"
      permissions = "0755"
      owner       = "root:root"
      encoding    = "b64"
      content     = ""
    },
    {
      path        = "/etc/openvpn/setup_routing.sh"
      permissions = "0755"
      owner       = "root:root"
      encoding    = "b64"
      content     = base64encode(local.setup_routing_contents)
    },
    {
      path        = "/etc/openvpn/teardown_routing.sh"
      permissions = "0755"
      owner       = "root:root"
      encoding    = "b64"
      content     = base64encode(local.teardown_routing_contents)
    },
    {
      path        = "/etc/sysconfig/network/routes"
      permissions = "0755"
      owner       = "root:root"
      encoding    = "b64"
      content = base64encode(
      "default ${local.trusted_nic_ip_address} - tun0 table openvpn-route \n\r ")
    }
  ]
  "runcmd" : [
    "systemctl enable openvpn@server",
    "systemctl start openvpn@server",
  ]
})}
  END
}

