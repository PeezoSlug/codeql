// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.Element
import codeql.swift.elements.type.Type

class TypeBase extends Synth::TType, Element {
  string getName() { result = Synth::convertTypeToDb(this).(Raw::Type).getName() }

  Type getImmediateCanonicalType() {
    result = Synth::convertTypeFromDb(Synth::convertTypeToDb(this).(Raw::Type).getCanonicalType())
  }

  final Type getCanonicalType() { result = getImmediateCanonicalType().resolve() }
}
