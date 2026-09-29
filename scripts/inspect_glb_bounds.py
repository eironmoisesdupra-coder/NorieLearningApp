#!/usr/bin/env python3
import hashlib, json, math, struct, sys
from pathlib import Path

def mul(a,b):
    r=[0.0]*16
    for c in range(4):
        for row in range(4):
            r[c*4+row]=sum(a[k*4+row]*b[c*4+k] for k in range(4))
    return r

def identity():
    return [1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1]

def local_matrix(node):
    if "matrix" in node:
        return [float(v) for v in node["matrix"]]
    tx,ty,tz=node.get("translation",[0,0,0])
    x,y,z,w=node.get("rotation",[0,0,0,1])
    sx,sy,sz=node.get("scale",[1,1,1])
    xx,yy,zz=x*x,y*y,z*z
    xy,xz,yz=x*y,x*z,y*z
    wx,wy,wz=w*x,w*y,w*z
    # column-major T * R * S
    return [
        (1-2*(yy+zz))*sx, (2*(xy+wz))*sx, (2*(xz-wy))*sx, 0,
        (2*(xy-wz))*sy, (1-2*(xx+zz))*sy, (2*(yz+wx))*sy, 0,
        (2*(xz+wy))*sz, (2*(yz-wx))*sz, (1-2*(xx+yy))*sz, 0,
        tx,ty,tz,1,
    ]

def point(m,p):
    x,y,z=p
    return (
        m[0]*x+m[4]*y+m[8]*z+m[12],
        m[1]*x+m[5]*y+m[9]*z+m[13],
        m[2]*x+m[6]*y+m[10]*z+m[14],
    )

def main(path):
    data=Path(path).read_bytes()
    if data[:4] != b"glTF":
        raise SystemExit("not a GLB")
    pos=12
    js=None
    while pos+8 <= len(data):
        length,kind=struct.unpack_from("<II",data,pos)
        pos+=8
        chunk=data[pos:pos+length]
        pos+=length
        if kind == 0x4E4F534A:
            js=json.loads(chunk.rstrip(b" \t\r\n\0").decode("utf-8"))
            break
    if js is None:
        raise SystemExit("GLB JSON chunk missing")
    nodes=js.get("nodes",[])
    meshes=js.get("meshes",[])
    accessors=js.get("accessors",[])
    parent={}
    for i,node in enumerate(nodes):
        for child in node.get("children",[]):
            parent[child]=i
    worlds={}
    def world(i):
        if i in worlds: return worlds[i]
        m=local_matrix(nodes[i])
        if i in parent: m=mul(world(parent[i]),m)
        worlds[i]=m
        return m
    lo=[math.inf]*3
    hi=[-math.inf]*3
    mesh_nodes=0
    for i,node in enumerate(nodes):
        mi=node.get("mesh")
        if mi is None: continue
        mesh_nodes+=1
        m=world(i)
        for prim in meshes[mi].get("primitives",[]):
            ai=prim.get("attributes",{}).get("POSITION")
            if ai is None: continue
            acc=accessors[ai]
            amin,amax=acc.get("min"),acc.get("max")
            if not amin or not amax: continue
            for x in (amin[0],amax[0]):
                for y in (amin[1],amax[1]):
                    for z in (amin[2],amax[2]):
                        p=point(m,(x,y,z))
                        for k in range(3):
                            lo[k]=min(lo[k],p[k]); hi[k]=max(hi[k],p[k])
    dims=[hi[i]-lo[i] for i in range(3)]
    center=[(lo[i]+hi[i])/2 for i in range(3)]
    out={
        "sha256": hashlib.sha256(data).hexdigest(),
        "bytes": len(data),
        "meshNodes": mesh_nodes,
        "min": [round(v,6) for v in lo],
        "max": [round(v,6) for v in hi],
        "center": [round(v,6) for v in center],
        "dimensions": [round(v,6) for v in dims],
    }
    print("ANATOMY_GLB_BOUNDS="+json.dumps(out,separators=(",",":")))

if __name__ == "__main__":
    main(sys.argv[1])
