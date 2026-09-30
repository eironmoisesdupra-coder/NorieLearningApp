# NorieLearning Anatomy 3D Asset Attribution

## Skeletal system model

**Asset:** `overview-skeleton.glb`

**Runtime source used by the build pipeline:**  
https://github.com/yamz8/human-body-simulator/tree/main/public/models

The upstream project identifies this skeleton as **Open3Dmodel**, from the Open Anatomy lineage, and distributes the skeleton under **Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)**.

Upstream attribution/source:
- Open3Dmodel / Open Anatomy lineage
- AnatomyTool / Open3Dmodel Create
- Mirror/integration used for this build: yamz8/human-body-simulator

License:
- https://creativecommons.org/licenses/by-sa/4.0/

NorieLearning does not claim ownership of this anatomy mesh. Any redistributed adaptations of this mesh remain subject to the applicable CC BY-SA terms.

### Pinned hotspot calibration source

The skeletal GLB used for hotspot calibration is pinned to `yamz8/human-body-simulator` commit `e4d76fbb424d15e1364963528a082a78fa359161`. Pinning prevents hotspot anchor coordinates from silently drifting if the upstream model changes.

## Internal organ atlas model

**Asset:** `anatomy-organs.glb`

**Runtime source used by the build pipeline:**  
https://github.com/yamz8/human-body-simulator/tree/main/public/models

The organ atlas is derived from **BodyParts3D version 3.0**, via the Kevin-Mattheus-Moerman BodyParts3D mirror used by the upstream Body Atlas project.

Upstream attribution/source:
- BodyParts3D version 3.0
- Database Center for Life Science
- Original archive DOI: 10.18908/lsdba.nbdc00837-000
- Mirror/integration used for this build: yamz8/human-body-simulator

License:
- Creative Commons Attribution-ShareAlike 2.1 Japan (CC BY-SA 2.1 JP)
- https://creativecommons.org/licenses/by-sa/2.1/jp/

The web-ready organ GLB retains semantic organ node naming from the upstream derivative. NorieLearning does not claim ownership of this mesh. Redistributed adaptations remain subject to the applicable attribution and ShareAlike terms.

## Educational-use note

These models are used for educational visualization and should not be treated as diagnostic or clinical references.
