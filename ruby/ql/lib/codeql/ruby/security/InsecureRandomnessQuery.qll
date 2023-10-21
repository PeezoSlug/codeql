/**
 * Provides default sources, sinks and sanitizers for detecting Insecure Randomness
 * vulnerabilities, as well as extension points for adding your own.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
import InsecureRandomnessCustomizations::InsecureRandomness

/**
 * A taint-tracking configuration for detecting Insecure Randomness vulnerabilities.
 * DEPRECATED: Use `InsecureRandomnessFlow`
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "InsecureRandomnessConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

private module InsecureRandomnessConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }
}

/**
 * Taint-tracking for detecting Insecure Randomness vulnerabilities.
 */
module InsecureRandomnessFlow = TaintTracking::Global<InsecureRandomnessConfig>;
