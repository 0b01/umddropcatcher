from requests import get
from json import loads
for i in range (1,45):
    json = loads(get("http://api.umd.io/v0/courses?semester=201708&per_page=100&page="+str(i)).text)
    for course in json:
        print course['course_id']
