function initTree(people) {
  //Create a new ST instance
  var st = new $jit.ST({
    //make it a multitree
    multitree: true,
    //set orientation of the tree
    orientation: 'top',
    //id of viz container element
    injectInto: 'infovis',
    //set distance between node and its children
    levelDistance: 33,
    //set the number of levels to show
    levelsToShow: 10,
    //don't constrain the number of nodes shown
    constrained: false,
    //enable panning
    Navigation: {
      enable:false,
      panning:false
    },
    //set node and edge styles
    //set overridable=true for styling individual
    //nodes or edges
    Node: {
      width: 90,
      height: 55,
      type: 'rectangle',
      color: '#ccc',
      autoHeight: false,
      autoWidth: false,
      overridable: true
    },

    Edge: {
      type: 'bezier',
      overridable: true,
      color: '#333'
    },

    //This method is called on DOM label creation.
    //Use this method to add event handlers and styles to
    //your node.
    onCreateLabel: function(label, node) {
      label.id = node.id;
      label.innerHTML = node.name;
      label.onclick = function() {
        if (node.selected) {
          document.location.href = '/people/'+node.id;
        } else {
          document.location.href = '/people/'+node.id;
        }
      };
      //set label styles
      var style = label.style;
      style.width = '84px';
      style.height = '49px';
      style.padding = '0px';
      style.cursor = 'pointer';
      style.color = '#333';
      style.fontWeight = 'bold';
      style.fontSize = '0.8em';
      style.textAlign= 'center';
    },

    //This method is called right before plotting
    //a node. It's useful for changing an individual node
    //style properties before plotting it.
    //The data properties prefixed with a dollar
    //sign will override the global node style properties.
    onBeforePlotNode: function(node) {
      //add some color to the nodes in the path between the
      //root node and the selected node.
      if (node.selected) {
        node.data.$color = "#ff7";
      }
    },

    //This method is called right before plotting
    //an edge. It's useful for changing an individual edge
    //style properties before plotting it.
    //Edge data proprties prefixed with a dollar sign will
    //override the Edge global style properties.
    onBeforePlotLine: function(adj) {
      if (adj.nodeFrom.selected && adj.nodeTo.selected) {
        adj.data.$color = "#eed";
        adj.data.$lineWidth = 3;
      }
      else {
        delete adj.data.$color;
        delete adj.data.$lineWidth;
      }
    }
  });
  //load json data
  st.loadJSON(people);
  //compute node positions and layout
  st.compute();
  st.select(st.root);
  //XXX $jit.EdgeHelper.line.render({ x: 10, y: 30 }, { x: 10, y: 500 }, st.canvas);
}
