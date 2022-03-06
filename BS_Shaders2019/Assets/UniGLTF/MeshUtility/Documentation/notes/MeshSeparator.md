# MeshSeparator

MeshSeparator provides a functionality of separating meshes contained BlendShape. Simply select a GameObject with skinned Meshes and click processing. The mesh splitting results are generated in the Assets folder. The model with sparse BlendShape data distributed in a large-volume mesh can be benefited from size reduction and performance improvements after mesh separation.  

## How to use

Select a GameObject contained skinned mesh and BlendShape (or drag and drop a GameObject to TargetObject field shown below):

<img src="../images/interface_1.jpg" width="200">

From menu go to `UniGLTF` -> `Mesh Utility` -> `MeshProcessing Wizard`, select `MeshSeparator` and click `process`:

<img src="../images/interface_2.jpg" width="300">

The separate meshes are saved in the Assets folder.

<img src="../images/interface_3.jpg" width="200">

In the Hierarchy Window, click the generated GameObject and export.

<img src="../images/interface_4.jpg" width="250">

In this example, the model's mesh are split into two parts: face and body:

Face: with BlendShape      | Body: without BlendShape
:-------------------------:|:-------------------------:
<img title="result_1.jpg" src="../images/result_1.jpg" width="200">  | <img title="result_2.jpg" src="../images/result_2.jpg" width="200">

Note that if all the polygons of a mesh are used by BlendShape, MeshSeparator will not perform mesh separation.