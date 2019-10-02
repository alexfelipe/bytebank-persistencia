import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/material.dart';

const _tituloAppBar = 'Criando Transferência';

const _rotuloCampoValor = 'Valor';
const _dicaCampoValor = '0.00';

const _rotuloCampoNumeroConta = 'Número da conta';
const _dicaCampoNumeroConta = '0000';

const _textoBotaoConfirmar = 'Confirmar';

class FormularioTransferencia extends StatefulWidget {
  final Transferencia transferencia;

  FormularioTransferencia({this.transferencia});

  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState(transferencia);
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  int _idTransferenciaRecebida;
  String _campoValorRecebido = "";
  String _campoNumeroContaRecebido = "";

  FormularioTransferenciaState(Transferencia transferencia) {
    if (transferencia != null) {
      _idTransferenciaRecebida = transferencia.id;
      _campoNumeroContaRecebido = transferencia.numeroConta.toString();
      _campoValorRecebido = transferencia.valor.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_tituloAppBar),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Editor(
                texto: _campoNumeroContaRecebido,
                controlador: _controladorCampoNumeroConta,
                dica: _dicaCampoNumeroConta,
                rotulo: _rotuloCampoNumeroConta,
              ),
              Editor(
                texto: _campoValorRecebido,
                dica: _dicaCampoValor,
                controlador: _controladorCampoValor,
                rotulo: _rotuloCampoValor,
                icone: Icons.monetization_on,
              ),
              RaisedButton(
                child: Text(_textoBotaoConfirmar),
                onPressed: () => _criaTransferencia(context),
              ),
            ],
          ),
        ));
  }

  void _criaTransferencia(BuildContext context) {
    final int numeroConta = int.tryParse(_controladorCampoNumeroConta.text);
    final double valor = double.tryParse(_controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(
        valor,
        numeroConta,
        id: _idTransferenciaRecebida,
      );
      Navigator.pop(context, transferenciaCriada);
    }
  }
}
