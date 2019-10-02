class Transferencia {
  final int id;
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta, {int id}) : this.id = id;

  @override
  String toString() {
    return 'Transferencia{id: $id, valor: $valor, numeroConta: $numeroConta}';
  }
}
