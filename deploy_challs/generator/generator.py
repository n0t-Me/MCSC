from passlib.hash import bcrypt_sha256 as bcrypt
import json
import secrets
import os
import base64

TEAM_CREATION_DATE = "2024-04-21T18:21:44.711356"
USER_CREATION_DATE = "2024-04-21T17:21:44.711356"

teams = ['Slt3brgr', 'AkaSec', 'R00t__404', '0BL10V10N', 'Hun73r5', 'L3AK MA', 'TH3_CTF_TEAM', 'nari_tmnglt_oreblia', 'Dedicace', '0xNox', 'PageFault', 'HITM3N', 'ExcelsiorMar', 'KSTX', 'EJR-256', '7hE 0Ut51D3rS']


def gen_pass():
    return bcrypt.hash(secrets.token_hex(10))

def gen_friendly_pass():
    rnd = os.urandom(10)
    password = base64.b32encode(rnd).decode()
    return (password, bcrypt.hash(password))

def create_team_data(i):
    name = teams[i]
    data = {
        "id": i+2,
        "oauth_id": None,
        "name": name,
        "email": None,
        "password": gen_pass(),
        "secret": None,
        "website": None,
        "affiliation": None,
        "country": None,
        "hidden": 0,
        "banned": 0,
        "created": TEAM_CREATION_DATE,
        "captain_id": 10 + i*3,
        "bracket_id": None,
    }
    return data


def create_user_data(id, team_id):
    name = "player_" + str(id)
    password, hashed = gen_friendly_pass()
    data = {
        "id": id,
        "oauth_id": None,
        "name": name,
        "email": name + "@not-me.tech",
        "password": hashed,
        "type": "user",
        "secret": None,
        "website": None,
        "affiliation": None,
        "country": None,
        "hidden": 0,
        "banned": 0,
        "verified": 0,
        "created": USER_CREATION_DATE,
        "language": None,
        "team_id": team_id,
        "bracket_id": None,
    }

    print("\t- {}:{}".format(name, password))
    return data


def create_team_with_users(i):
    team_data = create_team_data(i)
    team_id = i + 2
    print("Team: {}".format(teams[i]))
    captain_data = create_user_data(10 + i*3, team_id)
    member1_data = create_user_data(10 + i*3 + 1, team_id)
    member2_data = create_user_data(10 + i*3 + 2, team_id)
    return (team_data, captain_data, member1_data, member2_data)


def add_data(data, team_data):
    data['results'].append(team_data)
    data['count'] += 1

def add_team_with_users(users_data, team_data, i):
    td, cd, m1d, m2d = create_team_with_users(i)
    add_data(team_data, td)
    add_data(users_data, cd)
    add_data(users_data, m1d)
    add_data(users_data, m2d)

def add_all(users_data, team_data):
    for i in range(len(teams)):
        add_team_with_users(users_data, team_data, i)


def main():
    teams_data = open("teams.json", "rt").read()
    users_data = open("users.json", "rt").read()

    teams_data = json.loads(teams_data)
    users_data = json.loads(users_data)

    add_all(users_data, teams_data)

    teams_data = json.dumps(teams_data)
    users_data = json.dumps(users_data)

    open("teams_new.json", "wt").write(teams_data)
    open("users_new.json", "wt").write(users_data)


main()
    
