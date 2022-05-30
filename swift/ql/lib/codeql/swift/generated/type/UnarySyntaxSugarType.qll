// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.type.SyntaxSugarType
import codeql.swift.elements.type.Type

class UnarySyntaxSugarTypeBase extends @unary_syntax_sugar_type, SyntaxSugarType {
  cached
  override Element getAChild() {
    none() or
    result = SyntaxSugarType.super.getAChild()
  }

  Type getBaseType() {
    exists(Type x |
      unary_syntax_sugar_types(this, x) and
      result = x.resolve()
    )
  }
}
