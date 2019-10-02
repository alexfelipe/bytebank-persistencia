import 'package:bytebank/models/transferencia.dart';
import 'package:flutter/material.dart';

final _editar = "Editar";
final _remover = "Remover";

class MenuItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;
  final Function() quandoEditarClicado;
  final Function() quandoRemoverClicado;

  MenuItemTransferencia(
    this._transferencia, {
    this.quandoEditarClicado,
    this.quandoRemoverClicado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Transferência ${_transferencia.id} - ${_transferencia.valor}',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          ListTile(
            onTap: () => quandoEditarClicado(),
            leading: Icon(Icons.edit),
            title: Text(_editar),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              return quandoRemoverClicado();
            },
            leading: Icon(Icons.delete),
            title: Text(_remover),
          ),
        ],
      ),
    );
  }
}
