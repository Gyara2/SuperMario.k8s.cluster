## Aquí se especifica el tamaño de cada máquina.
variable "vm_size" {
  type = list(string)
  description = "Tamaño de las máquinas virtuales"
  default = ["Standard_D2_v2", "Standard_D1_v2", "Standard_D1_v2"]

  # Standard_D1_v2 # 3.5 GB, 1 CPU 
  # Standard_D2_v2 # 7 GB, 2 CPU 
  ## Para el master ha sido necesario asignarle una máquina más potente dado que se entiende que una máquina 
  ## con sólo una CPU no será capaz de correr el servicio con normalidad.
}

## Definimos el nombre de las máquinas virtuales.
variable "vms" {
    description = "Máquinas virtuales a crear"
    type = list(string)
    default = ["master", "worker01", "worker02"]
}