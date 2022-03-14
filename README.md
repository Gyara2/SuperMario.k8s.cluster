# SuperMario.k8s.cluster
An Implementation for UNIR course, a complete deployment made with Terraform, Ansible, Kubernetes and Azure as Cloud


DESPLIEGUE DE APP CON CLUSTER EN AZURE
======================================

Para comenzar, indicar que esta práctica ha sido orientada a desplegar una app sencilla usando un contenedor de Dockerhub el cual se adhiere para mostrar el funcionamiento del cluster desplegado. Repositorio de la práctica: <https://github.com/alvaroguiradoASIR/SuperMario.k8s.cluster>

Los elementos contenidos durante el desarrollo de la práctica son muy variados y se explicarán con detalle durante la lectura de este informe.

En primer lugar, para una visión más completa, se aportará un diagrama general:

![](https://lh5.googleusercontent.com/u1fWqhMTXcKeRCv7Mxg-5eYySTgtOjCQAAo_AXxkCzHMsae5XVrL221VQVJPnZGxbnZP5e8zHixsbPwWsezsYXOV3gJbsaNzvjLClyxKVfPxccUjrT_CsPqz9RayQWpvRnG2h-5c)

Para empezar, se explicará el entorno desde donde se realizarán todas las tareas de desarrollo.

El desarrollo ha sido llevado a cabo usando una máquina con Visual Studio Code como entorno de desarrollo de código "linkeado" a un repositorio en Github.

De manera, que tras codificar las tareas de forma escalonada se agregaban al script deploy.sh para su automatización, el cual se encargaba de ejecutar los distintos playbooks de configuración.

![](https://lh5.googleusercontent.com/K6sbPrRiaGA_3tgeKuZ677P-Wg5mcZbI9dS0wSlNojEQqgiT5IbMznrOlXJPO59KQhhu80tZO2j0vEAFx_um3EDjB2ZYfWu5WNBHAjZl474bYulf1lOsU6gyqYTWT27Dx3Twye6C)

En este punto, sería muy aconsejable tener en cuenta que ciertos datos que han sido usados durante el desarrollo de la práctica no deberían subirse al repositorio, como las credenciales de la suscripción de Azure.

Al comienzo, necesitaremos crear la estructura de máquinas virtuales donde ejecutaremos las configuraciones pertinentes para realizar el despliegue. Ya fuera en un entorno local para testear previamente a su despliegue en Azure o a realizarlo directamente en Azure, necesitaremos crear los ficheros de Terraform concretos para generar esas máquinas con una pre-configuración básica (número de máquinas, prestaciones de cada una de ellas, reglas de seguridad, redes, etc.).

![](https://lh6.googleusercontent.com/C7leWPSngrNcPlLWQpXTEXNXvbitKIiWZXWIsPBmX8uJLbkDCT-zsL_kgSU54VsDJRiUw53u9B7siqiHPS4nI-Qc64vdBnaJ5QDH_vx0wLpyz4da-3lgCYyhXJ1YjqCfzPCiJhLZ)

De modo que Terraform, desde el punto de vista de lo que se trata, un IaC o (Infraestructure As Code) es justamente eso, nos permite generar un estructura básica a partir de una serie de ficheros de configuración realmente sencillos.

![](https://lh6.googleusercontent.com/XX-z--e31ozTZaNmC7PLlFoUqFp6EAbhJH5IhqrLj9kG4J8vLcNVqzVrdKnikXetnrJgB1gwXWGXS4dhf-QwtQnu3WDJAVxwtQOPTvc6Lo84JjEzfzhnGNTZc0WtCe4Z5gaOIto8)

En esta imagen pueden verse los ficheros usados para el despliegue de la infraestructura,

Empezando por abajo, el fichero 'vm.tf' se usará como fichero para definir la información correspondiente a las vms que serán desplegadas, aquí se especificarán elementos como el tamaño de disco, la imagen del mismo, etc.

Siguiendo el orden, en el fichero 'vars.tf' se especifican todas aquellas variables que serán útiles para el resto de archivos de Terraform, por ejemplo, las prestaciones de la máquina en cuanto a CPU y espacio de almacenamiento se refiere o las máquinas a desplegar.

En el fichero 'security.tf' se especificará el grupo de seguridad asignado a las máquinas, las reglas para puertos específicos será concretada en este fichero, en la práctica, llegado determinado momento tras el despliegue de la app será necesario realizar una pequeña modificación para poder visualizar el resultado final de este caso práctico.

A continuación, en el fichero 'network.tf' serán representadas las redes, subredes e IPs (estáticas en este caso) que serán agregadas a las distintas vms.

Finalmente, el fichero main.tf donde se especifican los providers de Terraform, el grupo de recursos que aglutinará todos los elementos citados anteriormente y las storage accounts para las distintas máquinas.

Como ficheros adicionales para esta práctica contamos con el fichero 'correccion-vars.tf el cual se usará para corregir este caso práctico y además, el fichero 'credentials.tf', este fichero contiene las credenciales de acceso a la cuenta de Azure y por tanto será necesario incluirlo a fichero '.gitignore' para evitar subir esta información al repositorio.

Entendiendo este apartado, en la práctica, el primer paso será usar Terraform para generar (ya sea en local o en Azure) esa estructura.

Para hacerlo de una manera limpia usaremos 'loops' o bucles, dado que facilitarán el despliegue de nuestro entorno en Azure, de hecho, dado el código del repositorio será posible crear máquinas adicionales incluyendo dos strings en un par de listas y de la misma manera en la sección correspondiente a Ansible pues tan solo definiendo un nombre se lanzará la configuración a la vm.

Decir que en este apartado no ha habido ningún problema pues es bastante sencillo de usar.

Una vez generada esa estructura básica y suponiendo que se han conseguido crear las máquinas necesarias, en el portal de Azure, en la sección 'Máquinas virtuales' de nuestra cuenta, se podrán comprobar las máquinas generadas así como sus direcciones IP públicas.

![](https://lh3.googleusercontent.com/8ysgB4AbsSQbpV_jel3Bc9t1ohRUidfiLkdbXVz1LklgPDuxWbzqId2p4_-Nvl34oS_XDm55Yo32TwGdt7wIBTAq0_DeFJpGMAbPCWY-6nU79xk_i-aSLHxVkUhX2Y3aWGcfInRi)![](https://lh3.googleusercontent.com/OYASglJarxM0VLmSgVeMtXY_ZGgIjYHhjsTdhIVnA0EbAk1Ve4BdS4BfZ2bg-uwQA00_5wRVMHr1U6yEhxj7HsmgDyGwVCfMwUdqe32_i9j7Cktz71ZjEqPpn3wJMSBz5zSvyJQp)![](https://lh5.googleusercontent.com/vDd96M0-Uc4C9NKgeoHObVWVMRn8ixxCeITN3ZDBRagrCHMTbDbgBsT6JpMbOaGMa4YZWwqSDiJruTCKuP3UUp-2MrPLoC9NhovguqZZ5ClND47iyq24Pl1_pw-DsflUEbeEDh4G)

Las máquinas desplegadas constan de las siguientes especificaciones:

master.azure: Standard_D2_v2

worker01.azure: Standard_D1_v2

worker02.azure:  Standard_D1_v2

![](https://lh3.googleusercontent.com/_I1A1DNm-Ae2rxPuV492Q5L5y9PIH5c41NffoHItzKruXTwGZSV40ip5jB3SqY5wViDRs6-OPomnu6Gf3jX0kznN310Rlerck7cNMiENt-OuBaeKCjIlw57nXBV8t6J59OQQleg4)

La imagen usada para cada máquina ha sido

name: centos-8-stream-free

version: 1.2019.0810

Finalmente, tras generar la estructura básica, es el momento de orientar nuestra atención a la siguiente sección, la automatización del despliegue del cluster y la app usando Ansible.

Desde este momento, el número de elementos que interactúan entre sí se incrementa considerablemente.

![](https://lh6.googleusercontent.com/LAdnfsfJb-KGmHPI0ZBqYbRqJm5wtpX3IlU_lTqhQakW8-JBlRdZprNXYi_9y7kJhh7ZgIKdBmoQmh8qUpZCGc29jxzlu98KVHkfKVu__da8GsMbNciMuHOuWtZWm5mueMK_9Dt5)

En primer lugar, cabe recordar que se usará un script '.sh' para automatizar la ejecución de cada uno de los playbooks.

![](https://lh4.googleusercontent.com/BrDSuc_SWkm7ya1ElP9Wu1te3RLmbajVT-OeldqhdJR9W7I8hidgknkX4w9Ki6oYBHgxp-HHhmfuO3Nq9TidbSyy7hBBh8DhO-uezKgOmUHvCjNHyB1NRJ_YHIfJX884-u6Xc_z0)

El primer paso, será configurar los hosts, una vez sabemos qué IP pública tiene cada máquina, se especificarán en el fichero 'hosts', de la siguiente manera:

![](https://lh3.googleusercontent.com/MM3NAtKjAb2lGyInlQsHrektBa-OTgIDevJ9pq5m531V1ezbTu3sk0ZCCpzZoDqQa3e8vCyMMcaE3bPFi9h_GfbhktozzOiAXAesUBBlEMHBf_gewqo6gGxBtwLKvGMPamgfuJZd)

El script recorrerá un directorio y ejecutará cada playbook en un orden determinado, para amenizar y mejorar la vista de este despliegue se ha orientado todo el proceso, desde el orden de los ficheros hasta la definición de roles en función de los elementos (vms).

El despliegue de la configuración ha sido orientado al tipo secuencial para facilitar la comprensión y el entendimiento de la práctica, no obstante, las indicaciones dentro del código son numerosas.

Se deberá prestar especial atención a los servicios de Kubernetes pues pueden resultar complejos de entender.

Durante el desarrollo de la práctica encontré múltiples errores y problemas derivados de haber planteado la estructura de la manera en la que está pero pienso que era importante para facilitar la vista del proceso completo.

Del mismo modo, durante el desarrollo en Azure tuve que tomar la decisión de obviar el nodo dedicado a NFS ya que la configuración y su uso era poco útil para este caso, por tanto, opté por añadir dos nodos workers para que se investigue y se pruebe usando ambos.

Por último recalcar que también se ha cuidado la capacidad de que pueda lanzarse tantas veces como se quiera sin que falle por ello, añadiendo comprobaciones en algunas de las tareas más sensibles.

![](https://lh4.googleusercontent.com/AXiw9h-qAk39i4bmwtZdQ8N_3IBXASlgyQXGKz1fXR-tLk_poFAN6ec-tzLzjpI0NujvaB4Gr2-YRrnlaqGKyQ38ACEdZgpI-LZc368wI2UJtqnLPW3laoZi49lYlV2XPeV0Q4c5)

Como podrá verse, el orden es bastante intuitivo, el árbol de directorios de Ansible está orientado en este sentido.

Así, en el directorio 'group_vars' se incluirán los ficheros de los que se servirán los playbooks para "tomar" aquellas variables que hayan sido especificadas en ellos y que contribuirán a hacer más fácil el proceso de automatización de ciertas tareas (tasks).

![](https://lh4.googleusercontent.com/iKJ9xhpsQD31bqfRD0-eUALaP5IPXEEp0DQWA3XsSpcXqSQvGziKec1Xp74ULtzY4ex-0NMJAj2-lGDDhk6enUPuaZjOLDcH_aKqcgZnwLOHPpFu02wJyduYHCEgG9YH0SO4Jcvx)

Continuando con el recorrido, en el directorio 'roles' especificaremos los roles que harán referencia los playbooks, en este caso se ha decidido estructurar de la siguiente manera para que fuera más fácil de comprender pues se han englobado las tareas por host.

![](https://lh4.googleusercontent.com/bBVyTyHGMawqtb66MVbUEnEhSWOdiU_bD1StHytRBd6Qv1b3MhF5J2yLfG9qPD5EqARxENWyRZA-z7AdWhoKaMjUGz4jtY0xxNdKy_yJs4876qH3KFVe8z2M9B7qg3P17wFYtDx7)

Finalmente, los playbooks que apuntarán a los roles para ejecutar las configuraciones.

![](https://lh3.googleusercontent.com/11hX4zlMQmxK9tAs00l9OxtIWBJTSrUBTHtB_7YKE-rHOudLSC2atHwHmCqtp70AHOt_Ye-4sH9_285sLIUNsjgMeBsU-eYFJI7GBPjSbVX0lhQ-_gCigm7uHaKxbo6wqz6UbX4d)

Una vez representados los elementos principales y la estructuración del código, se procederá a explicar los elementos que intervienen en la configuración.

Para comenzar, será necesario comprender cómo se creará este clúster de kubernetes.

El clúster de Kubernetes se sirve de contenedores donde se ejecutan aplicaciones, posibilita que escalen de una forma sencilla, un clúster se compone de nodos, máquinas virtuales que ejecutan contenedores donde estos ejecutan aplicaciones.

De la misma manera existen más elementos, como los pods, que se trata de un conjunto de estos contenedores unificados en un sólo nodo.

Existen servicios, que se encargan de que estas aplicaciones sean accesibles.

Kubectl, el cual permite gestionar el clúster desde la línea de comandos.

![](https://lh5.googleusercontent.com/raFh1W-kqGx0sV6B-ePcdOc21zO05I3Kt6r0-Diw9meE4JtFUYPV3uwZ31xeMhTHaj3DgkG4bmAy7uA2Zb9y8eu7jJrfuFF689aTaMpGuVrnVJNccNIjgg_w0BmA2H3RLn1N8W09)

En este caso, hay que decir que Kubernetes ha deprecado Docker por lo que se usará una alternativa, en este caso CRI-O, el cual se trata de una implementación de la CRI de Kubernetes, la CRI de Kubernetes se encarga de que kubelet pueda usar una amplia variedad de tiempos de ejecución de contenedores, sin necesidad de volver a compilarlos.

CRI-O, es una mejora dado que engloba multitud de estos 'container runtimes' y permite ejecutar contenedores directamente sin necesidad de herramientas adicionales o modificaciones de código especiales.

Por tanto, uno de estos contenedores correrá la app, de manera que se hará un 'pull' de una imagen de DockerHub la cual lanza una app de un juego en el navegador.

Otro de los elementos necesarios, será una SDN, la cual se trata de una red que es definida por software usando una serie de controladores a diferencia de las redes tradicionales en las que se necesita un enrutador y otros dispositivos hardware.

![](https://lh5.googleusercontent.com/U7YguCnWk2nj0-7KSfJgt67_XxzlB_TjqRjfZusYGdX64st4stSFGo3sj5ek0owRFcN3rZyo9S2YyBUA0jcRLzazgR0-fYOXQ8WPnbGsi3qN0GqkqHkMzrCbosNoYm-Ywa0uBZrq)

En la práctica se usará Flannel, una SDN creada para Kubernetes y que funciona ejecutando un agente 'flanneld' en cada nodo del clúster.

Por tanto, Flannel crea la red que permitirá que exista la comunicación necesaria entre los distintos nodos.

Ahora, una vez se crea la SDN, es necesario definir unas políticas de seguridad, para ello existe Calico, el cual correrá conjuntamente con nuestros otros pods para manejar la seguridad.

Finalmente, necesitaremos un Ingress, este Ingress se encargará de enrutar el tráfico de la app a donde corresponda y de balancear la carga, se usará HAproxy, de manera que se ejecutará como un pod más al igual que Calico.

Para finalizar, tras desplegar la app en un pod, será necesario realizar una serie de cambios para poder acceder al servicio web. El primer paso será, abrir el puerto al que se redirecciona el tráfico del puerto 80, para ello se modificará el fichero de Terraform 'security.tf' y se añadirá una nueva 'security_rule' que permita la entrada del tráfico entrante por el puerto especificado, conforme está planteado el despliegue usando Ansible, en un momento dado, tras el testeo en las últimas tareas, se imprime por pantalla este puerto.

Además de esto, será necesario crear una entrada en el fichero '/etc/hosts' de nuestra máquina controller en el formato '<PUBLIC_IP> host', de la misma manera que para el anterior, en las últimas tareas del despliegue se especifica esta información al probar la petición usando el comando 'curl'.

Por último, concluir que ha sido necesario actualizar a la versión 2.12 de Ansible para una tarea concreta que se explica en el fichero.

La app desplegada es un simple juego, el famoso 'Super Mario' desarrollado en JavaScript para ser ejecutado en un contenedor, decir que esta imagen ha sido usada para el propósito que ocupa la práctica de mostrar una aplicación en funcionamiento. Todos los créditos para el creador de esta imagen

![](https://lh3.googleusercontent.com/LSmpXbJdZcu0T5INkOqxtSIZoEQjxFoIRlqqAAPmhl1cmk9be5JjPm0T3yVJacGNW3tID7wlukWJIyQZ5EfoVrmwRGcdINC6VCDM8g7_BzunjkJTRrmEWVN-GtpDiScT1pwAI1BZ)

Usuario: [Pengbai](https://hub.docker.com/u/pengbai)

Repositorio de la app: [mariohtml5](https://github.com/PengBAI/mariohtml5)

Finalmente, testeamos la app siguiendo los pasos acordados:

![](https://lh4.googleusercontent.com/mZb6Df4VVZEYCLku1I1g4w22Q4NgiV3RZtCdoO0K-3OgtOebrfWloi2rGqhy0UIywe22YEg1MaVGiqrarvnbvzqZvTYIc1SRK83EoocT779buF1BAYoqGpY1xinT96kbB--8Khtc)

Como se dijo anteriormente, de las últimas salidas se puede extraer la información necesaria para poder probar la app en nuestra máquina controller.

![](https://lh5.googleusercontent.com/SxnthzaJWDRxJVgDzcDUz-GFwlskTSLm9dZ90-dh2XeYymFE_ehlXMgxE_pFqDdjeYoYH8LgvyZe0S18gPMcAxxK5b6MVKzEbXVw6lBWcArWPieD126hVpkMHAHRHT_TNjLBwBP-)

De la salida sacamos varias conclusiones:

Host: 'supermario.k8s2'

Puerto: '30216'

Path: '/'

Con esta información será posible testearlo, para ello, en primer lugar, se escribe la entrada de host en el fichero '/etc/hosts'.

![](https://lh4.googleusercontent.com/K2FmQkf70gbl-J8oYjAjIUzUusbnqXTmIYcqkJkX9vaipSb-TNzhdmErgLATBAEjHxTe7TrcjFslrKcsG6EWtcwEvO7PGGWxtXemNJW-F5MuGBufhYAy3H73pKekzOsDMiZnA-7H)

![](https://lh6.googleusercontent.com/DJBzI8TVZq5gvqqyXSb1u7_ARa7sWDmPy9HOvPREIF8F7LuDzdozHyUwN0hhTorCJJwjAvf5jESHbocltpqq77BCqLuIxMrFeAd4oi4pTwAj3EDS2kF1lwUsfYy7FPSrXFaTCU6z)

A continuación, en el fichero 'security.tf' de Terraform, se especifica una nueva regla para habilitar el tráfico a través de dicho puerto.

![](https://lh5.googleusercontent.com/SQBi-WYOqmfXIi3HMogXAHFyE8JHOdCKW6qgZEtJmmoJ_QTSC1A901NH-f-JknX37qAt7ee6Uklcb99P7jXbPetoYZvcKxen5Dz02bnejr7NrtoppvfQQeKyhBk8NlmnaKI6ZPBY)

Por último, es aplicada la nueva configuración.

![](https://lh6.googleusercontent.com/aeAvHfKwP_xk7i_p-HID4QSwCn6YcckLYUeOtHugU6uf1QSstViEIu0RRpQyUqyHektIgw57my4dpnjXLeET70SrO-Nm24joRFFZOm7jcZmIuvZ0J-TuUKJrsAF0DP-ePz3uIxte)

Tras la confirmación, en el navegador, se accede a la dirección de host y el puerto correspondiente para testear la app en funcionamiento.

![](https://lh6.googleusercontent.com/PkrPrTAji4zGHV2FeGO-tA913_WvYA3rJ0fpymaft6MW6vtDNBZOCWIouk-xOtDUkrnobz2uKVLNpGogn1viJ_FGePyg35BiXKxzYZt2UJsdhUjvy3ZZpXE-qCE5Xb7_dRdCEK_s)

Repositorio para esta práctica: [SuperMario.k8s.cluster](https://github.com/alvaroguiradoASIR/SuperMario.k8s.cluster.git)

ANEXO
-----

Finalmente, se adjuntan capturas del entorno desplegado:

Recursos creados

![](https://lh6.googleusercontent.com/VcmPuBfe560m_Z0Kl3eGT4qpO98Rm8BYRebYbwISAnrfJPIV3YrU7iWolrcfYNtgH9rTg-mh8MAZ9GVmKsrRLr4AtSU7hMslAHD34Sz1WvxM6FZ_eiEfHJeGwWeUFGPjFMDoZ-hi)

Máster IP Pública

![](https://lh4.googleusercontent.com/VyIh9qeYk1_6lf9lWVqaZSVj0LEpJIerVC0ubJ8mDoFwax5Yg77Exi4Z3gG85FP0U6RhkRYwhzAg4vLkA2voRW0b3N1iCeQVA86nQ5gHAjQChkCH-Upw2tKSAIn8iBxB74SlwDpU)

Worker01 IP Pública

![](https://lh5.googleusercontent.com/npHj-9jPbkEZsekMxDEWbVKoIXlePDck1L6OOaUCWh-PImOFbqlZ0wNDQfPXOITuqY9TNTQCEFzOqKIZ8t-DU00eSTIAHa5iLhpgN2PbNzPDD8wLnFw1YykY1Y63vEZHe0hlMXw5)

Worker02 IP Pública

![](https://lh4.googleusercontent.com/iIKIPVRX6iLs4gVe9c5LtsNStyDZSJiVt1H2mpNleKkAbpaCvV54hxZJWCJIo2gi9ljkWjBwi40jmj74pBE9FL8isJxfq_Yw2lct5DT-Ful-QWfCrlWYeS9Yn7cJzEO2LxlyiR_J)

Nodos desplegados

![](https://lh5.googleusercontent.com/Wtf_Sy6Z27Rqv_xfhLGIZI3Q1F1kym3fO4khKYRLMD2asxmp_gyrcX2A5gYp2nGZx6mbadpmbaDHfWXDCG2jYgtGL3mCKBzfzPrdHdshnj6vtva2E89ilZVeP1bIMzy8ANcYiAua)

Todos los pods desplegados

![](https://lh6.googleusercontent.com/xyM4UGlYm5f0cGqvWLYZdmiWOo9FwBuOs_YLZmTexFOsetLjId4Mp8h7w7UL4e-0rjSxZpvbCU83pt8qb6UKeSIqu44WPDNAX_oBMCYJEWR-ShiCPP7SNUKBzy-9wrrrkgbfwf0r)

Namespaces

![](https://lh5.googleusercontent.com/zwNdfVi99qlgcHKf2o1Vg4f3Wiml3DKnfUwkpk4XYBB0IiUoIWOQXrdzvAKoA9sqN5Seu-UsPAA2DFHN4nSTUfPpOJcz5bCevygdXArbBuNZmV1Y0CLlSnnboNCiyT6P4Z-PdCo5)

Services

![](https://lh5.googleusercontent.com/AFfRmeQj_ruXeJey_s58ZP8JfeJSjhbvdjLnyHPWqzQzutoya0bYl6maMSM8nEwViSUCU10K8t-gFgErwf0h7ty8HbYUXxGPXgsIr6O0t7Qc0l8ToEpGsm3DfKwbv-3WbQJ85E97)

Ingress

![](https://lh3.googleusercontent.com/4GT4vGwuGa7Alu-W1fMTSMma9g1_WkfFVEuqxSjwjvUD1PGdtxbn3gdW83BNGAG2cYSgQ46X0PABPhaf_v30ID7AAVXLZ7andpq4gliabQg5DdIDAuJpTgyT1nF4iOJooJsoh9wf)
