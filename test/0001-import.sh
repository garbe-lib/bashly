#!/usr/bin/bash

$(import test:2/subpackage); assert 0 "Importing exact version"
$(import test:2/subpackage/test); assert 0 "Import exact version and script"
$(import test:4.3+/subpackage); assert 1 "Importing higher version than installed should fail"
$(import test:2+/subpackage); assert 0 "Importing installed version"
