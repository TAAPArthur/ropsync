# ropsync

Rsync based On-demand Posix file SYNC

The algorithm

For each host
1. Determine which files are new and which have been deleted
2. Ignoring the set computed above, pull files from host and delete every file not present on the remote host
4. Push all local files to host and delete all remotes files that aren't present locally.
6. Add new files in src to known_files list which would be used in to determine new and deleted files in future runs

Assumptions:
1. All nodes trust each other
2. File names don't contain "\"
3. A file won't be modified on 2 machines simultaneously (ie before they can sync with each other)

The goal is to be able to sync files across multiple devices that the user
owns. This allows for general backup but more importantly the convince of
having the desired files on whatever machine the user wants to access at that
time. Note however, that this isn't a daemon and it won't auto sync of file
change by itself.
