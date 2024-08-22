// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface tokenRecipient {
    function receiveApproval(
        address _from,
        uint256 _value,
        address _token,
        bytes calldata _extraData
    ) external;
}

contract ManualToken {
    // Variables públicas del token
    string public name;
    string public symbol;
    uint8 public decimals = 18; 
    // 18 decimales es el estándar recomendado, evitar cambiarlo
    uint256 public totalSupply;

    // Esto crea un array con todos los balances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Esto genera un evento público en la blockchain que notificará a los clientes
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Esto genera un evento público en la blockchain que notificará a los clientes
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    // Esto notifica a los clientes sobre la cantidad quemada
    event Burn(address indexed from, uint256 value);

    /**
     * Función constructora
     *
     * Inicializa el contrato con un suministro inicial de tokens para el creador del contrato
     */
    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
    ) {
        totalSupply = initialSupply * 10 ** uint256(decimals); // Actualiza el suministro total con la cantidad de decimales
        balanceOf[msg.sender] = totalSupply; // Asigna al creador todos los tokens iniciales
        name = tokenName; // Establece el nombre para fines de visualización
        symbol = tokenSymbol; // Establece el símbolo para fines de visualización
    }

    /**
     * Transferencia interna, solo puede ser llamada por este contrato
     */
    function _transfer(address _from, address _to, uint256 _value) internal {
        // Prevenir transferencias a la dirección 0x0. Usar burn() en su lugar
        require(_to != address(0x0), "Transferencia a direccion invalida");
        // Verifica si el remitente tiene suficiente saldo
        require(balanceOf[_from] >= _value, "Saldo insuficiente");
        // Verifica si habrá desbordamiento (overflow)
        require(balanceOf[_to] + _value >= balanceOf[_to], "Overflow detectado");
        // Guarda los balances previos para una futura verificación
        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
        // Resta el valor del saldo del remitente
        balanceOf[_from] -= _value;
        // Añade el mismo valor al saldo del receptor
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Las aserciones se utilizan para análisis estático y detectar bugs. Nunca deberían fallar
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transferir tokens
     *
     * Envía `_value` tokens a `_to` desde tu cuenta
     *
     * @param _to La dirección del receptor
     * @param _value la cantidad a enviar
     */
    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * Transferir tokens desde otra dirección
     *
     * Envía `_value` tokens a `_to` en nombre de `_from`
     *
     * @param _from La dirección del remitente
     * @param _to La dirección del receptor
     * @param _value la cantidad a enviar
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender], "Monto supera el permitido"); // Verifica la asignación permitida (allowance)
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * Establecer la asignación para otra dirección
     *
     * Permite a `_spender` gastar hasta `_value` tokens en tu nombre
     *
     * @param _spender La dirección autorizada para gastar
     * @param _value el monto máximo que pueden gastar
     */
    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * Establecer la asignación para otra dirección y notificarla
     *
     * Permite a `_spender` gastar hasta `_value` tokens en tu nombre, y luego notifica al contrato sobre esto
     *
     * @param _spender La dirección autorizada para gastar
     * @param _value el monto máximo que pueden gastar
     * @param _extraData información adicional para enviar al contrato aprobado
     */
    function approveAndCall(
        address _spender,
        uint256 _value,
        bytes memory _extraData
    ) public returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(
                msg.sender,
                _value,
                address(this),
                _extraData
            );
            return true;
        }
    }

    /**
     * Destruir tokens
     *
     * Elimina de forma irreversible `_value` tokens del sistema
     *
     * @param _value la cantidad de tokens a quemar
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Saldo insuficiente para quemar"); // Verifica si el remitente tiene suficientes tokens
        balanceOf[msg.sender] -= _value; // Resta el valor del saldo del remitente
        totalSupply -= _value; // Actualiza el suministro total
        emit Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destruir tokens desde otra cuenta
     *
     * Elimina de forma irreversible `_value` tokens del sistema en nombre de `_from`.
     *
     * @param _from la dirección del remitente
     * @param _value la cantidad de tokens a quemar
     */
    function burnFrom(
        address _from,
        uint256 _value
    ) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Saldo insuficiente en la cuenta objetivo"); // Verifica si el saldo objetivo es suficiente
        require(_value <= allowance[_from][msg.sender], "Monto supera la asignacion permitida"); // Verifica la asignación permitida
        balanceOf[_from] -= _value; // Resta el valor del saldo objetivo
        allowance[_from][msg.sender] -= _value; // Resta de la asignación permitida
        totalSupply -= _value; // Actualiza el suministro total
        emit Burn(_from, _value);
        return true;
    }
}
