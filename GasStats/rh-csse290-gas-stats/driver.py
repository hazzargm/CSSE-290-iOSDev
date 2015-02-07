#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import os
import jinja2
from google.appengine.ext import ndb
import webapp2

jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(os.path.dirname(__file__)), autoescape=True)

DRIVER_PARENT_KEY = ndb.Key("Entity", 'driver_root')


class DriverHandler(webapp2.RequestHandler):
    def get(self):
        self.response.write('Welcome to Gas Stats!')
        
    def post(self):
        new_driver = Driver(parent=DRIVER_PARENT_KEY,
                      email=self.request.get("email"),
                      username=self.request.get("username"),
                      password=self.request.get("password"),
                      user_id=self.request.get('user_id'))
        new_driver.put()
        self.redirect(self.request.referer)    

app = webapp2.WSGIApplication([('/', DriverHandler)], debug=True)