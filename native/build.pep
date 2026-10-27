# An example build script, which nothing runs yet: it compiles
# native/add.c for the build's target with the clang the build hands it,
# and links the object, so the package's code can declare and call
# `extern int mypkg_add(int a, int b);`. To use it, uncomment `[build]` in
# pep.toml, which needs Pepper 0.11 or later. Delete this folder if the
# package has no C code. See
# https://docs.pepper-lang.dev/dev/tools/projects.html#build-scripts.

import [Path] from io;
import os;
import process;

main(): int {
    var object = Path(os.environment("PEP_OUT_DIR").value()).join(Path("add.o"));
    var compiled = process
        .Command(os.environment("PEP_CLANG").value())
        .arguments(["--target=" + os.environment("PEP_TARGET").value(), "-c", "native/add.c", "-o", object.to_string()])
        .run();
    if (compiled.is_err() or !compiled.value().status.success()) {
        return 1;
    }
    print($"pep:object={object}");
    print("pep:rerun-if-changed=native/add.c");
    return 0;
}
