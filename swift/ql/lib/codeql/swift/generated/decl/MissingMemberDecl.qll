// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.decl.Decl

class MissingMemberDeclBase extends @missing_member_decl, Decl {
  override string getAPrimaryQlClass() { result = "MissingMemberDecl" }

  cached
  override Element getAChild() {
    none() or
    result = Decl.super.getAChild()
  }
}
