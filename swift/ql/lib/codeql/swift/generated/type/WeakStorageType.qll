// generated by codegen/codegen.py
import codeql.swift.elements.Element
import codeql.swift.elements.type.ReferenceStorageType

class WeakStorageTypeBase extends @weak_storage_type, ReferenceStorageType {
  override string getAPrimaryQlClass() { result = "WeakStorageType" }

  cached
  override Element getAChild() {
    none() or
    result = ReferenceStorageType.super.getAChild()
  }
}
