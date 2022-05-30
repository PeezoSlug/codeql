// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.decl.FuncDecl

class AccessorDeclBase extends @accessor_decl, FuncDecl {
  override string getAPrimaryQlClass() { result = "AccessorDecl" }

  cached
  override Element getAChild() {
    none() or
    result = FuncDecl.super.getAChild()
  }

  predicate isGetter() { accessor_decl_is_getter(this) }

  predicate isSetter() { accessor_decl_is_setter(this) }

  predicate isWillSet() { accessor_decl_is_will_set(this) }

  predicate isDidSet() { accessor_decl_is_did_set(this) }
}
