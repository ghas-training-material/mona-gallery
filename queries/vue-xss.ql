/**
 * @name Client-side cross-site scripting
 * @description Writing user input directly to the DOM allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id js/vue-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.DomBasedXssQuery
import semmle.javascript.security.dataflow.DomBasedXssCustomizations
import DataFlow::PathGraph

// Unprecise Axios Source
class AxiosSource extends DomBasedXss::Source {
  AxiosSource() {
    this.(DataFlow::PropRead).getPropertyName() = "data" and
    exists(DataFlow::ParameterNode response | response.getName() = "response" |
      response.flowsTo(this.(DataFlow::PropRead).getBase())
    )
  }
}

class VForAttribute extends DataFlow::Node {
  HTML::Attribute attr;

  VForAttribute() {
    this.(DataFlow::HtmlAttributeNode).getAttribute() = attr and attr.getName() = "v-for"
  }

  /**
   * Gets the HTML attribute of this sink.
   */
  HTML::Attribute getAttr() { result = attr }

  string getForAlias() { result = attr.getValue().regexpCapture("(.*)\\s+in\\s+(.*)", 1).trim() }

  string getForArraySource() {
    result = attr.getValue().regexpCapture("(.*)\\s+in\\s+(.*)", 2).trim()
  }

  Vue::Component getComponent() {
    result.getTemplateElement().(Vue::Template::HtmlElement).getElement() = this.getAttr().getRoot()
  }

  DataFlow::Node getAForArraySourceValue() {
    exists(DataFlow::PropWrite propWrite |
      resolveRefForArraySourceValue(this, this.getForArraySource(), propWrite) and
      result = propWrite.getRhs()
    )
  }
}

predicate resolveRefForArraySourceValue(
  VForAttribute vfor, string accessPath, DataFlow::PropRef propRef
) {
  // accesssPath must be a prefix of the for array source.
  exists(int dotOffsets, string arraySrc |
    arraySrc = vfor.getForArraySource() and dotOffsets = arraySrc.indexOf(".")
  |
    (
      arraySrc.prefix(dotOffsets) = accessPath
      or
      arraySrc = accessPath
    ) and
    accessPath != "this"
  ) and
  (
    // Base case: foo or this.foo
    exists(string prop | prop = accessPath.replaceAll("?", "").replaceAll("this.", "") |
      propRef = vfor.getComponent().getAnInstanceRef().getAPropertyReference(prop)
    )
    or
    // Induction step: foo.bar or this.foo.bar
    exists(DataFlow::PropRef basePropRef, string baseAccessPath, string prop |
      baseAccessPath = accessPath.prefix(max(int idx | idx = accessPath.indexOf("."))) and
      prop = accessPath.suffix(max(int idx | idx = accessPath.indexOf(".")) + 1).replaceAll("?", "") and
      resolveRefForArraySourceValue(vfor, baseAccessPath, basePropRef) and
      propRef.getPropertyName() = prop and
      (
        propRef.getBase() = basePropRef
        or
        // A more precise source can be identified when the source of this.gallery, reponse.data, is flowing through an intermediate variable
        // to the base of a property reference where the property name matches our current property.
        // e.g.,
        // const gallery = response.data
        // axios.get("http://localhost:8081/gallery/art").then((response) => {
        //    gallery.art = response.data
        //    this.gallery = gallery
        basePropRef.(DataFlow::PropWrite).getRhs().getALocalSource().flowsTo(propRef.getBase())
      )
    )
  )
}

class VHtmlAttributeStep extends TaintTracking::SharedTaintStep {
  override predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) {
    succ.(VForAttribute).getAForArraySourceValue() = pred
    or
    exists(VForAttribute vfor, Vue::VHtmlAttribute vhtml | pred = vfor and succ = vhtml |
      vfor.getAttr().getElement() = vhtml.getAttr().getElement().getParent+() and
      vhtml.getAttr().getValue().prefix(vhtml.getAttr().getValue().indexOf(".", 0, 0)) =
        vfor.getForAlias()
    )
  }
}

from DataFlow::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  sink.getNode().(Sink).getVulnerabilityKind() + " vulnerability due to $@.", source.getNode(),
  "user-provided value"
