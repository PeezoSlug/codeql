// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.AstNode

class PatternBase extends @pattern, AstNode {
  cached
  override Element getAChild() {
    none() or
    result = AstNode.super.getAChild()
  }
}
