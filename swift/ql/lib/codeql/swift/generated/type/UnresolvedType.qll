// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.type.Type

class UnresolvedTypeBase extends @unresolved_type, Type {
  override string getAPrimaryQlClass() { result = "UnresolvedType" }

  cached
  override Element getAChild() {
    none() or
    result = Type.super.getAChild()
  }
}
