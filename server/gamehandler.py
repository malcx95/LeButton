import random
from datetime import datetime
import json

ID_LENGTH = 5

ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

class Player:

    def __init__(self, has_pressed=False):
        self.score = 0
        self.has_pressed = has_pressed
        self.pressed_time = None if not has_pressed else datetime.now()


class GameState:

    def __init__(self):
        self.players = {}

    def add_player(self):
        name = _generate_name(self.players)
        self.players[name] = Player(bool(len(self.players)))
        return name

    def get_player_score(self, name):
        return self.players[name].score

    def get_player_state(self, name):
        return self.players[name].has_pressed

    def player_push(self, name):
        if self.players[name].has_pressed:
            # The player has already pressed
            return False
        for player in self.players:
#            if self.players[player].has_pressed and \
#               self.players[player].pressed_time is not None:
#
            self.players[player].has_pressed = False
        self.players[name] = True
        return True


def handle_request(request, game_state):
    parsed = json.loads(request)
    try:
        action = parsed['action']
    except KeyError:
        raise TypeError('Invalid request! No action key!')
    if action == 'new':
        return _new_player(game_state)
    elif action == 'get':
        return _get_state(parsed['id'], game_state)
    elif action == 'score':
        return _get_state(parsed['id'], game_state)
    elif action == 'push':
        return _push(parsed['id'], game_state)
    else:
        raise TypeError('Invalid action \'{}\''.format(action))


def _new_player(game_state):
    return json.dumps({'id': game_state.add_player()})


def _get_score(name, game_state):
    return json.dumps({'score': game_state.get_player_score(name)})


def _get_state(name, game_state):
    return json.dumps({'state': game_state.get_player_state(name)})


def _push(name, game_state):
    return json.dumps({'success': game_state.player_push(name)})


def _generate_name(players):
    result = ""
    for i in range(ID_LENGTH):
        result += ALPHABET[random.randint(0, len(ALPHABET) - 1)]
    return result

