// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.type.NominalType

class ProtocolTypeBase extends @protocol_type, NominalType {
  override string getAPrimaryQlClass() { result = "ProtocolType" }

  cached
  override Element getAChild() {
    none() or
    result = NominalType.super.getAChild()
  }
}
