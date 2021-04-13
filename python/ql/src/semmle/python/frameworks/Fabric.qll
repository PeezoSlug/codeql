/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * both version 1.x and 2.x.
 *
 * See
 * - http://docs.fabfile.org/en/1.14/tutorial.html and
 * - http://docs.fabfile.org/en/2.5/getting-started.html
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * version 1.x.
 *
 * See http://docs.fabfile.org/en/1.14/tutorial.html.
 */
private module FabricV1 {
  /** Gets a reference to the `fabric` module. */
  API::Node fabric() { result = API::moduleImport("fabric") }

  /**
   * Gets a reference to the attribute `attr_name` of the `fabric` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private API::Node fabric_attr(string attr_name) { result = fabric().getMember(attr_name) }

  /** Provides models for the `fabric` module. */
  module fabric {
    // -------------------------------------------------------------------------
    // fabric.api
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.api` module. */
    API::Node api() { result = fabric_attr("api") }

    /** Provides models for the `fabric.api` module */
    module api {
      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.api` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private API::Node api_attr(string attr_name) { result = api().getMember(attr_name) }

      /**
       * A call to either
       * - `fabric.api.local`
       * - `fabric.api.run`
       * - `fabric.api.sudo`
       * See
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.local
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.run
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.sudo
       */
      private class FabricApiLocalRunSudoCall extends SystemCommandExecution::Range,
        DataFlow::CallCfgNode {
        FabricApiLocalRunSudoCall() { this = api_attr(["local", "run", "sudo"]).getACall() }

        override DataFlow::Node getCommand() {
          result.asCfgNode() = [node.getArg(0), node.getArgByName("command")]
        }
      }
    }
  }
}

/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * version 2.x.
 *
 * See http://docs.fabfile.org/en/2.5/getting-st  arted.html.
 */
private module FabricV2 {
  /** Gets a reference to the `fabric` module. */
  API::Node fabric() { result = API::moduleImport("fabric") }

  /**
   * Gets a reference to the attribute `attr_name` of the `fabric` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private API::Node fabric_attr(string attr_name) { result = fabric().getMember(attr_name) }

  /** Provides models for the `fabric` module. */
  module fabric {
    // -------------------------------------------------------------------------
    // fabric.connection
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.connection` module. */
    API::Node connection() { result = fabric_attr("connection") }

    /** Provides models for the `fabric.connection` module */
    module connection {
      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.connection` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private API::Node connection_attr(string attr_name) {
        result = connection().getMember(attr_name)
      }

      /**
       * Provides models for the `fabric.connection.Connection` class
       *
       * See https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.
       */
      module Connection {
        /** Gets a reference to the `fabric.connection.Connection` class. */
        API::Node classRef() {
          result in [fabric_attr("Connection"), connection_attr("Connection")]
        }

        /**
         * A source of instances of `fabric.connection.Connection`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `Connection::instance()` to get references to instances of `fabric.connection.Connection`.
         */
        abstract class InstanceSource extends DataFlow::LocalSourceNode { }

        private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
          ClassInstantiation() { this = classRef().getACall() }
        }

        /** Gets a reference to an instance of `fabric.connection.Connection`. */
        private DataFlow::LocalSourceNode instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `fabric.connection.Connection`. */
        DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

        /**
         * Gets a reference to either `run`, `sudo`, or `local` method on a
         * `fabric.connection.Connection` instance.
         *
         * See
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.run
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.sudo
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.local
         */
        private DataFlow::LocalSourceNode instanceRunMethods(DataFlow::TypeTracker t) {
          t.startInAttr(["run", "sudo", "local"]) and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = instanceRunMethods(t2).track(t2, t))
        }

