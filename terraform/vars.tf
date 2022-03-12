variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "West Europe"
}

variable "vm_size" {
  type = list(string)
  description = "Tamaño de las máquinas virtuales"
  default = ["Standard_D2_v2", "Standard_D1_v2", "Standard_D1_v2"]

  # Standard_D1_v2 # 3.5 GB, 1 CPU 
  # Standard_D2_v2 # 7 GB, 2 CPU 
  ## Para el master ha sido necesario asignarle una máquina más potente dado que se entiende que una máquina con sólo una CPU no será capaz de correr el servicio con normalidad
}

variable "vms" {
    description = "Máquinas virtuales a crear"
    type = list(string)
    default = ["master", "worker01", "worker02"]
}