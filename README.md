# Tu primer ERC20 Token desde Cero

¿Quieres aprender a desplegar tu propio token ERC20 utilizando Foundry? Estás en el lugar correcto. En este tutorial, te guiaré a través de todo el proceso, desde la instalación hasta el despliegue del contrato, de manera sencilla y directa. ¡Vamos a ello!

¿Qué Necesitas Antes de Empezar?
Antes de ponernos manos a la obra, asegúrate de tener Foundry instalado en tu sistema. Si aún no lo has hecho, no te preocupes, es fácil:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```


## Instalación del Proyecto
Primero, necesitas clonar el repositorio del proyecto en tu máquina local. Esto es lo que tienes que hacer:

### Clona el repositorio:

```bash
git clone https://github.com/cromewar/your-first-ERC20.git
cd your-first-ERC20
```


Instala las dependencias necesarias: Como este es un proyecto de contratos inteligentes, vamos a necesitar OpenZeppelin, entre otras cosas:

```bash
forge install OpenZeppelin/openzeppelin-c ontracts --no-commit
```

### Compilando el Contrato ERC20
Ahora que todo está configurado, es momento de compilar los contratos. Esto asegurará que todo esté en orden antes de proceder al despliegue. Simplemente ejecuta:

```bash
forge build
```
### Desplegando el Contrato en la Red

¡Vamos a lo más emocionante! Para desplegar el contrato, debes crear un script de despliegue en la carpeta script/. Una vez listo, puedes ejecutarlo con el siguiente comando:

```bash
forge script script/DeployNuestroToken.s.sol --broadcast --rpc-url URL_DE_TU_RED
```

Nota: Asegúrate de reemplazar URL_DE_TU_RED con la URL de la red en la que deseas desplegar tu token (por ejemplo, la red de pruebas Sepolia o la red principal de Ethereum).

### Ejecutando Pruebas

¡Genial! Ya casi terminamos. Antes de finalizar, es buena idea asegurarte de que todo funciona correctamente ejecutando las pruebas que has definido. Usa:

```bash
forge test
```

Esto ejecutará todas las pruebas que hayas configurado en la carpeta test/ y te dará tranquilidad de que todo funciona como debería.

### Licencia
Este proyecto está bajo la Licencia MIT, lo que significa que puedes usarlo libremente. Para más detalles, revisa el archivo LICENSE en el repositorio.
