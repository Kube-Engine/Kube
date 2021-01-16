# Kube's Makefile helper
# Used to prevent misusage of cmake

RELEASE_DIR		=	Release
DEBUG_DIR		=	Debug
BUILD_DIR		=	$(RELEASE_DIR)
BUILD_TYPE		=	Release

CMAKE_ARGS		=

RM		=	rm -rf

all: release

build:
	cmake -E make_directory $(BUILD_DIR)
	cmake -B $(BUILD_DIR) -H. -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) ${CMAKE_ARGS} -GNinja
	cmake --build $(BUILD_DIR)

release:
	$(MAKE) build BUILD_DIR=$(RELEASE_DIR) BUILD_TYPE=Release

debug:
	$(MAKE) build BUILD_DIR=$(DEBUG_DIR) BUILD_TYPE=Debug

tests:
	$(MAKE) release CMAKE_ARGS+=-DKF_TESTS=TRUE

tests_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_TESTS=TRUE

run_tests: tests
	ninja -C $(RELEASE_DIR) test

run_tests_debug: tests_debug
	ninja -C $(DEBUG_DIR) test

benchmarks:
	$(MAKE) release CMAKE_ARGS+=-DKF_BENCHMARKS=TRUE

benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_BENCHMARKS=TRUE

examples:
	$(MAKE) release CMAKE_ARGS+=-DKF_EXAMPLES=TRUE

examples_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_EXAMPLES=TRUE

# App
app:
	$(MAKE) release CMAKE_ARGS+=-DKF_APP=TRUE

app_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_APP=TRUE

app_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_APP=TRUE -DKF_TESTS=TRUE"

run_app_tests: app_tests
	ninja -C $(RELEASE_DIR) test

app_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_APP=TRUE -DKF_TESTS=TRUE"

run_app_tests_debug: app_tests_debug
	ninja -C $(DEBUG_DIR) test

app_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_APP=TRUE -DKF_BENCHMARKS=TRUE"

app_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_APP=TRUE -DKF_BENCHMARKS=TRUE"

# Core
core:
	$(MAKE) release CMAKE_ARGS+=-DKF_CORE=TRUE

core_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_CORE=TRUE

core_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_CORE=TRUE -DKF_TESTS=TRUE"

run_core_tests: core_tests
	ninja -C $(RELEASE_DIR) test

core_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_CORE=TRUE -DKF_TESTS=TRUE"

run_core_tests_debug: core_tests_debug
	ninja -C $(DEBUG_DIR) test

core_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_CORE=TRUE -DKF_BENCHMARKS=TRUE"

core_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_CORE=TRUE -DKF_BENCHMARKS=TRUE"

# ECS
ecs:
	$(MAKE) release CMAKE_ARGS+=-DKF_ECS=TRUE

ecs_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_ECS=TRUE

ecs_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_ECS=TRUE -DKF_TESTS=TRUE"

run_ecs_tests: ecs_tests
	ninja -C $(RELEASE_DIR) test

ecs_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_ECS=TRUE -DKF_TESTS=TRUE"

run_ecs_tests_debug: ecs_tests_debug
	ninja -C $(DEBUG_DIR) test

ecs_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_ECS=TRUE -DKF_BENCHMARKS=TRUE"

ecs_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_ECS=TRUE -DKF_BENCHMARKS=TRUE"

# Graphics
graphics:
	$(MAKE) release CMAKE_ARGS+=-DKF_GRAPHICS=TRUE

graphics_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_GRAPHICS=TRUE

graphics_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_GRAPHICS=TRUE -DKF_TESTS=TRUE"

run_graphics_tests: graphics_tests
	ninja -C $(RELEASE_DIR) test

graphics_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_GRAPHICS=TRUE -DKF_TESTS=TRUE"

run_graphics_tests_debug: graphics_tests_debug
	ninja -C $(DEBUG_DIR) test

graphics_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_GRAPHICS=TRUE -DKF_BENCHMARKS=TRUE"

graphics_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_GRAPHICS=TRUE -DKF_BENCHMARKS=TRUE"

# Interpreter
interpreter:
	$(MAKE) release CMAKE_ARGS+=-DKF_INTERPRETER=TRUE

interpreter_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_INTERPRETER=TRUE

interpreter_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_INTERPRETER=TRUE -DKF_TESTS=TRUE"

run_interpreter_tests: interpreter_tests
	ninja -C $(RELEASE_DIR) test

interpreter_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_INTERPRETER=TRUE -DKF_TESTS=TRUE"

run_interpreter_tests_debug: interpreter_tests_debug
	ninja -C $(DEBUG_DIR) test

interpreter_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_INTERPRETER=TRUE -DKF_BENCHMARKS=TRUE"

interpreter_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_INTERPRETER=TRUE -DKF_BENCHMARKS=TRUE"

# Meta
meta:
	$(MAKE) release CMAKE_ARGS+=-DKF_META=TRUE

meta_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_META=TRUE

meta_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_META=TRUE -DKF_TESTS=TRUE"

run_meta_tests: meta_tests
	ninja -C $(RELEASE_DIR) test

meta_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_META=TRUE -DKF_TESTS=TRUE"

run_meta_tests_debug: meta_tests_debug
	ninja -C $(DEBUG_DIR) test

meta_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_META=TRUE -DKF_BENCHMARKS=TRUE"