        /**
         * Gets a reference to either `run`, `sudo`, or `local` method on a
         * `fabric.connection.Connection` instance.
         *
         * See
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.run
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.sudo
         * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.local
         */
        DataFlow::Node instanceRunMethods() {
          instanceRunMethods(DataFlow::TypeTracker::end()).flowsTo(result)
        }
      }
    }

    /**
     * A call to either `run`, `sudo`, or `local` on a `fabric.connection.Connection` instance.
     * See
     * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.run
     * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.sudo
     * - https://docs.fabfile.org/en/2.5/api/connection.html#fabric.connection.Connection.local
     */
    private class FabricConnectionRunSudoLocalCall extends SystemCommandExecution::Range,
      DataFlow::CallCfgNode {
      FabricConnectionRunSudoLocalCall() {
        this.getFunction() = fabric::connection::Connection::instanceRunMethods()
      }

      override DataFlow::Node getCommand() {
        result.asCfgNode() = [node.getArg(0), node.getArgByName("command")]
      }
    }

    // -------------------------------------------------------------------------
    // fabric.tasks
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.tasks` module. */
    API::Node tasks() { result = fabric_attr("tasks") }

    /** Provides models for the `fabric.tasks` module */
    module tasks {
      /** Gets a reference to the `fabric.tasks.task` decorator. */
      API::Node task() { result in [tasks().getMember("task"), fabric().getMember("task")] }
    }

    class FabricTaskFirstParamConnectionInstance extends fabric::connection::Connection::InstanceSource,
      DataFlow::ParameterNode {
      FabricTaskFirstParamConnectionInstance() {
        exists(Function func |
          func.getADecorator() = fabric::tasks::task().getAUse().asExpr() and
          this.getParameter() = func.getArg(0)
        )
      }
    }

    // -------------------------------------------------------------------------
    // fabric.group
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.group` module. */
    API::Node group() { result = fabric_attr("group") }

    /** Provides models for the `fabric.group` module */
    module group {
      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.group` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private API::Node group_attr(string attr_name) { result = group().getMember(attr_name) }

      /**
       * Provides models for the `fabric.group.Group` class and its subclasses.
       *
       * `fabric.group.Group` is an abstract class, that has concrete implementations
       * `SerialGroup` and `ThreadingGroup`.
       *
       * See
       * - https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group
       * - https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.SerialGroup
       * - https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.ThreadingGroup
       */
      module Group {
        /**
         * A source of instances of a subclass of `fabric.group, extend this class to model new instances.Group`
         *
         * This can include instantiation of a class, return value from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use `Group::subclassInstance()` predicate to get references to an instance of a subclass of `fabric.group.Group`.
         */
        abstract class ModeledSubclass extends API::Node {
          /** Gets a string representation of this element. */
          override string toString() { result = this.(API::Node).toString() }
        }

        /** Gets a reference to an instance of a subclass of `fabric.group.Group`. */
        API::Node subclassInstance() { result = any(ModeledSubclass m).getASubclass*().getReturn() }

        /**
         * Gets a reference to the `run` method on an instance of a subclass of `fabric.group.Group`.
         *
         * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group.run
         */
        API::Node subclassInstanceRunMethod() { result = subclassInstance().getMember("run") }
      }

      /**
       * A call to `run` on an instance of a subclass of `fabric.group.Group`.
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.Group.run
       */
      private class FabricGroupRunCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
        FabricGroupRunCall() { this = fabric::group::Group::subclassInstanceRunMethod().getACall() }

        override DataFlow::Node getCommand() {
          result.asCfgNode() = [node.getArg(0), node.getArgByName("command")]
        }
      }

      /**
       * Provides models for the `fabric.group.SerialGroup` class
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.SerialGroup.
       */
      module SerialGroup {
        private class ClassInstantiation extends Group::ModeledSubclass {
          ClassInstantiation() { this in [group_attr("SerialGroup"), fabric_attr("SerialGroup")] }
        }
      }

      /**
       * Provides models for the `fabric.group.ThreadingGroup` class
       *
       * See https://docs.fabfile.org/en/2.5/api/group.html#fabric.group.ThreadingGroup.
       */
      module ThreadingGroup {
        private class ClassInstantiation extends Group::ModeledSubclass {
          ClassInstantiation() {
            this in [group_attr("ThreadingGroup"), fabric_attr("ThreadingGroup")]
          }
        }
      }
    }
  }
}
