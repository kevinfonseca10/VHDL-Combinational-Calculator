# VHDL-Combinational-Calculator
Calculadora Digital BCD en VHDL para FPGA 🧮
Este repositorio contiene un proyecto para la asignatura Diseño de Sistemas Digitales (1830) de la Facultad de Ingeniería, Departamento de Electrónica en la Pontificia Universidad Javeriana.
El proyecto consiste en una calculadora digital de 4 bits, descrita completamente en VHDL e implementada en una tarjeta de desarrollo Terasic DE0 con una FPGA Intel Cyclone III.

🚀 Características
Operaciones Soportadas:
  Suma BCD (Decimal Codificado en Binario)
  Resta BCD (con manejo de números negativos)
  Multiplicación Binaria
Interfaz de Usuario:
  Entrada de dos operandos (A y B) de 4 bits y un código de operación de 2 bits mediante 10 interruptores (SW).
  Visualización de los operandos y el resultado en 4 displays de 7 segmentos.
  
Manejo de Errores ⚠️:

  El sistema opera en el rango BCD [0-9].
  Si un operando introducido es mayor que 9, el display correspondiente muestra una 'E'.
  Si la entrada es inválida, el resultado de la operación muestra "EE" para notificar al usuario.

Arquitectura: Diseño combinacional.

📁 Estructura del Proyecto y Módulos
El diseño está compuesto por varios módulos VHDL, cada uno con una responsabilidad específica.

Módulos Principales
  calc_top.vhd: El Integrador Principal. Este es el módulo de más alto nivel. Conecta todos los demás componentes, mapea las entradas/salidas físicas (interruptores y displays) y gestiona el flujo de datos y la lógica de error final.
  alu.vhd: Unidad Aritmético-Lógica. Actúa como un director de orquesta. No realiza cálculos, sino que selecciona el resultado correcto (suma/resta o multiplicación) basándose en el código de operación del usuario.
  sum_sub.vhd: Cerebro de Suma/Resta. Un módulo optimizado que realiza tanto la suma BCD (con la corrección de sumar 6 cuando es necesario) como la resta en complemento a dos, calculando la magnitud y el signo del resultado.
  multiplicacion.vhd: Motor de Multiplicación. Implementa una multiplicación binaria de 4x4 utilizando el algoritmo de "desplazar y sumar" de forma estructural.
Módulos de Soporte y Lógica Base
  bin2bcd8.vhd: Conversor Binario a BCD. Un componente clave que toma el resultado binario de 8 bits de la multiplicación y lo convierte a dos dígitos BCD (decenas y unidades) para que pueda ser mostrado en los displays.
  bcd_to_7seg.vhd: Decodificador de Display. Traduce un número BCD de 4 bits al patrón de 7 señales necesario para encender los segmentos de un display y mostrar un dígito.
  bcd_guard.vhd: Guardia de Seguridad. Un módulo simple pero crucial que vigila las entradas A y B. Si alguna es mayor que 9, levanta una bandera de error.
  adder4bit.vhd: Sumador de 4 bits. Un bloque de construcción reutilizable, hecho a partir de cuatro full_adder.
  full_adder.vhd: Sumador Completo de 1 bit. El ladrillo fundamental de toda la lógica aritmética del proyecto.


By Sofía y Kevin
Pontificia Universidad Javeriana, Bogotá, Colombia
