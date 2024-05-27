# GHDL_tutorial_repo

Este repositorio contiene todas los archivos y directorios que se han generado testeando las herramientas.

## Contexto

Para mantener un entorno de trabajo más ordenado se ha decidido preparar este breve repositorio en el cual se encuentran todos los archivos y carpetas que se han generado testando las herramientas. Las librerías que se han usado han sido `ghdl`, `gtkwave`, `vunit` y `cocotb`.

Se ha partido de diseños VHDL que se habían preparado para otras asignaturas y se han modificado para utilizar las herramientas mencionadas anteriormente. El diseño que se ha elegido es una máquina que computa el máximo común divisor (MCD). Se ha elegido este diseño porque es fácil de testear y tiene cierta complejidad dado que tiene componentes que son interdependientes.

### GHDL

GHDL es una herramienta de compilación, elaboración y simulación de ficheros escritos en HDL (ya sea VHDL o SystemVerilog). Por lo tanto, para probar sus capacidades se ha modificado el diseño inicial que se tenía y se ha añadido un tb en el que se prueban varias parejas de números para encontrar el MCD en cada caso.

Para preparar el diseño se han seguido las indicaciones de la guía de usuario de GHDL. Como es un diseño compuesto de varios componentes, se le tienen que indicar todos a GHDL para que los tenga en cuenta cuando haga la compilación. Por ello, primero se crea un *working directory* y se añaden todos los ficheros vhd a ese working directory. Todos estos ficheros se encuentran en el directorio `sources/mcd_machine`.

    mkdir work
    ghdl -i --workdir=work *.vhd

Una vez añadidos todos los archivos fuente, se puede pasar al siguiente paso, el **análisis y la elaboración**. Aunque para ello existen los comandos *analyze* (-a) y *elaborate* (-e), en el tutorial de la guía se indica otro comando que ejecuta los dos pasos, el comando *make* (-m) que es el que se va a usar. Se añade la opción que permite compilar el código con el estándar de VHDL 2008. El nombre que se añade al final es el *entity* del fichero que será el *top* del diseño.

    ghdl -m --std=08 --workdir=work tb_MCD_Machine

Este comando compila los ficheros y generea un archivo ejecutable. Si ha habido algún error durante la compilación, esta se detendrá y se indicará el error. El archivo generado tiene el mismo nombre que el entity (pero en minúsculas) y se puede ejecutar con el comando *run* (-r). 

    ghdl -r --workdir=work tb_mcd_machine

### GtkWave

GtkWave es una herramienta pensada para graficar *waveforms* de las simualciones de los archivos HDL. Con GtkWave se pueden mostrar los tb que se han preaparado y simulado con GHDL.


### Vunit

Explain how to run the automated tests for this system

## Cocotb



