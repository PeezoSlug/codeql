// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.AstNode

class DeclBase extends @decl, AstNode {
  cached
  override Element getAChild() {
    none() or
    result = AstNode.super.getAChild()
  }
}
