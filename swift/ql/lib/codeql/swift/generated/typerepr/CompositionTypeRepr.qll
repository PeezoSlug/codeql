// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.typerepr.TypeRepr

class CompositionTypeReprBase extends @composition_type_repr, TypeRepr {
  override string getAPrimaryQlClass() { result = "CompositionTypeRepr" }

  cached
  override Element getAChild() {
    none() or
    result = TypeRepr.super.getAChild()
  }
}
