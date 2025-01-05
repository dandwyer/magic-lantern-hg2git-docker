import sys

def build_filter(args):
    return Filter(args)

class Filter:

    def __init__(self, args):
        pass

    def commit_message_filter(self, commit_data):
        hg_hash = commit_data['hg_hash'].decode('utf-8')
        message = f'hg-changeset: {hg_hash}'.encode('utf-8')
        if commit_data['desc'] != b'\x00':
            commit_data['desc'] += b'\n\n'
        commit_data['desc'] += message
