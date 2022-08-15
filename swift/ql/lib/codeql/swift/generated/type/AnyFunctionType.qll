// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.type.Type

class AnyFunctionTypeBase extends Synth::TAnyFunctionType, Type {
  Type getImmediateResult() {
    result =
      Synth::convertTypeFromDb(Synth::convertAnyFunctionTypeToDb(this)
            .(Raw::AnyFunctionType)
            .getResult())
  }

  final Type getResult() { result = getImmediateResult().resolve() }

  Type getImmediateParamType(int index) {
    result =
      Synth::convertTypeFromDb(Synth::convertAnyFunctionTypeToDb(this)
            .(Raw::AnyFunctionType)
            .getParamType(index))
  }

  final Type getParamType(int index) { result = getImmediateParamType(index).resolve() }

  final Type getAParamType() { result = getParamType(_) }

  final int getNumberOfParamTypes() { result = count(getAParamType()) }

  string getParamLabel(int index) {
    result = Synth::convertAnyFunctionTypeToDb(this).(Raw::AnyFunctionType).getParamLabel(index)
  }

  final string getAParamLabel() { result = getParamLabel(_) }

  final int getNumberOfParamLabels() { result = count(getAParamLabel()) }

  predicate isThrowing() {
    Synth::convertAnyFunctionTypeToDb(this).(Raw::AnyFunctionType).isThrowing()
  }

  predicate isAsync() { Synth::convertAnyFunctionTypeToDb(this).(Raw::AnyFunctionType).isAsync() }
}
