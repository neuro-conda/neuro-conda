#!~/.local/miniconda3/envs/neuroconda
#
# Central pytest configuration
#

# Builtin/3rd party package imports
import sys
import pytest

# Construct decorators for skipping certain tests based on platform
skip_if_not_linux = pytest.mark.skipif(sys.platform != "linux", reason="Only works in Linux")

# Add custom `--full` flag to pytest invocation
def pytest_addoption(parser):
    parser.addoption("--full", dest='all_tests', action="store_true", default=False,
        help="Run all tests including those marked with the `mark.full` flag")

def pytest_configure(config):
    config.addinivalue_line("markers", "full: mark tests to only run if invoked with `--full`")

def pytest_runtest_setup(item):
    if "full" in item.keywords and not item.config.getoption("--full"):
        pytest.skip("use --full to run this test")
