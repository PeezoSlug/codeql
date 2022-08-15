// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.type.Type

class ReferenceStorageTypeBase extends Synth::TReferenceStorageType, Type {
  Type getImmediateReferentType() {
    result =
      Synth::convertTypeFromDb(Synth::convertReferenceStorageTypeToDb(this)
            .(Raw::ReferenceStorageType)
            .getReferentType())
  }

  final Type getReferentType() { result = getImmediateReferentType().resolve() }
}
