# Creamos una máquina virtual
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
## Creamos la VM definiendo los parámetros concretos, su imagen, el usuario de ssh, etc.
resource "azurerm_linux_virtual_machine" "myVM" {
    name                = "${var.vms[count.index]}.azure"
    count               = length(var.vms)
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vm_size[count.index]
    admin_username      = var.ssh_user
    network_interface_ids = [ azurerm_network_interface.myNic[count.index].id ]
    disable_password_authentication = true

    admin_ssh_key {
        username   = var.ssh_user
        public_key = file(var.public_key_path)
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    source_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.stAccount[count.index].primary_blob_endpoint
    }

    tags = {
        environment = "CP2"
    }

}