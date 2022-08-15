// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.decl.GenericTypeDecl
import codeql.swift.elements.decl.IterableDeclContext
import codeql.swift.elements.type.Type

class NominalTypeDeclBase extends Synth::TNominalTypeDecl, GenericTypeDecl, IterableDeclContext {
  Type getImmediateType() {
    result =
      Synth::convertTypeFromDb(Synth::convertNominalTypeDeclToDb(this)
            .(Raw::NominalTypeDecl)
            .getType())
  }

  final Type getType() { result = getImmediateType().resolve() }
}
