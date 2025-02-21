# Readme for developers

## How to prepare a new release

1. Check if we have to upgrade Python (https://devguide.python.org/versions). If so, first update
   Python and check what breaks. Fix that.
2. Go through the list of explicit neuroscience dependencies (sections 1-4 in `environment.yml` files).
   Check if there is an update. Try to upgrade.
3. Fix potential errors (this is where work has to be done).
4. Commit necessary changes as "Update <package> Major.Minor -> Major.Minor


## Tips and tricks

- Consider moving a dependency from conda to pip or vice versa. Conda can resolve dependencies, 
  but not all  dependencies have conda recipes. pip dependencies can be restricted to specific 
  OSs.

- Use other tools such as pixi for helping with dependency conflicts.
- Use `conda env update --file neuro-conda-latest.yml` to avoid re-creating the whole environment
  for every change.
