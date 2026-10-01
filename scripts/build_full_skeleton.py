#!/usr/bin/env python3
import copy
import json
import re
import struct
import sys
from pathlib import Path

JSON_CHUNK = 0x4E4F534A
BIN_CHUNK = 0x004E4942
RIGHT_SUFFIX = re.compile(r'\.r\.?$', re.IGNORECASE)


def mul(a, b):
    out = [0.0] * 16
    for col in range(4):
        for row in range(4):
            out[col * 4 + row] = sum(
                a[k * 4 + row] * b[col * 4 + k]
                for k in range(4)
            )
    return out


def local_matrix(node):
    if "matrix" in node:
        return [float(v) for v in node["matrix"]]

    tx, ty, tz = node.get("translation", [0, 0, 0])
    x, y, z, w = node.get("rotation", [0, 0, 0, 1])
    sx, sy, sz = node.get("scale", [1, 1, 1])

    xx, yy, zz = x * x, y * y, z * z
    xy, xz, yz = x * y, x * z, y * z
    wx, wy, wz = w * x, w * y, w * z

    return [
        (1 - 2 * (yy + zz)) * sx,
        (2 * (xy + wz)) * sx,
        (2 * (xz - wy)) * sx,
        0,
        (2 * (xy - wz)) * sy,
        (1 - 2 * (xx + zz)) * sy,
        (2 * (yz + wx)) * sy,
        0,
        (2 * (xz + wy)) * sz,
        (2 * (yz - wx)) * sz,
        (1 - 2 * (xx + yy)) * sz,
        0,
        tx,
        ty,
        tz,
        1,
    ]


def read_glb(path):
    data = Path(path).read_bytes()
    magic, version, total = struct.unpack_from("<4sII", data, 0)
    if magic != b"glTF" or version != 2 or total != len(data):
        raise SystemExit("Invalid GLB header")

    chunks = []
    pos = 12
    while pos + 8 <= len(data):
        length, kind = struct.unpack_from("<II", data, pos)
        pos += 8
        chunk = data[pos:pos + length]
        pos += length
        chunks.append((kind, chunk))

    json_index = next(
        (i for i, (kind, _) in enumerate(chunks) if kind == JSON_CHUNK),
        None,
    )
    if json_index is None:
        raise SystemExit("GLB JSON chunk missing")

    js = json.loads(
        chunks[json_index][1].rstrip(b" \t\r\n\0").decode("utf-8")
    )
    return js, chunks, json_index


def write_glb(path, js, chunks, json_index):
    raw_json = json.dumps(
        js,
        separators=(",", ":"),
        ensure_ascii=False,
    ).encode("utf-8")
    raw_json += b" " * ((4 - len(raw_json) % 4) % 4)

    out_chunks = list(chunks)
    out_chunks[json_index] = (JSON_CHUNK, raw_json)

    total = 12 + sum(8 + len(chunk) for _, chunk in out_chunks)
    output = bytearray(struct.pack("<4sII", b"glTF", 2, total))

    for kind, chunk in out_chunks:
        output += struct.pack("<II", len(chunk), kind)
        output += chunk

    Path(path).write_bytes(output)


def main(source_path, output_path):
    js, chunks, json_index = read_glb(source_path)
    nodes = js.get("nodes", [])
    scenes = js.get("scenes", [])
    if not scenes:
        raise SystemExit("GLB has no scene")

    parent = {}
    for i, node in enumerate(nodes):
        for child in node.get("children", []):
            parent[child] = i

    worlds = {}

    def world(index):
        if index in worlds:
            return worlds[index]
        matrix = local_matrix(nodes[index])
        if index in parent:
            matrix = mul(world(parent[index]), matrix)
        worlds[index] = matrix
        return matrix

    mirror_x = [
        -1, 0, 0, 0,
         0, 1, 0, 0,
         0, 0, 1, 0,
         0, 0, 0, 1,
    ]

    source_count = len(nodes)
    mirrored_indices = []

    for index in range(source_count):
        node = nodes[index]
        name = str(node.get("name", "")).strip()
        if "mesh" not in node or not RIGHT_SUFFIX.search(name):
            continue

        clone = {
            "name": RIGHT_SUFFIX.sub(".l", name),
            "mesh": node["mesh"],
            "matrix": mul(mirror_x, world(index)),
        }
        for optional in ("skin", "weights", "extras"):
            if optional in node:
                clone[optional] = copy.deepcopy(node[optional])

        nodes.append(clone)
        mirrored_indices.append(len(nodes) - 1)

    scene_index = int(js.get("scene", 0))
    root_nodes = scenes[scene_index].setdefault("nodes", [])
    root_nodes.extend(mirrored_indices)

    js.setdefault("asset", {}).setdefault("extras", {})[
        "norieFullSkeletonMirror"
    ] = {
        "mirroredNodeCount": len(mirrored_indices),
        "method": "Mirror right-side .r mesh nodes across model X=0",
    }

    write_glb(output_path, js, chunks, json_index)
    print(
        "FULL_SKELETON_READY="
        + json.dumps(
            {
                "sourceNodes": source_count,
                "mirroredNodes": len(mirrored_indices),
                "totalNodes": len(nodes),
                "output": str(output_path),
            },
            separators=(",", ":"),
        )
    )


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit(
            "Usage: build_full_skeleton.py SOURCE.glb OUTPUT.glb"
        )
    main(sys.argv[1], sys.argv[2])