meta_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_META=TRUE -DKF_BENCHMARKS=TRUE"

# Object
object:
	$(MAKE) release CMAKE_ARGS+=-DKF_OBJECT=TRUE

object_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_OBJECT=TRUE

object_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_OBJECT=TRUE -DKF_TESTS=TRUE"

run_object_tests: object_tests
	ninja -C $(RELEASE_DIR) test

object_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_OBJECT=TRUE -DKF_TESTS=TRUE"

run_object_tests_debug: object_tests_debug
	ninja -C $(DEBUG_DIR) test

object_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_OBJECT=TRUE -DKF_BENCHMARKS=TRUE"

object_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_OBJECT=TRUE -DKF_BENCHMARKS=TRUE"

# UI
ui:
	$(MAKE) release CMAKE_ARGS+=-DKF_UI=TRUE

ui_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_UI=TRUE

ui_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_UI=TRUE -DKF_TESTS=TRUE"

run_ui_tests: ui_tests
	ninja -C $(RELEASE_DIR) test

ui_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_UI=TRUE -DKF_TESTS=TRUE"

run_ui_tests_debug: ui_tests_debug
	ninja -C $(DEBUG_DIR) test

ui_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_UI=TRUE -DKF_BENCHMARKS=TRUE"

ui_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_UI=TRUE -DKF_BENCHMARKS=TRUE"

# Flow
flow:
	$(MAKE) release CMAKE_ARGS+=-DKF_FLOW=TRUE

flow_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_FLOW=TRUE

flow_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_FLOW=TRUE -DKF_TESTS=TRUE"

run_flow_tests: flow_tests
	ninja -C $(RELEASE_DIR) test

flow_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_FLOW=TRUE -DKF_TESTS=TRUE"

run_flow_tests_debug: flow_tests_debug
	ninja -C $(DEBUG_DIR) test

flow_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_FLOW=TRUE -DKF_BENCHMARKS=TRUE"

flow_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_FLOW=TRUE -DKF_BENCHMARKS=TRUE"

# Voxel
voxel:
	$(MAKE) release CMAKE_ARGS+=-DKF_VOXEL=TRUE

voxel_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_VOXEL=TRUE

voxel_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_VOXEL=TRUE -DKF_TESTS=TRUE"

run_voxel_tests: voxel_tests
	ninja -C $(RELEASE_DIR) test

voxel_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_VOXEL=TRUE -DKF_TESTS=TRUE"

run_voxel_tests_debug: voxel_tests_debug
	ninja -C $(DEBUG_DIR) test

voxel_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_VOXEL=TRUE -DKF_BENCHMARKS=TRUE"

voxel_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_VOXEL=TRUE -DKF_BENCHMARKS=TRUE"

# Widgets
widgets:
	$(MAKE) release CMAKE_ARGS+=-DKF_WIDGETS=TRUE

widgets_debug:
	$(MAKE) debug CMAKE_ARGS+=-DKF_WIDGETS=TRUE

widgets_tests:
	$(MAKE) release CMAKE_ARGS+="-DKF_WIDGETS=TRUE -DKF_TESTS=TRUE"

run_widgets_tests: widgets_tests
	ninja -C $(RELEASE_DIR) test

widgets_tests_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_WIDGETS=TRUE -DKF_TESTS=TRUE"

run_widgets_tests_debug: widgets_tests_debug
	ninja -C $(DEBUG_DIR) test

widgets_benchmarks:
	$(MAKE) release CMAKE_ARGS+="-DKF_WIDGETS=TRUE -DKF_BENCHMARKS=TRUE"

widgets_benchmarks_debug:
	$(MAKE) debug CMAKE_ARGS+="-DKF_WIDGETS=TRUE -DKF_BENCHMARKS=TRUE"


clean:
	$(RM) ${RELEASE_DIR}
	$(RM) ${DEBUG_DIR}

fclean: clean

re: clean all

.PHONY: all \
	release debug \
	examples examples_debug \
	tests tests_debug run_tests run_tests_debug \
	benchmarks benchmarks_debug \
	app app_debug app_tests run_app_tests app_tests_debug run_app_tests_debug app_benchmarks app_benchmarks_debug \
	core core_debug core_tests run_core_tests core_tests_debug run_core_tests_debug core_benchmarks core_benchmarks_debug \
	graphics graphics_debug graphics_tests run_graphics_tests graphics_tests_debug run_graphics_tests_debug graphics_benchmarks graphics_benchmarks_debug \
	interpreter interpreter_debug interpreter_tests run_interpreter_tests interpreter_tests_debug run_interpreter_tests_debug interpreter_benchmarks interpreter_benchmarks_debug \
	meta meta_debug meta_tests run_meta_tests meta_tests_debug run_meta_tests_debug meta_benchmarks meta_benchmarks_debug \
	ui ui_debug ui_tests run_ui_tests ui_tests_debug run_ui_tests_debug ui_benchmarks ui_benchmarks_debug \
	flow flow_debug flow_tests run_flow_tests flow_tests_debug run_flow_tests_debug flow_benchmarks flow_benchmarks_debug \
	widgets widgets_debug widgets_tests run_widgets_tests widgets_tests_debug run_widgets_tests_debug widgets_benchmarks widgets_benchmarks_debug \
	clean fclean \
	re