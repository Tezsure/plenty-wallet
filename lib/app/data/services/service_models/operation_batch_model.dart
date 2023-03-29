class OperationModelBatch<T> {
  String? destination;
  double? amount;
  String? entrypoint;
  dynamic parameters;
  OperationModelBatch({
    this.destination,
    this.amount,
    this.entrypoint,
    this.parameters,
  });
}
