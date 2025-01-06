import sys

def build_filter(args):
    return Filter(args)

class Filter:

    def __init__(self, args):
        args = {arg: True for arg in args.split(',')}
        self.append_branch = args.pop('append-branch', False)

    def commit_message_filter(self, commit_data):
        hg_hash = commit_data['hg_hash'].decode('utf-8')
        message = f'hg-changeset: {hg_hash}'.encode('utf-8')
        if commit_data['desc'] != b'\x00':
            commit_data['desc'] += b'\n\n'
        commit_data['desc'] += message
        if self.append_branch:
            commit_data['desc'] = (
                commit_data['desc'] + b'\nhg-branch: ' + commit_data['branch']
            )
