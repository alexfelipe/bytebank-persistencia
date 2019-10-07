import 'dart:convert';

import 'package:bytebank/components/item_transferencia.dart';
import 'package:bytebank/dao/transferencia_dao.dart';
import 'package:bytebank/models/transferencia.dart';
import 'package:bytebank/screens/transferencia/formulario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const _tituloAppBar = 'Transferências';

class ListaTransferencias extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListaTransferencias> {
  final _dao = TransferenciaDao();
  final _webClient = TransferenciaWebClient();
  final List<Transferencia> _transferencias = List();

  @override
  void initState() {
    super.initState();
    _buscaTransferencias();
  }

  void _buscaTransferencias() async {
    List<Transferencia> novasTransferencias = await _dao.todasTransferencias();
    List<Transferencia> transferenciasWeb = await _webClient.todas();
    print(transferenciasWeb);
    if (novasTransferencias != null) {
      setState(() {
        _transferencias.addAll(novasTransferencias);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_transferencias);
    return Scaffold(
      appBar: AppBar(
        title: Text(_tituloAppBar),
      ),
      body: ListView.builder(
        itemCount: _transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = _transferencias[indice];
          return ItemTransferencia(
            transferencia,
            quandoMenuEditaClicado: () {
              _abreFormularioParaEdicao(context, transferencia);
            },
            quandoMenuRemoverClicado: () {
              _remove(transferencia);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _abreFormularioParaInsercao(context);
        },
      ),
    );
  }

  void _abreFormularioParaInsercao(BuildContext context) async {
    final transferenciaNova = await _vaiParaFormulario(context);
    if (transferenciaNova != null) {
      _salva(transferenciaNova);
    }
  }

  void _abreFormularioParaEdicao(
    BuildContext context,
    Transferencia transferencia,
  ) async {
    final transferenciaEditada =
        await _vaiParaFormulario(context, transferencia: transferencia);
    if (transferenciaEditada != null) {
      _edita(transferenciaEditada);
    }
  }

  void _remove(Transferencia transferencia) async {
    await _dao.remove(transferencia);
    _atualiza();
  }

  Future<Transferencia> _vaiParaFormulario(BuildContext context,
      {Transferencia transferencia}) {
    return Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return FormularioTransferencia(
          transferencia: transferencia,
        );
      },
    ));
  }

  void _salva(Transferencia transferencia) async {
    await _dao.salva(transferencia);
    _atualiza();
  }

  void _atualiza() async {
    final transferenciasNovas = await _dao.todasTransferencias();
    setState(() {
      _transferencias.clear();
      _transferencias.addAll(transferenciasNovas);
    });
  }

  void _edita(Transferencia transferencia) async {
    await _dao.edita(transferencia);
    _atualiza();
  }
}

class TransferenciaWebClient {
  Future<http.Response> buscaTransacoes() {
    return http.get("http://192.168.1.221:8080/transacoes");
  }

  List<Transferencia> fromJson(Map<String, dynamic> json) {
    return List.generate(
      json.length,
      (i) {
        return Transferencia(
          json['valor'],
          json['numeroConta'],
          id: json['id'],
        );
      },
    );
  }

  Future<List<Transferencia>> todas() async {
    final resposta = await buscaTransacoes();
    if (resposta.statusCode == 200) {
      final List jsond = json.decode(resposta.body);
      return jsond.map((i) => Transferencia.deJson(i)).toList();
    }
    throw Exception('falha ao carregar transferencias');
  }
}
