// generated by codegen/codegen.py
class ElementBase extends @element {
  string toString() { none() } // overridden by subclasses

  string getAPrimaryQlClass() { none() } // overridden by subclasses

  final string getPrimaryQlClasses() { result = concat(this.getAPrimaryQlClass(), ",") }

  ElementBase getResolveStep() { none() } // overridden by subclasses

  ElementBase resolve() {
    not exists(getResolveStep()) and result = this
    or
    result = getResolveStep().resolve()
  }

  ElementBase getAChild() { none() } // overridden by subclasses, internal use only

  predicate isUnknown() { element_is_unknown(this) }
}
