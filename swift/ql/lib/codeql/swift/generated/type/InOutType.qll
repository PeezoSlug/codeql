// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.type.Type

class InOutTypeBase extends @in_out_type, Type {
  override string getAPrimaryQlClass() { result = "InOutType" }

  cached
  override Element getAChild() {
    none() or
    result = Type.super.getAChild()
  }
}
