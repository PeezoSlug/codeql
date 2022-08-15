// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.type.NominalOrBoundGenericNominalType
import codeql.swift.elements.type.Type

class BoundGenericTypeBase extends Synth::TBoundGenericType, NominalOrBoundGenericNominalType {
  Type getImmediateArgType(int index) {
    result =
      Synth::convertTypeFromDb(Synth::convertBoundGenericTypeToDb(this)
            .(Raw::BoundGenericType)
            .getArgType(index))
  }

  final Type getArgType(int index) { result = getImmediateArgType(index).resolve() }

  final Type getAnArgType() { result = getArgType(_) }

  final int getNumberOfArgTypes() { result = count(getAnArgType()) }
}
