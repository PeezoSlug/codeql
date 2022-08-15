// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.type.Type

class InOutTypeBase extends Synth::TInOutType, Type {
  override string getAPrimaryQlClass() { result = "InOutType" }

  Type getImmediateObjectType() {
    result =
      Synth::convertTypeFromDb(Synth::convertInOutTypeToDb(this).(Raw::InOutType).getObjectType())
  }

  final Type getObjectType() { result = getImmediateObjectType().resolve() }
}
