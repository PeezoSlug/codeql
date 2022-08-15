// generated by codegen/codegen.py
private import codeql.swift.generated.Synth
private import codeql.swift.generated.Raw
import codeql.swift.elements.decl.AbstractStorageDecl
import codeql.swift.elements.expr.Expr
import codeql.swift.elements.pattern.Pattern
import codeql.swift.elements.type.Type

class VarDeclBase extends Synth::TVarDecl, AbstractStorageDecl {
  string getName() { result = Synth::convertVarDeclToDb(this).(Raw::VarDecl).getName() }

  Type getImmediateType() {
    result = Synth::convertTypeFromDb(Synth::convertVarDeclToDb(this).(Raw::VarDecl).getType())
  }

  final Type getType() { result = getImmediateType().resolve() }

  Type getImmediateAttachedPropertyWrapperType() {
    result =
      Synth::convertTypeFromDb(Synth::convertVarDeclToDb(this)
            .(Raw::VarDecl)
            .getAttachedPropertyWrapperType())
  }

  final Type getAttachedPropertyWrapperType() {
    result = getImmediateAttachedPropertyWrapperType().resolve()
  }

  final predicate hasAttachedPropertyWrapperType() { exists(getAttachedPropertyWrapperType()) }

  Pattern getImmediateParentPattern() {
    result =
      Synth::convertPatternFromDb(Synth::convertVarDeclToDb(this).(Raw::VarDecl).getParentPattern())
  }

  final Pattern getParentPattern() { result = getImmediateParentPattern().resolve() }

  final predicate hasParentPattern() { exists(getParentPattern()) }

  Expr getImmediateParentInitializer() {
    result =
      Synth::convertExprFromDb(Synth::convertVarDeclToDb(this).(Raw::VarDecl).getParentInitializer())
  }

  final Expr getParentInitializer() { result = getImmediateParentInitializer().resolve() }

  final predicate hasParentInitializer() { exists(getParentInitializer()) }
}
