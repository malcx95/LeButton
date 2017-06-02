import random
import json

ID_LENGTH = 5

ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

class Player:

    def __init__(self):
        self.score = 0


class GameState:

    def __init__(self):
        self.players = {}

    def add_player(self, name):
        pass


def handle_request(request, game_state):
    parsed = json.loads(request)
    try:
        action = request['action']
    except KeyError:
        raise TypeError('Invalid request! No action key!')
    if action == 'new':
        return _new_player(game_state)
    elif action == 'get':
        return _get_state(request['id'], game_state)
    elif action == 'score':
        return _get_state(request['id'], game_state)
    elif action == 'push':
        return _push(request['id'], game_state)
    else:
        raise TypeError('Invalid action \'{}\''.format(action))


def _new_player(game_state):
    pass


def _get_score(name, game_state):
    pass


def _get_state(name, game_state):
    pass


def _push(request, game_state):
    pass


def _generate_name(players):
    result = ""
    for i in range(ID_LENGTH):
        result += ALPHABET[random.randint(len(ALPHABET) - 1)]
    return result
