import 'package:bytebank/components/menu_item_transferencia.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/material.dart';

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;
  final Function() quandoMenuEditaClicado;
  final Function() quandoMenuRemoverClicado;

  ItemTransferencia(
    this._transferencia, {
    this.quandoMenuEditaClicado,
    this.quandoMenuRemoverClicado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transferencia.id.toString()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_transferencia.valor.toString()),
            Text(_transferencia.numeroConta.toString()),
          ],
        ),
        onTap: () {
          _abreMenu(context);
        },
      ),
    );
  }

  void _abreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MenuItemTransferencia(
        _transferencia,
        quandoEditarClicado: () => quandoMenuEditaClicado(),
        quandoRemoverClicado: () => quandoMenuRemoverClicado(),
      ),
    );
  }
}
